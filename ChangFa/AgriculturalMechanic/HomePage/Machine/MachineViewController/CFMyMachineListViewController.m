//
//  CFMyMachineViewController.m
//  ChangFa
//
//  Created by Developer on 2018/5/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFMyMachineListViewController.h"
#import "CFMyMachineListTableViewCell.h"
@interface CFMyMachineListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *machineListTableView;
@end

@implementation CFMyMachineListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UserBackgroundColor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的农机";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Navigation_Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    [self createMyMachineListView];
    // Do any additional setup after loading the view.
}
- (void)createMyMachineListView
{
    self.machineListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, navHeight, CF_WIDTH, CF_HEIGHT - navHeight) style:UITableViewStylePlain];
    self.machineListTableView.delegate = self;
    self.machineListTableView.dataSource = self;
    self.machineListTableView.showsVerticalScrollIndicator = NO;
    self.machineListTableView.backgroundColor = UserBackgroundColor;
    [self.view addSubview:self.machineListTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    CFMyMachineListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFMyMachineListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 224 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, 30 * screenHeight)];
    return headerView;
}
- (void)leftButtonClick
{
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
