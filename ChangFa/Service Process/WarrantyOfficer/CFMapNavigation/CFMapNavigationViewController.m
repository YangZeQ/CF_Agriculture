//
//  CFMapNavigationViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/20.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFMapNavigationViewController.h"
#import "CFMapTableViewCell.h"
#import "CFWorkOrderTableViewCell.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MapKit/MKTypes.h>
#import "MANaviRoute.h"
#import <MapKit/MKMapItem.h>
#import "PointAnnotation.h"
static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge = 20;
@interface CFMapNavigationViewController ()<AMapLocationManagerDelegate, MAMapViewDelegate, AMapSearchDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)AMapSearchAPI *mapSearch;
@property (nonatomic, strong)AMapLocationManager *locationManager;
@property (nonatomic, strong)MAMapView *mapView;
@property (nonatomic, strong) AMapRoute *route;
@property (nonatomic, strong) MANaviRoute *naviRoute;
@property (nonatomic, strong)UITableView *mapTableView;
@property (nonatomic, assign)double latitude;
@property (nonatomic, assign)double longitude;
@property (nonatomic, strong)UIView *vagueView;
@property (nonatomic, strong)NSArray *mapArray;
@end

@implementation CFMapNavigationViewController
- (NSArray *)mapArray
{
    if (_mapArray == nil) {
        _mapArray = [self getInstalledMapAppWithEndLocation:CLLocationCoordinate2DMake(self.stationLatitude, self.stationLongitude)];
    }
    return _mapArray;
}
- (UIView *)vagueView
{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _vagueView.hidden = YES;
        [self.view addSubview:_vagueView];
    }
    return _vagueView;
}
- (AMapSearchAPI *)mapSearch
{
    if (_mapSearch == nil) {
        _mapSearch = [[AMapSearchAPI alloc] init];
        _mapSearch.delegate = self;
    }
    return _mapSearch;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMapNavigationView];
    // Do any additional setup after loading the view.
}
- (void)createMapNavigationView
{
    [self showTheMapView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(30 * screenWidth, (30 + 20) * screenHeight, 60 * screenWidth, 60 * screenHeight);
    [backButton setImage:[UIImage imageNamed:@"CF_Map_Back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(CF_WIDTH - 130 * screenWidth, CF_HEIGHT - 330 * screenHeight, 100 * screenWidth, 100 * screenHeight);
    [locationButton setImage:[UIImage imageNamed:@"CF_Map_Location"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationButton];
    
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, CF_HEIGHT - 180 * screenHeight, CF_WIDTH, 180 * screenHeight)];
    addressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addressView];
    UILabel *addressLabel = [[UILabel  alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, CF_WIDTH - 190 * screenWidth, 50 * screenHeight)];
    addressLabel.text = self.position;
    addressLabel.font = CFFONT18;
    [addressView addSubview:addressLabel];
    UILabel *addressInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(addressLabel.frame.origin.x, addressLabel.frame.size.height + addressLabel.frame.origin.y + 20 * screenHeight, addressLabel.frame.size.width, addressLabel.frame.size.height)];
    addressInfoLabel.text = self.position;
    addressInfoLabel.font = CFFONT14;
    [addressView addSubview:addressInfoLabel];
    UIButton *navigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navigationButton.frame = CGRectMake(addressLabel.frame.size.width + addressLabel.frame.origin.x + 30 * screenWidth, 40 * screenHeight, 100 * screenWidth, 100 * screenHeight);
    [navigationButton setImage:[UIImage imageNamed:@"CF_Map_Navigation"] forState:UIControlStateNormal];
    [navigationButton addTarget:self action:@selector(navigationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:navigationButton];
    
    self.mapTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CF_HEIGHT - (102 * (self.mapArray.count - 1) + 360) * screenHeight, CF_WIDTH, (102 * (self.mapArray.count - 1) + 360) * screenHeight) style:UITableViewStylePlain];
    self.mapTableView.backgroundColor = BackgroundColor;
    self.mapTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mapTableView.delegate = self;
    self.mapTableView.dataSource = self;
    self.mapTableView.scrollEnabled = NO;
    [self.vagueView addSubview:self.mapTableView];
    
    
}
- (void)createNavigationView
{
    [self.mapTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.mapArray.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    CFMapTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFMapTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    if (indexPath.section == 0) {
            cell.infoLabel.text = @"显示路线";
    } else if (indexPath.section == 1) {
        cell.infoLabel.text = [_mapArray[indexPath.row] objectForKey:@"title"];
    } else {
        cell.infoLabel.text = @"取消";
        cell.infoLabel.textColor = [UIColor redColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0.01f;
    }
    return 28 * screenHeight;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self drivingRouteSearch];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self skipSystemMap];
        } else {
            NSLog(@"%@", [_mapArray[indexPath.row] objectForKey:@"title"]);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [_mapArray[indexPath.row] objectForKey:@"url"]]]];
        }
    }
    if (indexPath.section == 2) {
        self.vagueView.hidden = YES;
    }
}
#pragma mark - 高德地图规划路线
- (void)drivingRouteSearch
{
    self.mapSearch.delegate = self;
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.latitude
                                           longitude:self.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.stationLatitude
                                                longitude:self.stationLongitude];
    [self.mapSearch AMapDrivingRouteSearch:navi];
}
/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    self.route = response.route;
    //解析response获取路径信息
//    if (response.count > 0)
//    {
        [self presentCurrentCourse];
//    }
}
/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.latitude longitude:self.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.stationLatitude longitude:self.stationLongitude]];
    [self.naviRoute addToMapView:self.mapView];

    /* 缩放地图使其适应polylines的展示. */
    [self.mapView showOverlays:self.naviRoute.routePolylines edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge) animated:YES];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}
#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 8;
        polylineRenderer.lineDashPattern = @[@10, @15];
        polylineRenderer.strokeColor = [UIColor redColor];

        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];

        polylineRenderer.lineWidth = 8;

        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }

        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];

        polylineRenderer.lineWidth = 8;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;

        return polylineRenderer;
    }

    return nil;
}

#pragma mark  苹果自带
- (void)skipSystemMap {

    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(self.latitude, self.longitude);

    //当前的位置
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    //目的地的位置
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
//    toLocation.name = self.desAddress;
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];

    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };

    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}
- (void)locationButtonClick
{
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(self.stationLatitude, self.stationLongitude);
}
- (void)navigationButtonClick
{
    self.vagueView.hidden = NO;
    [self createNavigationView];
}
- (void)showTheMapView{
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT)];
    _mapView.delegate = self;
    //    [_mapView setZoomLevel:15.0 animated:YES];
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(_stationLatitude, _stationLongitude);
    _mapView.showsCompass = NO;
    [self configLocationManager];
    [self initAnnotations];
}
#pragma mark -定位
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    [self startSerialLocation];
}
- (void)startSerialLocation
{
    //开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)stopSerialLocation
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
}
#pragma mark - 设置大头针坐标
- (void)initAnnotations
{
    NSMutableArray *coordinates = [NSMutableArray array];
    PointAnnotation *pointAnnotation = [[PointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.stationLatitude, self.stationLongitude);
    pointAnnotation.title = @"";
    pointAnnotation.model = [[MachineModel alloc]init];
    pointAnnotation.model.lat = [NSString stringWithFormat:@"%f", self.stationLatitude];
    pointAnnotation.model.lng = [NSString stringWithFormat:@"%f", self.stationLongitude];
    [coordinates addObject:pointAnnotation];
    [_mapView addAnnotations:coordinates];
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    
}
- (void)backButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    NSLog(@"%@", annotation);
    // 自定义userLocation对应的annotationView
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAAnnotationView*annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        CGRect annotationViewRect = annotationView.frame;
        annotationView.frame = CGRectMake(annotationViewRect.origin.x, annotationViewRect.origin.y, 200, 200);
        switch ([_machineType integerValue]) {
            case 1:
                annotationView.image = [UIImage imageNamed:@"CF_Map_Tractors_Default"];
                break;
            case 2:
                annotationView.image = [UIImage imageNamed:@"CF_Map_Harvester_Defult"];
                break;
            case 3:
                annotationView.image = [UIImage imageNamed:@"CF_Map_RiceTransplanter_Defult"];
                break;
            case 4:
                annotationView.image = [UIImage imageNamed:@"CF_Map_Dryer_Defult"];
                break;
            default:
                break;
        }
        
        //        UITapGestureRecognizer *tapPosition = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseMethodToshow)];
        //        [annotationView addGestureRecognizer:tapPosition];
        
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"CF_Map_WorkerPosition"];
        MAAnnotationView *userLocationAnnotationView = annotationView;
        return userLocationAnnotationView;
    }
    return nil;
}
#pragma mark - 导航方法
- (NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation
{
    NSMutableArray *maps = [NSMutableArray array];

    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];

    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=北京&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }

    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=1&style=2",@"导航功能",@"nav123456",endLocation.latitude,endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }

    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",endLocation.latitude, endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }

    return maps;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.vagueView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
