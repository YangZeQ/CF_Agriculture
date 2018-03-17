//
//  CFAgencySellViewController.m
//  ChangFa
//
//  Created by Developer on 2018/1/23.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAgencySellViewController.h"
#import "ScanViewController.h"
#import "MachineModel.h"
#import "CFRegisterTextFieldView.h"
#import "CFAFNetWorkingMethod.h"
#import "CFAgencySellSuccessViewController.h"
@interface CFAgencySellViewController ()<scanViewControllerDelegate, UITextFieldDelegate>
@property (nonatomic, strong)UIView *machineNumberView;
@property (nonatomic, strong)UILabel *machineNumber;
@property (nonatomic, strong)UIView *lineView;

@property (nonatomic, strong)CFRegisterTextFieldView *identifyText;
@property (nonatomic, strong)CFRegisterTextFieldView *nameText;
@property (nonatomic, strong)CFRegisterTextFieldView *phoneText;
@property (nonatomic, strong)CFRegisterTextFieldView *addressText;

@property (nonatomic, strong)MachineModel *model;
@end

@implementation CFAgencySellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"出售";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.view.backgroundColor = BackgroundColor;
    
    [self createSellView];
    // Do any additional setup after loading the view.
}
- (void)createSellView{
    [self scanViewWithText:@"农机信息" Place:@"" ScanText:@"农机扫码" ScanImage:@"scanCompany" ViewFrame:CGRectMake(0, navHeight, self.view.frame.size.width, 396 * screenHeight) ScanButtonFrame:CGRectMake(self.view.frame.size.width / 2 - 94 * screenWidth, 92 * screenHeight, 188 * screenWidth, 188 * screenHeight)];
    [self createUserInfoView];
    
    UIButton *sellButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sellButton.frame = CGRectMake(0, self.view.frame.size.height - 100 * screenHeight, self.view.frame.size.width, 100 * screenHeight);
    [sellButton setTitle:@"出售" forState:UIControlStateNormal];
    [sellButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sellButton setBackgroundColor:ChangfaColor];
    [sellButton addTarget:self action:@selector(sellButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sellButton];
}
- (void)sellButtonClick{
    if ([_model.imei length] < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请获取农机信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    } else if ([_nameText.textField.text length] < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请填写姓名" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    } else if ([_phoneText.textField.text length] < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请填写电话号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    } else if ([_addressText.textField.text length] < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请填写地址" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    } else if ([_identifyText.textField.text length] < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请填写身份证号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict =@{
                          @"imei":self.model.imei,
                          @"carBar":self.model.productBarCode,
                          @"distributorsID":[userDefault objectForKey:@"UserDistributorId"],
                          @"name":_nameText.textField.text,
                          @"tel":_phoneText.textField.text,
                          @"address":_addressText.textField.text,
                          @"cardNumber":_identifyText.textField.text,
                          };
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/sweepCodeSales" Params:dict Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            CFAgencySellSuccessViewController *sellSuccess = [[CFAgencySellSuccessViewController alloc]init];
            sellSuccess.machineModel = self.model;
            PersonModel *person = [[PersonModel alloc]init];
            person.uname = _nameText.textField.text;
            person.phone = _phoneText.textField.text;
            person.location = _addressText.textField.text;
            person.identify = _identifyText.textField.text;
            sellSuccess.personModel = person;
            [self.navigationController pushViewController:sellSuccess animated:YES];
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
- (void)scanViewWithText:(NSString *)text
                   Place:(NSString *)place
                ScanText:(NSString *)scanText
               ScanImage:(NSString *)scanImage
               ViewFrame:(CGRect)viewFrame
         ScanButtonFrame:(CGRect)scanButtonFrame{
    _machineNumberView = [[UIView alloc]initWithFrame:viewFrame];
    _machineNumberView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_machineNumberView];
    
    _machineNumber = [[UILabel alloc]init];
    _machineNumber.frame = CGRectMake(50 * screenWidth, 20 * screenHeight, 400 * screenWidth, 42 * screenHeight);
    _machineNumber.text = text;
    _machineNumber.font = CFFONT16;
    _machineNumber.textAlignment = NSTextAlignmentLeft;
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(putInMachineNumber)];
    _machineNumber.userInteractionEnabled = YES;
//    [_machineNumber addGestureRecognizer:tapGesture];
    [_machineNumberView addSubview:_machineNumber];
    
    UIButton *machineNumberPlace = [UIButton buttonWithType:UIButtonTypeCustom];
    machineNumberPlace.frame = CGRectMake(self.view.frame.size.width -  280 * screenWidth, _machineNumber.frame.origin.y, 250 * screenWidth, _machineNumber.frame.size.height);
    [machineNumberPlace setTitle:place forState:UIControlStateNormal];
    machineNumberPlace.titleLabel.font = CFFONT16;
    [machineNumberPlace setTitleColor:ChangfaColor forState:UIControlStateNormal];
//    [machineNumberPlace addTarget:self action:@selector(whereIsMachineNumber) forControlEvents:UIControlEventTouchUpInside];
    [_machineNumberView addSubview:machineNumberPlace];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(_machineNumber.frame.origin.x, _machineNumber.frame.size.height + _machineNumber.frame.origin.y + 30 * screenHeight, self.view.frame.size.width - _machineNumber.frame.origin.x * 2, 2 * screenHeight)];
    _lineView.backgroundColor = BackgroundColor;
    [_machineNumberView addSubview:_lineView];
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = scanButtonFrame;
    [scanButton setImage:[UIImage imageNamed:scanImage] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scanMachine) forControlEvents:UIControlEventTouchUpInside];
    [_machineNumberView addSubview:scanButton];
    
    UILabel *scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, scanButton.frame.size.height + scanButton.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 26 * screenHeight)];
    scanLabel.text = scanText;
    scanLabel.font = CFFONT16;
    scanLabel.textAlignment = NSTextAlignmentCenter;
    [_machineNumberView addSubview:scanLabel];
}
- (void)createUserInfoView{
    UIView *userInfo = [[UIView alloc]initWithFrame:CGRectMake(0, _machineNumberView.frame.size.height + _machineNumberView.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 550 * screenHeight)];
    userInfo.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userInfo];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * screenWidth, 30 * screenHeight, 500 * screenWidth, 50 * screenHeight)];
    titleLabel.text = @"用户信息";
    [userInfo addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.size.height + titleLabel.frame.origin.y, self.view.frame.size.width - titleLabel.frame.origin.x * 2, 3 * screenHeight)];
    lineView.backgroundColor = BackgroundColor;
    [userInfo addSubview:lineView];
    
    _identifyText = [[CFRegisterTextFieldView alloc]initWithImageName:@"ID" Placeholder:@"请输入身份证号码" GetCode:NO SecretCode:NO Frame:CGRectMake(60 * screenWidth, titleLabel.frame.size.height + titleLabel.frame.origin.y + 30 * screenHeight, self.view.frame.size.width - 120 * screenWidth, 80 * screenHeight) ScaleWidth:screenWidth ScaleHeight:screenHeight];
    //限制弹出数字键盘
    _identifyText.textField.keyboardType = UIKeyboardTypeNumberPad;
    //修改return按键样式
    _identifyText.textField.returnKeyType = UIReturnKeyDone;
    _identifyText.textField.delegate = self;
    _nameText = [[CFRegisterTextFieldView alloc]initWithImageName:@"User" Placeholder:@"请输入姓名" GetCode:NO SecretCode:NO Frame:CGRectMake(_identifyText.frame.origin.x, _identifyText.frame.size.height + _identifyText.frame.origin.y + 30 * screenHeight, _identifyText.frame.size.width, _identifyText.frame.size.height) ScaleWidth:screenWidth ScaleHeight:screenHeight];
    _nameText.textField.delegate = self;
    _phoneText = [[CFRegisterTextFieldView alloc]initWithImageName:@"Phone" Placeholder:@"请输入电话号码" GetCode:NO SecretCode:NO Frame:CGRectMake(_identifyText.frame.origin.x, _nameText.frame.size.height + _nameText.frame.origin.y + 30 * screenHeight, _identifyText.frame.size.width, _identifyText.frame.size.height) ScaleWidth:screenWidth ScaleHeight:screenHeight];
    _phoneText.textField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneText.textField.returnKeyType = UIReturnKeyDone;
    _phoneText.textField.delegate = self;
    _addressText = [[CFRegisterTextFieldView alloc]initWithImageName:@"Address" Placeholder:@"请输入地址" GetCode:NO SecretCode:NO Frame:CGRectMake(_identifyText.frame.origin.x, _phoneText.frame.size.height + _phoneText.frame.origin.y + 30 * screenHeight, _identifyText.frame.size.width, _identifyText.frame.size.height) ScaleWidth:screenWidth ScaleHeight:screenHeight];
    _addressText.textField.delegate = self;
    [userInfo addSubview:_identifyText];
    [userInfo addSubview:_nameText];
    [userInfo addSubview:_phoneText];
    [userInfo addSubview:_addressText];

}
- (void)scanMachine{
    ScanViewController *scan = [[ScanViewController alloc]init];
    scan.scanType = @"sell";
    scan.delegate = self;
    [self presentViewController:scan animated:YES completion:^{
        
    }];
}
- (void)scanGetInformation:(MachineModel *)model{
    if ([model.carState integerValue] == 2 || [model.carState integerValue] == 4) {
        self.model = model;
        [self reloadCompanyMachineNumberView:model];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"该农机不可销售" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}
- (void)reloadCompanyMachineNumberView:(MachineModel *)model {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,_lineView.frame.size.height + _lineView.frame.origin.y, self.view.frame.size.width, _machineNumberView.frame.size.height - _lineView.frame.size.height - _lineView.frame.origin.y)];
    backView.backgroundColor = [UIColor whiteColor];
    [_machineNumberView addSubview:backView];
    UIImageView *machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, 236 * screenWidth, 236 * screenHeight)];
    switch ([model.carType integerValue]) {
        case 1:
            machineImage.image = [UIImage imageNamed:@"CFTuoLaJi"];
            break;
        case 2:
            machineImage.image = [UIImage imageNamed:@"CFShouGeJi"];
            break;
        case 3:
            machineImage.image = [UIImage imageNamed:@"CFChaYangji"];
            break;
        case 4:
            machineImage.image = [UIImage imageNamed:@"CFHongGanJi"];
            break;
        default:
            break;
    }
    [backView addSubview:machineImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.size.width + machineImage.frame.origin.x + 30 * screenWidth, 73 * screenHeight, self.view.frame.size.width - 346 * screenWidth, 30 * screenHeight)];
    nameLabel.text = [@"名称：" stringByAppendingString:[NSString stringWithFormat:@"%@",model.productName]];
    nameLabel.font = CFFONT14;
    [backView addSubview:nameLabel];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.size.height + nameLabel.frame.origin.y + 30 * screenHeight, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    typeLabel.text = [@"型号：" stringByAppendingString:[NSString stringWithFormat:@"%@",model.productModel]];
    typeLabel.font = CFFONT14;
    [backView addSubview:typeLabel];
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, typeLabel.frame.size.height + typeLabel.frame.origin.y + 30 * screenHeight, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    numberLabel.text = [@"车架号："stringByAppendingString:[NSString stringWithFormat:@"%@",model.productBarCode]];
    numberLabel.font = CFFONT14;
    numberLabel.textColor = [UIColor redColor];
    [backView addSubview:numberLabel];
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, -400 * screenHeight, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
