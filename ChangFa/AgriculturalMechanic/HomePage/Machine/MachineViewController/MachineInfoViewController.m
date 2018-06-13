//
//  MachineInfoViewController.m
//  ChangFa
//
//  Created by dev on 2018/1/7.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "MachineInfoViewController.h"
#import "UIAlertController+EndEditing.h"
#import "CFAlarmNewsViewController.h"
@interface MachineInfoViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *vagueView;
@property (nonatomic, copy)NSString *editNote;
@end

@implementation MachineInfoViewController
- (UIView *)vagueView{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _vagueView.hidden = YES;
        [self.view addSubview:_vagueView];
    }
    return _vagueView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"农机详情";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"CFAlarm"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    self.view.backgroundColor = BackgroundColor;
    [self createMachineDetailInfoView];
    
    
    // Do any additional setup after loading the view.
}
- (void)createMachineDetailInfoView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight + 10 * screenHeight, self.view.frame.size.width, 266 * screenHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView *machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(60 * screenWidth, 30 * screenHeight, 206 * screenWidth, 206 * screenHeight)];
    switch ([_model.carType integerValue]) {
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

    UILabel *machineName = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.origin.x + machineImage.frame.size.width + 30 * screenWidth, 38 * screenHeight, 400 * screenWidth, 50 * screenHeight)];
    if ([_model.carState integerValue] == 0) {
        machineName.text = @"农机状态：离线";
    } else {
        machineName.text = @"农机状态：在线";
    }
    UILabel *machineHour = [[UILabel alloc]initWithFrame:CGRectMake(machineName.frame.origin.x, machineName.frame.size.height + machineName.frame.origin.y + 20 * screenHeight, machineName.frame.size.width, machineName.frame.size.height)];
    machineHour.text = [[@"总行驶时长：" stringByAppendingString:[NSString stringWithFormat:@"%@", self.model.workingHours]] stringByAppendingString:@" h"];
    UILabel *machineNumber = [[UILabel alloc]initWithFrame:CGRectMake(machineName.frame.origin.x, machineHour.frame.size.height + machineHour.frame.origin.y + 20 * screenHeight, machineName.frame.size.width, machineName.frame.size.height)];
    machineNumber.textColor = [UIColor redColor];
    machineNumber.text = [@"车架号：" stringByAppendingString:self.model.productBarCode];
    
    machineName.font = [UIFont systemFontOfSize:[self autoScaleW:14]];
    machineHour.font = [UIFont systemFontOfSize:[self autoScaleW:14]];
    machineNumber.font = [UIFont systemFontOfSize:[self autoScaleW:14]];
    [headerView addSubview:machineName];
    [headerView addSubview:machineHour];
    [headerView addSubview:machineNumber];
    [self.view addSubview:headerView];
    [headerView addSubview:machineImage];
    
    NSArray *nameArray = [NSArray arrayWithObjects:@"备注", @"名称", @"型号", @"发动机转速", @"油压", @"水温", @"电压", @"海拔高度", nil];
    for (int i = 0; i < 8; i++) {
        UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height + headerView.frame.origin.y + 20 * screenHeight + 89 * screenHeight * i, self.view.frame.size.width, 88 * screenHeight)];
        infoView.backgroundColor = [UIColor whiteColor];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * screenWidth, 20 * screenHeight, 220 * screenWidth, 44 * screenHeight)];
        nameLabel.text = nameArray[i];
        nameLabel.font = CFFONT15;
        UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 10 * screenWidth, nameLabel.frame.origin.y, 390 * screenWidth, nameLabel.frame.size.height)];
        infoLabel.font = CFFONT14;
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            infoView.frame = CGRectMake(0, headerView.frame.size.height + headerView.frame.origin.y + 20 * screenHeight + 86 * screenHeight * i, self.view.frame.size.width, 85 * screenHeight);
            nameLabel.frame = CGRectMake(60 * screenWidth, 20 * screenHeight, 220 * screenWidth, 44 * screenHeight);
        }
        [infoView addSubview:nameLabel];
        [infoView addSubview:infoLabel];
        [self.view addSubview:infoView];
        if (i == 0) {
            infoLabel.text = self.model.note;
            infoLabel.tag = 1000;
            infoLabel.userInteractionEnabled = YES;
            UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
            editButton.frame = CGRectMake(infoLabel.frame.size.width + infoLabel.frame.origin.x, nameLabel.frame.origin.y, 40 * screenWidth, nameLabel.frame.size.height);
            [editButton setImage:[UIImage imageNamed:@"xiugaibeizhu"] forState:UIControlStateNormal];
            [editButton addTarget:self action:@selector(editRemarks) forControlEvents:UIControlEventTouchUpInside];
            [infoView addSubview:editButton];
        }
        switch (i) {
            case 1:infoLabel.text = self.model.productName;
                break;
            case 2:infoLabel.text = [NSString stringWithFormat:@"%@", self.model.productModel];
                break;
            case 3:infoLabel.text = [[NSString stringWithFormat:@"%@", self.model.speed] stringByAppendingString:@" r/min"];
                break;
            case 4:infoLabel.text = [self.model.hydraulic stringByAppendingString:@" Kpa"];
                break;
            case 5:infoLabel.text = [self.model.temperature stringByAppendingString:@" ˚C"];
                break;
            case 6:
            {
                infoLabel.text = [self.model.voltage stringByAppendingString:@" V"];
                NSMutableString *mutableString = [[NSMutableString alloc] initWithString:[self.model.voltage stringByAppendingString:@" V"]];
                [mutableString insertString:@"." atIndex:2];
                infoLabel.text = [NSString stringWithFormat:@"%@", mutableString];
            }
                break;
            case 7:infoLabel.text = [self.model.height stringByAppendingString:@" m"];
                break;
            default:
                break;
        }
    }
    
    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 182 * screenHeight, self.view.frame.size.width, 162 * screenHeight)];
    userView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userView];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * screenWidth, 20 * screenHeight, 220 * screenWidth, 50 * screenHeight)];
    nameLabel.text = @"用户姓名";
    [userView addSubview:nameLabel];
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * screenWidth, 22 * screenHeight + nameLabel.frame.origin.y + nameLabel.frame.size.height, 220 * screenWidth, 50 * screenHeight)];
    phoneLabel.text = @"手机号";
    [userView addSubview:phoneLabel];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.size.width + nameLabel.frame.origin.x, nameLabel.frame.origin.y, 320 * screenWidth, nameLabel.frame.size.height)];
    name.text = self.model.name;
    [userView addSubview:name];
    UILabel *phone = [[UILabel alloc]initWithFrame:CGRectMake(name.frame.origin.x, phoneLabel.frame.origin.y, name.frame.size.width, name.frame.size.height)];
    phone.text = self.model.tel;
    [userView addSubview:phone];

    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(self.view.frame.size.width - 110 * screenWidth, 59 * screenHeight, 50 * screenWidth, 50 * screenHeight);
    [phoneButton setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(callTheUser) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:phoneButton];
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonClick{
    CFAlarmNewsViewController *alarmNews = [[CFAlarmNewsViewController alloc]init];
    alarmNews.machineModel = _model;
    [self.navigationController pushViewController:alarmNews animated:YES];
    return;
    self.vagueView.hidden = NO;
    UIButton *relieveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    relieveButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 245 * screenHeight, [UIScreen mainScreen].bounds.size.width, 120 * screenHeight);
    [relieveButton setBackgroundColor:[UIColor whiteColor]];
    [relieveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [relieveButton setTitle:@"解除绑定" forState:UIControlStateNormal];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定解除绑定吗" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cancelBindMachine];
    }];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
- (void)cancelButtonClick{
    self.vagueView.hidden = YES;
}
- (void)cancelBindMachine{
    NSDictionary *dict = @{
                           @"imei":self.model.imei,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/cancelUserBindCar" Params:dict Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bindMachine" object:nil userInfo:nil];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"解除绑定成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                for (UIViewController *viewController in self.navigationController.childViewControllers) {
                    if ([viewController isKindOfClass:[SliderViewController class]]) {
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
- (void)editRemarks{
//    self.vagueView.hidden = NO;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改备注" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    //    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
    //    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 2)];
    //    [alert setValue:alertControllerStr forKey:@"attributedTitle"];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        if (self.editNote.length >= 1) {
            textField.placeholder = self.editNote;
        } else {
            textField.placeholder = self.model.note;
        }
        textField.delegate = self;
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self editUserMachineNote];
    }];
    [sureAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
- (void)callTheUser{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@", self.model.tel];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (void)editUserMachineNote{
    if (self.editNote.length < 1) {
        self.editNote = @" ";
    }
    NSDictionary *dict = @{
                           @"imei":self.model.imei,
                           @"note":self.editNote,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/editUserCarNote" Params:dict Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            UILabel *label = [self.view viewWithTag:1000];
            label.text = self.editNote;
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.editNote = textField.text;
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
