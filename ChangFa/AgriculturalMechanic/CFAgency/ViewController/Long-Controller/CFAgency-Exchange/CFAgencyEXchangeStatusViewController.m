//
//  CFAgencyEXchangeStatusViewController.m
//  ChangFa
//
//  Created by Developer on 2018/2/7.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAgencyEXchangeStatusViewController.h"
#import "CFAgencyManagerViewController.h"
#import "SliderViewController.h"
@interface CFAgencyEXchangeStatusViewController ()
@property (nonatomic, strong)UIScrollView *retreatScrollView;
@property (nonatomic, strong)UILabel *timelabel;
@property (nonatomic, strong)UIView *vagueView;
@end

@implementation CFAgencyEXchangeStatusViewController
- (UIView *)vagueView{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _vagueView.hidden = YES;
        [self.view addSubview:_vagueView];
    }
    return _vagueView;
}
- (instancetype)initWithSubmitTime:(NSString *)time{
    if (self = [super init]) {
        self.submitTime = time;
    }
    return self;
}
- (instancetype)initWithModel:(MachineModel *)model{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}
- (void)backToRootControllerViewWithTime:(NSString *)time{
    UIImageView *statusImage = [[UIImageView alloc]initWithFrame:CGRectMake(60 * screenWidth, 60 * screenHeight + navHeight, 50 * screenWidth, 300 * screenHeight)];
    statusImage.image = [UIImage imageNamed:@"Exchange_Checking"];
    [self.view addSubview:statusImage];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(statusImage.frame.size.width + statusImage.frame.origin.x + 60 * screenWidth, statusImage.frame.origin.y, self.view.frame.size.width - 200 * screenWidth, 50 * screenHeight)];
    titleLabel.text = @"审核中";
    [self.view addSubview:titleLabel];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 20 * screenHeight, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    textLabel.text = @"返厂请求提交成功，等待后台审核";
    textLabel.font = CFFONT16;
    [self.view addSubview:textLabel];
    
    UILabel *timelabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, textLabel.frame.origin.y + textLabel.frame.size.height + 20 * screenHeight, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    timelabel.font = CFFONT14;
    timelabel.text = time;
    timelabel.textColor = [UIColor grayColor];
    [self.view addSubview:timelabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(30 * screenWidth, self.view.frame.size.height - 130 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 100 * screenHeight);
    backButton.layer.cornerRadius = 20 * Width;
    [backButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setBackgroundColor:ChangfaColor];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}
- (void)backButtonClick{
    for (UIViewController *viewController in self.navigationController.childViewControllers) {
        if ([viewController isKindOfClass:[SliderViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"调拨申请";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"申请记录" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    //    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BackgroundColor;
    if (self.submitTime.length > 1) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self backToRootControllerViewWithTime:self.submitTime];
    } else {
        self.view.backgroundColor = BackgroundColor;
        [self createRetreatStatusView];
    }
    
}
- (void)createRetreatStatusView{
    self.retreatScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.retreatScrollView.showsVerticalScrollIndicator = YES;
    self.retreatScrollView.showsHorizontalScrollIndicator = NO;
//    self.retreatScrollView.pagingEnabled = YES;
    self.retreatScrollView.bounces = NO;
    //    self.retreatScrollView.scrollEnabled = NO;
//    self.retreatScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1701 * screenHeight);
    [self.view addSubview:self.retreatScrollView];
    
    
    UIView *statiusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 495 * screenHeight)];
    statiusView.backgroundColor = [UIColor whiteColor];
    [self.retreatScrollView addSubview:statiusView];
    
    UIImageView *statusImage = [[UIImageView alloc]initWithFrame:CGRectMake(60 * screenWidth, 60 * screenHeight, 50 * screenWidth, 300 * screenHeight)];
    statusImage.image = [UIImage imageNamed:@"Exchange_Checking"];
    [statiusView addSubview:statusImage];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(statusImage.frame.size.width + statusImage.frame.origin.x + 60 * screenWidth, statusImage.frame.origin.y, self.view.frame.size.width - 200 * screenWidth, 50 * screenHeight)];
    titleLabel.text = @"审核中";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [statiusView addSubview:titleLabel];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10 * screenHeight, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    textLabel.text = @"调拨请求提交成功，等待后台审核";
    textLabel.textColor = [UIColor darkGrayColor];
    textLabel.font = CFFONT15;
    [statiusView addSubview:textLabel];
    
    UILabel *timelabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, textLabel.frame.origin.y + textLabel.frame.size.height + 10 * screenHeight, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    timelabel.font = CFFONT14;
    timelabel.text = [[_model.apply_time substringWithRange:NSMakeRange(0, 19)] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    timelabel.textColor = [UIColor lightGrayColor];
    [statiusView addSubview:timelabel];
    
    UILabel *titleStastusLabel = [[UILabel alloc]initWithFrame:CGRectMake(statusImage.frame.size.width + statusImage.frame.origin.x + 60 * screenWidth, statusImage.frame.origin.y + 250 * screenHeight, self.view.frame.size.width - 200 * screenWidth, 50 * screenHeight)];
    titleStastusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [statiusView addSubview:titleStastusLabel];
    
    UILabel *textStastusLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleStastusLabel.frame.origin.y + titleStastusLabel.frame.size.height + 10 * screenHeight, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    textStastusLabel.textColor = [UIColor darkGrayColor];
    textStastusLabel.font = CFFONT15;
    [statiusView addSubview:textStastusLabel];
    
    UILabel *timeStastuslabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, textStastusLabel.frame.origin.y + textStastusLabel.frame.size.height + 10 * screenHeight, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    timeStastuslabel.font = CFFONT14;
    timeStastuslabel.textColor = [UIColor lightGrayColor];
    [statiusView addSubview:timeStastuslabel];
    switch ([_model.apply_state integerValue]) {
        case 0:
            statusImage.image = [UIImage imageNamed:@"Exchange_Checking"];
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"diangengduo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消申请" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
            [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
            break;
        case 1:
            statusImage.image = [UIImage imageNamed:@"Exchange_CheckSuccess"];
            titleStastusLabel.text = @"通过";
            textStastusLabel.text = @"调拨请求已通过";
            timeStastuslabel.text = [[_model.checkDate substringWithRange:NSMakeRange(0, 19)] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            break;
        case 2:
            statusImage.image = [UIImage imageNamed:@"Exchange_CheckFail"];
            titleStastusLabel.text = @"不通过";
            textStastusLabel.text = @"理由：调拨农机不符合审核条件";
            timeStastuslabel.text = [[_model.checkDate substringWithRange:NSMakeRange(0, 19)] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            break;
        default:
            break;
    }
    
    UIView *retreatInfoView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, statiusView.frame.size.height + 20 * screenHeight, self.view.frame.size.width - 30 * 2 * screenWidth, 620 * screenHeight)];
    retreatInfoView.backgroundColor = [UIColor whiteColor];
    retreatInfoView.layer.cornerRadius = 20 * screenWidth;
    [self.retreatScrollView addSubview:retreatInfoView];
    UILabel *machineInfo = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, retreatInfoView.frame.size.width - 60 * screenWidth, 50 * screenHeight)];
    machineInfo.textColor = [UIColor lightGrayColor];
    UILabel *machineName = [[UILabel alloc]initWithFrame:CGRectMake(machineInfo.frame.origin.x, machineInfo.frame.origin.y + machineInfo.frame.size.height + 20 * screenHeight, machineInfo.frame.size.width, machineInfo.frame.size.height)];
    UILabel *machineType = [[UILabel alloc]initWithFrame:CGRectMake(machineName.frame.origin.x, machineName.frame.origin.y + machineName.frame.size.height + 10 * screenHeight, machineName.frame.size.width, machineName.frame.size.height)];
    UILabel *machineNumber = [[UILabel alloc]initWithFrame:CGRectMake(machineName.frame.origin.x, machineType.frame.origin.y + machineType.frame.size.height + 10 * screenHeight, machineName.frame.size.width, machineName.frame.size.height)];
    machineNumber.textColor = [UIColor redColor];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, machineNumber.frame.origin.y + machineNumber.frame.size.height + 20 * screenHeight, retreatInfoView.frame.size.width, screenHeight)];
    lineLabel.backgroundColor = BackgroundColor;
    UILabel *exchangeAgency = [[UILabel alloc]initWithFrame:CGRectMake(machineNumber.frame.origin.x, lineLabel.frame.size.height + lineLabel.frame.origin.y + 20 * screenHeight, machineNumber.frame.size.width, machineNumber.frame.size.height)];
    exchangeAgency.textColor = [UIColor lightGrayColor];
    UILabel *agencyPlace = [[UILabel alloc]initWithFrame:CGRectMake(machineNumber.frame.origin.x, exchangeAgency.frame.size.height + exchangeAgency.frame.origin.y + 10 * screenHeight, machineNumber.frame.size.width, machineNumber.frame.size.height)];
    UILabel *agencyName = [[UILabel alloc]initWithFrame:CGRectMake(machineNumber.frame.origin.x, agencyPlace.frame.size.height + agencyPlace.frame.origin.y + 10 * screenHeight, machineNumber.frame.size.width, machineNumber.frame.size.height)];
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(machineName.frame.origin.x, agencyName.frame.origin.y + agencyName.frame.size.height + 10 * screenHeight, machineName.frame.size.width, machineName.frame.size.height)];
    UILabel *userPhone = [[UILabel alloc]initWithFrame:CGRectMake(machineName.frame.origin.x, userName.frame.origin.y + userName.frame.size.height + 10 * screenHeight, machineName.frame.size.width, machineName.frame.size.height)];
    //    UILabel *machineInfo = [[UILabel alloc]initWithFrame:CGRectMake(machineName.frame.origin.x, sellTime.frame.origin.y + sellTime.frame.size.height + 10 * screenHeight, machineName.frame.size.width, machineName.frame.size.height)];
    
    machineName.font = CFFONT14;
    machineType.font = CFFONT14;
    machineNumber.font = CFFONT14;
    agencyPlace.font = CFFONT14;
    agencyName.font = CFFONT14;
    userName.font = CFFONT14;
    userPhone.font = CFFONT14;
    
    machineInfo.text = @"农机信息";
    machineName.text = [@"名称：" stringByAppendingString:[NSString stringWithFormat:@"%@", self.model.productName]];;
    machineType.text = [@"型号：" stringByAppendingString:[NSString stringWithFormat:@"%@", self.model.productModel]];
    machineNumber.text = [@"车架号：" stringByAppendingString:[NSString stringWithFormat:@"%@", self.model.productBarCode]];
    exchangeAgency.text = @"调拨的经销商";
    agencyPlace.text = [@"" stringByAppendingString:[NSString stringWithFormat:@"%@", self.model.distributorsAddress]];;
    agencyName.text = [@"" stringByAppendingString:[NSString stringWithFormat:@"%@", self.model.distributorsName]];;
    userName.text = [@"用户姓名：" stringByAppendingString:[NSString stringWithFormat:@"%@", self.model.distributorsContact]];
    userPhone.text = [@"用户电话：" stringByAppendingString:[NSString stringWithFormat:@"%@", self.model.distributorsTel]];
    
    [retreatInfoView addSubview:machineInfo];
    [retreatInfoView addSubview:machineName];
    [retreatInfoView addSubview:machineType];
    [retreatInfoView addSubview:machineNumber];
    [retreatInfoView addSubview:lineLabel];
    [retreatInfoView addSubview:exchangeAgency];
    [retreatInfoView addSubview:agencyPlace];
    [retreatInfoView addSubview:agencyName];
    [retreatInfoView addSubview:userName];
    [retreatInfoView addSubview:userPhone];
    
//    UILabel *retreatReason = [[UILabel alloc]initWithFrame:CGRectMake(machineName.frame.origin.x, sellTime.frame.size.height + sellTime.frame.origin.y + 50 * screenHeight, machineName.frame.size.width, machineName.frame.size.height)];
//    retreatReason.textColor = [UIColor lightGrayColor];
//    UILabel *reasonDescribe = [[UILabel alloc]initWithFrame:CGRectMake(machineName.frame.origin.x, retreatReason.frame.size.height + retreatReason.frame.origin.y + 10 * screenHeight, machineName.frame.size.width, machineName.frame.size.height)];
//    UILabel *retreatReasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineName.frame.origin.x, reasonDescribe.frame.size.height + reasonDescribe.frame.origin.y + 10 * screenHeight, machineName.frame.size.width + 10 * screenWidth, 500 * screenHeight)];
//    //    retreatReasonLabel.layer.cornerRadius = 20 * screenWidth;
//    //    [retreatReasonLabel.layer setMasksToBounds:YES];
//    //    retreatReasonLabel.backgroundColor = BackgroundColor;
//    retreatReasonLabel.numberOfLines = 0;
//
//    retreatReason.font = CFFONT16;
//    reasonDescribe.font = CFFONT16;
//    retreatReasonLabel.font = CFFONT16;
//
//    retreatReason.text = @"退换原因";
//    reasonDescribe.text = @"原因简短描述";
//    retreatReasonLabel.text = @"原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述原因简短描述";
//    [retreatInfoView addSubview:retreatReason];
//    [retreatInfoView addSubview:reasonDescribe];
//    [retreatInfoView addSubview:retreatReasonLabel];
    
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonClick{
    self.vagueView.hidden = NO;
    UIButton *relieveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    relieveButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 245 * screenHeight, [UIScreen mainScreen].bounds.size.width, 120 * screenHeight);
    [relieveButton setBackgroundColor:[UIColor whiteColor]];
    [relieveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [relieveButton setTitle:@"撤销申请" forState:UIControlStateNormal];
    [relieveButton addTarget:self action:@selector(relieveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.vagueView addSubview:relieveButton];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, relieveButton.frame.size.height + relieveButton.frame.origin.y + 5 * screenHeight, [UIScreen mainScreen].bounds.size.width, 120 * screenHeight);
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.vagueView addSubview:cancelButton];
}
- (void)relieveButtonClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定撤销申请吗" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cancelApply];
    }];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
- (void)cancelButtonClick{
    self.vagueView.hidden = YES;
}
- (void)cancelApply{
    NSDictionary *dict = @{
                           @"applyId":self.applyId,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/cancelCarApply?" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"撤销成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                for (UIViewController *viewController in self.navigationController.childViewControllers) {
                    if ([viewController isKindOfClass:[CFAgencyManagerViewController class]]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                        return;
                    }
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.vagueView.hidden = YES;
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
