//
//  CFBindIMEIViewController.m
//  ChangFa
//
//  Created by Developer on 2018/1/22.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFBindIMEIViewController.h"
#import "BindAndOutputView.h"
#import "OutputMachineViewController.h"
@interface CFBindIMEIViewController ()
@property (nonatomic, strong)BindAndOutputView *bindView;
@end

@implementation CFBindIMEIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定成功";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.view.backgroundColor = BackgroundColor;
    [self createBindIMEIView];
    // Do any additional setup after loading the view.
}
- (void)createBindIMEIView {
    _bindView = [[BindAndOutputView alloc]initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width, self.view.frame.size.height - navHeight) ViewStyle:@"imei"];
    _bindView.model = self.model;
    [_bindView.outputButton addTarget:self action:@selector(outputMachine) forControlEvents:UIControlEventTouchUpInside];
    [_bindView.completeButton addTarget:self action:@selector(completeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bindView];
}
- (void)outputMachine {
    OutputMachineViewController *output = [[OutputMachineViewController alloc]init];
    output.model = self.model;
    [self.navigationController pushViewController:output animated:YES];
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
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setModel:(MachineModel *)model{
    _model = model;
    _bindView.model = model;
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
