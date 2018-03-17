//
//  CFRepairsRecordInfoViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/3.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsRecordInfoViewController.h"
#import "CFRepairsDetailInfoViewController.h"
#import "CFCommenViewController.h"
#import "CFRepairsRecordCourseTableViewCell.h"

@interface CFRepairsRecordInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong)UIView *courseView;
@property (nonatomic, strong)UITableView *courseTableView;
@property (nonatomic, strong)NSMutableArray *courseArray;
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSString *reportId;

@property (nonatomic, strong)UIView *commentView;
@property (nonatomic, strong)UILabel *phoneLabel;
@property (nonatomic, strong)UILabel *commentInfoLabele;
@property (nonatomic, strong)UILabel *oddNumbersLabel;
@property (nonatomic, strong)UILabel *completeTimeLabel;
@property (nonatomic, strong)UILabel *createTimeLabel;
@end

@implementation CFRepairsRecordInfoViewController
- (NSMutableArray *)courseArray
{
    if (_courseArray == nil) {
        _courseArray = [NSMutableArray array];
    }
    return _courseArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.titleArray = @[@"已提交", @"审核通过", @"已接单", @"维修结束", @"待评价", @"已完成"];
    switch ([_recordModel.status integerValue]) {
        case 1:
            self.navigationItem.title = _titleArray[0];
            break;
        case 2:
            self.navigationItem.title = _titleArray[1];
            break;
        case 3:
            self.navigationItem.title = _titleArray[2];
            break;
        case 4:
            self.navigationItem.title = _titleArray[3];
            break;
        case 5:
           self.navigationItem.title = _titleArray[4];
            break;
        case 6:
            self.navigationItem.title = _titleArray[5];
            break;
        default:
            break;
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    [self getRecordStatusInfo];
    [self createRecordInfoView];
    // Do any additional setup after loading the view.
}
- (void)createRecordInfoView
{
    UITapGestureRecognizer *tapMachineInfo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getRecordInfo)];
    UIView *machineInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width, 220 * screenHeight)];
    [machineInfoView addGestureRecognizer:tapMachineInfo];
    machineInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:machineInfoView];
    //图片
    UIImageView *machineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, 160 * screenWidth, 160 * screenHeight)];
    switch ([_recordModel.machineType integerValue]) {
        case 1:
            machineImageView.image = [UIImage imageNamed:@"CFTuoLaJi"];
            break;
        case 2:
            machineImageView.image = [UIImage imageNamed:@"CFShouGeJi"];
            break;
        case 3:
            machineImageView.image = [UIImage imageNamed:@"CFChaYangji"];
            break;
        case 4:
            machineImageView.image = [UIImage imageNamed:@"CFHongGanJi"];
            break;
        default:
            break;
    }
    [machineInfoView addSubview:machineImageView];
    //名称
    UILabel *machineName = [[UILabel alloc]initWithFrame:CGRectMake(machineImageView.frame.size.width + machineImageView.frame.origin.x + 20 * screenWidth, machineImageView.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 176 * screenWidth, 50 * screenHeight)];
    machineName.text = [@"名称：" stringByAppendingString:_recordModel.machineName];
    machineName.font = CFFONT14;
    [machineInfoView addSubview:machineName];
    //类型
    UILabel *machineType = [[UILabel alloc]initWithFrame:CGRectMake(machineName.frame.origin.x, machineName.frame.size.height + machineName.frame.origin.y + 5 * screenHeight, machineName.frame.size.width, machineName.frame.size.height)];
    machineType.text = [@"类型：" stringByAppendingString:_recordModel.machineModel];
    machineType.font = CFFONT14;
    [machineInfoView addSubview:machineType];
    
    UIImageView *infoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CF_WIDTH - 60 * screenWidth, machineType.frame.origin.y + 10 * screenHeight, 15 * screenWidth, 30 * screenHeight)];
    infoImageView.image = [UIImage imageNamed:@"xiugai"];
    [machineInfoView addSubview:infoImageView];
    
    //备注
    UILabel *machineNote = [[UILabel alloc]initWithFrame:CGRectMake(machineType.frame.origin.x, machineType.frame.size.height + machineType.frame.origin.y + 5 * screenHeight, machineType.frame.size.width, machineType.frame.size.height)];
    machineNote.text = [@"备注：" stringByAppendingString:_recordModel.machineRemarks];
    machineNote.font = CFFONT14;
    [machineInfoView addSubview:machineNote];
    
    UILabel *courseLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, machineInfoView.frame.origin.y + machineInfoView.frame.size.height + 50 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 50 * screenHeight)];
    courseLabel.text = @"进程";
    [self.view addSubview:courseLabel];
    
    
    if ([_recordModel.status integerValue] == 6) {
        [self createCommentDoneView];
    } else {
        _courseView = [[UIView alloc]initWithFrame:CGRectMake(courseLabel.frame.origin.x, courseLabel.frame.origin.y + courseLabel.frame.size.height + 20 * screenHeight, courseLabel.frame.size.width, 0 * screenHeight)];
        _courseView.backgroundColor = [UIColor whiteColor];
        _courseView.layer.cornerRadius = 20 * screenWidth;
        [self.view addSubview:_courseView];
        _courseTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 17 * screenHeight, _courseView.frame.size.width, 0) style:UITableViewStylePlain];
        _courseTableView.delegate = self;
        _courseTableView.dataSource = self;
        _courseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_courseView addSubview:_courseTableView];
    }
    
}
- (void)createCommentDoneView
{
    _commentView = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight + 220 * screenHeight + 30 * screenHeight, CF_WIDTH, 474 * screenHeight)];
    _commentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_commentView];
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 20 * screenHeight, CF_WIDTH - 60 * screenWidth, 40 * screenHeight)];
    commentLabel.text = @"我的评论";
    [_commentView addSubview:commentLabel];
    //手机号
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(commentLabel.frame.origin.x, commentLabel.frame.size.height + commentLabel.frame.origin.y + 20 * screenHeight, commentLabel.frame.size.width, commentLabel.frame.size.height)];
    _phoneLabel.text = _recordModel.mobile;
    _phoneLabel.font = CFFONT14;
    _phoneLabel.textColor = [UIColor grayColor];
    [_commentView addSubview:_phoneLabel];
    
    //详情
    _commentInfoLabele = [[UILabel alloc]initWithFrame:CGRectMake(commentLabel.frame.origin.x, _phoneLabel.frame.size.height + _phoneLabel.frame.origin.y + 20 * screenHeight, commentLabel.frame.size.width, commentLabel.frame.size.height)];
    _commentInfoLabele.numberOfLines = 0;
    _commentInfoLabele.text = _recordModel.commentContent;
    [_commentView addSubview:_commentInfoLabele];
    //图片
    UIImageView *commentImageVeiw = [[UIImageView alloc]initWithFrame:CGRectMake(commentLabel.frame.origin.x, _commentInfoLabele.frame.size.height + _commentInfoLabele.frame.origin.y + 20 * screenHeight, 160 * screenWidth, 160 * screenHeight)];
    [_commentView addSubview:commentImageVeiw];
    UILabel *commentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(commentLabel.frame.origin.x, commentImageVeiw.frame.size.height + commentImageVeiw.frame.origin.y + 20 * screenHeight, commentLabel.frame.size.width,  commentLabel.frame.size.height)];
    [_commentView addSubview:commentTimeLabel];
    
    UIView *timeView = [[UIView alloc]initWithFrame:CGRectMake(0, _commentView.frame.size.height + _commentView.frame.origin.y + 30 * screenHeight, CF_WIDTH, 200 * screenHeight)];
    timeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:timeView];
    _oddNumbersLabel = [[UILabel alloc]initWithFrame:CGRectMake(commentLabel.frame.origin.x, 20 * screenHeight, commentLabel.frame.size.width, commentLabel.frame.size.height)];
    _oddNumbersLabel.text = @"报修单号：";
    _oddNumbersLabel.font = CFFONT14;
    [timeView addSubview:_oddNumbersLabel];
    _completeTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(commentLabel.frame.origin.x, _oddNumbersLabel.frame.size.height + _oddNumbersLabel.frame.origin.y + 20 * screenHeight, commentLabel.frame.size.width, commentLabel.frame.size.height)];
    _completeTimeLabel.text = @"完成时间：" ;
    _completeTimeLabel.font = CFFONT14;
    [timeView addSubview:_completeTimeLabel];
    _createTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(commentLabel.frame.origin.x, _completeTimeLabel.frame.size.height + _completeTimeLabel.frame.origin.y + 20 * screenHeight, commentLabel.frame.size.width, commentLabel.frame.size.height)];
    _createTimeLabel.text = @"创建时间：";
    _createTimeLabel.font = CFFONT14;
    [timeView addSubview:_createTimeLabel];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    CFRepairsRecordCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFRepairsRecordCourseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    if (indexPath.row == 0) {
        cell.lineTopLabel.hidden = YES;
        if (_courseArray.count == 1) {
            cell.lineBottomLabel.hidden = YES;
        }
        cell.courseImageView.frame = CGRectMake(60 * screenWidth, cell.lineTopLabel.frame.size.height, 26 * screenWidth, 26 * screenHeight);
        cell.lineBottomLabel.frame = CGRectMake(cell.lineTopLabel.frame.origin.x, cell.courseImageView.frame.size.height + cell.courseImageView.frame.origin.y, cell.lineTopLabel.frame.size.width, 102 * screenHeight);
        cell.courseImageView.image = [UIImage imageNamed:@"CF_Course_Doing"];
        if (self.courseArray.count == 5) {
            [cell.courseLabel removeFromSuperview];
            cell.courseview.content = @"待评价，去评价";
            cell.courseview.eventBlock = ^(NSAttributedString *str) {
                [self goCommentView];
            };
        } else {
            cell.courseLabel.text = self.titleArray[self.courseArray.count - indexPath.row - 1];
        }
        
    } else if (indexPath.row == self.courseArray.count - 1) {
        cell.lineBottomLabel.hidden = YES;
        cell.courseLabel.text = self.titleArray[self.courseArray.count - indexPath.row - 1];
    } else {
        cell.courseLabel.text = self.titleArray[self.courseArray.count - indexPath.row - 1];
    }
    cell.timeLabel.text = self.courseArray[indexPath.row];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160 * screenHeight;
}
#pragma mark - 报修详情
- (void)getRecordInfo
{
    if (self.courseArray.count == 0) {
        
    } else {
      CFRepairsDetailInfoViewController *repairsDetail = [[CFRepairsDetailInfoViewController alloc]init];
      repairsDetail.recordModel = self.recordModel;
      [self.navigationController pushViewController:repairsDetail animated:YES];
    }
}
#pragma mark - 去评价
- (void)goCommentView
{
    CFCommenViewController *comment = [[CFCommenViewController alloc]init];
    comment.recordModel = self.recordModel;
    [self.navigationController pushViewController:comment animated:YES];
}
#pragma mark - 获取报修状态
- (void)getRecordStatusInfo
{
    self.reportId = self.recordModel.reportId;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{
                             @"token":[userDefault objectForKey:@"UserToken"],
                             @"reportId":self.recordModel.reportId,
                             };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"reportRepair/getReportInfoById" Loading:1 Params:params Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            self.recordModel = [CFRepairsRecordModel recordModelWithDictionary:[[responseObject objectForKey:@"body"] objectForKey:@"result"]];
            [self reloadRepairsRecordInfoView];
        }
        self.courseArray = (NSMutableArray *)[[self.courseArray reverseObjectEnumerator] allObjects];
        CGRect courseFrame = _courseView.frame;
        self.courseView.frame = CGRectMake(courseFrame.origin.x, courseFrame.origin.y, courseFrame.size.width, (34 + 160 * self.recordModel.statusArray.count) * screenHeight);
        if (self.courseArray.count > 5) {
            self.courseTableView.frame = CGRectMake(0, 17 * screenHeight, _courseView.frame.size.width, 160 * 5 * screenHeight);
        } else {
            self.courseTableView.frame = CGRectMake(0, 17 * screenHeight, _courseView.frame.size.width, _courseView.frame.size.height - 34 * screenHeight);
        }
        [self.courseTableView reloadData];
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
// 重新赋值维修状态页面
- (void)reloadRepairsRecordInfoView
{
    self.recordModel.reportId = self.reportId;
    self.courseArray = self.recordModel.statusArray;
    _phoneLabel.text = _recordModel.mobile;
    _commentInfoLabele.text = _recordModel.commentContent;
    _completeTimeLabel.text = [@"完成时间：" stringByAppendingString:_recordModel.finishTime];
    _createTimeLabel.text = [@"创建时间：" stringByAppendingString:_recordModel.reportTime];
    
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_phoneLabel.frame.size.width - 50 * screenWidth, 0, 50 * screenWidth, _phoneLabel.frame.size.height)];
    commentLabel.textAlignment = NSTextAlignmentRight;
    commentLabel.text = [NSString stringWithFormat:@"%@.0", _recordModel.commentLevel];
    [_phoneLabel addSubview:commentLabel];
    
    for (int i = 0; i < [_recordModel.commentLevel integerValue]; i++) {
        UIImageView *commentLevelImage = [[UIImageView alloc]initWithFrame:CGRectMake(_phoneLabel.frame.size.width - 110 * screenWidth - 50 * i * screenWidth, 3 * screenHeight, 25 * screenWidth, 25 * screenHeight)];
        commentLevelImage.image = [UIImage imageNamed:@"CF_Comment_Star_Full"];
        [_phoneLabel addSubview:commentLevelImage];
    }
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
