//
//  CFAgencyExchangeViewController.m
//  ChangFa
//
//  Created by Developer on 2018/2/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAgencyExchangeViewController.h"
#import "CFAgencyEXchangeStatusViewController.h"
#import "ScanViewController.h"
#import "CFPickViewController.h"
#import "CFPickView.h"
#import "MachineModel.h"
#import "AgencyModel.h"
@interface CFAgencyExchangeViewController ()<scanViewControllerDelegate>
@property (nonatomic, strong)UIView *machineNumberView;
@property (nonatomic, strong)UILabel *machineNumber;
@property (nonatomic, strong)UIView *lineView;

@property (nonatomic, strong)UIView *retreatReasonView;
@property (nonatomic, strong)UIButton *placeButton;
@property (nonatomic, strong)UIButton *agencyButton;
@property (nonatomic, strong)UIView *agencyView;
@property (nonatomic, strong)UILabel *agencyName;
@property (nonatomic, strong)UILabel *agencyPhone;
@property (nonatomic, strong)MachineModel *model;
@property (nonatomic, strong)AgencyModel *agencyModel;
@property (nonatomic, strong)CFPickViewController *addressPick;
@property (nonatomic, strong)CFPickViewController *agencyPick;
@property (nonatomic, strong)CFPickView *areaPickView;
@property (nonatomic, strong)CFPickView *agencyPickView;
@property (nonatomic, strong)NSString *selectedButton;
@property (nonatomic, strong)UIView *vagueView; // 透明层

@property (nonatomic, assign)NSInteger sign;
@end

@implementation CFAgencyExchangeViewController
- (UIView *)vagueView{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:_vagueView];
    }
    return _vagueView;
}
- (UIView *)agencyView{
    if (_agencyView == nil) {
        _agencyView.backgroundColor = [UIColor redColor];
        _agencyView = [[UIView alloc]initWithFrame:CGRectMake(0, _retreatReasonView.frame.size.height + _retreatReasonView.frame.origin.y, self.view.frame.size.width, 170 * screenHeight)];
        _agencyName = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 10 * screenHeight, _retreatReasonView.frame.size.width - 60 * screenWidth, 50 * screenHeight)];
        _agencyName.text = @"经销商：";
        _agencyPhone = [[UILabel alloc]initWithFrame:CGRectMake(_agencyName.frame.origin.x, _agencyName.frame.size.height + _agencyName.frame.origin.y + 20 * screenHeight, _agencyName.frame.size.width, _agencyName.frame.size.height)];
        _agencyPhone.text = @"电话：";
        [_agencyView addSubview:_agencyName];
        [_agencyView addSubview:_agencyPhone];
        [self.view addSubview:_agencyView];
    }
    return _agencyView;
}
- (CFPickViewController *)agencyPick{
    if (_agencyPick == nil) {
        _agencyPick = [[CFPickViewController alloc]initWithProvinceID:_addressPick.provinceID CityID:_addressPick.cityID districtID:_addressPick.districtID];
        _agencyPick.cancelButton.tag = 2001;
        _agencyPick.sureButton.tag = 2002;
        [_agencyPick.cancelButton addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_agencyPick.sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addChildViewController:_agencyPick];
        [self.view addSubview:_agencyPick.view];
    }
    return _agencyPick;
}
- (CFPickViewController *)addressPick{
    if (_addressPick == nil) {
        _addressPick = [[CFPickViewController alloc]initWithType:@"address"];
        _addressPick.cancelButton.tag = 1001;
        _addressPick.sureButton.tag = 1002;
        [_addressPick.cancelButton addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addressPick.sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addChildViewController:_addressPick];
        [self.view addSubview:_addressPick.view];
    }
    return _addressPick;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"调拨";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"申请记录" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    //    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.view.backgroundColor = BackgroundColor;
    // Do any additional setup after loading the view.
    [self createRetreatView];
    _sign = 1;
}
- (void)createRetreatView{
    [self scanViewWithText:@"农机信息" Place:nil ScanText:@"农机扫码" ScanImage:@"scanCompany" ViewFrame:CGRectMake(0, navHeight, self.view.frame.size.width, 338 * screenHeight) ScanButtonFrame:CGRectMake(self.view.frame.size.width / 2 - 49 * screenWidth, 130 * screenHeight, 98 * screenWidth, 98 * screenHeight) ScanType:@"scanMachineBarCode"];
    
    _retreatReasonView = [[UIView alloc]initWithFrame:CGRectMake(0, _machineNumberView.frame.size.height + _machineNumberView.frame.origin.y + 20 * screenHeight, self.view.frame.size.width, 288 * screenHeight)];
    _retreatReasonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_retreatReasonView];
    
    UILabel *exchangeAgency = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 0, self.view.frame.size.width - 60 * screenWidth, 88 * screenHeight)];
    exchangeAgency.text = @"调拨的经销商";
    [_retreatReasonView addSubview:exchangeAgency];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 87 * screenHeight, exchangeAgency.frame.size.width, screenHeight)];
    lineLabel.backgroundColor = BackgroundColor;
    [exchangeAgency addSubview:lineLabel];
    
    _placeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _placeButton.frame = CGRectMake(0, exchangeAgency.frame.size.height + exchangeAgency.frame.origin.y + 50 * screenHeight, self.view.frame.size.width, 50 * screenHeight);
    _placeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _placeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 30 * screenWidth, 0, 0);
    [_placeButton setTitle:@"请选择经销商所在地" forState:UIControlStateNormal];
    _placeButton.titleLabel.font = CFFONT16;
    [_placeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_placeButton addTarget:self action:@selector(selectedAgencyPlace) forControlEvents:UIControlEventTouchUpInside];
    [_retreatReasonView addSubview:_placeButton];
    UIButton *selectPlace = [UIButton buttonWithType:UIButtonTypeCustom];
    selectPlace.frame = CGRectMake(self.view.frame.size.width - 60 * screenWidth, 10 * screenHeight, 20 * screenWidth, 30 * screenHeight);
    [selectPlace setBackgroundImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
    [selectPlace addTarget:self action:@selector(selectedAgencyPlace) forControlEvents:UIControlEventTouchUpInside];
    [_placeButton addSubview:selectPlace];
    
    _agencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _agencyButton.frame = CGRectMake(0, _placeButton.frame.size.height + _placeButton.frame.origin.y + 30 * screenHeight, _placeButton.frame.size.width, _placeButton.frame.size.height);
    _agencyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _agencyButton.contentEdgeInsets = UIEdgeInsetsMake(0, 30 * screenWidth, 0, 0);
    [_agencyButton setTitle:@"请选择经销商" forState:UIControlStateNormal];
    _agencyButton.titleLabel.font = CFFONT16;
    [_agencyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_agencyButton addTarget:self action:@selector(selectedAgency) forControlEvents:UIControlEventTouchUpInside];
    [_retreatReasonView addSubview:_agencyButton];
    UIButton *selectAgency = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAgency.frame = CGRectMake(self.view.frame.size.width - 60 * screenWidth, 10 * screenHeight, 20 * screenWidth, 30 * screenHeight);
    [selectAgency setBackgroundImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
    [selectAgency addTarget:self action:@selector(selectedAgency) forControlEvents:UIControlEventTouchUpInside];
    [_agencyButton addSubview:selectAgency];
    self.agencyView.hidden = YES;
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(30 * screenWidth, self.view.frame.size.height - 130 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 100 * screenHeight);
    submitButton.layer.cornerRadius = 20 * Width;
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setBackgroundColor:ChangfaColor];
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    _areaPickView = [[CFPickView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight)];
    self.vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.areaPickView.cancelButton addTarget:self action:@selector(pickViewCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.areaPickView.sureButton addTarget:self action:@selector(pickViewsuerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _vagueView.hidden = YES;
    _agencyPickView = [[CFPickView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight)];
    [self.agencyPickView.cancelButton addTarget:self action:@selector(pickViewCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.agencyPickView.sureButton addTarget:self action:@selector(pickViewsuerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_vagueView];
    [self.view addSubview:_areaPickView];
    [self.view addSubview:_agencyPickView];
}
- (void)pickViewCancelButtonClick{
    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
        self.agencyPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
}
- (void)pickViewsuerButtonClick{
    if ([self.selectedButton isEqualToString:@"address"]) {
        [self.placeButton setTitle:_areaPickView.selectedInfo forState:UIControlStateNormal];
        [self.placeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.agencyButton setTitle:@"选择经销商" forState:UIControlStateNormal];
        [self.agencyButton setTitleColor:BackgroundColor forState:UIControlStateNormal];
    } else {
        [self.agencyButton setTitle:_agencyPickView.selectedInfo forState:UIControlStateNormal];
        [self.agencyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _agencyName.text = [@"经销商：" stringByAppendingString:[NSString stringWithFormat:@"%@", _agencyPickView.agencyModel.contact]];
        _agencyPhone.text = [@"电话：" stringByAppendingString:[NSString stringWithFormat:@"%@", _agencyPickView.agencyModel.tel]];
        self.agencyView.hidden = NO;
    }

    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
        self.agencyPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
}

- (void)submitButtonClick{
    if (self.model.imei.length < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请获取农机信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    } else if ([self.agencyButton.titleLabel.text isEqualToString:@"选择经销商"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选取经销商" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定调拨" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    //    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
    //    [alertControllerStr addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 2)];
    //    [alert setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self submitRetreatRequest];
    }];
    [sureAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
- (void)scanViewWithText:(NSString *)text
                   Place:(NSString *)place
                ScanText:(NSString *)scanText
               ScanImage:(NSString *)scanImage
               ViewFrame:(CGRect)viewFrame
         ScanButtonFrame:(CGRect)scanButtonFrame
                ScanType:(NSString *)scanType{
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
    
    UILabel *scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, scanButton.frame.size.height + scanButton.frame.origin.y + 40 * screenHeight, self.view.frame.size.width, 26 * screenHeight)];
    scanLabel.text = scanText;
    scanLabel.font = CFFONT16;
    scanLabel.textAlignment = NSTextAlignmentCenter;
    [_machineNumberView addSubview:scanLabel];
    
}
- (void)scanMachine{
    ScanViewController *scan = [[ScanViewController alloc]init];
    scan.delegate = self;
    [self presentViewController:scan animated:YES completion:^{
        
    }];
}
- (void)scanGetInformation:(MachineModel *)model{
    self.model = model;
    [self reloadMachineNumberView:model];
}
- (void)reloadMachineNumberView:(MachineModel *)model {
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,_lineView.frame.size.height + _lineView.frame.origin.y, self.view.frame.size.width, _machineNumberView.frame.size.height - _lineView.frame.size.height - _lineView.frame.origin.y)];
    backView.backgroundColor = [UIColor whiteColor];
    [_machineNumberView addSubview:backView];
    UIImageView *machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, 190 * screenWidth, 190 * screenHeight)];
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
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.size.width + machineImage.frame.origin.x + 30 * screenWidth, machineImage.frame.origin.y, self.view.frame.size.width - (machineImage.frame.size.width + machineImage.frame.origin.x + 60 * screenWidth), 50 * screenHeight)];
    nameLabel.text = [@"名称：" stringByAppendingString:[NSString stringWithFormat:@"%@",model.productName]];
    nameLabel.font = CFFONT14;
    [backView addSubview:nameLabel];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.size.height + nameLabel.frame.origin.y + 20 * screenHeight, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    typeLabel.text = [@"型号：" stringByAppendingString:[NSString stringWithFormat:@"%@",model.productModel]];
    typeLabel.font = CFFONT14;
    [backView addSubview:typeLabel];
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, typeLabel.frame.size.height + typeLabel.frame.origin.y + 20 * screenHeight, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    numberLabel.text = [@"车架号："stringByAppendingString:[NSString stringWithFormat:@"%@",model.productBarCode]];
    numberLabel.font = CFFONT14;
    numberLabel.textColor = [UIColor redColor];
    [backView addSubview:numberLabel];
    
}
- (void)selectedAgencyPlace{
    [self.view endEditing:YES];
    self.selectedButton = @"address";
    _areaPickView.style = 1;
    _areaPickView.numberOfComponents = 2;
    _areaPickView.frame = CGRectMake(0, self.view.frame.size.height - 528 * screenHeight, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight);
    _vagueView.hidden = NO;
//    self.addressPick.view.hidden = NO;
}
- (void)cancelBtnClick:(UIButton *)sender{
    if (sender.tag == 1001) {
        self.addressPick.view.hidden = YES;
    } else {
        self.agencyPick.view.hidden = YES;
    }
}
- (void)sureButtonClick:(UIButton *)sender{
    if (sender.tag == 1002) {
        if (_addressPick.province.length > 0) {
            if (_addressPick.city.length < 1) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择所属市" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:alertAction];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            } else if (_addressPick.district.length < 1) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择所属区" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:alertAction];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            } else {
                [self.placeButton setTitle:[[_addressPick.province stringByAppendingString:_addressPick.city] stringByAppendingString:_addressPick.district]  forState:UIControlStateNormal];
                [self.placeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        //    [UIView animateWithDuration:0.5 animations:^{
        self.addressPick.view.hidden = YES;
        //    }];
    } else {
        self.agencyModel = _agencyPick.agencyModel;
        [self.agencyButton setTitle:_agencyModel.distributorsName forState:UIControlStateNormal];
        _agencyName.text = [@"经销商：" stringByAppendingString:[NSString stringWithFormat:@"%@", _agencyPick.agencyModel.contact]];
        _agencyPhone.text = [@"电话：" stringByAppendingString:[NSString stringWithFormat:@"%@", _agencyPick.agencyModel.tel]];
        self.agencyPick.view.hidden = YES;
        self.agencyView.hidden = NO;
    }
    
}
- (void)selectedAgency{
    if ([_placeButton.titleLabel.text isEqualToString:@"请选择经销商所在地"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择经销商所在地" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return ;
    }
    self.selectedButton = @"agency";
    _agencyPickView.provinceID = _areaPickView.provinceID;
    _agencyPickView.cityID = _areaPickView.cityID;
    _agencyPickView.areaID = @"";
    _agencyPickView.style = 2;
    _agencyPickView.numberOfComponents = 1;
    _agencyPickView.frame = CGRectMake(0, self.view.frame.size.height - 528 * screenHeight, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight);
    _vagueView.hidden = NO;
//    self.agencyPick.view.hidden = NO;
}
- (void)submitRetreatRequest{
    NSDictionary *dict = @{
                           @"imei":_model.imei,
                           @"returnReason":@"",
                           @"returnNote":@"",
                           @"belongsDistributorsID":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDistributorId"],
                           @"distributorsID":self.agencyPickView.agencyModel.distributorsID,
                           @"distributorsName":self.agencyPickView.agencyModel.distributorsName,
                           @"distributorsContact":self.agencyPickView.agencyModel.contact,
                           @"distributorsTel":self.agencyPickView.agencyModel.tel,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/applyAllocation" Params:dict Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            CFAgencyEXchangeStatusViewController *retreatStatus = [[CFAgencyEXchangeStatusViewController alloc]initWithSubmitTime:[formatter stringFromDate:[NSDate date]]];
//            retreatStatus.model = self.model;
//            retreatStatus.agencyModel = self.agencyModel;
            [self.navigationController pushViewController:retreatStatus animated:YES];
            
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[[responseObject objectForKey:@"head"]objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
        self.agencyPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
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
