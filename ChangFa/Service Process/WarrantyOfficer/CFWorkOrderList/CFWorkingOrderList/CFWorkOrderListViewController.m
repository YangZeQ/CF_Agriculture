//
//  CFWorkOrderListViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/20.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFWorkOrderListViewController.h"
#import "CFWorkOrderInfoViewController.h"
#import "CFWorkOrderTableViewCell.h"
#import "ScanViewController.h"
@interface CFWorkOrderListViewController ()<UITableViewDelegate, UITableViewDataSource, scanViewControllerDelegate>
@property (nonatomic, strong)UITableView *orderListTabelView;
@property (nonatomic, strong)NSMutableArray *orderListArray;
@end

@implementation CFWorkOrderListViewController
- (NSMutableArray *)orderListArray
{
    if (_orderListArray == nil) {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self getOrderList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.title = @"派工单";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"CF_OrderList_Scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    [self createWorkOrderListView];
    // Do any additional setup after loading the view.
}
- (void)createWorkOrderListView
{
    self.orderListTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT) style:UITableViewStyleGrouped];
    self.orderListTabelView.delegate = self;
    self.orderListTabelView.dataSource = self;
    self.orderListTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.orderListTabelView];
    
    [self getOrderList];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderListArray.count;
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
    cell.cellStyle = 1;
    cell.model = self.orderListArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFWorkOrderModel *model = self.orderListArray[indexPath.section];
    CFWorkOrderInfoViewController *orderInfo = [[CFWorkOrderInfoViewController alloc]init];
    orderInfo.dispatchId = model.dispatchId;
    [self.navigationController pushViewController:orderInfo animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonClick
{
    ScanViewController *scan = [[ScanViewController alloc]init];
    scan.delegate = self;
    [self presentViewController:scan animated:YES completion:^{
        
    }];
}
#pragma mark - 扫描代理方法
- (void)scanGetInformation:(MachineModel *)model
{
    
}
#pragma mark - 获取派工单
- (void)getOrderList
{
    NSDictionary *param = @{
                            @"repairUserId":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserUid"],
                            };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"dispatch/selectAllDispatchs" Loading:0 Params:param Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"dispatch%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        [self.orderListArray removeAllObjects];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            for (NSDictionary *dict in [[responseObject objectForKey:@"body"] objectForKey:@"resultList"]) {
                CFWorkOrderModel *model = [CFWorkOrderModel orderModelWithDictionary:dict];
                [self.orderListArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.orderListTabelView reloadData];
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
