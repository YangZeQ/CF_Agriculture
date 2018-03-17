//
//  CFAgencySoldViewController.m
//  ChangFa
//
//  Created by Developer on 2018/1/23.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAgencySoldViewController.h"
#import "CFAgencyPutInStorageTableViewCell.h"
#import "CFAgencyMachineDetailInfoViewController.h"
#import "CFAFNetWorkingMethod.h"
@interface CFAgencySoldViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *soldMachineArray;

@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UIButton *refreshButton;
@end

@implementation CFAgencySoldViewController
- (NSMutableArray *)soldMachineArray{
    if (!_soldMachineArray) {
        _soldMachineArray = [NSMutableArray array];
    }
    return _soldMachineArray;
}
- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10 * screenHeight, self.view.frame.size.width, self.view.frame.size.height - 10 * screenHeight)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 256 * screenWidth) / 2, 260 * screenHeight, 256 * screenWidth, 367 * screenHeight)];
        [self.view addSubview:_backView];
        [_backView addSubview:_backImageView];
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshButton.frame = CGRectMake((self.view.frame.size.width - 240 * screenWidth) / 2, _backImageView.frame.size.height + _backImageView.frame.origin.y + 60 * screenHeight, 240 * screenWidth, 100 * screenHeight);
        [_refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
        [_refreshButton.layer setBorderColor:BackgroundColor.CGColor];
        [_refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_refreshButton.layer setBorderWidth:1];
        _refreshButton.layer.cornerRadius = 20 * screenWidth;
        [_refreshButton addTarget:self action:@selector(getSoldMachine) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_refreshButton];
        _backView.hidden = YES;
    }
    return _backView;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.soldTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = [UIColor whiteColor];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationToChangeAgencyMachineInfo) name:@"ChangeAgencySoldMachineInfo" object:nil];
    // Do any additional setup after loading the view.
    [self createSoldView];
//    [self getSoldMachine];
}
- (void)createSoldView{
    self.soldTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.soldTableView.delegate = self;
    self.soldTableView.dataSource = self;
    self.soldTableView.backgroundColor = BackgroundColor;
    self.soldTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.soldTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.soldMachineArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    CFAgencyPutInStorageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFAgencyPutInStorageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.model = self.soldMachineArray[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10 * screenHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CFAgencyMachineDetailInfoViewController *machineInfo = [[CFAgencyMachineDetailInfoViewController alloc]init];
    machineInfo.machineModel = self.soldMachineArray[indexPath.section];
    machineInfo.viewType = @"sold";
    [self.navigationController pushViewController:machineInfo animated:YES];
}
- (void)getSoldMachine{
    NSDictionary *dict = @{
                           @"distributorsID":self.distributorsID,
                           @"state":@3,
                           @"page":@1,
                           @"pageSize":@10,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/getCarList?" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            [self.soldMachineArray removeAllObjects];
            for (NSDictionary *dic in [[responseObject objectForKey:@"body"] objectForKey:@"resultList"]) {
                MachineModel *model = [MachineModel machineModelWithDictionary:dic];
                [self.soldMachineArray addObject:model];
            }
            [self.soldTableView reloadData];
        } else if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 300) {
            [self.soldMachineArray removeAllObjects];
            [self.soldTableView reloadData];
            self.backView.hidden = NO;
            self.backImageView.frame = CGRectMake((self.view.frame.size.width - 256 * screenWidth) / 2, 260 * screenHeight, 256 * screenWidth, 367 * screenHeight);
            self.refreshButton.frame = CGRectMake((self.view.frame.size.width - 240 * screenWidth) / 2, _backImageView.frame.size.height + _backImageView.frame.origin.y + 60 * screenHeight, 240 * screenWidth, 100 * screenHeight);
            _backImageView.image = [UIImage imageNamed:@"CF_NoData"];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.code == -1009 || error.code == -1001) {
            self.backView.hidden = NO;
            self.backImageView.frame = CGRectMake((self.view.frame.size.width - 488 * screenWidth) / 2, 260 * screenHeight, 488 * screenWidth, 373 * screenHeight);
            self.refreshButton.frame = CGRectMake((self.view.frame.size.width - 240 * screenWidth) / 2, _backImageView.frame.size.height + _backImageView.frame.origin.y + 60 * screenHeight, 240 * screenWidth, 100 * screenHeight);
            self.backImageView.image = [UIImage imageNamed:@"CF_NoNetwork"];
        }
    }];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self.delegate changeSoldTableViewStatus];
}
- (void)viewDidDisappear:(BOOL)animated{
    [self.soldTableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
}
- (void)setRefresh:(NSString *)refresh{
    [self getSoldMachine];
}
- (void)notificationToChangeAgencyMachineInfo{
    [self getSoldMachine];
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
