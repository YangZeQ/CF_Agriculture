//
//  CFWorkOrderInfoViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/19.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFWorkOrderInfoViewController.h"
#import "CFMapNavigationViewController.h"
#import "CFFillInOrderViewController.h"
#import "CFReasonTextView.h"
#import "CFRepairsPhotoCell.h"
#import "CFRepairsRecordCourseTableViewCell.h"
#import "CFWordOrderInfoModel.h"
@interface CFWorkOrderInfoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UIScrollView *orderScrollView;
@property (nonatomic, strong)UILabel *orderNumberLabel;
@property (nonatomic, strong)UILabel *orderNameLabel;
@property (nonatomic, strong)UILabel *orderPhoneLabel;
@property (nonatomic, strong)UILabel *switchLabel;
@property (nonatomic, strong)UIImageView *switchImage;
@property (nonatomic, strong)UIImageView *machineImage;
@property (nonatomic, strong)UILabel *machineNameLabel;
@property (nonatomic, strong)UILabel *machineTypeLabel;
@property (nonatomic, strong)UILabel *machineTimeLabel;
@property (nonatomic, strong)UILabel *machinePositionLabel;
@property (nonatomic, strong)UILabel *costLabel;
@property (nonatomic, strong)CFReasonTextView *reasonTextView;
@property (nonatomic, strong)UICollectionView *repairsPhotoCollection;
@property (nonatomic, strong)CFRepairsPhotoCell *repairsPhotoCell;
@property (nonatomic, strong)UILabel *photoLabel;
@property (nonatomic, strong)UIView *repairProgressView;
@property (nonatomic, strong)UITableView *repairProgressTableView;
@property (nonatomic, strong)UITableView *vagueProgressTableView;
@property (nonatomic, strong)UIButton *submitButton;
@property (nonatomic, strong)UIView *vagueView;

@property (nonatomic, strong)CFWordOrderInfoModel *orderInfoModel;

@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *statusTimeArray;

@property (nonatomic, assign)BOOL switchStatus;
@property (nonatomic, strong)NSString *fileIds;
@end

@implementation CFWorkOrderInfoViewController
- (NSMutableArray *)photoArray
{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (NSMutableArray *)statusTimeArray
{
    if (_statusTimeArray == nil) {
        _statusTimeArray = [NSMutableArray array];
    }
    return _statusTimeArray;
}
- (UIView *)vagueView
{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _vagueView.hidden = YES;
        UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, navHeight + 89 * screenHeight, CF_WIDTH - 60 * screenWidth, 950 * screenHeight)];
        progressView.backgroundColor = [UIColor whiteColor];
        progressView.layer.cornerRadius = 20 * screenWidth;
        [_vagueView addSubview:progressView];
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, progressView.frame.size.width, 140 * screenHeight)];
        titleView.backgroundColor = BackgroundColor;
        titleView.layer.cornerRadius = 20 * screenWidth;
        [progressView addSubview:titleView];
        UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(173 * screenWidth, 24 * screenHeight, 92 * screenWidth, 92 * screenHeight)];
        titleImage.image = [UIImage imageNamed:@"CF_Course"];
        [titleView addSubview:titleImage];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleImage.frame.size.width + titleImage.frame.origin.x + 50 * screenWidth, 50 * screenHeight, 300 * screenWidth, 40 * screenHeight)];
        titleLabel.text = @"维修进程";
        [titleView addSubview:titleLabel];
        _vagueProgressTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 140 * screenHeight, progressView.frame.size.width, progressView.frame.size.height - 160 * screenHeight) style:UITableViewStylePlain];
        _vagueProgressTableView.delegate = self;
        _vagueProgressTableView.dataSource = self;
        _vagueProgressTableView.backgroundColor = [UIColor whiteColor];
        _vagueProgressTableView.bounces = NO;
        _vagueProgressTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _vagueProgressTableView.showsVerticalScrollIndicator = NO;
        [progressView addSubview:_vagueProgressTableView];
        [self.view addSubview:_vagueView];
    }
    return _vagueView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.title = @"派工单详情";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    [self createWorkOrderInfoView];
    [self getOrderInfoWithDispatchId:self.dispatchId];
    // Do any additional setup after loading the view.
}
- (void)createWorkOrderInfoView
{
    self.orderScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT)];
    self.orderScrollView.userInteractionEnabled = YES;
    self.orderScrollView.contentSize = CGSizeMake(0, 2250 * screenHeight);
    [self.view addSubview:self.orderScrollView];
    
    self.fileIds = @"";
    // 报修人信息
    UIView *orderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, 222 * screenHeight)];
    orderView.backgroundColor = [UIColor whiteColor];
    [self.orderScrollView addSubview:orderView];
    _orderNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 20 * screenHeight, CF_WIDTH - 60 * screenWidth, 40 * screenHeight)];
    _orderNumberLabel.text = @"派工单号：";
    _orderNumberLabel.font = CFFONT14;
    [orderView addSubview:_orderNumberLabel];
    UILabel *orderLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _orderNumberLabel.frame.size.height + _orderNumberLabel.frame.origin.y + 20 * screenHeight, CF_WIDTH, 2 * screenHeight)];
    orderLineLabel.backgroundColor = BackgroundColor;
    [orderView addSubview:orderLineLabel];
    _orderNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, orderLineLabel.frame.size.height + orderLineLabel.frame.origin.y + 20 * screenHeight, _orderNumberLabel.frame.size.width, _orderNumberLabel.frame.size.height)];
    _orderNameLabel.text = @"报修人姓名：";
    _orderNameLabel.font = CFFONT14;
    [orderView addSubview:_orderNameLabel];
    _orderPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, _orderNameLabel.frame.size.height + _orderNameLabel.frame.origin.y + 20 * screenHeight, _orderNumberLabel.frame.size.width, _orderNumberLabel.frame.size.height)];
    _orderPhoneLabel.text = @"报修人电话：";
    _orderPhoneLabel.font = CFFONT14;
    [orderView addSubview:_orderPhoneLabel];
    
    //报修农机信息
    UIView *machineView = [[UIView alloc]initWithFrame:CGRectMake(0, orderView.frame.size.height + orderView.frame.origin.y + 10 * screenHeight, CF_WIDTH, 472 * screenHeight)];
    machineView.backgroundColor = [UIColor whiteColor];
    [self.orderScrollView addSubview:machineView];
    UILabel *machineOrder = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, 24 * screenHeight, _orderNumberLabel.frame.size.width, _orderNumberLabel.frame.size.height)];
    machineOrder.text = @"报修单";
    machineOrder.font = CFFONT15;
    machineOrder.userInteractionEnabled = YES;
    [machineView addSubview:machineOrder];
    _switchLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineView.frame.size.width - 130 * screenWidth, machineOrder.frame.origin.y, 80 * screenWidth, machineOrder.frame.size.height)];
    _switchLabel.text = @"收起";
    _switchLabel.font = CFFONT14;
    _switchLabel.userInteractionEnabled = YES;
    [machineView addSubview:_switchLabel];
    _switchImage = [[UIImageView alloc]initWithFrame:CGRectMake(_switchLabel.frame.size.width + _switchLabel.frame.origin.x, _switchLabel.frame.origin.y + 5 * screenHeight, 15 * screenWidth, 30 * screenHeight)];
    _switchImage.image = [UIImage imageNamed:@"xiugai"];
    _switchImage.userInteractionEnabled = YES;
    _switchStatus = YES;
    [machineView addSubview:_switchImage];
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.frame = CGRectMake(_switchLabel.frame.origin.x, 0, 130 * screenWidth, 88 * screenHeight);
    [switchButton addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [machineView addSubview:switchButton];
    UILabel *machineLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, machineOrder.frame.size.height + machineOrder.frame.origin.y + 24 * screenHeight, _orderNumberLabel.frame.size.width, 2 * screenHeight)];
    machineLineLabel.backgroundColor = BackgroundColor;
    [machineView addSubview:machineLineLabel];
    _machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, machineLineLabel.frame.size.height + machineLineLabel.frame.origin.y + 30 * screenHeight, 120 * screenWidth, 120 * screenHeight)];
    _machineImage.layer.cornerRadius = 60 * screenWidth;
    [machineView addSubview:_machineImage];
    _machineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.size.width + _machineImage.frame.origin.x + 20 * screenWidth, machineLineLabel.frame.size.height + machineLineLabel.frame.origin.y + 40 * screenHeight, machineView.frame.size.width - 200 * screenWidth, 40 * screenHeight)];
    _machineNameLabel.text = @"尽管拖拉机";
    _machineNameLabel.font = CFFONT14;
    [machineView addSubview:_machineNameLabel];
    _machineTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineNameLabel.frame.origin.x, _machineNameLabel.frame.size.height + _machineNameLabel.frame.origin.y + 20 * screenHeight, _machineNameLabel.frame.size.width, _machineNameLabel.frame.size.height)];
    _machineTypeLabel.text = @"CFA254";
    _machineTypeLabel.font = CFFONT14;
    [machineView addSubview:_machineTypeLabel];
    _machineTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, _machineImage.frame.size.height + _machineImage.frame.origin.y + 10 * screenHeight, _orderNumberLabel.frame.size.width, _orderNumberLabel.frame.size.height)];
    _machineTimeLabel.text = @"购买时间";
    _machineTimeLabel.font = CFFONT13;
    [machineView addSubview:_machineTimeLabel];
    UILabel *positionLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _machineTimeLabel.frame.size.height + _machineTimeLabel.frame.origin.y + 20 * screenHeight, CF_WIDTH, 2 * screenHeight)];
    positionLineLabel.backgroundColor = BackgroundColor;
    [machineView addSubview:positionLineLabel];
    _machinePositionLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, positionLineLabel.frame.size.height + positionLineLabel.frame.origin.y + 30 * screenHeight, _orderNumberLabel.frame.size.width, _orderNumberLabel.frame.size.height)];
    _machinePositionLabel.text = @"农机位置：";
    _machinePositionLabel.font = CFFONT14;
    _machinePositionLabel.userInteractionEnabled = YES;
    [machineView addSubview:_machinePositionLabel];
    UIImageView *positionImage = [[UIImageView alloc]initWithFrame:CGRectMake(_switchImage.frame.origin.x, _machinePositionLabel.frame.origin.y + 5 * screenHeight, 15 * screenWidth, 30 * screenHeight)];
    positionImage.image = [UIImage imageNamed:@"xiugai"];
    positionImage.userInteractionEnabled = YES;
    [machineView addSubview:positionImage];
    UIButton *positionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    positionButton.frame = CGRectMake(0, 0, _machinePositionLabel.frame.size.width, _machinePositionLabel.frame.size.height);
    [positionButton addTarget:self action:@selector(positionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_machinePositionLabel addSubview:positionButton];
    _costLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, _machinePositionLabel.frame.size.height + _machinePositionLabel.frame.origin.y + 20 * screenHeight, _orderNumberLabel.frame.size.width, _orderNumberLabel.frame.size.height)];
    _costLabel.text = @"里程费用≈";
    _costLabel.font = CFFONT14;
    _costLabel.textColor = ChangfaColor;
    [machineView addSubview:_costLabel];
    
    //故障描述
    UILabel *reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, machineView.frame.size.height + machineView.frame.origin.y + 40 * screenHeight, _orderNumberLabel.frame.size.width, _orderNumberLabel.frame.size.height)];
    reasonLabel.text = @"故障描述";
    reasonLabel.font = CFFONT15;
    [self.orderScrollView addSubview:reasonLabel];
    _reasonTextView = [[CFReasonTextView alloc]initWithFrame:CGRectMake(0, reasonLabel.frame.size.height + reasonLabel.frame.origin.y + 10 * screenHeight, CF_WIDTH, 380 * screenHeight)];
    //    _reasonTextView.delegate = self;
    _reasonTextView.editable = NO;
    _reasonTextView.maxNumberOfLines = 10;
    _reasonTextView.font = CFFONT15;
    [self.orderScrollView addSubview:_reasonTextView];
    
    //故障照片
    _photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, _reasonTextView.frame.size.height + _reasonTextView.frame.origin.y + 40 * screenHeight, _orderNumberLabel.frame.size.width, _orderNumberLabel.frame.size.height)];
    _photoLabel.text = @"故障照片";
    _photoLabel.font = CFFONT15;
    [self.orderScrollView addSubview:_photoLabel];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _repairsPhotoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _photoLabel.frame.size.height + _photoLabel.frame.origin.y + 10 * screenHeight, CF_WIDTH, 250 * screenHeight) collectionViewLayout:layout];
    _repairsPhotoCollection.backgroundColor = BackgroundColor;
    layout.sectionInset = UIEdgeInsetsMake(0, _orderNumberLabel.frame.origin.x, 0, _orderNumberLabel.frame.origin.x);
    layout.itemSize = CGSizeMake(250 * Width, 250 * Height);
    layout.minimumLineSpacing = 10 * Width;
    layout.minimumInteritemSpacing = 0 * screenWidth;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _repairsPhotoCollection.showsHorizontalScrollIndicator = NO;
    _repairsPhotoCollection.delegate = self;
    _repairsPhotoCollection.dataSource = self;
    [_repairsPhotoCollection registerClass:[CFRepairsPhotoCell class] forCellWithReuseIdentifier:@"repairsPhotoCellId"];
    [self.orderScrollView addSubview:_repairsPhotoCollection];
    
    //维修进程
    _repairProgressView = [[UIView alloc]initWithFrame:CGRectMake(_orderNumberLabel.frame.origin.x, _repairsPhotoCollection.frame.size.height + _repairsPhotoCollection.frame.origin.y + 80 * screenHeight, _orderNumberLabel.frame.size.width, 480 * screenHeight)];
    _repairProgressView.backgroundColor = [UIColor whiteColor];
    _repairProgressView.layer.cornerRadius = 20 * screenWidth;
    _repairProgressView.layer.shadowColor = [UIColor blackColor].CGColor;
    _repairProgressView.layer.shadowOpacity = 0.5;
    _repairProgressView.layer.shadowRadius = 20 * screenWidth;
    _repairProgressView.layer.shadowOffset = CGSizeMake(0, 3 * screenWidth);
    [self.orderScrollView addSubview:_repairProgressView];
    UIImageView *progressImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _repairProgressView.frame.size.width, 120 * screenHeight)];
    progressImage.image = [UIImage imageNamed:@"CF_Order_Progress"];
    progressImage.userInteractionEnabled = YES;
    [_repairProgressView addSubview:progressImage];
    UILabel *repairStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 16 * screenHeight, progressImage.frame.size.width, 50 * screenHeight)];
    repairStatusLabel.text = @"维修进程";
    repairStatusLabel.textColor = [UIColor whiteColor];
    repairStatusLabel.textAlignment =NSTextAlignmentCenter;
    repairStatusLabel.userInteractionEnabled = YES;
    [_repairProgressView addSubview:repairStatusLabel];
    UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(_repairProgressView.frame.size.width / 2 - 15 * screenWidth, repairStatusLabel.frame.size.height + repairStatusLabel.frame.origin.y + 16 * screenHeight, 30 * screenWidth, 15 * screenHeight)];
    buttonImage.image = [UIImage imageNamed:@"CF_Progress_Button"];
    buttonImage.userInteractionEnabled = YES;
    [_repairProgressView addSubview:buttonImage];
    UIButton *repairStatusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    repairStatusButton.frame = progressImage.frame;
    [repairStatusButton addTarget:self action:@selector(repairStatusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_repairProgressView addSubview:repairStatusButton];
    
    self.repairProgressTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, progressImage.frame.size.height, _repairProgressView.frame.size.width, _repairProgressView.frame.size.height - progressImage.frame.size.height - 20 * screenHeight) style:UITableViewStylePlain];
    self.repairProgressTableView.delegate = self;
    self.repairProgressTableView.dataSource = self;
    self.repairProgressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.repairProgressTableView.bounces = NO;
    self.repairProgressTableView.showsVerticalScrollIndicator = NO;
    
    [_repairProgressView addSubview:self.repairProgressTableView];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(0,CF_HEIGHT - 100 * screenHeight, CF_WIDTH, 100 * screenHeight);
//    _submitButton.layer.cornerRadius = 20 * Width;
    [_submitButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setBackgroundColor:ChangfaColor];
    [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
}
#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderInfoModel.statusArray.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    CFRepairsRecordCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFRepairsRecordCourseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID Time:YES];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == self.orderInfoModel.statusArray.count) {
        cell.courseImageView.image = [UIImage imageNamed:@"CF_Status_Current"];
        cell.lineBottomLabel.hidden = YES;
        cell.dayLabel.hidden = YES;
        cell.dayTimeLabel.hidden = YES;
        cell.courseLabel.textColor = ChangfaColor;
    } else {
        cell.courseImageView.image = [UIImage imageNamed:@"CF_Status_Done"];
        cell.lineBottomLabel.hidden = NO;
        cell.dayLabel.hidden = NO;
        cell.dayTimeLabel.hidden = NO;
        cell.dayLabel.text = [self.statusTimeArray[indexPath.row] substringWithRange:NSMakeRange(5, 5)];
        cell.dayTimeLabel.text = [self.statusTimeArray[indexPath.row] substringWithRange:NSMakeRange(11, 5)];
        cell.courseLabel.textColor = [UIColor grayColor];
    }
    cell.status = indexPath.row;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160 * screenHeight;
}
#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.orderInfoModel.filePath.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    _repairsPhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"repairsPhotoCellId" forIndexPath:indexPath];
    [_repairsPhotoCell.repairsPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.orderInfoModel.filePath[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"CF_RepairImage"]];
    return _repairsPhotoCell;
}
#pragma mark - 获取派工单详情
- (void)getOrderInfoWithDispatchId:(NSString *)dispatchId
{
    NSDictionary *param = @{
                            @"dispatchId":dispatchId,
                            };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"dispatch/selectById" Loading:0 Params:param Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"dispatch%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            self.orderInfoModel = [CFWordOrderInfoModel orderInfoModelWithDictionary:[[responseObject objectForKey:@"body"] objectForKey:@"result"]];
            [self setOrderInforToView];
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
- (void)updataOrderStatus
{
    NSString *status = [NSString stringWithFormat:@"%ld", [self.orderInfoModel.status integerValue] + 1];

    NSDictionary *param = @{
                            @"status":status,
                            @"dispatchId":self.orderInfoModel.disId,
                            @"fileIds":self.fileIds,
                            };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"dispatch/updateDispatchStatus" Loading:0 Params:param Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"dispatch%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            [self getOrderInfoWithDispatchId:self.dispatchId];
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
#pragma mark - 页面赋值
- (void)setOrderInforToView
{
    switch ([self.orderInfoModel.machineType integerValue]) {
        case 1:
            _machineImage.image = [UIImage imageNamed:@"CFTuoLaJi"];
            break;
        case 2:
            _machineImage.image = [UIImage imageNamed:@"CFShouGeJi"];
            break;
        case 3:
            _machineImage.image = [UIImage imageNamed:@"CFChaYangji"];
            break;
        case 4:
            _machineImage.image = [UIImage imageNamed:@"CFHongGanJi"];
            break;
        default:
            break;
    }
    _orderNumberLabel.text = [_orderNumberLabel.text stringByAppendingString:self.orderInfoModel.disNum];
    _orderNameLabel.text = [_orderNameLabel.text stringByAppendingString:self.orderInfoModel.contactName];
    _orderPhoneLabel.text = [_orderPhoneLabel.text stringByAppendingString:self.orderInfoModel.contactMobile];
    _machineNameLabel.text = [_machineNameLabel.text stringByAppendingString:self.orderInfoModel.machineName];
    _machineTypeLabel.text = [_machineTypeLabel.text stringByAppendingString:self.orderInfoModel.machineModel];
    _machineTimeLabel.text = [_machineTimeLabel.text stringByAppendingString:self.orderInfoModel.buyTime];
    _machinePositionLabel.text = [_machinePositionLabel.text stringByAppendingString:self.orderInfoModel.taskAddress];
    _costLabel.text = [_costLabel.text stringByAppendingString:self.orderInfoModel.disNum];
    _reasonTextView.text = self.orderInfoModel.descriptions;
    if ([self.orderInfoModel.status integerValue] == 7) {
        [_submitButton setTitle:@"接受订单" forState:UIControlStateNormal];
    } else if ([self.orderInfoModel.status integerValue] == 14) {
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
    } else {
        [_submitButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    for (NSArray *arr in self.orderInfoModel.statusArray) {
        [self.statusTimeArray addObject:[arr[1] objectForKey:@"time"]];
    }
    [self.repairProgressTableView reloadData];
    [self.repairsPhotoCollection reloadData];
    [self.repairProgressTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.orderInfoModel.statusArray.count inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
#pragma mark - 展开/收起
- (void)switchButtonClick:(UIButton *)sender
{
    CGRect progressFrame = _repairProgressView.frame;
    if (_switchStatus) {
        _switchImage.frame = CGRectMake(_switchLabel.frame.size.width + _switchLabel.frame.origin.x - 7.5 * screenWidth, _switchLabel.frame.origin.y +15 * screenHeight, 30 * screenWidth, 15 * screenHeight);
        self.orderScrollView.contentSize = CGSizeMake(0, 1400 * screenHeight);
        _switchImage.image = [UIImage imageNamed:@"CF_Progress_Button"];
        _switchLabel.text = @"展开";
        _reasonTextView.hidden = YES;
        _photoLabel.hidden = YES;
        _repairsPhotoCollection.hidden = YES;
        _repairProgressView.frame = CGRectMake(progressFrame.origin.x, _reasonTextView.frame.origin.y - 50 * screenHeight, progressFrame.size.width, progressFrame.size.height);
    } else {
        _switchImage.frame = CGRectMake(_switchLabel.frame.size.width + _switchLabel.frame.origin.x, _switchLabel.frame.origin.y + 5 * screenHeight, 15 * screenWidth, 30 * screenHeight);
        self.orderScrollView.contentSize = CGSizeMake(0, 2250 * screenHeight);
        _switchImage.image = [UIImage imageNamed:@"xiugai"];
        _switchLabel.text = @"收起";
        _reasonTextView.hidden = NO;
        _photoLabel.hidden = NO;
        _repairsPhotoCollection.hidden = NO;
        _repairProgressView.frame = CGRectMake(progressFrame.origin.x, _repairsPhotoCollection.frame.size.height + _repairsPhotoCollection.frame.origin.y + 80 * screenHeight, progressFrame.size.width, progressFrame.size.height);
    }
    _switchStatus = !_switchStatus;
}
- (void)positionButtonClick
{
    NSArray *strArray = [self.orderInfoModel.taskLocation componentsSeparatedByString:@","];
    CFMapNavigationViewController *map = [[CFMapNavigationViewController alloc]init];
    map.stationLatitude = [strArray[1] doubleValue];
    map.stationLongitude = [strArray[0] doubleValue];
    map.position = self.orderInfoModel.taskAddress;
    [self presentViewController:map animated:YES completion:^{
        
    }];
}
- (void)repairStatusButtonClick
{
    self.vagueView.hidden = NO;
}
- (void)submitButtonClick
{
    if ([self.orderInfoModel.status integerValue] == 14) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([self.orderInfoModel.status integerValue] < 10) {
        [self updataOrderStatus];
    } else {
        CFFillInOrderViewController *fill = [[CFFillInOrderViewController alloc]init];
        fill.repairId = self.orderInfoModel.repairId;
        fill.disId = self.orderInfoModel.disId;
        fill.disNum =  self.orderInfoModel.disNum;
        [self.navigationController pushViewController:fill animated:YES];
    }
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.vagueView.hidden = YES;
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
