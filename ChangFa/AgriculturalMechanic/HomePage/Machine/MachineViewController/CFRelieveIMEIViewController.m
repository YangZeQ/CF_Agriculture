//
//  CFRelieveIMEIViewController.m
//  ChangFa
//
//  Created by Developer on 2018/1/22.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRelieveIMEIViewController.h"
#import "BindAndOutputView.h"
#import "CFAFNetWorkingMethod.h"
@interface CFRelieveIMEIViewController ()

@end

@implementation CFRelieveIMEIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"解除绑定";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.view.backgroundColor = BackgroundColor;
    [self createRelieveIMEIView];
    // Do any additional setup after loading the view.
}
- (void)createRelieveIMEIView {
    BindAndOutputView *bindView = [[BindAndOutputView alloc]initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width, self.view.frame.size.height - navHeight) ViewStyle:@"relieve"];
    [bindView.completeButton addTarget:self action:@selector(relieveIMEI) forControlEvents:UIControlEventTouchUpInside];
    [bindView.completeButton setTitle:@"解除绑定" forState:UIControlStateNormal];

    [self.view addSubview:bindView];
}
- (void)relieveIMEI {
    NSDictionary *dict = @{
                           @"imei":self.imei,
                           @"carBar":self.carbar,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/removeBindings" Params:dict Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"解除成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                for (UIViewController *viewController in self.navigationController.childViewControllers) {
                    if ([viewController isKindOfClass:[SliderViewController class]]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                        return;
                    }
                }
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)leftButtonClick {
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
