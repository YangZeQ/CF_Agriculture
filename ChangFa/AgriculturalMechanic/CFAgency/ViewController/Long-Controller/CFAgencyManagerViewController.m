//
//  CFAgencyManagerViewController.m
//  ChangFa
//
//  Created by Developer on 2018/2/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAgencyManagerViewController.h"
#import "CFAgencyRetreatViewController.h"
#import "CFAgencyExchangeViewController.h"
#import "CFAgencyReturnViewController.h"
#import "CFAgencyApplicationRecordViewController.h"
#import "CFManagerTypeView.h"
@interface CFAgencyManagerViewController ()

@end

@implementation CFAgencyManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"库存管理";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"申请记录" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.view.backgroundColor = BackgroundColor;
    [self createManagerView];
    // Do any additional setup after loading the view.
}
- (void)createManagerView{
    CFManagerTypeView *retreatView = [[CFManagerTypeView alloc]initWithFrame:CGRectMake(65 * screenWidth, 80 * screenHeight + navHeight, self.view.frame.size.width - 130 * screenWidth, 220 * screenHeight) ViewImage:@"Manager_retreat" Title:@"退换" Text:@"用户农机的退换"];
    [retreatView.viewButton addTarget:self action:@selector(retreateMachine) forControlEvents:UIControlEventTouchUpInside];
    CFManagerTypeView *exchangeView = [[CFManagerTypeView alloc]initWithFrame:CGRectMake(65 * screenWidth, retreatView.frame.size.height + retreatView.frame.origin.y + 60 * screenHeight, retreatView.frame.size.width, retreatView.frame.size.height) ViewImage:@"Manager_exchange" Title:@"调拨" Text:@"农机调拨到其他经销商库"];
    [exchangeView.viewButton addTarget:self action:@selector(exchangeMachine) forControlEvents:UIControlEventTouchUpInside];
    CFManagerTypeView *returenView = [[CFManagerTypeView alloc]initWithFrame:CGRectMake(65 * screenWidth, exchangeView.frame.size.height + exchangeView.frame.origin.y + 60 * screenHeight, retreatView.frame.size.width, retreatView.frame.size.height) ViewImage:@"Manager_return" Title:@"返厂" Text:@"库存农机返厂"];
    [returenView.viewButton addTarget:self action:@selector(returnMachine) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retreatView];
    [self.view addSubview:exchangeView];
    [self.view addSubview:returenView];

}
- (void)retreateMachine{
    CFAgencyRetreatViewController *retreat = [[CFAgencyRetreatViewController alloc]init];
    [self.navigationController pushViewController:retreat animated:YES];
}
- (void)exchangeMachine{
    CFAgencyExchangeViewController *exchange = [[CFAgencyExchangeViewController alloc]init];
    [self.navigationController pushViewController:exchange animated:YES];
}
- (void)returnMachine{
    CFAgencyReturnViewController *returnVC = [[CFAgencyReturnViewController alloc]init];
    [self.navigationController pushViewController:returnVC animated:YES];
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonClick{
    CFAgencyApplicationRecordViewController *applicationRecord = [[CFAgencyApplicationRecordViewController alloc]init];
    [self.navigationController pushViewController:applicationRecord animated:YES];
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
