//
//  OutputMachineViewController.m
//  ChangFa
//
//  Created by Developer on 2018/1/17.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "OutputMachineViewController.h"
#import "MachinebarTableViewCell.h"
#import "MachineInfoTableViewCell.h"
#import "InfoTableViewCell.h"
#import "PersonModel.h"
#import "MachineModel.h"
#import "AgencyModel.h"
#import "AddressPickerView.h"
#import "CFAFNetWorkingMethod.h"
#import "BindAndOutputView.h"
#import "CFPickViewController.h"
#import "SliderViewController.h"
#import "CFPickView.h"
@interface OutputMachineViewController ()
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIImageView *machineImage;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *typeLabel;
@property (nonatomic, strong)UILabel *barlabel;
@property (nonatomic, strong)UILabel *imeiLabel;
@property (nonatomic, strong)UIButton *addressButton;
@property (nonatomic, strong)UIButton *agencyButton;
@property (nonatomic, strong)UIButton *outputButton;
@property (nonatomic, strong)AddressPickerView *addressPickerView;
@property (nonatomic, strong)AddressPickerView *agencyPickerView;
@property (nonatomic, strong)UIView *vagueView; // 透明层
@property (nonatomic, strong)CFPickViewController *addressPick;
@property (nonatomic, strong)CFPickViewController *agencyPick;
@property (nonatomic, strong)AgencyModel *agencymodel;
@property (nonatomic, strong)CFPickView *areaPickView;
@property (nonatomic, strong)CFPickView *agencyPickView;
@property (nonatomic, strong)NSString *selectedButton;
@end

@implementation OutputMachineViewController
- (UIView *)vagueView{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:_vagueView];
    }
    return _vagueView;
}
- (AddressPickerView *)addressPickerView{
    if (!_addressPickerView) {
        _addressPickerView = [[AddressPickerView alloc]initWithStyle:3];
//        _addressPickerView.delegate = self;
        [_addressPickerView setTitleHeight:50 pickerViewHeight:165];
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _addressPickerView;
}
- (AddressPickerView *)agencyPickerView{
    if (!_agencyPickerView) {
        _agencyPickerView = [[AddressPickerView alloc]initWithStyle:0];
//        _agencyPickerView.delegate = self;
        [_agencyPickerView setTitleHeight:50 pickerViewHeight:165];
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _agencyPickerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"农机出库";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"diangengduo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    self.view.backgroundColor =BackgroundColor;
    [self creatTableView];
    // Do any additional setup after loading the view.
}
- (void)creatTableView{
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1016 * screenHeight) style:UITableViewStylePlain];
//    self.tableView.scrollEnabled = NO;
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];
    self.backView = [[UIView alloc]initWithFrame:self.view.frame];
    self.backView.backgroundColor = BackgroundColor;
    [self.view addSubview:self.backView];
    
    UIView *machineInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width, 538 * screenHeight)];
    machineInfoView.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:machineInfoView];

    _machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(60 * screenWidth, 30 * screenHeight, 236 * screenWidth, 236 * screenHeight)];
    _machineImage.image = [UIImage imageNamed:@"machinePicture"];
    [machineInfoView addSubview:_machineImage];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.size.width + _machineImage.frame.origin.x + 30 * screenWidth, 53 * screenHeight, [UIScreen mainScreen].bounds.size.width - 346 * screenWidth, 100 * screenHeight)];
    _nameLabel.numberOfLines = 2;
    _nameLabel.text = @"名称：";
    _nameLabel.font = CFFONT15;
    [machineInfoView addSubview:_nameLabel];
    _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.size.height + _nameLabel.frame.origin.y + 10 * screenHeight, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
    _typeLabel.text = @"型号：";
    _typeLabel.font = CFFONT15;
    [machineInfoView addSubview:_typeLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, _machineImage.frame.size.height + _machineImage.frame.origin.y + 30 * screenHeight, [UIScreen mainScreen].bounds.size.width - 60 * screenWidth, 2 * screenHeight)];
    lineView.backgroundColor = BackgroundColor;
    [machineInfoView addSubview:lineView];
    
    _imeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.origin.x, lineView.frame.size.height + lineView.frame.origin.y + 40 * screenHeight, [UIScreen mainScreen].bounds.size.width - 120 * screenWidth, 60 * screenHeight)];
    _barlabel = [[UILabel alloc]initWithFrame:CGRectMake(_imeiLabel.frame.origin.x, _imeiLabel.frame.origin.y + _imeiLabel.frame.size.height + 40 * screenHeight, _imeiLabel.frame.size.width, _imeiLabel.frame.size.height)];
    _imeiLabel.text = @"IMEI：";
    _imeiLabel.font = CFFONT15;
    _barlabel.textColor = [UIColor redColor];
    _barlabel.text = @"车架号：";
    _barlabel.font = CFFONT15;
    [machineInfoView addSubview:_imeiLabel];
    [machineInfoView addSubview:_barlabel];
    
    UIButton *relieveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    relieveButton.frame = CGRectMake(_barlabel.frame.size.width - 150 * screenWidth, 0, 150 * screenWidth, _imeiLabel.frame.size.height);
    [relieveButton setTitle:@"解除绑定" forState:UIControlStateNormal];
    [relieveButton setBackgroundColor:ChangfaColor];
    relieveButton.titleLabel.font = CFFONT15;
//    [relieveButton setTitleColor:ChangfaColor forState:UIControlStateNormal];
    [relieveButton addTarget:self action:@selector(relieveIMEIButtonClick) forControlEvents:UIControlEventTouchUpInside];
    relieveButton.layer.cornerRadius = 20 * screenWidth;
    _barlabel.userInteractionEnabled = YES;
    [_barlabel addSubview:relieveButton];
    
    _nameLabel.text = [_nameLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", _model.productName]];
    _typeLabel.text = [_typeLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", _model.productModel]];
    _barlabel.text = [_barlabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", _model.productBarCode]];
    _imeiLabel.text = [_imeiLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", _model.imei]];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.origin.x, machineInfoView.frame.size.height + machineInfoView.frame.origin.y + 50 * screenHeight, 300 * screenWidth, 50 * screenHeight)];
    titleLabel.text = @"出库";
    [self.backView addSubview:titleLabel];
    UIView *address = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.size.height + titleLabel.frame.origin.y + 20 * screenHeight, self.view.frame.size.width, 120 * screenHeight)];
    address.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:address];
    UIView *agency = [[UIView alloc]initWithFrame:CGRectMake(0, address.frame.size.height + address.frame.origin.y + 2 * screenHeight, self.view.frame.size.width, address.frame.size.height)];
    agency.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:agency];
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.origin.x, 30 * screenHeight, 206 * screenWidth, _barlabel.frame.size.height)];
    UILabel *agencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(addressLabel.frame.origin.x, addressLabel.frame.origin.y , addressLabel.frame.size.width, addressLabel.frame.size.height)];
    addressLabel.text = @"地址";
    agencyLabel.text = @"经销商";
    addressLabel.font = CFFONT16;
    agencyLabel.font = CFFONT16;
    self.addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addressButton.frame = CGRectMake(addressLabel.frame.size.width + addressLabel.frame.origin.x, addressLabel.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 326 * screenWidth, addressLabel.frame.size.height);
    self.agencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.agencyButton.frame = CGRectMake(self.addressButton.frame.origin.x, self.addressButton.frame.origin.y, self.addressButton.frame.size.width, self.addressButton.frame.size.height);
    self.addressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.agencyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.addressButton.titleLabel.font = CFFONT16;
    self.agencyButton.titleLabel.font = CFFONT16;
    [self.addressButton setTitle:@"选择地址" forState:UIControlStateNormal];
    [self.agencyButton setTitle:@"选择经销商" forState:UIControlStateNormal];
    [_addressButton addTarget:self action:@selector(getAddressInfo) forControlEvents:UIControlEventTouchUpInside];
    [_agencyButton addTarget:self action:@selector(getAgencyInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.addressButton setTitleColor:BackgroundColor forState:UIControlStateNormal];
    [self.agencyButton setTitleColor:BackgroundColor forState:UIControlStateNormal];
    [address addSubview:addressLabel];
    [agency addSubview:agencyLabel];
    [address addSubview:self.addressButton];
    [agency addSubview:self.agencyButton];
    
    _outputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _outputButton.frame = CGRectMake(30 * screenWidth, self.view.frame.size.height - 180 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 100 * screenHeight);
    _outputButton.layer.cornerRadius = 20 * screenWidth;
    [_outputButton setTitle:@"确定" forState:UIControlStateNormal];
    [_outputButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_outputButton setBackgroundColor:ChangfaColor];
    [_outputButton addTarget:self action:@selector(sureToOutput) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:_outputButton];
    
//    [self.view addSubview:self.addressPickerView];
//    [self.view addSubview:self.agencyPickerView];
    
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
        [self.addressButton setTitle:_areaPickView.selectedInfo forState:UIControlStateNormal];
        [self.addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.agencyButton setTitle:@"选择经销商" forState:UIControlStateNormal];
        [self.agencyButton setTitleColor:BackgroundColor forState:UIControlStateNormal];
    } else {
        [self.agencyButton setTitle:_agencyPickView.selectedInfo forState:UIControlStateNormal];
        [self.agencyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
        self.agencyPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
}

- (void)sureToOutput{
    if ([self.agencyButton.titleLabel.text isEqualToString:@"选择经销商"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择经销商信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    }
    NSDictionary *dict = @{
                           @"imei": self.model.imei,
                           @"carBar": self.model.productBarCode,
                           @"distributorsID": _agencyPickView.agencyModel.distributorsID,
                           @"distributorsName": _agencyPickView.agencyModel.distributorsName,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/sweepCodeOutLibrary" Params:dict Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            BindAndOutputView *output = [[BindAndOutputView alloc]initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width, self.view.frame.size.height - navHeight) ViewStyle:@"outputSuccess"];
            [output.completeButton addTarget:self action:@selector(completeButtonClick) forControlEvents:UIControlEventTouchUpInside];
            output.imageStatus.image = [UIImage imageNamed:@"outputSuccess"];
            output.model = self.model;
            output.agencyModel = self.agencyPickView.agencyModel;
            [self.view addSubview:output];
            self.navigationItem.rightBarButtonItem = nil;
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
- (void)getAddressInfo{
    [self.view endEditing:YES];
    self.selectedButton = @"address";
    _areaPickView.numberOfComponents = 2;
    _areaPickView.style = 1;
    _areaPickView.frame = CGRectMake(0, self.view.frame.size.height - 528 * screenHeight, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight);
    _vagueView.hidden = NO;
    return;
}
- (void)getAgencyInfo{
    NSLog(@"%@", _areaPickView.areaID);
//    if (_addressPick.provinceID.length < 1 || _addressPick.cityID.length < 1 || _addressPick.districtID.length < 1) {
    if ([_addressButton.titleLabel.text isEqualToString:@"选择地址"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择地址" preferredStyle:UIAlertControllerStyleAlert];
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
//    _agencyPick = [[CFPickViewController alloc]initWithProvinceID:_addressPick.provinceID CityID:_addressPick.cityID districtID:_addressPick.districtID];
//    _agencyPick.cancelButton.tag = 2001;
//    _agencyPick.sureButton.tag = 2002;
//    [_agencyPick.cancelButton addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_agencyPick.sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addChildViewController:_agencyPick];
//    [self.view addSubview:_agencyPick.view];
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
                [self.addressButton setTitle:[[_addressPick.province stringByAppendingString:_addressPick.city] stringByAppendingString:_addressPick.district]  forState:UIControlStateNormal];
                [self.addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        //    [UIView animateWithDuration:0.5 animations:^{
        self.addressPick.view.hidden = YES;
        //    }];
    } else {
        self.agencymodel = _agencyPick.agencyModel;
        [self.agencyButton setTitle:_agencyPick.agencyModel.distributorsName forState:UIControlStateNormal];
        [self.agencyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.agencyPick.view.hidden = YES;
    }

}
- (void)sureBtnClickReturnProvince:(NSString *)province
                              City:(NSString *)city
                              Area:(NSString *)area {
    [_addressButton setTitle:[[province stringByAppendingString:city] stringByAppendingString:area] forState:UIControlStateNormal];
    [_addressPickerView hide];
    [_agencyPickerView hide];
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.frame = [UIScreen mainScreen].bounds;
    }];
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
//- (void)rightButtonClick{
//    self.vagueView.hidden = NO;
//    UIButton *relieveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    relieveButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 245 * screenHeight, [UIScreen mainScreen].bounds.size.width, 120 * screenHeight);
//    [relieveButton setBackgroundColor:[UIColor whiteColor]];
//    [relieveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [relieveButton setTitle:@"解除绑定IMEI号" forState:UIControlStateNormal];
//    [relieveButton addTarget:self action:@selector(relieveIMEIButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.vagueView addSubview:relieveButton];
//    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelButton.frame = CGRectMake(0, relieveButton.frame.size.height + relieveButton.frame.origin.y + 5 * screenHeight, [UIScreen mainScreen].bounds.size.width, 120 * screenHeight);
//    [cancelButton setBackgroundColor:[UIColor whiteColor]];
//    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(cancelRelieve) forControlEvents:UIControlEventTouchUpInside];
//    [self.vagueView addSubview:cancelButton];
//}
- (void)relieveIMEIButtonClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定解除IMEI号吗" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self relieveIMEI];
    }];
    [sureAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
- (void)relieveIMEI{
    NSDictionary *dict = @{
                           @"imei":self.model.imei,
                           @"carBar":self.model.productBarCode,
                           };
     NSLog(@"%@", _model.bindType);
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/removeBindings" Params:dict Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            for (UIViewController *viewController in self.navigationController.childViewControllers) {
                if ([viewController isKindOfClass:[SliderViewController class]]) {
                    [self.navigationController popToViewController:viewController animated:YES];
                    return;
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self cancelRelieve];
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
- (void)cancelRelieve{
    self.vagueView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setModel:(MachineModel *)model{
    _model = model;
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
    _nameLabel.text = [_nameLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", model.productName]];
    _typeLabel.text = [_typeLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", model.productModel]];
    _barlabel.text = [_barlabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", model.productBarCode]];
    _imeiLabel.text = [_imeiLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", model.imei]];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = [UIScreen mainScreen].bounds;
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
        self.agencyPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
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
