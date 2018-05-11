//
//  LandingViewController.m
//  ChangFa
//
//  Created by dev on 2017/12/25.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "CFLoginViewController.h"
#import "LeftViewController.h"
#import "CFAFNetWorkingMethod.h"
#import "SliderViewController.h"
#import "CFLoginTextField.h"
@interface CFLoginViewController ()<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITextField *accountText;
@property (nonatomic, strong) UITextField *secretText;
@property (nonatomic, strong) UIImageView *secretRight;
@property (nonatomic, assign) BOOL secret;
@end

@implementation CFLoginViewController
- (void)viewWillAppear:(BOOL)animated{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self paintView];
    self.navigationController.navigationBar.barTintColor = ChangfaColor;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([[userDefault objectForKey:@"UserUid"] length] > 0) {
        RootTabbarViewController *root = [[RootTabbarViewController alloc]initWithNavigationHeight:self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height];
        LeftViewController *left = [[LeftViewController alloc]init];
        SliderViewController *slider = [[SliderViewController alloc]initWithLeftView:left andMainView:root];
        left.delegate = slider;
        [self.navigationController pushViewController:slider animated:NO];
      
    } else {

    }
}
#pragma mark -界面铺设
- (void)paintView{

    // 常发图标
    UIImageView *imageChang = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    imageChang.frame = CGRectMake(self.view.frame.size.width / 2 - 130 * screenWidth, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height + 90 * screenHeight, 260 * screenWidth, 260 * screenHeight);
    [self.view addSubview:imageChang];
    // 账号、密码
//    _accountText = [[UITextField alloc]initWithFrame:CGRectMake(56 * Width, 450 * Height, selfWidith - 56 * 2 * Width, 100 * Height)];
    _accountText = [[CFLoginTextField alloc]initWithFrame:CGRectMake(56 * screenWidth, 550 * screenHeight, selfWidith - 56 * 2 * screenWidth, 100 * screenHeight)];
    UIView *accountLine = [[UIView alloc]initWithFrame:CGRectMake(0, _accountText.frame.size.height - 2 * screenHeight, _accountText.frame.size.width, 2 * screenHeight)];
    accountLine.backgroundColor = [UIColor grayColor];
    [_accountText addSubview:accountLine];
    _accountText.placeholder = @"请输入账号";
    //限制弹出数字键盘
    _accountText.keyboardType = UIKeyboardTypeNumberPad;
    //修改return按键样式
    _accountText.returnKeyType = UIReturnKeyDone;
//    accountText.textAlignment = NSTextAlignmentCenter;(居中)
    self.view.userInteractionEnabled = YES;
    _accountText.userInteractionEnabled= YES;
    _accountText.font = [UIFont systemFontOfSize:[self autoScaleW:14]];
    _accountText.borderStyle = UITextBorderStyleNone;
    UIImageView *accountImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Account"]];
    accountImage.frame = CGRectMake(0, 0, 50 * screenWidth, 50 * screenHeight);
    accountImage.contentMode = UIViewContentModeCenter;
    _accountText.leftView = accountImage;
    _accountText.leftViewMode = UITextFieldViewModeAlways;
    _accountText.delegate = self;
//    [_accountText becomeFirstResponder];
    [self.view addSubview:_accountText];

//    _secretText = [[UITextField alloc]initWithFrame:CGRectMake(_accountText.frame.origin.x, _accountText.frame.origin.y + _accountText.frame.size.height + 5 * Height, _accountText.frame.size.width, _accountText.frame.size.height)];
    _secretText = [[CFLoginTextField alloc]initWithFrame:CGRectMake(_accountText.frame.origin.x, _accountText.frame.origin.y + _accountText.frame.size.height + 55 * screenHeight, _accountText.frame.size.width, _accountText.frame.size.height)];
    UIView *secretLine = [[UIView alloc]initWithFrame:CGRectMake(0, _accountText.frame.size.height - 2 * screenHeight, _accountText.frame.size.width, 2 * screenHeight)];
    secretLine.backgroundColor = [UIColor grayColor];
    [_secretText addSubview:secretLine];
    _secretText.placeholder = @"请输入密码";
    _secretText.font = [UIFont systemFontOfSize:[self autoScaleW:14]];
    _secretText.borderStyle = UITextBorderStyleNone;
    UIImageView *secretLeft = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LoginSecretCode"]];
    secretLeft.frame = CGRectMake(0, 0, 50 * screenWidth, 50 * screenHeight);
    secretLeft.contentMode = UIViewContentModeCenter;
    _secretText.leftView = secretLeft;
    _secretText.leftViewMode = UITextFieldViewModeAlways;
    _secretRight = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"biyan"]];
    _secretRight.frame = CGRectMake(0, 0, secretLeft.frame.size.width, secretLeft.frame.size.height);
    _secretText.rightView = _secretRight;
    _secretRight.contentMode = UIViewContentModeCenter;
    _secretText.rightViewMode = UITextFieldViewModeAlways;
    // 添加手势
    _secret = YES;
    _secretText.secureTextEntry = YES;
    _secretRight.userInteractionEnabled = YES;
    UITapGestureRecognizer *secretTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToShowOrNot:)];
    [_secretRight addGestureRecognizer:secretTap];
    [_secretText addSubview:_secretRight];
    _secretText.delegate = self;
//    UIButton *secretRightBtn = [UIButton buttonWithType: UIButtonTypeCustom];
//    secretRightBtn.frame = secretRight.frame;
//    [secretRightBtn setBackgroundColor:[UIColor grayColor]];
//    [_secretText becomeFirstResponder];
    [self.view addSubview:_secretText];
    
    // 登录
    UIButton *landBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    landBtn.backgroundColor = ChangfaColor;
    landBtn.userInteractionEnabled = YES;
    landBtn.layer.cornerRadius = 20 * screenWidth;
//    landBtn.frame = CGRectMake(_accountText.frame.origin.x, _accountText.frame.origin.y + _accountText.frame.size.height * 3, _accountText.frame.size.width, _accountText.frame.size.height);
    landBtn.frame = CGRectMake(_accountText.frame.origin.x, _accountText.frame.origin.y + _accountText.frame.size.height * 4, _accountText.frame.size.width, _accountText.frame.size.height);
    [landBtn setTitle:@"登录" forState:UIControlStateNormal];
    [landBtn addTarget:self action:@selector(landingView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:landBtn];
    
    // 注册账号、忘记密码
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(_accountText.frame.origin.x, landBtn.frame.size.height + landBtn.frame.origin.y, 200 * screenWidth, 100 * screenHeight);
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    registerBtn.contentEdgeInsets = UIEdgeInsetsMake(0,5 * screenWidth, 0, 0);
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:[self autoScaleW:14]];
    [registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(_accountText.frame.origin.x + _accountText.frame.size.width - registerBtn.frame.size.width, registerBtn.frame.origin.y, registerBtn.frame.size.width, registerBtn.frame.size.height);
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgetBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 5 * screenWidth);
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:[self autoScaleW:14]];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetSecret) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
//    // 三方登陆
//    UILabel *thirdPart = [[UILabel alloc]initWithFrame:CGRectMake(_accountText.frame.origin.x, landBtn.frame.size.height + landBtn.frame.origin.y + 150 * Height, _accountText.frame.size.width, _accountText.frame.size.height)];
//    thirdPart.text = @"第三方登录";
//    thirdPart.font = [UIFont systemFontOfSize:[self autoScaleW:14]];
//    thirdPart.textColor = [UIColor grayColor];
//    thirdPart.textAlignment = NSTextAlignmentCenter;
//    UILabel *thirdLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, _accountText.frame.size.height / 2 - Height, 150 * Width, 2 * Height)];
//    thirdLeft.backgroundColor = [UIColor grayColor];
//    [thirdPart addSubview:thirdLeft];
//    UILabel *thirdRight = [[UILabel alloc]initWithFrame:CGRectMake(_accountText.frame.size.width - thirdLeft.frame.size.width, thirdLeft.frame.origin.y, thirdLeft.frame.size.width, thirdLeft.frame.size.height)];
//    thirdRight.backgroundColor = [UIColor grayColor];
//    [thirdPart addSubview:thirdRight];
//    [self.view addSubview:thirdPart];
//
//    UIButton *weChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    weChatBtn.frame = CGRectMake(selfWidith / 2 - 120 * Width, thirdPart.frame.size.height + thirdPart.frame.origin.y + 30 * Height, 50 * Width, 65 * Height);
////    [weChatBtn setBackgroundColor:[UIColor cyanColor]];
//    [weChatBtn setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
//    [weChatBtn addTarget:self action:@selector(weChatLanding) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:weChatBtn];
//    UIButton *QQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    QQBtn.frame = CGRectMake(selfWidith / 2 + 60 * Width, weChatBtn.frame.origin.y, weChatBtn.frame.size.width, weChatBtn.frame.size.height);
////    [QQBtn setBackgroundColor:[UIColor cyanColor]];
//    [QQBtn setBackgroundImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
//    [QQBtn addTarget:self action:@selector(QQLanding) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:QQBtn];
}
#pragma mark -手势(改变开闭眼状态，管理密码显隐)
- (void)tapToShowOrNot:(UITextField *)sender{
    [_secretText becomeFirstResponder];
    if (_secret == YES) {
        _secret = NO;
        _secretText.secureTextEntry = NO;
        NSString *secretStr = _secretText.text;
        _secretText.text = @"";
        _secretText.text = secretStr;
        _secretRight.image = [UIImage imageNamed:@"kaiyan"];
    } else {
        _secret = YES;
        _secretText.secureTextEntry = YES;
        NSString *secretStr = _secretText.text;
        _secretText.text = @"";
        _secretText.text = secretStr;
        _secretRight.image = [UIImage imageNamed:@"biyan"];
    }
}
#pragma mark -textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    if (!textField.window.isKeyWindow) {
//        [textField.window makeKeyAndVisible];
//    }
//    [textField becomeFirstResponder];
}
#pragma mark -回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 父类视图结束编辑，直接回收键盘
    [self.view endEditing:YES];
//    [_accountText resignFirstResponder];
//    [_secretText resignFirstResponder];
}
#pragma mark -登陆 ([UIApplication sharedApplication] statusBarFrame]获取状态栏高度)
- (void)landingView{

    NSDictionary *dic = @{
                           @"userName":self.accountText.text,
                           @"userpwd":self.secretText.text,
                           @"loginType":@0,
                           @"accessToken":@"",
                           @"openId":@"",
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/userLogin" Params:dic Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"body"]];
            //1.获得NSUserDefaults文件
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //2.向文件中写入内容
            for (id object in [dic objectForKey:@"userInfo"]) {
                if ([[object class] isEqual:NULL]) {
                    NSLog(@"%@", object);
                }
            }
            [userDefaults setObject:[dic objectForKey:@"token"] forKey:@"UserToken"];
            [userDefaults setObject:[[dic objectForKey:@"userInfo"] objectForKey:@"uid"] forKey:@"UserUid"];
            [userDefaults setObject:[[dic objectForKey:@"userInfo"] objectForKey:@"uname"] forKey:@"UserName"];
            [userDefaults setObject:[[dic objectForKey:@"userInfo"] objectForKey:@"phone"] forKey:@"UserPhone"];
            [userDefaults setObject:[[dic objectForKey:@"userInfo"] objectForKey:@"bindNum"] forKey:@"UserBindNum"];
            if ([[[dic objectForKey:@"userInfo"] objectForKey:@"location"] isKindOfClass:[NSNull class]]) {
                [userDefaults setObject:@"" forKey:@"UserLocation"];
            } else {
                [userDefaults setObject:[[dic objectForKey:@"userInfo"] objectForKey:@"location"] forKey:@"UserLocation"];
            }
            if ([[[dic objectForKey:@"userInfo"] objectForKey:@"headUrl"] isKindOfClass:[NSNull class]]) {
                [userDefaults setObject:@"" forKey:@"UserHeadUrl"];
            } else {
                [userDefaults setObject:[[dic objectForKey:@"userInfo"] objectForKey:@"headUrl"] forKey:@"UserHeadUrl"];
            }
            if ([[[dic objectForKey:@"userInfo"] objectForKey:@"distributorId"] isKindOfClass:[NSNull class]]) {
                [userDefaults setObject:@"" forKey:@"UserDistributorId"];
            } else {
                [userDefaults setObject:[[dic objectForKey:@"userInfo"] objectForKey:@"distributorId"] forKey:@"UserDistributorId"];
            }
            if ([[[dic objectForKey:@"userInfo"] objectForKey:@"distributorName"] isKindOfClass:[NSNull class]]) {
                [userDefaults setObject:@"" forKey:@"UserDistributorName"];
            } else {
                [userDefaults setObject:[[dic objectForKey:@"userInfo"] objectForKey:@"distributorName"] forKey:@"UserDistributorName"];
            }
            NSLog(@"%@", [userDefaults objectForKey:@"UserDistributorId"]);
            [userDefaults setObject:[[dic objectForKey:@"userInfo"] objectForKey:@"roleType"] forKey:@"UserRoleType"];
            [userDefaults setObject:[dic objectForKey:@"loginType"] forKey:@"UserLoginType"];
            //2.1立即同步
            [userDefaults synchronize];
            RootTabbarViewController *root = [[RootTabbarViewController alloc]initWithNavigationHeight:self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height];
            LeftViewController *left = [[LeftViewController alloc]init];
            SliderViewController *slider = [[SliderViewController alloc]initWithLeftView:left andMainView:root];
            left.delegate = slider;
            [self.navigationController pushViewController:slider animated:YES];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录失败" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];


}

#pragma mark -注册
- (void)registerView{
    RegisterViewController *registe = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registe animated:YES];
   
}

#pragma mark -忘记密码
- (void)forgetSecret{
    ForgetViewController *forgetVC = [[ForgetViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];

}
#pragma mark -微信登录
- (void)weChatLanding{

}
#pragma mark -QQ登录
- (void)QQLanding{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //如果是限制只能输入数字的文本框
    
    if (_accountText==textField) {
        
        return [self validateNumber:string];
        
    }
    
    //否则返回yes,不限制其他textfield
    
    return YES;
    
}

- (BOOL)validateNumber:(NSString*)number {
    
    BOOL res = YES;
    
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    int i = 0;
    
    while (i < number.length) {
        
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        
        if (range.length == 0) {
            
            res = NO;
            
            break;
            
        }
        
        i++;
        
    }
    
    return res;
    
}



//新版手机正则表达式(手机号换的太快，这里就做个简单的判断)

//- (BOOL)isMobileNumber:(NSString *)mobileNum
//
//{
//
//    if (mobileNum.length != 11)
//
//    {
//
//        return NO;
//
//    }
//
//    return YES;
//
//}
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
