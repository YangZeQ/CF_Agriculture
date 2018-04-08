//
//  CFRepairsStationInfoViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsStationInfoViewController.h"
#import "CFCommentInfoViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "MapPinView.h"
#import "PointAnnotation.h"
@interface CFRepairsStationInfoViewController ()<AMapLocationManagerDelegate, MAMapViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong)AMapLocationManager *locationManager;
@property (nonatomic, strong)NSMutableArray *positionArray;
@property (nonatomic, strong)NSMutableArray *machineArray;
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, strong)UIView *positionView;
@property (nonatomic, strong)UIView *otherPositionView;
@property (nonatomic, strong)MAMapView *mapView;
@property (nonatomic, strong)UIButton *mapButton;
@property (nonatomic, assign)double latitude;
@property (nonatomic, assign)double longitude;
@property (nonatomic, strong)NSString *stationLocation;
@property (nonatomic, strong)MAAnnotationView *selectedPin;
@property (nonatomic, assign)NSInteger selectedPinStatus;

@property (nonatomic, strong)UIView *stationBackgroundView;
//维修站信息
@property (nonatomic, strong)UIImageView *stationImageView;
@property (nonatomic, strong)UILabel *stationAddress;
@property (nonatomic, strong)UILabel *stationDistance;
@property (nonatomic, strong)UILabel *businessTimeLabel;
@property (nonatomic, strong)UILabel *contactLabel;
@property (nonatomic, strong)UILabel *contactPhoneLabel;
//评论
@property (nonatomic, strong)UILabel *commentInfoLabel;
@property (nonatomic, strong)UILabel *commentPhoneLabel;
@property (nonatomic, strong)UILabel *commentTextLabel;
@property (nonatomic, strong)UILabel *commentTimeLabel;
@end

@implementation CFRepairsStationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"维修站详情";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    [self createStationInfoView];
    [self getRepairsStationInfo];
    // Do any additional setup after loading the view.
}
- (void)createStationInfoView{
    [self showTheMapView];
    _stationBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight + 466 * screenHeight, CF_WIDTH, CF_HEIGHT - navHeight - 466 * screenHeight)];
    _stationBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_stationBackgroundView];
    //图片
    _stationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, 130 * screenWidth, 130 * screenHeight)];
    if ([_stationModel.type integerValue] == 1) {
        _stationImageView.image = [UIImage imageNamed:@"CF_Station_Maintenance"];
    } else {
        _stationImageView.image = [UIImage imageNamed:@"CF_Station_Agency"];
    }
    [_stationBackgroundView addSubview:_stationImageView];
    //名称
    UILabel *stationTitle = [[UILabel alloc]initWithFrame:CGRectMake(_stationImageView.frame.size.width + _stationImageView.frame.origin.x + 20 * screenWidth, _stationImageView.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 190 * screenWidth, 40 * screenHeight)];
    [stationTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    stationTitle.text = self.stationModel.serviceCompany;
    [_stationBackgroundView addSubview:stationTitle];
    //类型
    UILabel *stationType = [[UILabel alloc]initWithFrame:CGRectMake(stationTitle.frame.origin.x, stationTitle.frame.size.height + stationTitle.frame.origin.y + 5 * screenHeight, stationTitle.frame.size.width, stationTitle.frame.size.height)];
    stationType.text = @"维修站类型：";
    stationType.font = CFFONT14;
    stationType.textColor = [UIColor darkGrayColor];
    [_stationBackgroundView addSubview:stationType];
    //星级
    UILabel *stationStarLabel = [[UILabel alloc]initWithFrame:CGRectMake(stationType.frame.origin.x, stationType.frame.size.height + stationType.frame.origin.y + 5 * screenHeight, stationTitle.frame.size.width, stationTitle.frame.size.height)];
    stationStarLabel.text = @"服务星级：";
    stationStarLabel.font = CFFONT14;
    stationStarLabel.textColor = [UIColor darkGrayColor];
    [_stationBackgroundView addSubview:stationStarLabel];
    UIImageView *stationStar = [[UIImageView alloc]initWithFrame:CGRectMake(stationTitle.frame.origin.x, stationType.frame.size.height + stationType.frame.origin.y + 10 * screenHeight, stationTitle.frame.size.width, stationTitle.frame.size.height)];
    stationStar.image = [UIImage imageNamed:@""];
    [_stationBackgroundView addSubview:stationStar];
    //地址
    _stationAddress = [[UILabel alloc]initWithFrame:CGRectMake(_stationImageView.frame.origin.x, _stationImageView.frame.origin.y + _stationImageView.frame.size.height + 10 * screenHeight, [UIScreen mainScreen].bounds.size.width - 60 * screenWidth, 30 * screenHeight)];
    _stationAddress.text = @"地址：";
    _stationAddress.font = CFFONT13;
    _stationAddress.textColor = [UIColor grayColor];
    [_stationBackgroundView addSubview:_stationAddress];
    //距离
    _stationDistance = [[UILabel alloc]initWithFrame:CGRectMake(_stationImageView.frame.origin.x, _stationAddress.frame.origin.y + _stationAddress.frame.size.height + 10 * screenHeight, _stationAddress.frame.size.width, _stationAddress.frame.size.height)];
    _stationDistance.text = @"距离：";
    _stationDistance.font = CFFONT13;
    _stationDistance.textColor = [UIColor grayColor];
    NSString *distance = [[[[NSString stringWithFormat:@"%ld", [_stationModel.distance integerValue] / 1000] stringByAppendingString:@"."] stringByAppendingString:[NSString stringWithFormat:@"%ld", [_stationModel.distance integerValue] % 1000]] stringByAppendingString:@"Km"];
    _stationDistance.text = [_stationDistance.text stringByAppendingString:distance];
    [_stationBackgroundView addSubview:_stationDistance];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(_stationImageView.frame.origin.x, _stationDistance.frame.size.height + _stationDistance.frame.origin.y + 20 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 2 * screenHeight)];
    lineLabel.backgroundColor = BackgroundColor;
    [_stationBackgroundView addSubview:lineLabel];
    
    _businessTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineLabel.frame.origin.x, lineLabel.frame.size.height + lineLabel.frame.origin.y + 10 * screenHeight, lineLabel.frame.size.width, 40 * screenHeight)];
    _businessTimeLabel.text = @"营业时间：";
    _businessTimeLabel.font = CFFONT14;
    _businessTimeLabel.textColor = [UIColor darkGrayColor];
    [_stationBackgroundView addSubview:_businessTimeLabel];
    
    _contactLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineLabel.frame.origin.x, _businessTimeLabel.frame.size.height + _businessTimeLabel.frame.origin.y + 10 * screenHeight, lineLabel.frame.size.width, _businessTimeLabel.frame.size.height)];
    _contactLabel.text = @"联  系  人：";
    _contactLabel.font = CFFONT14;
    _contactLabel.textColor = [UIColor darkGrayColor];
    [_stationBackgroundView addSubview:_contactLabel];
    
    _contactPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineLabel.frame.origin.x, _contactLabel.frame.size.height + _contactLabel.frame.origin.y + 10 * screenHeight, lineLabel.frame.size.width, _businessTimeLabel.frame.size.height)];
    _contactPhoneLabel.text = @"电       话：";
    _contactPhoneLabel.font = CFFONT14;
    _contactPhoneLabel.textColor = [UIColor darkGrayColor];
    [_stationBackgroundView addSubview:_contactPhoneLabel];
    
    UIView *commentView = [[UIView alloc]initWithFrame:CGRectMake(0, _contactPhoneLabel.frame.size.height + _contactPhoneLabel.frame.origin.y + 20 * screenHeight, self.view.frame.size.width, 100 * screenHeight)];
    commentView.backgroundColor = BackgroundColor;
    [_stationBackgroundView addSubview:commentView];
    
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineLabel.frame.origin.x, 0, 100 * screenWidth, commentView.frame.size.height)];
    commentLabel.userInteractionEnabled = YES;
    commentLabel.text = @"评论";
    [commentView addSubview:commentLabel];
    _commentInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 230 * screenWidth, 0, 150 * screenWidth, commentView.frame.size.height)];
    _commentInfoLabel.text = @"共50条评论";
    _commentInfoLabel.font = CFFONT14;
    _commentInfoLabel.textColor = [UIColor grayColor];
    _commentInfoLabel.userInteractionEnabled = YES;
    _commentInfoLabel.textAlignment = NSTextAlignmentRight;
    [commentView addSubview:_commentInfoLabel];
    UITapGestureRecognizer *tapMoreComment = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getMoreCommentInfo)];
    [_commentInfoLabel addGestureRecognizer:tapMoreComment];
    
    UIImageView *commentInfoImage = [[UIImageView alloc]initWithFrame:CGRectMake(_commentInfoLabel.frame.origin.x + _commentInfoLabel.frame.size.width + 10 * screenWidth, _commentInfoLabel.frame.origin.y + 35 * screenHeight, 30 * screenWidth, 30 * screenHeight)];
    commentInfoImage.image = [UIImage imageNamed:@"CF_Station_Info"];
    commentInfoImage.userInteractionEnabled = YES;
    [commentView addSubview:commentInfoImage];
//    UIButton *commentInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    commentInfoButton.frame = CGRectMake(_commentInfoLabel.frame.origin.x, _commentInfoLabel.frame.origin.y, 200 * screenWidth, _commentInfoLabel.frame.size.height);
//    [commentView addSubview:commentInfoButton];
    
    _commentPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineLabel.frame.origin.x, commentView.frame.size.height + commentView.frame.origin.y + 10 * screenHeight, lineLabel.frame.size.width, 40 * screenHeight)];
    _commentPhoneLabel.text = @"150*****857";
    _commentPhoneLabel.font = CFFONT14;
    _commentPhoneLabel.textColor = [UIColor grayColor];
    [_stationBackgroundView addSubview:_commentPhoneLabel];
    
    _commentTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineLabel.frame.origin.x, _commentPhoneLabel.frame.size.height + _commentPhoneLabel.frame.origin.y + 10 * screenHeight, lineLabel.frame.size.width, 40 * screenHeight)];
    _commentTextLabel.text = @"服务态度非常好服务态度非常好服务态度非常好服务态度非常好服务态度非常好";
    _commentTextLabel.font = CFFONT15;
    [_stationBackgroundView addSubview:_commentTextLabel];
    
    _commentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineLabel.frame.origin.x, _commentTextLabel.frame.size.height + _commentTextLabel.frame.origin.y + 10 * screenHeight, lineLabel.frame.size.width, 40 * screenHeight)];
    _commentTimeLabel.text = @"昨天 14:37";
    _commentTimeLabel.textColor = [UIColor grayColor];
    _commentTimeLabel.font = CFFONT13;
    [_stationBackgroundView addSubview:_commentTimeLabel];
    
    [self initAnnotations];
}
- (void)showTheMapView{
    
    self.stationLocation = self.stationModel.location;
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, navHeight, CF_WIDTH, 466 * screenHeight)];
    UIButton *repairStationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    repairStationButton.frame = CGRectMake(CF_WIDTH - 118 * screenWidth, 40 * screenHeight, 58 * screenWidth, 58 * screenHeight);
    [repairStationButton setImage:[UIImage imageNamed:@"CF_Map_RepairStation_Button"] forState:UIControlStateNormal];
    [repairStationButton addTarget:self action:@selector(repairStationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:repairStationButton];
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userButton.frame = CGRectMake(repairStationButton.frame.origin.x, repairStationButton.frame.size.height + repairStationButton.frame.origin.y + 80 * screenHeight, repairStationButton.frame.size.width, repairStationButton.frame.size.height);
    [userButton addTarget:self action:@selector(userButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [userButton setImage:[UIImage imageNamed:@"CF_Map_User_Button"] forState:UIControlStateNormal];
    [_mapView addSubview:userButton];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
    pan.delegate = self;
    [_mapView addGestureRecognizer:pan];
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
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"begin");
        [UIView animateWithDuration:0.5 animations:^{
            _stationBackgroundView.frame = CGRectMake(0, self.view.frame.size.height, CF_WIDTH, CF_HEIGHT - navHeight - _mapView.frame.size.height);
        }];
        _mapView.frame = self.view.bounds;
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"beginend");
        [UIView animateWithDuration:0.5 animations:^{
            _mapView.frame = CGRectMake(0, navHeight, self.view.frame.size.width, 466 * screenHeight);
            _stationBackgroundView.frame = CGRectMake(0, navHeight + _mapView.frame.size.height, CF_WIDTH, CF_HEIGHT - navHeight - _mapView.frame.size.height);
        }];
    }
}
- (void)repairStationButtonClick
{
    NSArray *strArray = [self.stationLocation componentsSeparatedByString:@","];
    _mapView.centerCoordinate = CLLocationCoordinate2DMake([strArray[1] doubleValue], [strArray[0] doubleValue]);
}
- (void)userButtonClick
{
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
#pragma mark 手势代理方法 ，判断触摸的是地图还是外层的view
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //判断如果是百度地图的view 既可以实现手势拖动 scrollview 的滚动关闭
    if ([gestureRecognizer.view isKindOfClass:[MAMapView class]] ){
        return YES;
    }else{
        return NO;
    }
    
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

        CGRect annotationViewRect = annotationView.frame;
        annotationView.frame = CGRectMake(annotationViewRect.origin.x, annotationViewRect.origin.y, 200, 200);
        annotationView.image = [UIImage imageNamed:@"CF_Map_RepairStation"];
        
        //        UITapGestureRecognizer *tapPosition = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseMethodToshow)];
        //        [annotationView addGestureRecognizer:tapPosition];
        
        return annotationView;
    }
    // 自定义userLocation对应的annotationView
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        self.longitude = annotation.coordinate.longitude;
        self.latitude = annotation.coordinate.latitude;
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
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    
    if ([view.annotation isKindOfClass:[PointAnnotation class]]) {
//        view.image = [UIImage imageNamed:@"nongjiselected"];
        if (self.selectedPin && self.selectedPinStatus == 1) {
//            self.selectedPin.image = [UIImage imageNamed:@"nongji"];
        }
        self.selectedPinStatus = 1;
        self.selectedPin = view;
        
        PointAnnotation *pointAnn = view.annotation;
//        [self getCarDistanceWithModel:pointAnn.model];
    } else {
//        view.image = [UIImage imageNamed:@"nongji"];
    }
}

#pragma mark - 设置大头针坐标
- (void)initAnnotations
{
    NSMutableArray *coordinates = [NSMutableArray array];
    NSArray *strArray = [self.stationLocation componentsSeparatedByString:@","];
    PointAnnotation *pointAnnotation = [[PointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([strArray[1] doubleValue],[strArray[0] doubleValue]);
    pointAnnotation.title = @"";
    pointAnnotation.model = [[MachineModel alloc]init];
    pointAnnotation.model.lat = strArray[0];
    pointAnnotation.model.lng = strArray[1];
    [coordinates addObject:pointAnnotation];
    [_mapView addAnnotations:coordinates];
    
}
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    
}
#pragma mark - 获取维修站详情
- (void)getRepairsStationInfo
{
    NSDictionary *params = @{
                             @"serviceId":self.stationModel.serviceId,
                             };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"serviceInfo/getServiceInfoById" Loading:1 Params:params Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            self.stationModel = [CFRepairsStationModel stationModelWithDictionary:[[responseObject objectForKey:@"body"] objectForKey:@"result"]];
            [self reloadRepairsStationInfoView];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[[responseObject objectForKey:@"head"]objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];

        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
// 重新赋值维修站信息
- (void)reloadRepairsStationInfoView
{
    _stationAddress.text = [[[_stationAddress.text stringByAppendingString:_stationModel.province] stringByAppendingString:_stationModel.city] stringByAppendingString:_stationModel.county];
    if ([_stationModel.companyType integerValue] == 1) {
        _stationImageView.image = [UIImage imageNamed:@"CF_Station_Maintenance"];
    } else {
        _stationImageView.image = [UIImage imageNamed:@"CF_Station_Agency"];
    }
    _commentInfoLabel.text = [NSString stringWithFormat:@"共%@条评论", [NSString stringWithFormat:@"%@", _stationModel.commentNum]];
    _contactLabel.text = [_contactLabel.text stringByAppendingString:_stationModel.contactName];
    _contactPhoneLabel.text = [_contactPhoneLabel.text stringByAppendingString:_stationModel.contactMobile];
    _commentPhoneLabel.text = _stationModel.mobile;
    _commentTextLabel.text = _stationModel.commentContent;
    _commentTimeLabel.text = _stationModel.commentTime;
    
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_commentPhoneLabel.frame.size.width - 50 * screenWidth, 0, 50 * screenWidth, _commentPhoneLabel.frame.size.height)];
    commentLabel.textAlignment = NSTextAlignmentRight;
    NSLog(@"%@", [NSString stringWithFormat:@"%@", self.stationModel.commentLevel]);
    if ([[NSString stringWithFormat:@"%@", self.stationModel.commentLevel] length] == 1) {
         commentLabel.text = [NSString stringWithFormat:@"%@.0", _stationModel.commentLevel];
    } else {
         commentLabel.text = [NSString stringWithFormat:@"%@", _stationModel.commentLevel];
    }
    [_commentPhoneLabel addSubview:commentLabel];
    
    for (int i = 0; i < [_stationModel.commentLevel integerValue]; i++) {
        UIImageView *commentLevelImage = [[UIImageView alloc]initWithFrame:CGRectMake(_commentPhoneLabel.frame.size.width - 110 * screenWidth - 50 * i * screenWidth, 3 * screenHeight, 25 * screenWidth, 25 * screenHeight)];
        commentLevelImage.image = [UIImage imageNamed:@"CF_Comment_Star_Full"];
        [_commentPhoneLabel addSubview:commentLevelImage];
    }
}
- (void)getMoreCommentInfo
{
    if ([self.stationModel.commentNum integerValue] < 1) {
        [MBManager showBriefAlert:@"暂无评论" time:1];
        return;
    }
    CFCommentInfoViewController *commentInfo = [[CFCommentInfoViewController alloc]init];
    commentInfo.serviceId = self.stationModel.serviceId;
    commentInfo.commentLevel = _stationModel.commentLevel;
    NSLog(@"%@", self.stationModel.serviceId);
    [self.navigationController pushViewController:commentInfo animated:YES];
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchbeg");
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    if (_selected) {
//        [UIView animateWithDuration:0.5 animations:^{
//            _stationBackgroundView.frame = CGRectMake(0, self.view.frame.size.height, CF_WIDTH, CF_HEIGHT - navHeight - _mapView.frame.size.height);
//        }];
//        _mapView.frame = self.view.bounds;
//    } else {
//        [UIView animateWithDuration:0.5 animations:^{
//            _mapView.frame = CGRectMake(0, navHeight, self.view.frame.size.width, 466 * screenHeight);
//            _stationBackgroundView.frame = CGRectMake(0, navHeight + _mapView.frame.size.height, CF_WIDTH, CF_HEIGHT - navHeight - _mapView.frame.size.height);
//        }];
//    }
//    _selected = !_selected;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchend");
}
- (void)touchesCanceled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

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
