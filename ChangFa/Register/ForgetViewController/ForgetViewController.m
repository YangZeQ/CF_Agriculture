//
//  ForgetViewController.m
//  ChangFa
//
//  Created by dev on 2017/12/26.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "ForgetViewController.h"
#import "CFRegisterTextFieldView.h"
#import "CFAFNetWorkingMethod.h"
@interface ForgetViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)CFRegisterTextFieldView *phoneNumberView;
@property (nonatomic, strong)CFRegisterTextFieldView *IdentifyView;
@property (nonatomic, strong)CFRegisterTextFieldView *putSecretView;
@property (nonatomic, strong)CFRegisterTextFieldView *sureSecretView;

@property (nonatomic, strong)dispatch_source_t timer;
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    self.navigationItem.title = @"找回密码";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatView];
    // Do any additional setup after loading the view.
}
#pragma mark -创建视图
- (void)creatView{
    // 手机号
    _phoneNumberView = [[CFRegisterTextFieldView alloc] initWithImageName:@"Phone" Placeholder:@"请输入手机号" GetCode:NO SecretCode:NO Frame:CGRectMake(56 * Width, 64 + 44 * Height, self.view.frame.size.width - 2 * 56 * Width, 100 * Height) ScaleWidth:Width ScaleHeight:Height];
    _phoneNumberView.textField.delegate = self;
    //限制弹出数字键盘
    _phoneNumberView.textField.keyboardType = UIKeyboardTypeNumberPad;
    //修改return按键样式
    _phoneNumberView.textField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_phoneNumberView];
    // 验证码
    _IdentifyView = [[CFRegisterTextFieldView alloc]initWithImageName:@"VerifiedCode" Placeholder:@"请输入验证码" GetCode:YES SecretCode:NO Frame:CGRectMake(_phoneNumberView.frame.origin.x, _phoneNumberView.frame.origin.y + _phoneNumberView.frame.size.height + 44 * Height, _phoneNumberView.frame.size.width, _phoneNumberView.frame.size.height) ScaleWidth:Width ScaleHeight:Height];
    [_IdentifyView.getCodeBtn addTarget:self action:@selector(getCodeNumber) forControlEvents:UIControlEventTouchUpInside];
    _IdentifyView.textField.delegate = self;
    _IdentifyView.textField.keyboardType = UIKeyboardTypeNumberPad;
    _IdentifyView.textField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_IdentifyView];
    // 密码
    _putSecretView = [[CFRegisterTextFieldView alloc]initWithImageName:@"SecretCode" Placeholder:@"请输入新密码" GetCode:NO SecretCode:YES Frame:CGRectMake(_phoneNumberView.frame.origin.x, _IdentifyView.frame.size.height + _IdentifyView.frame.origin.y + 44 * Height, _phoneNumberView.frame.size.width, _phoneNumberView.frame.size.height) ScaleWidth:Width ScaleHeight:Height];
    _putSecretView.textField.secureTextEntry = YES;
    [self.view addSubview:_putSecretView];
    // 确认密码
    _sureSecretView = [[CFRegisterTextFieldView alloc]initWithImageName:@"SureSecretCode" Placeholder:@"请确认密码" GetCode:NO SecretCode:NO Frame:CGRectMake(_phoneNumberView.frame.origin.x, _putSecretView.frame.size.height + _putSecretView.frame.origin.y + 44 * Height, _phoneNumberView.frame.size.width, _phoneNumberView.frame.size.height) ScaleWidth:Width ScaleHeight:Height];
    _sureSecretView.textField.secureTextEntry = YES;
    [self.view addSubview:_sureSecretView];

    // 重置
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(_phoneNumberView.frame.origin.x, _sureSecretView.frame.size.height + _sureSecretView.frame.origin.y + 100 * Height, _phoneNumberView.frame.size.width, 88 * Height);
    registerBtn.layer.cornerRadius = 10 * Width;
    [registerBtn setBackgroundColor:ChangfaColor];
    [registerBtn setTitle:@"确定重置" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}
#pragma mark -返回上一层
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getCodeNumber{
    if (![CFClassMethod methodToJudgeTheMobile:self.phoneNumberView.textField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSDictionary *dict = @{
                           @"phone":self.phoneNumberView.textField.text,
                           @"sendType":@2
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/sendVerificationCode" Params:dict Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"sendSuccess%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            [self openCountdown];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"已发送，注意查收" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"网络错误，请重新发送" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"sendFailure%@", error);
    }];
}
- (void)agreeButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"disagree"] forState:UIControlStateNormal];
        
    }
}

- (void)delegateButtonClick{
    NSLog(@"协议");
}
- (void)registerButtonClick{
    NSDictionary *dict = @{
                           @"phone":self.phoneNumberView.textField.text,
                           @"verification":self.IdentifyView.textField.text,
                           @"newPwd":self.putSecretView.textField.text,
                           };
    
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/forgetPassword" Params:dict Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[[responseObject objectForKey:@"head"] objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //如果是限制只能输入数字的文本框
    
    if (_phoneNumberView.textField == textField) {
        
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

-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            NSLog(@"%ld", (long)time);
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [_IdentifyView.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//                [_IdentifyView.getCodeBtn setTitleColor:[UIColor colorFromHexCode:@"FB8557"] forState:UIControlStateNormal];
                _IdentifyView.getCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [_IdentifyView.getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
//                [_IdentifyView.getCodeBtn setTitleColor:[UIColor colorFromHexCode:@"979797"] forState:UIControlStateNormal];
                _IdentifyView.getCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
- (void)viewDidDisappear:(BOOL)animated{
    if ( _timer) {
        dispatch_source_cancel(_timer);
    }
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
