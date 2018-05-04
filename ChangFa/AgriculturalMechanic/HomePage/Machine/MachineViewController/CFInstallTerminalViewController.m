//
//  CFInstallTerminalViewController.m
//  ChangFa
//
//  Created by Developer on 2018/4/26.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFInstallTerminalViewController.h"

@interface CFInstallTerminalViewController ()
@property (nonatomic, strong)UIScrollView *installScrollView;
@property (nonatomic, strong)UIView *vagueView;
@end

@implementation CFInstallTerminalViewController

- (UIView *)vagueView
{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _vagueView.hidden = YES;
        [self.view addSubview:_vagueView];
    }
    return _vagueView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"安装终端";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Navigation_Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    [self createInstallTerminalView];
    // Do any additional setup after loading the view.
}

- (void)createInstallTerminalView
{
    self.view.backgroundColor = UserBackgroundColor;
 
    self.installScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT - navHeight)];
    self.installScrollView.contentSize = CGSizeMake(0, 1430 * screenHeight);
    self.installScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.installScrollView];
    
    UIButton *installButton = [UIButton buttonWithType:UIButtonTypeCustom];
    installButton.frame = CGRectMake(0, CF_HEIGHT - 99 * screenHeight, CF_WIDTH, 99 * screenHeight);
    [installButton setBackgroundImage:[UIImage imageNamed:@"Install_Terminal"] forState:UIControlStateNormal];
    [installButton setTitle:@"确定安装" forState:UIControlStateNormal];
    [installButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [installButton addTarget:self action:@selector(installButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:installButton];
    
    UIImageView *installMachineImage = [[UIImageView alloc]initWithFrame:CGRectMake(40 * screenWidth, 0, CF_WIDTH - 80 * screenWidth, 296 * screenHeight)];
    installMachineImage.image = [UIImage imageNamed:@"Install_Dryer"];
    [_installScrollView addSubview:installMachineImage];
    UILabel *terminalFunctionLabel = [[UILabel alloc]initWithFrame:CGRectMake(35 * screenWidth, installMachineImage.frame.size.height + 25 * screenHeight, CF_WIDTH - 70 * screenWidth, 30 * screenHeight)];
    terminalFunctionLabel.text = @"安装终端模块功能";
    terminalFunctionLabel.font = CFFONT16;
    [_installScrollView addSubview:terminalFunctionLabel];
    NSArray *functionImageArray = [NSArray arrayWithObjects:@"Function_Position", @"Function_Oil", @"Function_Temperature", @"Function_Speed", @"Function_Height", nil];
    NSArray *functionTitleArray = [NSArray arrayWithObjects:@"位置", @"油压", @"水温", @"发动机转速", @"海拔高度", nil];
    for (int i = 0; i < functionImageArray.count; i++) {
        UIView *functionView = [[UIView alloc]initWithFrame:CGRectMake(41 * screenWidth + 237 * screenWidth * (i % 3), 20 * screenHeight + 176 * screenHeight * (i / 3) + terminalFunctionLabel.frame.size.height + terminalFunctionLabel.frame.origin.y, 196 * screenWidth, 156 * screenHeight)];
        functionView.backgroundColor = [UIColor whiteColor];
        functionView.layer.cornerRadius = 20 * screenWidth;
        [_installScrollView addSubview:functionView];
        UIImageView *functionImage = [[UIImageView alloc]initWithFrame:CGRectMake(66 * screenWidth, 12 * screenHeight, 64 * screenWidth, 64 * screenHeight)];
        functionImage.image = [UIImage imageNamed:functionImageArray[i]];
        [functionView addSubview:functionImage];
        UILabel *functionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100 * screenHeight, functionView.frame.size.width, 30 * screenWidth)];
        functionTitleLabel.text = functionTitleArray[i];
        functionTitleLabel.font = CFFONT16;
        functionTitleLabel.textAlignment = NSTextAlignmentCenter;
        [functionView addSubview:functionTitleLabel];
    }
    UIView *explainView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, terminalFunctionLabel.frame.origin.y + 422 * screenHeight, CF_WIDTH - 60 * screenWidth, 516 * screenHeight)];
    explainView.backgroundColor = [UIColor whiteColor];
    explainView.layer.cornerRadius = 20 * screenWidth;
    [_installScrollView addSubview:explainView];
    UILabel *installExplainLabel = [[UILabel alloc]initWithFrame:CGRectMake(43 * screenWidth, 32 * screenHeight, explainView.frame.size.width - 43 * 2 * screenWidth, 30 * screenHeight)];
    installExplainLabel.text = @"安装说明";
    installExplainLabel.font = CFFONT16;
    [explainView addSubview:installExplainLabel];
    UILabel *installLable = [[UILabel alloc]initWithFrame:CGRectMake(installExplainLabel.frame.origin.x, installExplainLabel.frame.size.height + installExplainLabel.frame.origin.y + 15 * screenHeight, installExplainLabel.frame.size.width, 144 * screenHeight)];
    installLable.numberOfLines = 0;
    installLable.text = @"此农机还未安装终端模块，绑定农机只能读取基本信息。安装终端模块，可获取农机位置、水温等工况信息";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:installLable.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:20 * screenHeight];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, installLable.text.length)];
    installLable.attributedText = attributedString;
    installLable.font = CFFONT14;
    [explainView addSubview:installLable];
    UILabel *costExplainLable = [[UILabel alloc]initWithFrame:CGRectMake(installExplainLabel.frame.origin.x, installLable.frame.size.height + installLable.frame.origin.y + 58 * screenHeight, installExplainLabel.frame.size.width, installExplainLabel.frame.size.height)];
    costExplainLable.numberOfLines = 0;
    costExplainLable.text = @"费用说明";
    costExplainLable.font = CFFONT16;
    [explainView addSubview:costExplainLable];
    UILabel *costLable = [[UILabel alloc]initWithFrame:CGRectMake(installExplainLabel.frame.origin.x, costExplainLable.frame.size.height + costExplainLable.frame.origin.y + 15 * screenHeight, installExplainLabel.frame.size.width, 144 * screenHeight)];
    costLable.numberOfLines = 0;
    costLable.text = @"此农机还未安装终端模块，绑定农机只能读取基本信息。安装终端模块，可获取农机位置、水温等工况信息";
    NSMutableAttributedString *costAttributedString = [[NSMutableAttributedString alloc]initWithString:costLable.text];;
    NSMutableParagraphStyle *coastParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    [coastParagraphStyle setLineSpacing:20 * screenHeight];
    [costAttributedString addAttribute:NSParagraphStyleAttributeName value:coastParagraphStyle range:NSMakeRange(0, costLable.text.length)];
    costLable.attributedText = costAttributedString;
    costLable.font = CFFONT14;
    [explainView addSubview:costLable];
    
}
- (void)createSubmitSuccessView
{
    self.vagueView.hidden = NO;
    UIView *submintSuccessView = [[UIView alloc]initWithFrame:CGRectMake(75 * screenWidth, (CF_HEIGHT - 680 * screenHeight) / 2, CF_WIDTH - 150 * screenWidth, 680 * screenHeight)];
    submintSuccessView.backgroundColor = [UIColor whiteColor];
    submintSuccessView.layer.cornerRadius = 20 * screenWidth;
    [self.vagueView addSubview:submintSuccessView];
    
    UIImageView *submitImage = [[UIImageView alloc]initWithFrame:CGRectMake(90 * screenWidth, 10 * screenHeight, submintSuccessView.frame.size.width - 180 * screenWidth, 127 * screenHeight)];
    submitImage.image = [UIImage imageNamed:@"Submit_Success"];
    [submintSuccessView addSubview:submitImage];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 63 * screenHeight, submintSuccessView.frame.size.width, 35 * screenHeight)];
    titleLabel.text = @"提交成功!";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = CFFONT18;
    [submintSuccessView addSubview:titleLabel];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 156 * screenHeight, submintSuccessView.frame.size.width, 2 * screenHeight)];
    lineLabel.backgroundColor = BackgroundColor;
    [submintSuccessView addSubview:lineLabel];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(71 * screenWidth, 240 * screenHeight, submintSuccessView.frame.size.width - 142 * screenWidth, 100 * screenHeight)];
    textLabel.text = @"我们三包员收到信息，会在三个工作日内联系您！请耐心等候。";
    textLabel.font = CFFONT14;
    textLabel.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:textLabel.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:19 * screenHeight];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textLabel.text.length)];
    textLabel.attributedText = attributedString;
    [submintSuccessView addSubview:textLabel];
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(102 * screenWidth, 495 * screenHeight, submintSuccessView.frame.size.width - 204 * screenWidth, 88 * screenHeight);
    [sureButton setBackgroundImage:[UIImage imageNamed:@"Submit_Pop"] forState:UIControlStateNormal];
    [sureButton setTitle:@"知道了" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [submintSuccessView addSubview:sureButton];
    
}
- (void)installButtonClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定安装终端模块" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    //    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
    //    [alertControllerStr addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 2)];
    //    [alert setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self createSubmitSuccessView];
    }];
    [sureAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
- (void)sureButtonClick
{
    self.vagueView.hidden = YES;
    self.installTerminalBlock();
    [self.navigationController popViewControllerAnimated:YES];
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
