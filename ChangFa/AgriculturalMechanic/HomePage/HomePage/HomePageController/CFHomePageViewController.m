//
//  CFHomePageViewController.m
//  ChangFa
//
//  Created by dev on 2017/12/29.
//  Copyright © 2017年 dev. All rights reserved.
//
#import "CFHomePageViewController.h"
#import "CFBasePageControl.h"
#import "MyMachineCollectionViewCell.h"
#import "AddMachineCollectionViewCell.h"
#import "SystemNewsViewController.h"
#import "BandMachineViewController.h"
#import "CFAFNetWorkingMethod.h"
#import "MachineInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "MachineModel.h"
#import "AgencyModel.h"
#import "CFAgencyMachineStatusViewController.h"
#import "CFAgencySellViewController.h"
#import "CFSalesPersonMyAgencyViewController.h"
#import "CFChooseTypeViewController.h"
//#import "CFAgencyManagerViewController.h"
#import "SDCycleScrollView.h"
#import "CFAddMachineViewController.h"
#import "ScanViewController.h"

#import "CFCommenViewController.h"

#import "CFWorkOrderInfoViewController.h"
#import "CFWorkOrderListViewController.h"
#import "CFWorkOrderTableViewCell.h"
#import "CFWorkOrderModel.h"
#import "CFMapNavigationViewController.h"
@interface CFHomePageViewController ()<SDCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, BandMachineViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, scanViewControllerDelegate>
@property (nonatomic, strong)UIButton *rightButton;
@property (nonatomic, strong)UIView *navigationView;
@property (nonatomic, strong)UILabel *navigationLabel;
@property (nonatomic, strong)UILabel *locationLabel;
@property (nonatomic, strong)UIImageView *weatherImage;
@property (nonatomic, strong)UILabel *temperatureLabel;
@property (nonatomic, strong)UILabel *temperatureRangeLabel;
@property (nonatomic, strong)SDCycleScrollView *imageScrollView;
@property (nonatomic, strong)UILabel *imageTitleLabel;
@property (nonatomic, strong)SDCycleScrollView *machineScrollView;
@property (nonatomic, strong)CFBasePageControl *pageView;
@property (nonatomic, strong)UICollectionView *machineCollection;
@property (nonatomic, strong)MyMachineCollectionViewCell *machineCell;
@property (nonatomic, strong)AddMachineCollectionViewCell *addCell;
@property (nonatomic, strong)UICollectionViewCell *cell;
@property (nonatomic, strong)NSMutableArray *myMachineArray;
@property (nonatomic, strong)NSMutableArray *carouselFigureArray;
@property (nonatomic, strong)UIView *signView;
@property (nonatomic, strong)UITableView *orderTableView;
@property (nonatomic, strong)NSMutableArray *orderArray;
@end

@implementation CFHomePageViewController

- (NSMutableArray *)myMachineArray
{
    if (!_myMachineArray) {
        _myMachineArray = [NSMutableArray array];
    }
    return _myMachineArray;
}
- (NSMutableArray *)carouselFigureArray
{
    if (!_carouselFigureArray) {
        _carouselFigureArray = [NSMutableArray array];
    }
    return _carouselFigureArray;
}
- (NSMutableArray *)orderArray
{
    if (_orderArray == nil) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}
- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserRoleType"]] integerValue] == 1) {
        [self getMyMachineInformation];
    }
    if ([[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserRoleType"]] integerValue] == 6) {
        [self getWaittingForReceiveOrderList];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatHomePageView];
    // Do any additional setup after loading the view.
}
#pragma mark -铺设界面
- (void)creatHomePageView
{
    // 模拟导航栏铺设
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navHeight)];
    NSLog(@"navheight:%lf", navHeight);
    _navigationView.backgroundColor = ChangfaColor;
    [self.view addSubview:_navigationView];
    _navigationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, _navigationView.frame.size.width, 44)];
    _navigationLabel.text = @"常发农装";
    _navigationLabel.userInteractionEnabled = YES;
    _navigationLabel.font = [UIFont systemFontOfSize:[self autoScaleW:20]];
    _navigationLabel.textAlignment = NSTextAlignmentCenter;
    _navigationLabel.textColor = [UIColor whiteColor];
    [_navigationView addSubview:_navigationLabel];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(_navigationView.frame.size.width - 44 * Width, 0, 44 * Width, 44);
    [_rightButton setImage:[UIImage imageNamed:@"xinxi"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationLabel addSubview:_rightButton];
//轮播图
    [self getCarouselImage];
    _imageScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, _navigationView.frame.size.height, self.view.frame.size.width, 406 * screenHeight) delegate:self placeholderImage:[UIImage imageNamed:@"SDCycleScrollView"]];
    _imageScrollView.currentPageDotImage = [UIImage imageNamed:@"ImageScroll_Current"];
    _imageScrollView.pageDotImage = [UIImage imageNamed:@"ImageScroll_Other"];
    _imageScrollView.pageControlDotSize = CGSizeMake(30 * screenWidth, 8 * screenHeight);
    [self.view addSubview:_imageScrollView];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserRoleType"]] integerValue] == 1) {
        [self createMachineWorkerView];
    } else if ([[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserRoleType"]] integerValue] == 2) {
        [self createAgencyView];
    } else if ([[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserRoleType"]] integerValue] == 3) {
        [self createSalesPersonView];
    } else if ([[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserRoleType"]] integerValue] == 4) {
        [self createCompanyView];
    } else if ([[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserRoleType"]] integerValue] == 6) {
        [self createWarrantyOfficerView];
    }
}

// 营销公司/仓管
- (void)createCompanyView
{
    self.view.backgroundColor = BackgroundColor;
    self.tabBarController.tabBar.hidden = YES;
    UIView *scanMachineView = [[UIView alloc]initWithFrame:CGRectMake(0, _imageScrollView.frame.size.height + _imageScrollView.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 380 * screenHeight)];
    scanMachineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scanMachineView];
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake(self.view.frame.size.width / 2 - 100 * screenWidth, 40 * screenHeight, 200 * screenWidth, 200 * screenHeight);
    [scanButton setImage:[UIImage imageNamed:@"scanCompany"] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(tapScanView) forControlEvents:UIControlEventTouchUpInside];
    [scanMachineView addSubview:scanButton];
    
    UILabel *scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, scanButton.frame.size.height + scanButton.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 50 * screenHeight)];
    scanLabel.text = @"农机扫码";
    scanLabel.textColor = BlackTextColor;
    scanLabel.textAlignment = NSTextAlignmentCenter;
    [scanMachineView addSubview:scanLabel];
}
- (void)tapScanView
{
    BandMachineViewController *band = [[BandMachineViewController alloc]init];
    band.userType = @"company";
    band.navigationItem.title = @"绑定农机";
    [self.navigationController pushViewController:band animated:YES];
}
// 经销商
- (void)createAgencyView
{
    self.view.backgroundColor = BackgroundColor;
    self.tabBarController.tabBar.hidden = YES;
    UIView *agencyView = [[UIView alloc]initWithFrame:CGRectMake(0, self.imageScrollView.frame.size.height + self.imageScrollView.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 360 * screenHeight)];
    agencyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:agencyView];
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake((CF_WIDTH / 3 - 66 * screenWidth) / 2, 88 * screenHeight, 66 * screenWidth, 66 * screenHeight);
    [scanButton setImage:[UIImage imageNamed:@"Agency_Scan"] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(agencySellButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [agencyView addSubview:scanButton];
    UILabel *scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, scanButton.frame.size.height + scanButton.frame.origin.y + 30 * screenHeight, CF_WIDTH / 3, 50 * screenHeight)];
    scanLabel.text = @"扫一扫";
    scanLabel.textColor = BlackTextColor;
    scanLabel.textAlignment = NSTextAlignmentCenter;
    [agencyView addSubview:scanLabel];
    
    UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    orderButton.frame = CGRectMake(CF_WIDTH / 3 + scanButton.frame.origin.x, scanButton.frame.origin.y, scanButton.frame.size.width, scanButton.frame.size.height);
    [orderButton setImage:[UIImage imageNamed:@"Agency_Order"] forState:UIControlStateNormal];
    [orderButton addTarget:self action:@selector(agencyOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [agencyView addSubview:orderButton];
    UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(CF_WIDTH / 3, scanLabel.frame.origin.y, scanLabel.frame.size.width, scanLabel.frame.size.height)];
    orderLabel.text = @"派工单";
    orderLabel.textColor = BlackTextColor;
    orderLabel.textAlignment = NSTextAlignmentCenter;
    [agencyView addSubview:orderLabel];
    
    UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    statusButton.frame = CGRectMake(CF_WIDTH / 3 * 2 + scanButton.frame.origin.x, scanButton.frame.origin.y, scanButton.frame.size.width, scanButton.frame.size.height);
    [statusButton setImage:[UIImage imageNamed:@"Agency_ Inventory"] forState:UIControlStateNormal];
    [statusButton addTarget:self action:@selector(agencyMachineStatusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [agencyView addSubview:statusButton];
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(CF_WIDTH / 3 * 2, scanLabel.frame.origin.y, scanLabel.frame.size.width, scanLabel.frame.size.height)];
    statusLabel.text = @"库存信息";
    statusLabel.textColor = BlackTextColor;
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [agencyView addSubview:statusLabel];
}
- (void)agencyMachineStatusButtonClick
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    CFAgencyMachineStatusViewController *machineStatus = [[CFAgencyMachineStatusViewController alloc]init];
    machineStatus.navigationItem.title = @"农机状态";
    machineStatus.distributorsID = [userDefault objectForKey:@"UserDistributorId"];
    [self.navigationController pushViewController:machineStatus animated:YES];
}
- (void)agencySellButtonClick
{
    ScanViewController *scan = [[ScanViewController alloc]init];
    scan.delegate = self;
//    scan.scanType = @"0";
//    [self.navigationController pushViewController:scan animated:YES];
    [self presentViewController:scan animated:NO completion:^{
        
    }];
}
- (void)scanGetInformation:(MachineModel *)model
{
    CFChooseTypeViewController *choose = [[CFChooseTypeViewController alloc]init];
    choose.machineModel = model;
    [self.navigationController pushViewController:choose animated:YES];
}
- (void)agencyOrderButtonClick
{
    CFWorkOrderListViewController *orderList = [[CFWorkOrderListViewController alloc]init];
    [self.navigationController pushViewController:orderList animated:YES];
}
// 销售员
- (void)createSalesPersonView
{
    self.view.backgroundColor = BackgroundColor;
    self.tabBarController.tabBar.hidden = YES;
    UIView *salesPersonBackView = [[UIView alloc]initWithFrame:CGRectMake(0, _imageScrollView.frame.size.height + _imageScrollView.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 280 * screenHeight)];
    salesPersonBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:salesPersonBackView];
    
//    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    scanButton.frame = CGRectMake((CF_WIDTH / 2 - 66 * screenWidth) / 2, 60 * screenHeight, 66 * screenWidth, 66 * screenHeight);
//    [scanButton setImage:[UIImage imageNamed:@"CF_ScanImage"] forState:UIControlStateNormal];
//    [scanButton addTarget:self action:@selector(tapScanView) forControlEvents:UIControlEventTouchUpInside];
//    [salesPersonBackView addSubview:scanButton];
//
//    UILabel *scanLabel = [[UILabel alloc]initWithFrame:CGRectMake((CF_WIDTH / 2 - 200 * screenWidth) / 2, scanButton.frame.size.height + scanButton.frame.origin.y + 30 * screenHeight, 200 * screenWidth, 50 * screenHeight)];
//    scanLabel.text = @"扫一扫";
//    scanLabel.font = CFFONT15;
//    scanLabel.textColor = [UIColor grayColor];
//    scanLabel.textAlignment = NSTextAlignmentCenter;
//    [salesPersonBackView addSubview:scanLabel];
    
    UIButton *agencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agencyButton.frame = CGRectMake((CF_WIDTH - 66 * screenWidth) / 2, 60 * screenHeight, 66 * screenWidth, 66 * screenHeight);
    [agencyButton setImage:[UIImage imageNamed:@"CF_AgencyImage"] forState:UIControlStateNormal];
    [agencyButton addTarget:self action:@selector(agencyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [salesPersonBackView addSubview:agencyButton];
    
    UILabel *agencyLabel = [[UILabel alloc]initWithFrame:CGRectMake((CF_WIDTH - 200 * screenWidth) / 2, agencyButton.frame.size.height + agencyButton.frame.origin.y + 30 * screenHeight, 200 * screenWidth, 50 * screenHeight)];
    agencyLabel.text =@"我的经销商";
    agencyLabel.font = CFFONT15;
    agencyLabel.textColor = BlackTextColor;
    agencyLabel.textAlignment = NSTextAlignmentCenter;
    [salesPersonBackView addSubview:agencyLabel];

}
- (void)agencyButtonClick
{
    CFSalesPersonMyAgencyViewController *sales = [[CFSalesPersonMyAgencyViewController alloc]init];
    [self.navigationController pushViewController:sales animated:YES];
}
// 农机手
- (void)createMachineWorkerView
{
    UILabel *myMachineLabel = [[UILabel alloc]initWithFrame:CGRectMake(38 * screenWidth, _imageScrollView.frame.size.height + _imageScrollView.frame.origin.y + 30 * screenHeight, selfWidith - 30 * screenWidth, 50 * screenHeight)];
    myMachineLabel.text = @"我的农机";
    myMachineLabel.textColor = [UIColor grayColor];
    myMachineLabel.font = CFFONT14;
    [self.view addSubview:myMachineLabel];
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//    _machineCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, myMachineLabel.frame.origin.y + myMachineLabel.frame.size.height, self.view.frame.size.width, 414 * screenHeight) collectionViewLayout:layout];
//    _machineCollection.backgroundColor = [UIColor whiteColor];
//    layout.sectionInset = UIEdgeInsetsMake(0 * screenHeight, 0 * screenWidth, 0 * screenHeight, 0 * screenWidth);
//    layout.itemSize = CGSizeMake(334 * screenWidth, 414 * screenHeight);
//    layout.minimumLineSpacing = 10 * screenWidth;
//    layout.minimumInteritemSpacing = 0;
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    _machineCollection.showsHorizontalScrollIndicator = NO;
//    _machineCollection.delegate = self;
//    _machineCollection.dataSource = self;
//    [_machineCollection registerClass:[MyMachineCollectionViewCell class] forCellWithReuseIdentifier:@"machineCellId"];
//    [_machineCollection registerClass:[AddMachineCollectionViewCell class] forCellWithReuseIdentifier:@"addMachineCellId"];
//    [self.view addSubview:_machineCollection];
//    [self getMyMachineInformation];
//    return;
    _rightButton.hidden = YES;
    self.view.backgroundColor = UserBackgroundColor;
    
    _navigationView.backgroundColor = [UIColor whiteColor];
    _navigationLabel.text = @"丁酉年腊月初六";
    _navigationLabel.font = CFFONT13;
    _navigationLabel.textColor = [UIColor blackColor];
    UIImageView *locationImage = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 34, 24 * screenWidth, 32 * screenHeight)];
    locationImage.image = [UIImage imageNamed:@"Home_Location"];
    [_navigationView addSubview:locationImage];
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(73 * screenWidth, 34, 60 * screenWidth, 28 * screenHeight)];
    _locationLabel.text = @"常州";
    _locationLabel.textColor = [UIColor grayColor];
    _locationLabel.font = CFFONT14;
    [_navigationView addSubview:_locationLabel];
    
    _weatherImage = [[UIImageView alloc]initWithFrame:CGRectMake(600 * screenWidth, 33, 44 * screenWidth, 44 * screenHeight)];
    _weatherImage.image = [UIImage imageNamed:@"Home_Weather"];
    [_navigationView addSubview:_weatherImage];
    _temperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(688 * screenWidth, 28, 40 * screenWidth, 40 * screenHeight)];
    _temperatureLabel.text = @"8°";
    _temperatureLabel.font = CFFONT18;
    [_navigationView addSubview:_temperatureLabel];
    _temperatureRangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(672 * screenWidth, 51, 56 * screenWidth, 17 * screenHeight)];
    _temperatureRangeLabel.text = @"6/10°";
    _temperatureRangeLabel.font = CFFONT9;
    _temperatureRangeLabel.textAlignment = NSTextAlignmentRight;
    [_navigationView addSubview:_temperatureRangeLabel];
    // 我的农机

    
    //轮播图标题栏
    UIImageView *scrollTitleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _imageScrollView.frame.size.height - 80 * screenHeight, CF_WIDTH, 80 * screenHeight)];
    scrollTitleView.image = [UIImage imageNamed:@"ImageScroll_Title"];
    [_imageScrollView addSubview:scrollTitleView];
    _imageTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 * screenWidth, 0, CF_WIDTH, 70 * screenHeight)];
    _imageTitleLabel.text = @"每日资讯：常发农机开启新旅程";
    _imageTitleLabel.font = CFFONT16;
    _imageScrollView.pageControlBottomOffset = -10 * screenHeight;
    [scrollTitleView addSubview:_imageTitleLabel];
    
//    _imageScrollView.titleLabelHeight = 60 * screenHeight;
//    _imageScrollView.titleLabelTextFont = CFFONT16;
//    _imageScrollView.titlesGroup = [NSArray arrayWithObjects:@"每日资讯：常发农机开启新旅程", nil];
//    _imageScrollView.titleLabelBackgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//    _imageScrollView.pageControlBottomOffset = 80 * screenHeight;
    
    // 添加农机
    UILabel *additionLabel = [[UILabel alloc]initWithFrame:CGRectMake(555 * screenWidth, myMachineLabel.frame.origin.y, 120 * screenWidth, myMachineLabel.frame.size.height)];
    additionLabel.text = @"添加农机";
    additionLabel.font = CFFONT14;
    additionLabel.textColor = [UIColor grayColor];
    additionLabel.userInteractionEnabled = YES;
    [self.view addSubview:additionLabel];
    UIButton *additionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    additionButton.frame = CGRectMake(additionLabel.frame.size.width + additionLabel.frame.origin.x + 20 * screenWidth, additionLabel.frame.origin.y + 10 * screenHeight, 30 * screenWidth, 30                                                                        * screenHeight);
    [additionButton setImage:[UIImage imageNamed:@"Home_Addition"] forState:UIControlStateNormal];
    [additionButton addTarget:self action:@selector(additionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:additionButton];
    UIButton *additionMachineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    additionMachineButton.frame = CGRectMake(additionLabel.frame.origin.x, additionLabel.frame.origin.y, additionLabel.frame.size.width + additionButton.frame.size.width + 20 * screenWidth, additionLabel.frame.size.height);
    [additionMachineButton addTarget:self action:@selector(additionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:additionMachineButton];
    
    // 农机轮播图
    _machineScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, additionLabel.frame.size.height + additionLabel.frame.origin.y + 8 * screenHeight, CF_WIDTH, 300 * screenHeight) delegate:self placeholderImage:[UIImage imageNamed:@"Home_Machine_Placeholder"]];
    _machineScrollView.currentPageDotImage = [UIImage imageNamed:@"yuandian"];
    _machineScrollView.pageDotImage = [UIImage imageNamed:@"yuanhuan"];
    _machineScrollView.pageControlBottomOffset = -42 * screenHeight;
    _machineScrollView.hidesForSinglePage = NO;
    _machineScrollView.delegate = self;
    _machineScrollView.pageControlDotSize = CGSizeMake(10 * screenWidth, 10 * screenWidth);
    [self.view addSubview:_machineScrollView];
    
    // 功能列表
    UIView *functionView = [[UIView alloc]initWithFrame:CGRectMake(0, _machineScrollView.frame.size.height + _machineScrollView.frame.origin.y + 30  * screenHeight, CF_WIDTH, 200 * screenHeight)];
    functionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:functionView];
    NSArray *functionImageArray = [NSArray arrayWithObjects:@"Home_Function_Repair", @"Home_Function_RepairRecord", @"Home_Function_Warning", @"Home_Function_Financial", nil];
    NSArray *functionTitleArray = [NSArray arrayWithObjects:@"报修", @"报修记录", @"报警信息", @"金融服务", nil];
    for (int i = 0; i < functionImageArray.count; i++) {
        UIImageView *functionImage = [[UIImageView alloc]initWithFrame:CGRectMake(CF_WIDTH / 4 * i + (CF_WIDTH / 4 - 50 *screenWidth) / 2, 35 * screenHeight, 60 * screenWidth, 60 * screenHeight)];
        functionImage.image = [UIImage imageNamed:functionImageArray[i]];
        [functionView addSubview:functionImage];
        
        UILabel *functionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CF_WIDTH / 4 * i, functionImage.frame.size.height + functionImage.frame.origin.y +  30 * screenHeight, CF_WIDTH / 4, 50 * screenHeight)];
        functionLabel.text = functionTitleArray[i];
        functionLabel.font = CFFONT14;
        functionLabel.textAlignment = NSTextAlignmentCenter;
        [functionView addSubview:functionLabel];
    }
    
}
#pragma mark -SDCycleScrollView Delegate实现
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}

#pragma mark -UICollectionView Delegate实现
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.myMachineArray.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   _machineCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"machineCellId" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        _addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addMachineCellId" forIndexPath:indexPath];
        return _addCell;
    }
    _machineCell.model = self.myMachineArray[indexPath.row - 1];
    return _machineCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        BandMachineViewController *band = [[BandMachineViewController alloc]init];
        band.userType = @"worker";
        band.delegate = self;
        band.navigationItem.title = @"添加农机";
        [self.navigationController pushViewController:band animated:YES];
    } else {
        [self getDetailMachineInformation:self.myMachineArray[indexPath.row - 1]];
    }
}
- (void)bindMachineSuccess
{
    [self getMyMachineInformation];
}
// 三包员
- (void)createWarrantyOfficerView
{
    self.view.backgroundColor = BackgroundColor;
    self.tabBarController.tabBar.hidden = YES;
    UIView *salesPersonBackView = [[UIView alloc]initWithFrame:CGRectMake(0, _imageScrollView.frame.size.height + _imageScrollView.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 280 * screenHeight)];
    salesPersonBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:salesPersonBackView];
    
    UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    orderButton.frame = CGRectMake(332 * screenWidth, 60 * screenHeight, 86 * screenWidth, 86 * screenHeight);
    [orderButton setImage:[UIImage imageNamed:@"CF_WorkOrder"] forState:UIControlStateNormal];
    [orderButton addTarget:self action:@selector(orderButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [salesPersonBackView addSubview:orderButton];
    _signView = [[UIView alloc]initWithFrame:CGRectMake(orderButton.frame.size.width + orderButton.frame.origin.x - 10 * screenWidth, orderButton.frame.origin.y - 10 * screenHeight, 20 * screenWidth, 20 * screenHeight)];
    _signView.backgroundColor = [UIColor redColor];
    _signView.layer.cornerRadius = 10 * screenWidth;
    _signView.hidden = YES;
    [salesPersonBackView addSubview:_signView];
    
    UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, orderButton.frame.size.height + orderButton.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 50 * screenHeight)];
    orderLabel.text =@"派工单";
    orderLabel.font = CFFONT15;
    orderLabel.textColor = [UIColor grayColor];
    orderLabel.textAlignment = NSTextAlignmentCenter;
    [salesPersonBackView addSubview:orderLabel];
    
//    self.orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, salesPersonBackView.frame.size.height + salesPersonBackView.frame.origin.y + 20 * screenHeight, CF_WIDTH, 370 * screenHeight) style:UITableViewStyleGrouped];
//    self.orderTableView.delegate = self;
//    self.orderTableView.dataSource = self;
//    self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.orderTableView.backgroundColor = BackgroundColor;
//    [self.view addSubview:self.orderTableView];
    
    [self getWaittingForReceiveOrderList];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    CFWorkOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFWorkOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.model = self.orderArray[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CFWorkOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.model = self.orderArray[indexPath.section];
    return 180 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFWorkOrderModel *model = self.orderArray[indexPath.section];
    CFWorkOrderInfoViewController *orderInfo = [[CFWorkOrderInfoViewController alloc]init];
    orderInfo.dispatchId = model.dispatchId;
    [self.navigationController pushViewController:orderInfo animated:YES];
}
- (void)orderButtonClick
{
    CFWorkOrderListViewController *orderList = [[CFWorkOrderListViewController alloc]init];
    [self.navigationController pushViewController:orderList animated:YES];
}
#pragma mark -导航栏右按钮点击时事件
- (void)rightButtonClick
{
    SystemNewsViewController *system = [[SystemNewsViewController alloc]init];
    system.navigationViewHeight = self.navigationViewHeight;
    [self.navigationController pushViewController:system animated:YES];
}
#pragma mark -获取所有绑定农机
- (void)getMyMachineInformation
{
    NSDictionary *dict = @{
                           @"userName":@"",
                           @"userpwd":@"",
                           @"loginType":@0,
                           @"accessToken":@"",
                           @"openId":@"",
                           };
   
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/getUserBindCar" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            NSDictionary *dictBody = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"body"]];
            [self.myMachineArray removeAllObjects];
            NSMutableArray *modelArray = [NSMutableArray array];
            for (NSDictionary *dictResult in [dictBody objectForKey:@"resultList"]) {
                MachineModel *model = [MachineModel machineModelWithDictionary:dictResult];
                [self.myMachineArray addObject:model];
                [modelArray addObject:@""];
                UIView *machineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, 300 * screenHeight)];
                machineView.backgroundColor = [UIColor whiteColor];
                UIImageView *machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(20 * screenWidth, 60 * screenHeight, 260 * screenWidth, 180 * screenHeight)];
                machineImage.image = [UIImage imageNamed:@"Machine_Image"];
                [machineView addSubview:machineImage];
                UILabel *machineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.size.width + machineImage.frame.origin.x + 20 * screenWidth, 84 * screenHeight, CF_WIDTH - 330 * screenWidth, 30 * screenHeight)];
                machineNameLabel.text = [NSString stringWithFormat:@"类型：%@", model.productName];
                machineNameLabel.font = CFFONT16;
                [machineView addSubview:machineNameLabel];
                UILabel *machineTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineNameLabel.frame.origin.x, machineNameLabel.frame.size.height + machineNameLabel.frame.origin.y + 20 * screenHeight, machineNameLabel.frame.size.width, machineNameLabel.frame.size.height)];
                machineTypeLabel.text = [NSString stringWithFormat:@"型号：%@", model.productModel];
                machineTypeLabel.font = CFFONT16;
                [machineView addSubview:machineTypeLabel];
                UILabel *machineRemarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineNameLabel.frame.origin.x, machineTypeLabel.frame.size.height + machineTypeLabel.frame.origin.y + 20 * screenHeight, machineNameLabel.frame.size.width, machineNameLabel.frame.size.height)];
                machineRemarkLabel.text = [NSString stringWithFormat:@"备注：%@", model.note];
                machineRemarkLabel.font = CFFONT14;
                machineRemarkLabel.textColor = [UIColor grayColor];
                [machineView addSubview:machineRemarkLabel];
                [self.machineScrollView.machineModelArray addObject:machineView];
//                [self.machineCollection reloadData];
            }
            self.machineScrollView.imageURLStringsGroup = modelArray;
            self.machineScrollView.isAddMachineView = YES;
        } else if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 300) {
            [self.myMachineArray removeAllObjects];
            [self.machineCollection reloadData];
        }  else {
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
#pragma mark -获取农机详情
- (void)getDetailMachineInformation:(MachineModel *)dictModel
{
    NSDictionary *dictPost = @{
                           @"imei":dictModel.imei,
                           @"carBar":dictModel.productBarCode,
                           };

    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/getUserCarInfo" Params:dictPost Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            NSDictionary *dictBody = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"body"]];
            MachineInfoViewController *machine = [[MachineInfoViewController alloc]init];
            machine.model = [MachineModel machineModelWithDictionary:dictBody];
            [self.navigationController pushViewController:machine animated:YES];
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
#pragma mark -获取轮播图信息
- (void)getCarouselImage
{
    [CFAFNetWorkingMethod requestDataWithUrl:@"notice/getNoticeImgList" Params:nil Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
     NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
     if ([[dict objectForKey:@"code"] integerValue] == 200) {
         NSArray *imageArray = [NSArray arrayWithObject:[[responseObject objectForKey:@"body"] objectForKey:@"resultList"]];
         NSArray *d = [NSArray arrayWithArray:imageArray[0]];
         for (NSDictionary *imageDic in d) {
             [self.carouselFigureArray addObject:[imageDic objectForKey:@"imgurl"]];
         }
         _imageScrollView.imageURLStringsGroup = self.carouselFigureArray;
     } else {
         if (self.carouselFigureArray.count < 1) {
             UIImageView *placeHolderImage = [[UIImageView alloc]initWithFrame:_imageScrollView.frame];
             placeHolderImage.backgroundColor = ChangfaColor;
             placeHolderImage.image = [UIImage imageNamed:@"CF_CarouselImage"];
             [self.view addSubview:placeHolderImage];
         }
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
#pragma mark - 获取未接单信息
- (void)getWaittingForReceiveOrderList
{
    NSDictionary *param = @{
                            @"repairUserId":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserUid"],
                            @"status":@7,
                            @"repairMobile":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"],
                            };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"dispatch/selectDispatchsByStatus" Loading:0 Params:param Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"dispatch%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        [self.orderArray removeAllObjects];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            for (NSDictionary *dict in [[responseObject objectForKey:@"body"] objectForKey:@"resultList"]) {
                CFWorkOrderModel *model = [CFWorkOrderModel orderModelWithDictionary:dict];
                [self.orderArray addObject:model];
                _signView.hidden = NO;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.orderTableView reloadData];
            });
            
        } else if([[dict objectForKey:@"code"] integerValue] == 300) {
            _signView.hidden = YES;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.orderTableView reloadData];
            });
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
// 添加农机
- (void)additionButtonClick
{
    CFAddMachineViewController *addMachine = [[CFAddMachineViewController alloc]init];
    [self.navigationController pushViewController:addMachine animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"it's ok");
}
- (void)didReceiveMemoryWarning
{
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
