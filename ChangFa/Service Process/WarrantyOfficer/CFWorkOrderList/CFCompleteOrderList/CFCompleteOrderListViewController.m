//
//  CFCompleteOrderListViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/22.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFCompleteOrderListViewController.h"
#import "CFCompleteOrderInfoViewController.h"
#import "CFWorkOrderTableViewCell.h"
@interface CFCompleteOrderListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *orderTableView;
@property (nonatomic, strong)NSMutableArray *orderArray;
@end

@implementation CFCompleteOrderListViewController
- (NSMutableArray *)orderArray
{
    if (_orderArray == nil) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.title = @"已完成派工单";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"CF_Search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    [self createCompleteOrderListView];
    [self getWaittingForReceiveOrderList];
    // Do any additional setup after loading the view.
}
- (void)createCompleteOrderListView
{
    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT) style:UITableViewStyleGrouped];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.backgroundColor = BackgroundColor;
    _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_orderTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _orderArray.count;
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
    cell.cellStyle = 2;
    cell.model = self.orderArray[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20 * screenHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFCompleteOrderInfoViewController *orderInfo = [[CFCompleteOrderInfoViewController alloc]init];
    CFWorkOrderModel *model = _orderArray[indexPath.section];
    orderInfo.dispatchId = model.dispatchId;
    [self.navigationController pushViewController:orderInfo animated:YES];
}
#pragma mark - 获取已完成派工单信息
- (void)getWaittingForReceiveOrderList
{
    NSDictionary *param = @{
                            @"repairUserId":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserUid"],
                            @"status":@15,
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
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonClick
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
