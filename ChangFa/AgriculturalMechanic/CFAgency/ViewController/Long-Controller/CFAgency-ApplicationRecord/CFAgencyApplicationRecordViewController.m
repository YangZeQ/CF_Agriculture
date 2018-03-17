//
//  CFAgencyApplicationRecordViewController.m
//  ChangFa
//
//  Created by Developer on 2018/2/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAgencyApplicationRecordViewController.h"
#import "CFAgencyRetreatStatusViewController.h"
#import "CFAgencyEXchangeStatusViewController.h"
#import "CFAgencyReturnStatusViewController.h"
#import "CFAgencyApplicationRecordTableViewCell.h"
#import "MachineModel.h"
@interface CFAgencyApplicationRecordViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *reacordTableView;
@property (nonatomic, strong)NSMutableArray *recordArray;
@end

@implementation CFAgencyApplicationRecordViewController
- (NSMutableArray *)recordArray{
    if (_recordArray == nil) {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请记录";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.view.backgroundColor = BackgroundColor;
    [self createApplicationRecordView];
    [self getApplicationRecordInfo];
    // Do any additional setup after loading the view.
}
- (void)createApplicationRecordView{
    self.reacordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.reacordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.reacordTableView.delegate = self;
    self.reacordTableView.dataSource = self;
    self.reacordTableView.backgroundColor = BackgroundColor;
    [self.view addSubview:self.reacordTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.recordArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    CFAgencyApplicationRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFAgencyApplicationRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.model = self.recordArray[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 195 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self getApplyStatusInfoWithModel:self.recordArray[indexPath.section]];
}
- (void)getApplicationRecordInfo{
    NSDictionary *dict = @{
                           @"carModel":@"",
                           @"carName":@"",
                           @"carNumber":@"",
                           @"carState":@"",
                           @"userName":@"",
                           @"page":@1,
                           @"pageSize":@10,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/getApplyCarList?" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            [self.recordArray removeAllObjects];
            for (NSDictionary *dic in [[responseObject objectForKey:@"body"] objectForKey:@"resultList"]) {
                MachineModel *model = [MachineModel machineModelWithDictionary:dic];
                [self.recordArray addObject:model];
            }
            [self.reacordTableView reloadData];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[[responseObject objectForKey:@"head"] objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)getApplyStatusInfoWithModel:(MachineModel *)model{
    NSDictionary *dict = @{
                           @"applyId":model.applyId,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/getApplyCarInfo?" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@  %@", responseObject, model.apply_type);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            if ([[[responseObject objectForKey:@"body"] objectForKey:@"apply_type"] integerValue] == 1) {
                CFAgencyRetreatStatusViewController *retreat = [[CFAgencyRetreatStatusViewController alloc]initWithModel:[MachineModel machineModelWithDictionary:[responseObject objectForKey:@"body"]]];
                retreat.applyId = model.applyId;
                [self.navigationController pushViewController:retreat animated:YES];
            } else if ([[[responseObject objectForKey:@"body"] objectForKey:@"apply_type"] integerValue] == 3) {
                CFAgencyEXchangeStatusViewController *exchange = [[CFAgencyEXchangeStatusViewController alloc]initWithModel:[MachineModel machineModelWithDictionary:[responseObject objectForKey:@"body"]]];
                exchange.applyId = model.applyId;
                [self.navigationController pushViewController:exchange animated:YES];
            } else if ([[[responseObject objectForKey:@"body"] objectForKey:@"apply_type"] integerValue] == 2) {
                CFAgencyReturnStatusViewController *returnStatus = [[CFAgencyReturnStatusViewController alloc]initWithModel:[MachineModel machineModelWithDictionary:[responseObject objectForKey:@"body"]]];
                returnStatus.applyId = model.applyId;
                [self.navigationController pushViewController:returnStatus animated:YES];
            }
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[[responseObject objectForKey:@"head"] objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
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
