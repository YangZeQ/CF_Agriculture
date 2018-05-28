//
//  TestViewController.m
//  ChangFa
//
//  Created by Developer on 2018/4/17.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "TestViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "PointAnnotation.h"
@interface TestViewController ()<AMapLocationManagerDelegate, MAMapViewDelegate>
@property (nonatomic, strong)AMapLocationManager *locationManager;
@property (nonatomic, strong)MAMapView *mapView;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showTheMapView];
    // Do any additional setup after loading the view.
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
    _mapView.showsCompass = NO;
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(31.686143391928, 119.952612033421);
    [_mapView addAnnotation:pointAnnotation];
    //    _mapView.centerCoordinate = CLLocationCoordinate2DMake(self.stationLatitude, self.stationLongitude);
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
//    self.latitude = location.coordinate.latitude;
//    self.longitude = location.coordinate.longitude;
}
#pragma mark - 设置大头针坐标
- (void)initAnnotations
{
    NSMutableArray *coordinates = [NSMutableArray array];
    PointAnnotation *pointAnnotation = [[PointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(31.686143391928, 119.852612033421);
    pointAnnotation.title = @"";
//    pointAnnotation.model = [[MachineModel alloc]init];
//    pointAnnotation.model.lat = [NSString stringWithFormat:@"%f", self.stationLatitude];
//    pointAnnotation.model.lng = [NSString stringWithFormat:@"%f", self.stationLongitude];
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
    NSLog(@"%@", mapView.annotations);
    // 自定义userLocation对应的annotationView
    if ([annotation isKindOfClass:[MAAnnotationView class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAAnnotationView*annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        CGRect annotationViewRect = annotationView.frame;
        annotationView.frame = CGRectMake(annotationViewRect.origin.x, annotationViewRect.origin.y, 200, 200);
        annotationView.image = [UIImage imageNamed:@"CF_Map_RepairStation"];
        
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
