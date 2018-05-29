//
//  CFIntegralViewController.m
//  ChangFa
//
//  Created by Developer on 2018/4/28.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFIntegralViewController.h"
#import "CFIntegralTableViewCell.h"

@interface CFIntegralViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UILabel *integralLabel;
@end

@implementation CFIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UserBackgroundColor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"积分明细";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Navigation_Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"积分规则" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, CFFONT16, NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self createIntegralView];
    // Do any additional setup after loading the view.
}
- (void)createIntegralView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight, CF_WIDTH, 172 * screenHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    _integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50 * screenHeight, CF_WIDTH, 30 * screenHeight)];
    _integralLabel.text = @"300";
    _integralLabel.textColor = ChangfaColor;
    _integralLabel.textAlignment= NSTextAlignmentCenter;
    [headView addSubview:_integralLabel];
    UILabel *currentIntegralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 112 * screenHeight, CF_WIDTH, 30 * screenHeight)];
    currentIntegralLabel.textAlignment = NSTextAlignmentCenter;
    currentIntegralLabel.text = @"我的当前积分";
    currentIntegralLabel.font = CFFONT15;
    [headView addSubview:currentIntegralLabel];
    
    UILabel *integralRecordLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, headView.frame.size.height + navHeight, CF_WIDTH - 60 * screenWidth, 90 * screenHeight)];
    integralRecordLabel.text = @"积分纪录";
    integralRecordLabel.textColor = [UIColor grayColor];
    integralRecordLabel.font = CFFONT14;
    [self.view addSubview:integralRecordLabel];
    NSLog(@"%lf, %lf", navHeight, 128 * screenHeight);
    UITableView *integralRecordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 262 * screenHeight + navHeight, CF_WIDTH, CF_HEIGHT - (262 * screenHeight + navHeight)) style:UITableViewStylePlain];
    integralRecordTableView.delegate = self;
    integralRecordTableView.dataSource = self;
    integralRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:integralRecordTableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    CFIntegralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFIntegralTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130 * screenHeight;
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
