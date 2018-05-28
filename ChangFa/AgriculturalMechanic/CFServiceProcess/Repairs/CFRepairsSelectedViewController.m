//
//  CFRepairsSelectedViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsSelectedViewController.h"
#import "CFRepairsMachineTableViewCell.h"
@interface CFRepairsSelectedViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CFRepairsSelectedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"选择农机";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Navigation_Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.view.backgroundColor = BackgroundColor;
    [self createRepairsSelectedMachine];
    // Do any additional setup after loading the view.
}
- (void)createRepairsSelectedMachine
{
    UITableView *selectedTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT) style:UITableViewStylePlain];
    selectedTableView.delegate = self;
    selectedTableView.dataSource = self;
    [self.view addSubview:selectedTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    CFRepairsMachineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFRepairsMachineTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    return cell;
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
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
