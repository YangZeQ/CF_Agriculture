//
//  PutNumberViewController.m
//  ChangFa
//
//  Created by dev on 2018/1/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "PutNumberViewController.h"
#import "BandMachineViewController.h"
@interface PutNumberViewController ()
@property (nonatomic, strong)UITextField *numberTextField;
@end

@implementation PutNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationLable.text = @"输入车架号";
    [self.leftButton setImage:[UIImage imageNamed:@"fanhuiwhite"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = BackgroundColor;
    [self createPutNumberView];
    // Do any additional setup after loading the view.
}
- (void)createPutNumberView{
    UIView *putInView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height + 30 * screenHeight, self.view.frame.size.width, 98 * screenHeight)];
    putInView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:putInView];
    self.numberTextField = [[UITextField alloc]initWithFrame:CGRectMake(50 * screenWidth, 0, self.view.frame.size.width - 50 * screenWidth, putInView.frame.size.height)];
    self.numberTextField.placeholder = @"请输入车架号";
    [putInView addSubview:self.numberTextField];
    
    UIButton *bandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bandButton.frame = CGRectMake(30 * screenWidth, putInView.frame.size.height + putInView.frame.origin.y + 360 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 100 * screenHeight);
    bandButton.layer.cornerRadius = 20 * screenWidth;
    [bandButton setTitle:@"绑定" forState:UIControlStateNormal];
    [bandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bandButton setBackgroundColor:ChangfaColor];
    [bandButton addTarget:self action:@selector(bandMachine) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bandButton];
}
- (void)leftButtonClick{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)bandMachine{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate bandMachineAccordingNumber:self.numberTextField.text];
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
