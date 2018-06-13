//
//  MapViewController.m
//  ChangFa
//
//  Created by dev on 2017/12/29.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import "MapPinView.h"
#import "PointAnnotation.h"
#import "MyMachineMapTableViewCell.h"
#import "CFAFNetWorkingMethod.h"
#import "MachineModel.h"
#import "CFAFNetWorkingMethod.h"
#import "SystemNewsViewController.h"
@interface MapViewController ()<AMapLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MAMapViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong)UILabel *lineLabel;
@property (nonatomic, strong)AMapLocationManager *locationManager;
@property (nonatomic, strong)MAMapView *mapView;
@property (nonatomic, strong)UITableView *myMachineTableview;
@property (nonatomic, strong)NSMutableArray *positionArray;
@property (nonatomic, strong)NSMutableArray *machineArray;
@property (nonatomic, strong)UIButton *myMachine;
@property (nonatomic, assign)NSString *selected;
@property (nonatomic, strong)UIView *positionView;
@property (nonatomic, strong)UIView *otherPositionView;

@property (nonatomic, strong)UILabel *machineName;
@property (nonatomic, strong)UILabel *machineRemark;
@property (nonatomic, strong)UILabel *machineType;
@property (nonatomic, strong)UILabel *machineDistance;
@property (nonatomic, strong)UILabel *positionLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *phoneLabel;

@property (nonatomic, strong)UIView *personView;
@property (nonatomic, strong)UIButton *mapButton;
@property (nonatomic, strong)UIButton *rightButton;

@property (nonatomic, assign)double latitude;
@property (nonatomic, assign)double longitude;
@property (nonatomic, strong)MAAnnotationView *selectedPin;
@property (nonatomic, assign)NSInteger selectedPinStatus;
@property (nonatomic, copy)NSString *lastSelectedImage;
@end


@implementation MapViewController
- (NSMutableArray *)positionArray{
    if (!_positionArray) {
        _positionArray = [NSMutableArray array];
    }
    return _positionArray;
}
- (NSMutableArray *)machineArray{
    if (!_machineArray) {
        _machineArray = [NSMutableArray array];
    }
    return _machineArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getMachinePosition];
    [self showTheMapView];
    [self createTitleView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMapInfo) name:@"bindMachine" object:nil];
    // Do any additional setup after loading the view.
}
- (void)changeMapInfo{
    [self getMachinePosition];
}
- (void)createTitleView{
    // 模拟导航栏铺设
    UIView *navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationViewHeight)];
    
    navigationView.backgroundColor = ChangfaColor;
    [self.view addSubview:navigationView];
    UILabel *navigationLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, navigationView.frame.size.width, 44)];
    navigationLable.text = @"常发农装";
    navigationLable.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    navigationLable.userInteractionEnabled = YES;
    navigationLable.font = [UIFont systemFontOfSize:[self autoScaleW:20]];
    navigationLable.textAlignment = NSTextAlignmentCenter;
    navigationLable.textColor = [UIColor whiteColor];
    [navigationView addSubview:navigationLable];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(navigationView.frame.size.width - 44, 0, 44, 44);
    [_rightButton setImage:[UIImage imageNamed:@"xinxi"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationLable addSubview:_rightButton];
    
    [self showTheMachinePosition];
    [self getAllMyMachine];
    self.positionView.hidden = YES;
    self.selectedPinStatus = 0;
}
#pragma mark -导航栏右按钮点击时事件
- (void)rightButtonClick{
    SystemNewsViewController *system = [[SystemNewsViewController alloc]init];
    system.navigationViewHeight = self.navigationViewHeight;
    [self.navigationController pushViewController:system animated:YES];
}
- (void)showTheTableview{
    self.myMachineTableview.hidden = NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.machineArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    MyMachineMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MyMachineMapTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.model = self.machineArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 186 * screenHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showTheMachinePosition];
    self.myMachineTableview.hidden = YES;
}
#pragma mark -农机位置信息
- (void)showTheMachinePosition{
    _positionView = [[UIView alloc]init];
//    if ([self.selected isEqualToString:@"myMachine"]) {
        _positionView.frame = CGRectMake(0, 64, self.view.frame.size.width, 211 * screenHeight);
//    } else {
//        _positionView.frame = CGRectMake(0, 64, self.view.frame.size.width, 341 * screenHeight);
//    }
    _positionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_positionView];
    _machineName = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, 380 * screenWidth, 50 * screenHeight)];
    _machineName.text = @"农机：";
    _machineName.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [_positionView addSubview:_machineName];
    _machineRemark = [[UILabel alloc]initWithFrame:CGRectMake(_machineName.frame.size.width + _machineName.frame.origin.x, _machineName.frame.origin.y, _machineName.frame.size.width, _machineName.frame.size.height)];
    _machineRemark.text = @"备注：";
    _machineRemark.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [_positionView addSubview:_machineRemark];
    _machineType = [[UILabel alloc]initWithFrame:CGRectMake(_machineName.frame.origin.x, _machineName.frame.size.height + _machineName.frame.origin.y, _machineName.frame.size.width, _machineName.frame.size.height)];
    _machineType.text = @"型号：";
    _machineType.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [_positionView addSubview:_machineType];
    _machineDistance = [[UILabel alloc]initWithFrame:CGRectMake(_machineRemark.frame.origin.x, _machineType.frame.origin.y, _machineName.frame.size.width, _machineName.frame.size.height)];
    _machineDistance.text = @"距离我：";
    _machineDistance.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [_positionView addSubview:_machineDistance];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _machineType.frame.size.height + _machineType.frame.origin.y + 20 * screenHeight, self.view.frame.size.width, screenHeight)];
    lineLabel.backgroundColor = BackgroundColor;
    [_positionView addSubview:lineLabel];
    
    UIImageView *imagePosition = [[UIImageView alloc]initWithFrame:CGRectMake(_machineName.frame.origin.x, lineLabel.frame.origin.y + 11 * screenHeight, 30 * screenWidth, 35 * screenHeight)];
    imagePosition.image = [UIImage imageNamed:@"dingweigreen"];
    [_positionView addSubview:imagePosition];
    _positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(imagePosition.frame.origin.x + imagePosition.frame.size.width + 20 * screenWidth, imagePosition.frame.origin.y - 2 * screenHeight, 630 * screenWidth, 40 * screenHeight)];
    _positionLabel.text = @"农机位置：";
    _positionLabel.font = [UIFont systemFontOfSize:[self autoScaleW:14]];
    [_positionView addSubview:_positionLabel];
    
}

- (void)showTheMapView{

    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, self.navigationViewHeight, self.view.frame.size.width, self.view.frame.size.height - self.navigationViewHeight)];
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
//
//    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//    pointAnnotation.coordinate = CLLocationCoordinate2DMake(31.696143391928, 119.952612033421);
    _mapView.delegate = self;
    _mapView.showsCompass = NO;
    self.mapButton.hidden = YES;
//    [_mapView addAnnotation:pointAnnotation];
    [self configLocationManager];
}
- (void)myMachineButtonClick:(UIButton *)sender{
    self.lineLabel.frame = CGRectMake(sender.frame.origin.x + 25 * screenWidth, sender.frame.origin.y + sender.frame.size.height, 100 * screenWidth, 2);
    self.selected = @"myMachine";
    self.positionView.hidden = YES;
    self.mapButton.hidden = NO;
//    [self.otherPositionView removeFromSuperview];
//    [self showTheMachinePosition];
}
- (void)nearbyMachineButtonClick:(UIButton *)sender{
    self.lineLabel.frame = CGRectMake(sender.frame.origin.x + 25 * screenWidth, sender.frame.origin.y + sender.frame.size.height, 100 * screenWidth, 2);
    self.myMachineTableview.hidden = YES;
    self.selected = @"otherMachine";
    self.positionView.hidden = YES;
    _mapButton.hidden = YES;
}
#pragma mark -获取我的农机
- (void)getAllMyMachine{
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/getUserBindCar" Params:nil Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            [self.machineArray removeAllObjects];
            for (NSDictionary *dictModel in [[responseObject objectForKey:@"body"] objectForKey:@"resultList"]) {
                MachineModel *model = [MachineModel machineModelWithDictionary:dictModel];
                [self.machineArray addObject:model];
            }
            [self.myMachineTableview reloadData];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark -获取农机位置
- (void)getMachinePosition{
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/getVehicleLocation" Params:nil Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"position%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            // 移除所有大头针
            [_mapView removeOverlays:_mapView.overlays];
            [_mapView removeAnnotations:_mapView.annotations];
            [_positionArray removeAllObjects];
            for (NSDictionary *dictModel in [[responseObject objectForKey:@"body"] objectForKey:@"resultList"]) {
                MachineModel *model = [MachineModel machineModelWithDictionary:dictModel];
                [self.positionArray addObject:model];
            }
            [self initAnnotations];
        } else if ([[dict objectForKey:@"code"] integerValue] == 300) {
            [_mapView removeOverlays:_mapView.overlays];
            [_mapView removeAnnotations:_mapView.annotations];
            [_positionArray removeAllObjects];
            [self initAnnotations];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
            
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark -获取农机距我位置
- (void)getCarDistanceWithModel:(MachineModel *)model{
    NSLog(@"%@   %f", model.lat, self.longitude);
    NSDictionary *dict = @{
                           @"originlng":[NSNumber numberWithDouble:self.longitude],
                           @"originlat":[NSNumber numberWithDouble:self.latitude],
                           @"destinationlng":[NSNumber numberWithDouble:[model.lng doubleValue]],
                           @"destinationlat":[NSNumber numberWithDouble:[model.lat doubleValue]],
                           @"imei":model.imei,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/getCarDistance" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            _positionView.frame = CGRectMake(0, 64, self.view.frame.size.width, 211 * screenHeight);
            self.personView.hidden = YES;
            self.machineName.text = [@"农机：" stringByAppendingString:[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"body"] objectForKey:@"prouctName"]]];
            if ([[[responseObject objectForKey:@"body"] objectForKey:@"note"] length] < 1) {
                self.machineRemark.text = [@"备注：" stringByAppendingString:@"无"];
            } else {
                self.machineRemark.text = [@"备注：" stringByAppendingString:[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"body"] objectForKey:@"note"]]];
            }
            self.machineType.text = [@"型号：" stringByAppendingString:[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"body"] objectForKey:@"prouctModel"]]];
            self.machineDistance.text = [@"距离我：" stringByAppendingString:[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"body"] objectForKey:@"distance"]]];
            self.positionLabel.text = [@"农机位置：" stringByAppendingString:[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"body"] objectForKey:@"address"]]];
            self.nameLabel.text = [@"姓名：" stringByAppendingString:[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"body"] objectForKey:@"prouctName"]]];
            self.phoneLabel.text = [@"手机："  stringByAppendingString:[NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"body"] objectForKey:@"prouctName"]]];
            self.positionView.hidden = NO;
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }

    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark -定位
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.locationTimeout = 5;
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:YES];
    
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
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAAnnotationView*annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
//        self.longitude = annotation.coordinate.longitude;
//        self.latitude = annotation.coordinate.latitude;
        
        CGRect annotationViewRect = annotationView.frame;
        annotationView.frame = CGRectMake(annotationViewRect.origin.x, annotationViewRect.origin.y, 200, 200);
//        annotationView.image = [UIImage imageNamed:@"nongji"];
        for (MachineModel *model in self.positionArray) {
            if ([model.lat doubleValue] == annotation.coordinate.latitude) {
                switch ([model.carType integerValue]) {
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
            }
        }
//        UITapGestureRecognizer *tapPosition = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseMethodToshow)];
//        [annotationView addGestureRecognizer:tapPosition];

        return annotationView;
    }
    // 自定义userLocation对应的annotationView
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
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    NSLog(@"%f", view.annotation.coordinate.latitude);
    NSString *defaultImage = @"CF_Map_Tractors_Default";
    NSString *selectedImage = @"CF_Map_Tractors_Selected";
    for (MachineModel *model in self.positionArray) {
        if ([model.lat doubleValue] == view.annotation.coordinate.latitude) {
            switch ([model.carType integerValue]) {
                case 1:
                    defaultImage = @"CF_Map_Tractors_Default";
                    selectedImage = @"CF_Map_Tractors_Selected";
                    break;
                case 2:
                    defaultImage = @"CF_Map_Harvester_Defult";
                    selectedImage = @"CF_Map_Harvester_Selected";
                    break;
                case 3:
                    defaultImage = @"CF_Map_RiceTransplanter_Defult";
                    selectedImage = @"CF_Map_RiceTransplanter_Selected";
                    break;
                case 4:
                    defaultImage = @"CF_Map_Dryer_Defult";
                    selectedImage = @"CF_Map_Dryer_Selected";
                    break;
                default:
                    break;
            }
        }
    }
    if ([view.annotation isKindOfClass:[PointAnnotation class]]) {
        view.image = [UIImage imageNamed:selectedImage];
        if (self.selectedPin && self.selectedPinStatus == 1) {
            self.selectedPin.image = [UIImage imageNamed:_lastSelectedImage];
        }
        self.selectedPinStatus = 1;
        self.selectedPin = view;

        PointAnnotation *pointAnn = view.annotation;
        [self getCarDistanceWithModel:pointAnn.model];
    } else {
//        view.image = [UIImage imageNamed:_lastSelectedImage];
    }
    _lastSelectedImage = defaultImage;
}
#pragma mark - 设置大头针坐标
- (void)initAnnotations
{
    NSMutableArray *coordinates = [NSMutableArray array];
    for (int i = 0; i < _positionArray.count; i++)
    {
        MachineModel *model = _positionArray[i];
        PointAnnotation *pointAnnotation = [[PointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([model.lat doubleValue],[model.lng doubleValue]);
        pointAnnotation.title = @"";
        pointAnnotation.model = model;
        [coordinates addObject:pointAnnotation];
    }
    [_mapView addAnnotations:coordinates];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.myMachineTableview.hidden = YES;
    self.positionView.hidden = YES;
    self.selectedPin.image = [UIImage imageNamed:_lastSelectedImage];
    self.selectedPinStatus = 0;
}
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    self.myMachineTableview.hidden = YES;
    self.positionView.hidden = YES;
    self.selectedPin.image = [UIImage imageNamed:_lastSelectedImage];
    self.selectedPinStatus = 0;
}
#pragma mark -打电话
- (void)callTheUser{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@", self.phoneLabel.text];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
