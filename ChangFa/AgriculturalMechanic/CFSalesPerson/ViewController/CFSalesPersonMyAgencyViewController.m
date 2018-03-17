//
//  CFSalesPersonMyAgencyViewController.m
//  ChangFa
//
//  Created by Developer on 2018/1/25.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFSalesPersonMyAgencyViewController.h"
#import "CFSalesPersonMyAgencyTableViewCell.h"
#import "CFSalesPersonAgencyInfoViewController.h"
#import "CFAFNetWorkingMethod.h"
@interface CFSalesPersonMyAgencyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *myAgencyTableView;
@property (nonatomic, strong)NSMutableArray *myAgencyArray;
@end

@implementation CFSalesPersonMyAgencyViewController
- (NSMutableArray *)myAgencyArray{
    if (_myAgencyArray == nil) {
        _myAgencyArray = [NSMutableArray array];
    }
    return _myAgencyArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的经销商";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    [self createMyAgencyView];
    [self getAllMyAgencyInfo];
    // Do any additional setup after loading the view.
}
- (void)createMyAgencyView{
    self.myAgencyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.myAgencyTableView.backgroundColor = BackgroundColor;
    self.myAgencyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myAgencyTableView.delegate = self;
    self.myAgencyTableView.dataSource = self;
    self.myAgencyTableView.bounces = NO;
    [self.view addSubview:self.myAgencyTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.myAgencyArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    CFSalesPersonMyAgencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFSalesPersonMyAgencyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.model = self.myAgencyArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CFSalesPersonAgencyInfoViewController *machineStatus = [[CFSalesPersonAgencyInfoViewController alloc]init];
    machineStatus.agencyModel = self.myAgencyArray[indexPath.section];
    NSLog(@"%@", machineStatus.agencyModel.distributorsName);
    machineStatus.navigationItem.title = @"我的经销商";
    [self.navigationController pushViewController:machineStatus animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30 * screenHeight;
}
#pragma mark -获取我的经销商
- (void)getAllMyAgencyInfo{
    NSDictionary *dict = @{
                           @"page":@1,
                           @"pageSize":@10,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"distributors/getSalesmanDistributorsList" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@, %@", responseObject, [[responseObject objectForKey:@"head"] objectForKey:@"message"]);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            for (NSDictionary *dic in [[responseObject objectForKey:@"body"] objectForKey:@"resultList"]) {
                AgencyModel *model = [AgencyModel agencyModelWithDictionary:dic];
                [self.myAgencyArray addObject:model];
            }
            [self.myAgencyTableView reloadData];
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
