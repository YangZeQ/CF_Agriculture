//
//  CFAgencySellSuccessViewController.m
//  ChangFa
//
//  Created by Developer on 2018/1/25.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAgencySellSuccessViewController.h"

@interface CFAgencySellSuccessViewController ()

@end

@implementation CFAgencySellSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"售出成功";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.view.backgroundColor = BackgroundColor;
    
    [self createSellSuccessView];
    // Do any additional setup after loading the view.
}
- (void)createSellSuccessView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, navHeight + 30 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 872 * screenHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 20 * screenWidth;
    [self.view addSubview:backView];
    
    UIImageView *successImage = [[UIImageView alloc]initWithFrame:CGRectMake(264 * screenWidth, 60 * screenHeight, 162 * screenWidth, 162 * screenHeight)];
    successImage.image = [UIImage imageNamed:@"CFAgencySellSuccess"];
    [backView addSubview:successImage];
    
    UILabel *machineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, successImage.frame.size.height + successImage.frame.origin.y + 100 * screenHeight, self.view.frame.size.width - 130 * screenWidth, 50 * screenHeight)];
    machineNameLabel.text = [NSString stringWithFormat:@"名称：%@", _machineModel.productName];
    [backView addSubview:machineNameLabel];
    UILabel *machineTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineNameLabel.frame.origin.x, machineNameLabel.frame.size.height + machineNameLabel.frame.origin.y + 20 * screenHeight, machineNameLabel.frame.size.width, machineNameLabel.frame.size.height)];
    machineTypeLabel.text = [NSString stringWithFormat:@"型号：%@", _machineModel.productModel];
    [backView addSubview:machineTypeLabel];
    UILabel *machineNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineNameLabel.frame.origin.x, machineTypeLabel.frame.size.height + machineTypeLabel.frame.origin.y + 20 * screenHeight, machineNameLabel.frame.size.width, machineNameLabel.frame.size.height)];
    machineNumberLabel.text = [NSString stringWithFormat:@"车架号：%@", _machineModel.productBarCode];
    machineNumberLabel.textColor = [UIColor redColor];
    [backView addSubview:machineNumberLabel];
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineNameLabel.frame.origin.x, machineNumberLabel.frame.size.height + machineNumberLabel.frame.origin.y + 50 * screenHeight, machineNameLabel.frame.size.width, machineNameLabel.frame.size.height)];
    userNameLabel.text = [NSString stringWithFormat:@"用户姓名：%@", _personModel.uname];
    [backView addSubview:userNameLabel];
    UILabel *userPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineNameLabel.frame.origin.x, userNameLabel.frame.size.height + userNameLabel.frame.origin.y + 20 * screenHeight, machineNameLabel.frame.size.width, machineNameLabel.frame.size.height)];
    userPhoneLabel.text = [NSString stringWithFormat:@"用户电话：%@", _personModel.phone];
    [backView addSubview:userPhoneLabel];
    UILabel *userIdentifyLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineNameLabel.frame.origin.x, userPhoneLabel.frame.size.height + userPhoneLabel.frame.origin.y + 20 * screenHeight, machineNameLabel.frame.size.width, machineNameLabel.frame.size.height)];
    userIdentifyLabel.text = [NSString stringWithFormat:@"身份证号码：%@", _personModel.identify];
    [backView addSubview:userIdentifyLabel];
    UILabel *selledLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineNameLabel.frame.origin.x, userIdentifyLabel.frame.size.height + userIdentifyLabel.frame.origin.y + 50 * screenHeight, machineNameLabel.frame.size.width, machineNameLabel.frame.size.height)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    selledLabel.text = [NSString stringWithFormat:@"售出时间：%@", [formatter stringFromDate:[NSDate date]]];
    [backView addSubview:selledLabel];
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake(30 * screenWidth, self.view.frame.size.height - 160 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 100 * screenHeight);
    completeButton.layer.cornerRadius = 20 * screenWidth;
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeButton setBackgroundColor:ChangfaColor];
    [completeButton addTarget:self action:@selector(completeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeButton];
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)completeButtonClick{
    for (UIViewController *viewController in self.navigationController.childViewControllers) {
        if ([viewController isKindOfClass:[SliderViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
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
