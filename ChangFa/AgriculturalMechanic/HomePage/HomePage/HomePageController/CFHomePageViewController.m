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
#import "CFAgencyManagerViewController.h"
#import "SDCycleScrollView.h"

#import "CFCommenViewController.h"

#import "CFWorkOrderInfoViewController.h"
#import "CFWorkOrderListViewController.h"
#import "CFWorkOrderTableViewCell.h"
#import "CFWorkOrderModel.h"
#import "CFMapNavigationViewController.h"
@interface CFHomePageViewController ()<SDCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, BandMachineViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UIButton *rightButton;
//@property (nonatomic, strong)UIScrollView *imageScrollView;
@property (nonatomic, strong)SDCycleScrollView *imageScrollView;
@property (nonatomic, strong)CFBasePageControl *pageView;
@property (nonatomic, strong)UICollectionView *machineCollection;
@property (nonatomic, strong)MyMachineCollectionViewCell *machineCell;
@property (nonatomic, strong)AddMachineCollectionViewCell *addCell;
@property (nonatomic, strong)UICollectionViewCell *cell;
@property (nonatomic, strong)NSMutableArray *myMachineArray;
@property (nonatomic, strong)NSMutableArray *carouselFigureArray;

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
    UIView *navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navHeight)];
    
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
//轮播图
    [self getCarouselImage];
    _imageScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, navigationView.frame.size.height, self.view.frame.size.width, 402 * Height) delegate:self placeholderImage:[UIImage imageNamed:@"SDCycleScrollView"]];
    _imageScrollView.currentPageDotImage = [UIImage imageNamed:@"yuandian"];
    _imageScrollView.pageDotImage = [UIImage imageNamed:@"yuanhuan"];
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
    
    UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    statusButton.frame = CGRectMake(103 * screenWidth, 88 * screenHeight, 68 * screenWidth, 68 * screenHeight);
    [statusButton setImage:[UIImage imageNamed:@"CF_Agency_MachineStatus"] forState:UIControlStateNormal];
    [statusButton addTarget:self action:@selector(agencyMachineStatusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [agencyView addSubview:statusButton];
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(21 * screenWidth, statusButton.frame.size.height + statusButton.frame.origin.y + 50 * screenHeight, 85 * 2 * screenWidth + 68 * screenWidth, 50 * screenHeight)];
    statusLabel.text = @"库存信息";
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [agencyView addSubview:statusLabel];
    
    
    UIButton *managerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    managerButton.frame = CGRectMake(statusButton.frame.size.width + statusButton.frame.origin.x + 85 * 2 * screenWidth, statusButton.frame.origin.y, statusButton.frame.size.width, statusButton.frame.size.height);
    [managerButton setImage:[UIImage imageNamed:@"CF_Agency_Manager"] forState:UIControlStateNormal];
    [managerButton addTarget:self action:@selector(agencyManagerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [agencyView addSubview:managerButton];
    UILabel *managerLabel = [[UILabel alloc]initWithFrame:CGRectMake(statusLabel.frame.size.width + statusLabel.frame.origin.x, statusLabel.frame.origin.y, statusLabel.frame.size.width, statusLabel.frame.size.height)];
    managerLabel.text = @"库存管理";
    managerLabel.textAlignment = NSTextAlignmentCenter;
    [agencyView addSubview:managerLabel];
    
    UIButton *sellButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sellButton.frame = CGRectMake(managerButton.frame.size.width + managerButton.frame.origin.x + 85 * 2 * screenWidth, managerButton.frame.origin.y, managerButton.frame.size.width, managerButton.frame.size.height);
    [sellButton setImage:[UIImage imageNamed:@"CF_Agency_Sell"] forState:UIControlStateNormal];
    [sellButton addTarget:self action:@selector(agencySellButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [agencyView addSubview:sellButton];
    UILabel *sellLabel = [[UILabel alloc]initWithFrame:CGRectMake(managerLabel.frame.size.width + managerLabel.frame.origin.x, managerLabel.frame.origin.y, managerLabel.frame.size.width, managerLabel.frame.size.height)];
    sellLabel.text = @"农机出售";
    sellLabel.textAlignment = NSTextAlignmentCenter;
    [agencyView addSubview:sellLabel];
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
    CFAgencySellViewController *sell = [[CFAgencySellViewController alloc]init];
    [self.navigationController pushViewController:sell animated:YES];
}
- (void)agencyManagerButtonClick
{
    CFAgencyManagerViewController *manager = [[CFAgencyManagerViewController alloc]init];
    [self.navigationController pushViewController:manager animated:YES];
}
// 销售员
- (void)createSalesPersonView
{
    self.view.backgroundColor = BackgroundColor;
    self.tabBarController.tabBar.hidden = YES;
    UIView *salesPersonBackView = [[UIView alloc]initWithFrame:CGRectMake(0, _imageScrollView.frame.size.height + _imageScrollView.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 280 * screenHeight)];
    salesPersonBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:salesPersonBackView];
    
    UIButton *agencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agencyButton.frame = CGRectMake(332 * screenWidth, 60 * screenHeight, 86 * screenWidth, 86 * screenHeight);
    [agencyButton setImage:[UIImage imageNamed:@"agencyImage"] forState:UIControlStateNormal];
    [agencyButton addTarget:self action:@selector(agencyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [salesPersonBackView addSubview:agencyButton];
    
    UILabel *agencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, agencyButton.frame.size.height + agencyButton.frame.origin.y + 50 * screenHeight, self.view.frame.size.width, 50 * screenHeight)];
    agencyLabel.text =@"我的经销商";
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
    // 我的农机
    UILabel *myMachineLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * Width, _imageScrollView.frame.size.height + _imageScrollView.frame.origin.y + 40 * Height, selfWidith - 30 * Width, 50 * Height)];
    myMachineLabel.text = @"我的农机";
    myMachineLabel.textColor = [UIColor darkGrayColor];
    myMachineLabel.font = CFFONT18;
    [self.view addSubview:myMachineLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _machineCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, myMachineLabel.frame.origin.y + myMachineLabel.frame.size.height, self.view.frame.size.width, 414 * Height) collectionViewLayout:layout];
    _machineCollection.backgroundColor = [UIColor whiteColor];
    layout.sectionInset = UIEdgeInsetsMake(0 * Height, 0 * Width, 0 * Height, 0 * Width);
    layout.itemSize = CGSizeMake(334 * Width, 414 * Height);
    layout.minimumLineSpacing = 0 * Width;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _machineCollection.showsHorizontalScrollIndicator = NO;
    _machineCollection.delegate = self;
    _machineCollection.dataSource = self;
    [_machineCollection registerClass:[MyMachineCollectionViewCell class] forCellWithReuseIdentifier:@"machineCellId"];
    [_machineCollection registerClass:[AddMachineCollectionViewCell class] forCellWithReuseIdentifier:@"addMachineCellId"];
    [self.view addSubview:_machineCollection];
    [self getMyMachineInformation];
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
    
    UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, orderButton.frame.size.height + orderButton.frame.origin.y + 50 * screenHeight, self.view.frame.size.width, 50 * screenHeight)];
    orderLabel.text =@"派工单";
    orderLabel.textAlignment = NSTextAlignmentCenter;
    [salesPersonBackView addSubview:orderLabel];
    
    self.orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, salesPersonBackView.frame.size.height + salesPersonBackView.frame.origin.y + 20 * screenHeight, CF_WIDTH, 370 * screenHeight) style:UITableViewStyleGrouped];
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.orderTableView.backgroundColor = BackgroundColor;
    [self.view addSubview:self.orderTableView];
    
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
            for (NSDictionary *dictResult in [dictBody objectForKey:@"resultList"]) {
                MachineModel *model = [MachineModel machineModelWithDictionary:dictResult];
                [self.myMachineArray addObject:model];
                [self.machineCollection reloadData];
            }
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
                            };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"dispatch/selectDispatchsByStatus" Loading:0 Params:param Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"dispatch%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        [self.orderArray removeAllObjects];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            for (NSDictionary *dict in [[responseObject objectForKey:@"body"] objectForKey:@"resultList"]) {
                CFWorkOrderModel *model = [CFWorkOrderModel orderModelWithDictionary:dict];
                [self.orderArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.orderTableView reloadData];
            });
            
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
