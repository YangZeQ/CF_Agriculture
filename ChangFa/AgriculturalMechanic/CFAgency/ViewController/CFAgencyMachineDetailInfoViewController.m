//
//  CFAgencyMachineDetailInfoViewController.m
//  ChangFa
//
//  Created by Developer on 2018/1/25.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAgencyMachineDetailInfoViewController.h"

@interface CFAgencyMachineDetailInfoViewController ()
@property (nonatomic, strong)UILabel *machineNameLabel;
@property (nonatomic, strong)UILabel *machineTypeLabel;
@property (nonatomic, strong)UILabel *machineNumberLabel;
@property (nonatomic, strong)UILabel *outputLabel;
@property (nonatomic, strong)UILabel *putinLabel;
@property (nonatomic, strong)UILabel *selledLabel;
@property (nonatomic, strong)UILabel *userNameLabel;
@property (nonatomic, strong)UILabel *userPhoneLabel;
@property (nonatomic, strong)MachineModel *model;
@end

@implementation CFAgencyMachineDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"农机详情";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.view.backgroundColor = BackgroundColor;
    
    [self createMachineDetailInfoView];
    // Do any additional setup after loading the view.
}
- (void)createMachineDetailInfoView{
    if ([self.viewType isEqualToString:@"sold"]) {
        [self selledMachineInfoView];
        [self getAgencyMachineDetailInfo];
    } else {
        [self unselledMachineInfoView];
        [self getAgencyMachineDetailInfo];
    }
}
- (void)unselledMachineInfoView{
    UIView *machineBackView = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight + 30 * screenHeight, self.view.frame.size.width, 300 * screenHeight)];              
    machineBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:machineBackView];
    
    UIImageView *machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(60 * screenWidth, 50 * screenHeight, 200 * screenWidth, 200 * screenHeight)];
    switch ([_machineModel.carType integerValue]) {
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
    [machineBackView addSubview:machineImage];
    _machineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.size.width + machineImage.frame.origin.x + 30 * screenWidth, 45 * screenHeight, self.view.frame.size.width - 340 * screenWidth, 50 * screenHeight)];
    _machineNameLabel.text = [NSString stringWithFormat:@"名称：%@", _machineModel.productName];
    _machineNameLabel.font = CFFONT15;
    [machineBackView addSubview:_machineNameLabel];
    _machineTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineNameLabel.frame.origin.x, _machineNameLabel.frame.size.height + _machineNameLabel.frame.origin.y + 30 * screenHeight, _machineNameLabel.frame.size.width, _machineNameLabel.frame.size.height)];
    _machineTypeLabel.text = [NSString stringWithFormat:@"型号：%@", _machineModel.productModel];
    _machineTypeLabel.font = CFFONT15;
    [machineBackView addSubview:_machineTypeLabel];
    _machineNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineNameLabel.frame.origin.x, _machineTypeLabel.frame.size.height + _machineTypeLabel.frame.origin.y + 30 * screenHeight, _machineNameLabel.frame.size.width, _machineNameLabel.frame.size.height)];
    _machineNumberLabel.text = [NSString stringWithFormat:@"车架号：%@", _machineModel.productBarCode];
    _machineNumberLabel.textColor = [UIColor redColor];
    _machineNumberLabel.font = CFFONT15;
    [machineBackView addSubview:_machineNumberLabel];
    
    UIView *userBackView = [[UIView alloc]initWithFrame:CGRectMake(0, machineBackView.frame.size.height + machineBackView.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 200 * screenHeight)];
    userBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userBackView];
    
    _outputLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.origin.x, 40 * screenHeight, self.view.frame.size.width - 120 * screenWidth, _machineNameLabel.frame.size.height)];
    _outputLabel.text = [NSString stringWithFormat:@"发往时间：%@", _machineModel.outDate];
//    _outputLabel.font = CFFONT15;
    [userBackView addSubview:_outputLabel];
    _putinLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.origin.x, _outputLabel.frame.size.height + _outputLabel.frame.origin.y + 30 * screenHeight, _outputLabel.frame.size.width, _machineNameLabel.frame.size.height)];
    _putinLabel.text = [NSString stringWithFormat:@"入库时间：%@", _machineModel.inputDate];
//    _outputLabel.font = CFFONT15;
    [userBackView addSubview:_putinLabel];
}
- (void)selledMachineInfoView{
    UIView *machineBackView = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight + 30 * screenHeight, self.view.frame.size.width, 300 * screenHeight)];
    machineBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:machineBackView];
    
    UIImageView *machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(60 * screenWidth, 30 * screenHeight, 240 * screenWidth, 240 * screenHeight)];
    switch ([_machineModel.carType integerValue]) {
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
    [machineBackView addSubview:machineImage];
    _machineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.size.width + machineImage.frame.origin.x + 30 * screenWidth, 45 * screenHeight, self.view.frame.size.width - 390 * screenWidth, 50 * screenHeight)];
    _machineNameLabel.text = [NSString stringWithFormat:@"名称：%@", _machineModel.productName];
    _machineNameLabel.font = CFFONT15;
    [machineBackView addSubview:_machineNameLabel];
    _machineTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineNameLabel.frame.origin.x, _machineNameLabel.frame.size.height + _machineNameLabel.frame.origin.y + 30 * screenHeight, _machineNameLabel.frame.size.width, _machineNameLabel.frame.size.height)];
    _machineTypeLabel.text = [NSString stringWithFormat:@"型号：%@", _machineModel.productModel];
    _machineTypeLabel.font = CFFONT15;
    [machineBackView addSubview:_machineTypeLabel];
    _machineNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineNameLabel.frame.origin.x, _machineTypeLabel.frame.size.height + _machineTypeLabel.frame.origin.y + 30 * screenHeight, _machineNameLabel.frame.size.width, _machineNameLabel.frame.size.height)];
    _machineNumberLabel.text = [NSString stringWithFormat:@"车架号：%@", _machineModel.productBarCode];
    _machineNumberLabel.textColor = [UIColor redColor];
    _machineNumberLabel.font = CFFONT15;
    [machineBackView addSubview:_machineNumberLabel];
    
    
    UIView *userBackView = [[UIView alloc]initWithFrame:CGRectMake(0, machineBackView.frame.size.height + machineBackView.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 450 * screenHeight)];
    userBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userBackView];
    
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.origin.x, 40 * screenHeight, self.view.frame.size.width - 170 * screenWidth, _machineNameLabel.frame.size.height)];
    _userNameLabel.text = [NSString stringWithFormat:@"用户姓名：%@", _machineModel.name];
    [userBackView addSubview:_userNameLabel];
    _userPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.origin.x, _userNameLabel.frame.size.height + _userNameLabel.frame.origin.y + 30 * screenHeight, _userNameLabel.frame.size.width, _machineNameLabel.frame.size.height)];
    _userPhoneLabel.text = [NSString stringWithFormat:@"用户电话：%@", _machineModel.tel];
    [userBackView addSubview:_userPhoneLabel];
    UIButton *userPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userPhoneButton.frame = CGRectMake(_userNameLabel.frame.size.width + _userNameLabel.frame.origin.x, 66 * screenHeight, 50 * screenWidth, 50 * screenHeight);
    [userPhoneButton setBackgroundImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];
    [userPhoneButton addTarget:self action:@selector(callTheUser) forControlEvents:UIControlEventTouchUpInside];
    [userBackView addSubview:userPhoneButton];
    
    _outputLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.origin.x, _userPhoneLabel.frame.size.height + _userPhoneLabel.frame.origin.y + 50 * screenHeight, _userNameLabel.frame.size.width, _machineNameLabel.frame.size.height)];
    _outputLabel.font = [UIFont systemFontOfSize:[self autoScaleW:13]];
    _outputLabel.text = [NSString stringWithFormat:@"发往时间：%@", _machineModel.outDate];
    [userBackView addSubview:_outputLabel];
    _putinLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.origin.x, _outputLabel.frame.size.height + _outputLabel.frame.origin.y + 20 * screenHeight, _userNameLabel.frame.size.width, _machineNameLabel.frame.size.height)];
    _putinLabel.font = [UIFont systemFontOfSize:[self autoScaleW:13]];
    _putinLabel.text = [NSString stringWithFormat:@"入库时间：%@", _machineModel.inputDate];
    [userBackView addSubview:_putinLabel];
    _selledLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.origin.x, _putinLabel.frame.size.height + _putinLabel.frame.origin.y + 20 * screenHeight, _userNameLabel.frame.size.width, _machineNameLabel.frame.size.height)];
    _selledLabel.font = [UIFont systemFontOfSize:[self autoScaleW:13]];
    _selledLabel.text = [NSString stringWithFormat:@"售出时间：%@", _machineModel.saleDate];
    [userBackView addSubview:_selledLabel];
}
- (void)getAgencyMachineDetailInfo{
    NSDictionary *dict = @{
                           @"imei":self.machineModel.imei,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/getStockCarInfo?" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"machine%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            self.model = [MachineModel machineModelWithDictionary:[responseObject objectForKey:@"body"]];
            [self setMachineInfo];
        } else {
            _userNameLabel.text = [NSString stringWithFormat:@"用户姓名：%@", @""];
            _userPhoneLabel.text = [NSString stringWithFormat:@"用户电话：%@", @""];
            _outputLabel.text = [NSString stringWithFormat:@"发往时间：%@", @""];
            _putinLabel.text = [NSString stringWithFormat:@"入库时间：%@", @""];
            _selledLabel.text = [NSString stringWithFormat:@"售出时间：%@", @""];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[[responseObject objectForKey:@"head"]objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        _userNameLabel.text = [NSString stringWithFormat:@"用户姓名：%@", @""];
        _userPhoneLabel.text = [NSString stringWithFormat:@"用户电话：%@", @""];
        _outputLabel.text = [NSString stringWithFormat:@"发往时间：%@", @""];
        _putinLabel.text = [NSString stringWithFormat:@"入库时间：%@", @""];
        _selledLabel.text = [NSString stringWithFormat:@"售出时间：%@", @""];
    }];
}
- (void)setMachineInfo{
    _userNameLabel.text = [NSString stringWithFormat:@"用户姓名：%@", _model.name];
    _userPhoneLabel.text = [NSString stringWithFormat:@"用户电话：%@", _model.tel];
    _outputLabel.text = [NSString stringWithFormat:@"发往时间：%@", _model.outDate];
    _outputLabel.text = [[_outputLabel.text stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:24];
    _putinLabel.text = [NSString stringWithFormat:@"入库时间：%@", _model.inputDate];
    _putinLabel.text = [[_putinLabel.text stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:24];
    _selledLabel.text = [NSString stringWithFormat:@"售出时间：%@", _model.saleDate];
    _selledLabel.text = [[_selledLabel.text stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:24];
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)callTheUser{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@", _model.tel];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (void)setPersonModel:(PersonModel *)personModel{
    
}
- (void)setMachineModel:(MachineModel *)machineModel{
    _machineModel = machineModel;
    _machineNameLabel.text = [_machineNameLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", machineModel.productName]];
    _machineTypeLabel.text = [_machineTypeLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", machineModel.productModel]];
    _machineNumberLabel.text = [_machineNumberLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", machineModel.productBarCode]];
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
