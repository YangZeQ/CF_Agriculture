//
//  BandMachineViewController.m
//  ChangFa
//
//  Created by dev on 2018/1/3.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "BandMachineViewController.h"
#import "CFBandInformationView.h"
#import "ScanViewController.h"
#import "PutNumberViewController.h"
#import "PickView.h"
#import "MachineModel.h"
#import "CFAFNetWorkingMethod.h"
#import "OutputMachineViewController.h"
#import "BindAndOutputView.h"
#import "CFRelieveIMEIViewController.h"
#import "CFBindIMEIViewController.h"
#import "CFPickView.h"
@interface BandMachineViewController ()<scanViewControllerDelegate, PutNumberViewControllerDelegate, UIGestureRecognizerDelegate, textDelegate, UITextFieldDelegate>
@property (nonatomic, strong)UIView *machineNumberView;
@property (nonatomic, strong)UILabel *machineNumber;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UIView *vagueView;
@property (nonatomic, strong)UIImageView *machineImage;
@property (nonatomic, strong)CFBandInformationView *idView;
@property (nonatomic, strong)CFBandInformationView *nameView;
@property (nonatomic, strong)CFBandInformationView *phoneView;
@property (nonatomic, strong)CFBandInformationView *remarkView;
@property (nonatomic, strong)CFPickView *pickView;
@property (nonatomic, strong)MachineModel *model;
@property (nonatomic, strong)UITextField *imeiTextField; //
@property (nonatomic, strong)UIButton *bandButton;
@property (nonatomic, copy)NSString *carBar;
@end

@implementation BandMachineViewController
- (MachineModel *)model{
    if (_model == nil) {
        _model = [[MachineModel alloc]init];
    }
    return _model;
}

- (UIView *)vagueView{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _vagueView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.view.backgroundColor = BackgroundColor;
    [self createBandMachineView];
    // Do any additional setup after loading the view.
}
#pragma mark -农机信息扫描页面
- (void)createBandMachineView{
    if ([self.userType isEqualToString:@"worker"]) {
        [self scanViewWithText:@"农机信息" Place:@"" ScanText:@"农机扫码" ScanImage:@"scan" ViewFrame:CGRectMake(0, navHeight, self.view.frame.size.width, 296 * screenHeight) ScanButtonFrame:CGRectMake(self.view.frame.size.width / 2 - 44 * screenWidth, 120 * screenHeight, 88 * screenWidth, 88 * screenHeight) scanType:@"scanMachine"];
        [self informationView];
    } else if ([self.userType isEqualToString:@"company"]) {
        [self scanViewWithText:@"农机信息" Place:@"" ScanText:@"农机扫码" ScanImage:@"scanCompany" ViewFrame:CGRectMake(0, navHeight, self.view.frame.size.width, 396 * screenHeight) ScanButtonFrame:CGRectMake(self.view.frame.size.width / 2 - 94 * screenWidth, 92 * screenHeight, 188 * screenWidth, 188 * screenHeight) scanType:@"scanMachineBarCode"];
        [self getIMEIInfo];
    }
}
// 农机手、营销公司等的具体农机信息页面
- (void)scanViewWithText:(NSString *)text
                   Place:(NSString *)place
                ScanText:(NSString *)scanText
               ScanImage:(NSString *)scanImage
               ViewFrame:(CGRect)viewFrame
         ScanButtonFrame:(CGRect)scanButtonFrame
                scanType:(NSString *)scanType{
    _machineNumberView = [[UIView alloc]initWithFrame:viewFrame];
    _machineNumberView.userInteractionEnabled = YES;
    _machineNumberView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_machineNumberView];
    
    _machineNumber = [[UILabel alloc]init];
    _machineNumber.frame = CGRectMake(50 * screenWidth, 25 * screenHeight, 400 * screenWidth, 42 * screenHeight);
    _machineNumber.text = text;
    _machineNumber.font = CFFONT16;
    _machineNumber.textAlignment = NSTextAlignmentLeft;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(putInMachineNumber)];
    _machineNumber.userInteractionEnabled = YES;
    [_machineNumber addGestureRecognizer:tapGesture];
    [_machineNumberView addSubview:_machineNumber];
    
    UIButton *machineNumberPlace = [UIButton buttonWithType:UIButtonTypeCustom];
    machineNumberPlace.frame = CGRectMake(self.view.frame.size.width -  330 * screenWidth, _machineNumber.frame.origin.y, 300 * screenWidth, _machineNumber.frame.size.height);
    [machineNumberPlace setTitle:place forState:UIControlStateNormal];
    machineNumberPlace.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    machineNumberPlace.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20 * screenWidth);
    [machineNumberPlace setTitleColor:ChangfaColor forState:UIControlStateNormal];
    machineNumberPlace.titleLabel.font = CFFONT16;
    [machineNumberPlace addTarget:self action:@selector(whereIsMachineNumber) forControlEvents:UIControlEventTouchUpInside];
    [_machineNumberView addSubview:machineNumberPlace];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(_machineNumber.frame.origin.x, _machineNumber.frame.size.height + _machineNumber.frame.origin.y + 25 * screenHeight, self.view.frame.size.width - _machineNumber.frame.origin.x * 2, 2 * screenHeight)];
    _lineView.backgroundColor = BackgroundColor;
    [_machineNumberView addSubview:_lineView];
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = scanButtonFrame;
    [scanButton setImage:[UIImage imageNamed:scanImage] forState:UIControlStateNormal];
    if ([scanType isEqualToString:@"scanMachine"]) {
        [scanButton addTarget:self action:@selector(scanMachine) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [scanButton addTarget:self action:@selector(scanMachineBarCode) forControlEvents:UIControlEventTouchUpInside];
    }
 
    [_machineNumberView addSubview:scanButton];
    
    UILabel *scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, scanButton.frame.size.height + scanButton.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 26 * screenHeight)];
    scanLabel.text = scanText;
    scanLabel.font = CFFONT16;
    scanLabel.textAlignment = NSTextAlignmentCenter;
    [_machineNumberView addSubview:scanLabel];
}
// 农机手
- (void)informationView{
    
    _idView = [[CFBandInformationView alloc]initWithFrame:CGRectMake(0, _machineNumberView.frame.size.height + _machineNumberView.frame.origin.y + 30 * screenHeight, _machineNumberView.frame.size.width, 120 * screenHeight) LabelStr:@"我的身份" PlaceHolderStr:@"选择身份"];
    UIButton *IDButton = [UIButton buttonWithType:UIButtonTypeCustom];
    IDButton.frame = _idView.bandTextField.frame;
    [IDButton addTarget:self action:@selector(chooseIdentify) forControlEvents:UIControlEventTouchUpInside];
    [_idView addSubview:IDButton];
    [self.view addSubview:_idView];
    
    _nameView = [[CFBandInformationView alloc]initWithFrame:CGRectMake(0, _idView.frame.size.height + _idView.frame.origin.y + screenHeight, _machineNumberView.frame.size.width, _idView.frame.size.height) LabelStr:@"姓名" PlaceHolderStr:@"输入姓名"];
    _nameView.bandTextField.delegate = self;
    [self.view addSubview:_nameView];
    
    _phoneView = [[CFBandInformationView alloc]initWithFrame:CGRectMake(0, _nameView.frame.size.height + _nameView.frame.origin.y + screenHeight, _machineNumberView.frame.size.width, _idView.frame.size.height) LabelStr:@"联系电话" PlaceHolderStr:@"输入联系电话"];
    _phoneView.bandTextField.keyboardType = UIKeyboardTypePhonePad;
    _phoneView.bandTextField.delegate = self;
    [self.view addSubview:_phoneView];
    
    _remarkView = [[CFBandInformationView alloc]initWithFrame:CGRectMake(0, _phoneView.frame.size.height + _phoneView.frame.origin.y + screenHeight, _machineNumberView.frame.size.width, _idView.frame.size.height) LabelStr:@"农机备注" PlaceHolderStr:@"选填（13字以内）"];
    _remarkView.bandTextField.delegate = self;
    [self.view addSubview:_remarkView];
    
    UIButton *bandMachineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bandMachineButton.frame = CGRectMake(30 * screenWidth, _remarkView.frame.size.height + _remarkView.frame.origin.y + 100 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 100 * screenHeight);
    bandMachineButton.layer.cornerRadius = 20 * screenWidth;
    [bandMachineButton setTitle:@"绑定" forState:UIControlStateNormal];
    [bandMachineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bandMachineButton setBackgroundColor:ChangfaColor];
    [bandMachineButton addTarget:self action:@selector(bandMachine) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bandMachineButton];
    
    _pickView = [[CFPickView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight)];
    self.vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.pickView.cancelButton addTarget:self action:@selector(pickViewCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.pickView.sureButton addTarget:self action:@selector(pickViewsuerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _vagueView.hidden = YES;
    [self.view addSubview:_vagueView];
    [self.view addSubview:_pickView];
}
// 营销公司
- (void)getIMEIInfo{
    UILabel *imeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, _machineNumberView.frame.size.height + _machineNumberView.frame.origin.y + 30 * screenHeight, 200 * screenWidth, 50 * screenHeight)];
    imeiLabel.text = @"IMEI";
    imeiLabel.font = CFFONT16;
    [self.view addSubview:imeiLabel];
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, imeiLabel.frame.size.height + imeiLabel.frame.origin.y + 20 * screenHeight, self.view.frame.size.width, 120 * screenHeight)];
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    _imeiTextField = [[UITextField alloc]initWithFrame:CGRectMake(imeiLabel.frame.origin.x, 0, self.view.frame.size.width - 150 * screenWidth, textView.frame.size.height)];
    _imeiTextField.placeholder = @"输入IMEI";
    _imeiTextField.keyboardType = UIKeyboardTypeNumberPad;
    _imeiTextField.font = CFFONT16;
    [textView addSubview:_imeiTextField];
    UIButton *imeiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imeiButton.frame = CGRectMake(_imeiTextField.frame.size.width + _imeiTextField.frame.origin.x + 10 * screenWidth, 20 * screenHeight, 80 * screenWidth, 80 * screenHeight);
    [imeiButton setImage:[UIImage imageNamed:@"scanCompany"] forState:UIControlStateNormal];
    [imeiButton addTarget:self action:@selector(scanMachineQRCode) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:imeiButton];
    
    _bandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bandButton.frame = CGRectMake(30 * screenWidth, self.view.frame.size.height - 180 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 100 * screenHeight);
    _bandButton.layer.cornerRadius = 20 * screenWidth;
    [_bandButton setTitle:@"确定" forState:UIControlStateNormal];
    [_bandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bandButton setBackgroundColor:ChangfaColor];
    [_bandButton addTarget:self action:@selector(bindIMEIAndCarBar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bandButton];
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -输入车架号
- (void)putInMachineNumber{
    PutNumberViewController *putVC = [[PutNumberViewController alloc]init];
    putVC.delegate = self;
    [self presentViewController:putVC animated:YES completion:^{
        
    }];
}
- (void)whereIsMachineNumber{
    
}
#pragma mark -弹出扫描界面
- (void)scanMachine{
    ScanViewController *scan = [[ScanViewController alloc]init];
    if ([self.userType isEqualToString:@"worker"]) {
        scan.scanType = @"worker";
    }
    scan.delegate = self;
    [self presentViewController:scan animated:YES completion:^{
        
    }];
}
- (void)scanMachineBarCode{
    ScanViewController *scan = [[ScanViewController alloc]init];
    scan.scanType = @"BarCode";
    scan.delegate = self;
    [self presentViewController:scan animated:YES completion:^{
        
    }];
}
- (void)scanMachineQRCode{
    ScanViewController *scan = [[ScanViewController alloc]init];
    scan.scanType = @"QRCode";
    scan.delegate = self;
    [self presentViewController:scan animated:YES completion:^{
        
    }];
}
#pragma mark -代理扫描实现方法
- (void)scanGetInformation:(MachineModel *)model{
    if ([self.userType isEqualToString:@"worker"]) {
        self.model = model;
        [_machineNumberView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self reloadWorkerMachineNumberView:model];
    } else {
    if ([model.bindType integerValue] == 3) {
        self.imeiTextField.text = model.imei;
        self.model.imei = model.imei;
    } else if ([model.bindType integerValue] == 1) {
        OutputMachineViewController *output = [[OutputMachineViewController alloc]init];
        output.model = model;
        [self.navigationController pushViewController:output animated:YES];
    } else {
        self.model = model;
        self.model.imei = self.imeiTextField.text;
        [_machineNumberView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        if ([self.userType isEqualToString:@"worker"]) {
//
//        } else if ([self.userType isEqualToString:@"company"]) {
            [self reloadCompanyMachineNumberView:model];
            if ([model.bindType intValue] == 1) {
                self.imeiTextField.text = model.imei;
                [self.bandButton setTitle:@"解除IMIEI" forState:UIControlStateNormal];
                [self.bandButton removeTarget:self action:@selector(bindIMEIAndCarBar) forControlEvents:UIControlEventTouchUpInside];
                [self.bandButton addTarget:self action:@selector(relieveIMEIAndCarBar) forControlEvents:UIControlEventTouchUpInside];
            }
            self.carBar = model.productBarCode;
//        }
    }
    }
    
}
// 代理重新布局农机手农机信息
- (void)reloadWorkerMachineNumberView:(MachineModel *)model{
    _machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, 236 * screenWidth, 236 * screenHeight)];
    switch ([model.carType integerValue]) {
        case 1:
            _machineImage.image = [UIImage imageNamed:@"CFTuoLaJi"];
            break;
        case 2:
            _machineImage.image = [UIImage imageNamed:@"CFShouGeJi"];
            break;
        case 3:
            _machineImage.image = [UIImage imageNamed:@"CFChaYangji"];
            break;
        case 4:
            _machineImage.image = [UIImage imageNamed:@"CFHongGanJi"];
            break;
        default:
            break;
    }
    [_machineNumberView addSubview:_machineImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.size.width + _machineImage.frame.origin.x + 30 * screenWidth, 73 * screenHeight, self.view.frame.size.width - 326 * screenWidth, 30 * screenHeight)];
    nameLabel.text = [@"名称：" stringByAppendingString:[NSString stringWithFormat:@"%@",model.productName]];
    nameLabel.font = CFFONT14;
    [_machineNumberView addSubview:nameLabel];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.size.height + nameLabel.frame.origin.y + 30 * screenHeight, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    typeLabel.text = [@"型号：" stringByAppendingString:[NSString stringWithFormat:@"%@",model.productModel]];
    typeLabel.font = CFFONT14;
    [_machineNumberView addSubview:typeLabel];
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, typeLabel.frame.size.height + typeLabel.frame.origin.y + 30 * screenHeight, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    numberLabel.text = [@"车架号："stringByAppendingString:[NSString stringWithFormat:@"%@",model.productBarCode]];
    numberLabel.font = CFFONT14;
    numberLabel.textColor = [UIColor redColor];
    [_machineNumberView addSubview:numberLabel];
}
// 代理重新布局营销公司农机信息
- (void)reloadCompanyMachineNumberView:(MachineModel *)model {
    _machineNumber = [[UILabel alloc]init];
    _machineNumber.frame = CGRectMake(30 * screenWidth, 20 * screenHeight, 400 * screenWidth, 42 * screenHeight);
    _machineNumber.text = @"农机信息";
    _machineNumber.textAlignment = NSTextAlignmentLeft;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(putInMachineNumber)];
    _machineNumber.userInteractionEnabled = YES;
    [_machineNumber addGestureRecognizer:tapGesture];
    [_machineNumberView addSubview:_machineNumber];

    _lineView = [[UIView alloc]initWithFrame:CGRectMake(_machineNumber.frame.origin.x, _machineNumber.frame.size.height + _machineNumber.frame.origin.y + 30 * screenHeight, self.view.frame.size.width - _machineNumber.frame.origin.x * 2, 2 * screenHeight)];
    _lineView.backgroundColor = BackgroundColor;
    [_machineNumberView addSubview:_lineView];
    
    _machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(_machineNumber.frame.origin.x, _lineView.frame.size.height + _lineView.frame.origin.y + 30 * screenHeight, 236 * screenWidth, 236 * screenHeight)];
    switch ([model.carType integerValue]) {
        case 1:
            _machineImage.image = [UIImage imageNamed:@"CFTuoLaJi"];
            break;
        case 2:
            _machineImage.image = [UIImage imageNamed:@"CFShouGeJi"];
            break;
        case 3:
            _machineImage.image = [UIImage imageNamed:@"CFChaYangji"];
            break;
        case 4:
            _machineImage.image = [UIImage imageNamed:@"CFHongGanJi"];
            break;
        default:
            break;
    }
    [_machineNumberView addSubview:_machineImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.size.width + _machineImage.frame.origin.x +30 * screenWidth, 163 * screenHeight, self.view.frame.size.width - 316 * screenWidth, 80 * screenHeight)];
    nameLabel.text = [@"名称：" stringByAppendingString:[NSString stringWithFormat:@"%@",model.productName]];
    nameLabel.font = CFFONT16;
    nameLabel.numberOfLines = 0;
    [_machineNumberView addSubview:nameLabel];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.size.height + nameLabel.frame.origin.y + 40 * screenHeight, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    typeLabel.text = [@"型号：" stringByAppendingString:[NSString stringWithFormat:@"%@",model.productModel]];
    typeLabel.font = CFFONT16;
    [_machineNumberView addSubview:typeLabel];
}
#pragma mark -选择身份
- (void)chooseIdentify{
    [self.view endEditing:YES];
    NSArray *arrayID = [NSArray arrayWithObjects:@"农机手", @"机主", nil];
    _pickView.numberOfComponents = 1;
    _pickView.sourceArray = arrayID;
    self.pickView.selectedInfo = arrayID[0];
    _pickView.frame = CGRectMake(0, self.view.frame.size.height - 528 * screenHeight, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight);
    _vagueView.hidden = NO;

}
- (void)pickViewCancelButtonClick{
    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.pickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.pickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
}
- (void)pickViewsuerButtonClick{
    self.idView.bandTextField.text = self.pickView.selectedInfo;
    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.pickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.pickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
}

#pragma mark -农机手绑定农机
- (void)bandMachine{
    if ([_nameView.bandTextField.text length] < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择身份" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    } else if ([_idView.bandTextField.text length] < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入姓名" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    } else if ([_phoneView.bandTextField.text length] < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入电话号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *identify = @"";
    if (_idView.bandTextField.text.length == 2) {
        identify = @"0";
    } else {
        identify = @"1";
    }
    if ([_model.imei length] > 15) {
        NSDictionary *dic = @{
                               @"carBar":[NSString stringWithFormat:@"%@", _model.productBarCode],
                               @"userTel":[NSString stringWithFormat:@"%@", _phoneView.bandTextField.text],
                               @"userIdentity":[NSString stringWithFormat:@"%@", identify],
                               @"userName":[NSString stringWithFormat:@"%@", _nameView.bandTextField.text],
                               @"note":[NSString stringWithFormat:@"%@", _remarkView.bandTextField.text],
                               };
            dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    } else {
        NSDictionary *dic = @{
                           @"imei":[NSString stringWithFormat:@"%@", _model.imei],
                           @"userTel":[NSString stringWithFormat:@"%@", _phoneView.bandTextField.text],
                           @"userIdentity":[NSString stringWithFormat:@"%@", identify],
                           @"userName":[NSString stringWithFormat:@"%@", _nameView.bandTextField.text],
                           @"note":[NSString stringWithFormat:@"%@", _remarkView.bandTextField.text],
                           };
        dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/bindUserCar" Params:dict Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"绑定成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.delegate bindMachineSuccess];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"bindMachine" object:nil userInfo:nil];
                NSInteger bindNumber = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserBindNum"] integerValue];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", bindNumber + 1] forKey:@"UserBindNum"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark -营销公司绑定/解除IMEI号
// 绑定
- (void)bindIMEIAndCarBar{
    if ([_imeiTextField.text length] < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请获取IMEi" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{

        }];
        return;
    } else if ([self.carBar length] < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请获取农机信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{

        }];
        return;
    }    
    NSDictionary *dict = @{
                           @"imei": self.imeiTextField.text,//
                           @"carBar": self.carBar,
                           @"distributorsID": @"",
                           @"distributorsName": @"",
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/sweepCodeBindings" Params:dict Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            MachineModel *model = self.model;
            model.imei = self.imeiTextField.text;
            CFBindIMEIViewController *bind = [[CFBindIMEIViewController alloc]init];
            bind.model = model;
            [self.navigationController pushViewController:bind animated:YES];
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
// 解除
- (void)relieveIMEIAndCarBar{
    CFRelieveIMEIViewController *relieve = [[CFRelieveIMEIViewController alloc]init];
    relieve.imei = self.imeiTextField.text;
    relieve.carbar = self.carBar;
    [self.navigationController pushViewController:relieve animated:YES];
}
#pragma mark -出库
- (void)outputMachine{
    OutputMachineViewController *output = [[OutputMachineViewController alloc]init];
    [self.navigationController pushViewController:output animated:YES];
}
- (void)bandMachineAccordingNumber:(NSString *)sender{
    self.machineNumber.text = [self.machineNumber.text stringByAppendingString:sender];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect pickViewFrame = self.pickView.frame;
        self.pickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
    self.vagueView.hidden = YES;
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, - 200 * screenHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
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
