//
//  CFRepairsStationViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsStationViewController.h"
#import "CFRepairsStationInfoViewController.h"
#import "CFRepairsStationTableViewCell.h"
@interface CFRepairsStationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *repairsStationTableView;
@end

@implementation CFRepairsStationViewController
- (NSMutableArray *)stationArray
{
    if (_stationArray == nil) {
        _stationArray = [NSMutableArray array];
    }
    return _stationArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.title = @"维修站点选择";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    [self createRepairsStationView];
    // Do any additional setup after loading the view.
}
- (void)createRepairsStationView
{
    self.repairsStationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.repairsStationTableView.backgroundColor = BackgroundColor;
    self.repairsStationTableView.delegate = self;
    self.repairsStationTableView.dataSource = self;
    self.repairsStationTableView.bounces = NO;
    [self.view addSubview:self.repairsStationTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.stationArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"repairsStation";
    CFRepairsStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFRepairsStationTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.stationInfoButton.tag = 1000 + indexPath.section;
        [cell.stationInfoButton addTarget:self action:@selector(getStationInfo:) forControlEvents:UIControlEventTouchUpInside];
        cell.model = self.stationArray[indexPath.section];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"DIDSELECTED");
    CFRepairsStationTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.stationBlock(cell.model);
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 296 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20 * screenHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, 20 * screenHeight)];
    headView.backgroundColor = BackgroundColor;
    return headView;
}
- (void)getStationInfo:(UIButton *)sender
{
    NSLog(@"button");
    CFRepairsStationInfoViewController *stationInfo = [[CFRepairsStationInfoViewController alloc]init];
    stationInfo.stationModel = self.stationArray[sender.tag - 1000];
    [self.navigationController pushViewController:stationInfo animated:YES];
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    NSLog(@"DEALLOC TOO");
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
