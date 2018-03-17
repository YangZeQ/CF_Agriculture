//
//  CFAgencyMachineStatusViewController.m
//  ChangFa
//
//  Created by Developer on 2018/1/23.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAgencyMachineStatusViewController.h"
#import "CFAgencySoldViewController.h"
#import "CFAgencyPutInStorageViewController.h"
#import "CFAgencySendingViewController.h"
@interface CFAgencyMachineStatusViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *statusScrollView;
@property (nonatomic, strong)UIButton *selectedButton;
@property (nonatomic, strong)CFAgencySendingViewController *sending;
@property (nonatomic, strong)CFAgencyPutInStorageViewController *putin;
@property (nonatomic, strong)CFAgencySoldViewController *sold;
@end

@implementation CFAgencyMachineStatusViewController
- (UIButton *)selectedButton{
    if (_selectedButton == nil) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedButton.backgroundColor = [UIColor whiteColor];
    }
    return _selectedButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.view.backgroundColor = BackgroundColor;
    [self createMachineStatusView];
    // Do any additional setup after loading the view.
}
- (void)createMachineStatusView{
    CFAgencySendingViewController *sending = [[CFAgencySendingViewController alloc]init];
    sending.height = navHeight + 88 * screenHeight + 100 * screenHeight;
    sending.cellType = @"selected";
    sending.distributorsID = self.distributorsID;
    CFAgencyPutInStorageViewController *putin = [[CFAgencyPutInStorageViewController alloc]init];
    putin.distributorsID = self.distributorsID;
    CFAgencySoldViewController *sold = [[CFAgencySoldViewController alloc]init];
    sold.distributorsID = self.distributorsID;
    [self addChildViewController:sending];
    [self addChildViewController:putin];
    [self addChildViewController:sold];
    
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width, 88 * screenHeight)];
    [self.view addSubview:buttonView];
    NSArray *statusButtonTitle = @[@"发往中", @"已入库", @"已出售"];
    for (int i = 0; i < 3; i++) {
        UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        statusButton.frame = CGRectMake(250 * screenWidth * i, 0, 250 * screenWidth, 88 * screenHeight);
        statusButton.tag = 1000 + i;
        statusButton.titleLabel.font = CFFONT15;
        if (i == 0) {
            self.selectedButton.frame = CGRectMake(250 * screenWidth * i, 0, 248 * screenWidth, 88 * screenHeight);
//            [self.selectedButton setBackgroundColor:BackgroundColor];
            [self.selectedButton setTitleColor:ChangfaColor forState:UIControlStateNormal];
            [self.selectedButton setTitle:statusButtonTitle[i] forState:UIControlStateNormal];
            self.selectedButton.tag = 2000;
            [self.selectedButton addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [statusButton setTitle:statusButtonTitle[i] forState:UIControlStateNormal];
        [statusButton setBackgroundColor:[UIColor whiteColor]];
        [statusButton addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [statusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [buttonView addSubview:statusButton];
        [buttonView addSubview:self.selectedButton];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(statusButton.frame.size.width * (i + 1) - screenWidth, 14 * screenHeight, 2 * screenWidth, 60 * screenHeight)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [buttonView addSubview:lineLabel];
    }
    self.statusScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, navHeight + 88 * screenHeight, self.view.frame.size.width, self.view.frame.size.height - navHeight - 88 * screenHeight)];
    self.statusScrollView.showsVerticalScrollIndicator = YES;
    self.statusScrollView.showsHorizontalScrollIndicator = YES;
    self.statusScrollView.bounces = NO;
    self.statusScrollView.scrollEnabled = NO;
    self.statusScrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.childViewControllers.count, self.view.frame.size.height - navHeight - 88 * screenHeight);
    [self.view addSubview:self.statusScrollView];
    
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIView *childView = [[UIView alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.statusScrollView.frame.size.height)];
        [childView addSubview:self.childViewControllers[i].view];
        [self.statusScrollView addSubview:childView];
    }
    
}
- (void)statusButtonClick:(UIButton *)sender{
    self.selectedButton.frame = CGRectMake(sender.frame.origin.x, 0, 248 * screenWidth, 88 * screenHeight);
    [self.selectedButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    if (sender.tag == 1000 || sender.tag == 2000) {
        self.statusScrollView.contentOffset = CGPointMake(0, 0);
        self.selectedButton.tag = 2000;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAgencySendMachineInfo" object:nil userInfo:nil];
//        self.sending.refresh = @"refresh";
    } else if (sender.tag == 1001 || sender.tag == 2001) {
        self.statusScrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        self.selectedButton.tag = 2001;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAgencyPutInMachineInfo" object:nil userInfo:nil];
//        self.putin.refresh = @"refresh";
    } else {
        self.statusScrollView.contentOffset = CGPointMake(self.view.frame.size.width * 2, 0);
        self.selectedButton.tag = 2002;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAgencySoldMachineInfo" object:nil userInfo:nil];
//        self.sold.refresh = @"refresh";
    }
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
