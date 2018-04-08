//
//  CFRepairsRecordViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsRecordViewController.h"
#import "CFRepairsRecordInfoViewController.h"
#import "CFRepairsRecordTableViewCell.h"
#import "CFRepairsRecordModel.h"
@interface CFRepairsRecordViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *repairsRecordTableView;
@property (nonatomic, strong)NSMutableArray *recordArray;

@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UIButton *refreshButton;
@end

@implementation CFRepairsRecordViewController
- (NSMutableArray *)recordArray
{
    if (_recordArray == nil) {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}
- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 256 * screenWidth) / 2, navHeight + 260 * screenHeight, 256 * screenWidth, 367 * screenHeight)];
        _backImageView.image = [UIImage imageNamed:@"CF_NoData"];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_backView];
        [_backView addSubview:_backImageView];
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshButton.frame = CGRectMake((self.view.frame.size.width - 240 * screenWidth) / 2, _backImageView.frame.size.height + _backImageView.frame.origin.y + 60 * screenHeight, 240 * screenWidth, 100 * screenHeight);
        [_refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
        [_refreshButton.layer setBorderColor:BackgroundColor.CGColor];
        [_refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_refreshButton.layer setBorderWidth:1];
        _refreshButton.layer.cornerRadius = 20 * screenWidth;
        [_refreshButton addTarget:self action:@selector(getRepairsRecord) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_refreshButton];
    }
    return _backView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.title = @"报修记录";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    [self createRepairsRecordView];
    // Do any additional setup after loading the view.
}
- (void)createRepairsRecordView
{
    self.repairsRecordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.repairsRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.repairsRecordTableView.delegate = self;
    self.repairsRecordTableView.dataSource = self;
    self.repairsRecordTableView.backgroundColor = BackgroundColor;
    [self.view addSubview:self.repairsRecordTableView];
    self.repairsRecordTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getRepairsRecord];
    }];
    self.repairsRecordTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getRepairsRecord];
    }];
    [self.repairsRecordTableView.mj_header beginRefreshing];
    
    self.backView.hidden = NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.recordArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"repairsStation";
    CFRepairsRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFRepairsRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.recordModel = self.recordArray[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20 * screenHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CFRepairsRecordTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CFRepairsRecordInfoViewController *stationInfo = [[CFRepairsRecordInfoViewController alloc]init];
    stationInfo.recordModel = cell.recordModel;
    [self.navigationController pushViewController:stationInfo animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220 * screenHeight;
}
- (void)getRepairsRecord
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{
                             @"userId":[userDefault objectForKey:@"UserUid"],
                             };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"reportRepair/getReportInfos" Loading:1 Params:params Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        [self.repairsRecordTableView.mj_header endRefreshing];
        [self.repairsRecordTableView.mj_footer endRefreshing];
        [self.recordArray removeAllObjects];
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            self.backView.hidden = YES;
            for (NSDictionary *dic in [[responseObject objectForKey:@"body"] objectForKey:@"resultList"]) {
                CFRepairsRecordModel *model = [CFRepairsRecordModel recordModelWithDictionary:dic];
                [self.recordArray addObject:model];
            }
            [self.repairsRecordTableView reloadData];
        } else if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 300) {
            self.backView.hidden = NO;
            self.backImageView.frame = CGRectMake((self.view.frame.size.width - 256 * screenWidth) / 2, navHeight + 260 * screenHeight, 256 * screenWidth, 367 * screenHeight);
            self.refreshButton.frame = CGRectMake((self.view.frame.size.width - 240 * screenWidth) / 2, _backImageView.frame.size.height + _backImageView.frame.origin.y + 60 * screenHeight, 240 * screenWidth, 100 * screenHeight);
            _backImageView.image = [UIImage imageNamed:@"CF_NoData"];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[[responseObject objectForKey:@"head"] objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        [self.repairsRecordTableView.mj_header endRefreshing];
        [self.repairsRecordTableView.mj_footer endRefreshing];
        if (error.code == -1009 || error.code == -1001) {
            self.backView.hidden = NO;
            self.backImageView.frame = CGRectMake((self.view.frame.size.width - 488 * screenWidth) / 2, navHeight + 260 * screenHeight, 488 * screenWidth, 373 * screenHeight);
            self.refreshButton.frame = CGRectMake((self.view.frame.size.width - 240 * screenWidth) / 2, _backImageView.frame.size.height + _backImageView.frame.origin.y + 60 * screenHeight, 240 * screenWidth, 100 * screenHeight);
            self.backImageView.image = [UIImage imageNamed:@"CF_NoNetwork"];
        }
    }];
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
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
