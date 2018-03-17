//
//  CFAgencySendingViewController.m
//  ChangFa
//
//  Created by Developer on 2018/1/23.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAgencySendingViewController.h"
#import "CFAgencySendingTableViewCell.h"
#import "CFAgencyPutInStorageTableViewCell.h"
#import "CFSalesPersonAgencyInfoViewController.h"
#import "CFAgencyMachineDetailInfoViewController.h"
#import "CFAFNetWorkingMethod.h"
@interface CFAgencySendingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UIButton *allSelectedButton;
@property (nonatomic, strong)UIButton *putinButton;
@property (nonatomic, strong)NSMutableArray *sendingMachineArray;
//@property (nonatomic, strong)CFAgencyPutInStorageTableViewCell *cell;
@property (nonatomic, assign)int selectedNumber;
@property (nonatomic, strong)MachineModel *selectedMachineModel;

@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UIButton *refreshButton;
@end

@implementation CFAgencySendingViewController
- (NSMutableArray *)sendingMachineArray{
    if (_sendingMachineArray == nil) {
        _sendingMachineArray = [NSMutableArray array];
    }
    return _sendingMachineArray;
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
        [_refreshButton addTarget:self action:@selector(getSendingMachine) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_refreshButton];
        _backView.hidden = YES;
    }
    return _backView;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.sendingTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationToChangeAgencyMachineInfo) name:@"ChangeAgencySendMachineInfo" object:nil];
    [self createSendingView];
    [self getSendingMachine];
    // Do any additional setup after loading the view.
}
- (void)createSendingView{
//    self.vcCanScroll = NO;
    self.sendingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.height) style:UITableViewStylePlain];
    self.sendingTableView.delegate = self;
    self.sendingTableView.dataSource = self;
    self.sendingTableView.backgroundColor = BackgroundColor;
    self.sendingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.sendingTableView];
    
    _allSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _allSelectedButton.frame = CGRectMake(0, _sendingTableView.frame.size.height + _sendingTableView.frame.origin.y, 510 * screenWidth, 100 * screenHeight);
//    [_allSelectedButton setTitle:@"全选" forState:UIControlStateNormal];
    [_allSelectedButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _allSelectedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _allSelectedButton.contentEdgeInsets = UIEdgeInsetsMake(0, 61 * screenWidth, 0, 0);
    [self.view addSubview:_allSelectedButton];
    
    _putinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _putinButton.frame = CGRectMake(_allSelectedButton.frame.size.width, _allSelectedButton.frame.origin.y, self.view.frame.size.width - _allSelectedButton.frame.size.width, _allSelectedButton.frame.size.height);
    _putinButton.frame = CGRectMake(0, _allSelectedButton.frame.origin.y, self.view.frame.size.width, _allSelectedButton.frame.size.height);
    [_putinButton setTitle:@"入库" forState:UIControlStateNormal];
    [_putinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_putinButton addTarget:self action:@selector(putInStorage) forControlEvents:UIControlEventTouchUpInside];
    [_putinButton setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_putinButton];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sendingMachineArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    if ([self.cellType isEqualToString:@"selected"]) {
        CFAgencySendingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[CFAgencySendingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        cell.model = self.sendingMachineArray[indexPath.row];
        return cell;
    } else {
        CFAgencyPutInStorageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[CFAgencyPutInStorageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        cell.model = self.sendingMachineArray[indexPath.section];
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10 * screenHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.cellType isEqualToString:@"selected"]) {
        CFAgencySendingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell.cellSelected) {
            cell.cellSelected = YES;
            self.selectedNumber++;
//            [_putinButton setTitle:[[@"入库（" stringByAppendingString:[NSString stringWithFormat:@"%d", self.selectedNumber]] stringByAppendingString:@"）"] forState:UIControlStateNormal];
            self.selectedMachineModel = self.sendingMachineArray[indexPath.row];
            NSLog(@"%@", self.selectedMachineModel.productName);
        } else {
            cell.cellSelected = NO;
            self.selectedNumber--;
//            [_putinButton setTitle:[[@"入库（" stringByAppendingString:[NSString stringWithFormat:@"%d", self.selectedNumber]] stringByAppendingString:@"）"] forState:UIControlStateNormal];
        }
    } else {
    CFAgencyMachineDetailInfoViewController *machineInfo = [[CFAgencyMachineDetailInfoViewController alloc]init];
    machineInfo.machineModel = self.sendingMachineArray[indexPath.section];
    machineInfo.viewType = @"unsold";
    [self.navigationController pushViewController:machineInfo animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.cellType isEqualToString:@"selected"]) {
        self.selectedNumber--;
        CFAgencySendingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        if (!cell.cellSelected) {
//            cell.cellSelected = YES;
//            self.selectedNumber++;
//            [_putinButton setTitle:[[@"入库（" stringByAppendingString:[NSString stringWithFormat:@"%d", self.selectedNumber]] stringByAppendingString:@"）"] forState:UIControlStateNormal];
//            self.selectedMachineModel = self.sendingMachineArray[indexPath.row];
//            NSLog(@"%@", self.selectedMachineModel.productName);
//        } else {
            cell.cellSelected = NO;
//            self.selectedNumber--;
//            [_putinButton setTitle:[[@"入库（" stringByAppendingString:[NSString stringWithFormat:@"%d", self.selectedNumber]] stringByAppendingString:@"）"] forState:UIControlStateNormal];
//        }
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self.delegate changeSendingTableViewStatus];
}
- (void)getSendingMachine{
    NSDictionary *dict = @{
                           @"distributorsID":self.distributorsID,
                           @"state":@1,
                           @"page":@1,
                           @"pageSize":@10,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/getCarList?" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            [self.sendingMachineArray removeAllObjects];
            for (NSDictionary *dic in [[responseObject objectForKey:@"body"] objectForKey:@"resultList"]) {
                MachineModel *model = [MachineModel machineModelWithDictionary:dic];
                [self.sendingMachineArray addObject:model];
            }
            [self.sendingTableView reloadData];
        } else if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 300) {
            [self.sendingMachineArray removeAllObjects];
            [self.sendingTableView reloadData];
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
- (void)putInStorage{
    if (self.selectedNumber == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择入库农机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{
                           @"imei":self.selectedMachineModel.imei,
                           @"carBar":self.selectedMachineModel.productBarCode,
                           @"distributorsID":[userDefault objectForKey:@"UserDistributorId"],
                           @"distributorsName":[userDefault objectForKey:@"UserDistributorName"],
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/sweepCodeStorage" Params:dict Method:@"" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"入库成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self getSendingMachine];
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)setRefresh:(NSString *)refresh{
    [self getSendingMachine];
}
- (void)notificationToChangeAgencyMachineInfo{
    [self getSendingMachine];
}
- (void)viewDidDisappear:(BOOL)animated{
    [self.sendingTableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
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
