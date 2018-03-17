//
//  PersonViewController.m
//  ChangFa
//
//  Created by dev on 2018/1/7.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "PersonViewController.h"
#import "PersonTableViewCell.h"
#import "AddressPickerView.h"
#import "PickView.h"
#import "CFAFNetWorkingMethod.h"
#import "ChangImageViewController.h"
#import <UIImageView+WebCache.h>
#import "CFPickView.h"
@interface PersonViewController ()<AddressPickerViewDelegate, SexPickerViewDelegate, IdentifyPickerViewDelegate>
//@property (nonatomic, strong)UITableView *sexTableView;
//@property (nonatomic, strong)UIView *pickView;
//@property (nonatomic, strong)NSMutableArray *arrayInfo;
@property (nonatomic ,strong)AddressPickerView * pickerView;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)AddressPickerView *pickViewSex;//性别、身份
@property (nonatomic, strong)AddressPickerView *pickViewID;

@property (nonatomic, strong)UIButton *sexInfo;
@property (nonatomic, strong)UIButton *identifyInfo;
@property (nonatomic, strong)UIButton *phoneInfo;
@property (nonatomic, strong)UIButton *placeInfo;

@property (nonatomic, strong)UIImageView *headImage;
@property (nonatomic, strong)NSString *headImageUrl;

@property (nonatomic, strong)CFPickView *areaPickView;
@property (nonatomic, strong)UIView *vagueView; // 透明层
@end

@implementation PersonViewController
- (UIView *)vagueView{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [self.view addSubview:_vagueView];
    }
    return _vagueView;
}

- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:50 pickerViewHeight:165];
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _backView.hidden = YES;
        
    }
    return _backView;
}
- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.headImageUrl = [NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserHeadUrl"]];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:self.headImageUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.title = @"个人资料";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [self createPersonView];

    // Do any additional setup after loading the view.
}
- (void)createPersonView{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    UITapGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabelToChangeInfo:)];
    UIView *sculpture = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 20 * screenHeight, self.view.frame.size.width, 272 * screenHeight)];
    sculpture.backgroundColor = [UIColor whiteColor];
    UILabel *sculptureLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * screenWidth, 111 * screenHeight, 150 * screenWidth, 50 * screenHeight)];
    sculptureLabel.text = @"头像";
    sculptureLabel.font = CFFONT16;
    [sculpture addSubview:sculptureLabel];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(660 * screenWidth, 121 * screenHeight , 30 * screenWidth, 30 * screenHeight);
    [rightButton setImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
    rightButton.tag = 1001;
    [rightButton addTarget:self action:@selector(changeinformation:) forControlEvents:UIControlEventTouchUpInside];
    [sculpture addSubview:rightButton];
//    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(460 * screenWidth, 46 * screenHeight, 180 * screenWidth, 180 * screenHeight)];
//    headImage.image = [UIImage imageNamed:@"touxiang"];
//    headImage.userInteractionEnabled = YES;
//    headImage.layer.cornerRadius = 90 * screenWidth;
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(460 * screenWidth, 46 * screenHeight, 180 * screenWidth, 180 * screenHeight);
//    [imageBtn setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
    imageBtn.tag = 1006;
    [imageBtn addTarget:self action:@selector(changeinformation:) forControlEvents:UIControlEventTouchUpInside];
//    [sculpture addSubview:headImage];
    _headImage = [[UIImageView alloc]initWithFrame:imageBtn.frame];
    _headImage.layer.cornerRadius = _headImage.frame.size.width / 2;
    _headImage.clipsToBounds = YES;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserHeadUrl"]]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    [sculpture addSubview:_headImage];
    [sculpture addSubview:imageBtn];
    
    UIView *sex = [[UIView alloc]initWithFrame:CGRectMake(0, sculpture.frame.size.height + sculpture.frame.origin.y + screenHeight, sculpture.frame.size.width, 122 * screenHeight)];
    sex.backgroundColor = [UIColor whiteColor];
    UILabel *sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(sculptureLabel.frame.origin.x, 36 * screenHeight, sculptureLabel.frame.size.width, sculptureLabel.frame.size.height)];
    sexLabel.text = @"性别";
    [sex addSubview:sexLabel];
    UIButton *sexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sexButton.frame = CGRectMake(rightButton.frame.origin.x, 46 * screenHeight , rightButton.frame.size.width, rightButton.frame.size.height);
    [sexButton setImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
    sexButton.tag = 1002;
    [sexButton addTarget:self action:@selector(changeinformation:) forControlEvents:UIControlEventTouchUpInside];
    [sex addSubview:sexButton];
    _sexInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    _sexInfo.tag = 1007;
    _sexInfo.frame = CGRectMake(sexLabel.frame.size.width + sexLabel.frame.origin.x + 50 * screenWidth, sexLabel.frame.origin.y, 380 * screenWidth, sexLabel.frame.size.height);
    [_sexInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _sexInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _sexInfo.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_sexInfo addTarget:self action:@selector(changeinformation:) forControlEvents:UIControlEventTouchUpInside];
    [sex addSubview:_sexInfo];
    
    UIView *identify = [[UIView alloc]initWithFrame:CGRectMake(0, sculpture.frame.origin.y + sculpture.frame.size.height + 30 * screenHeight, sex.frame.size.width, sex.frame.size.height)];
    identify.backgroundColor = [UIColor whiteColor];
    UILabel *identifyLabel = [[UILabel alloc]initWithFrame:CGRectMake(sculptureLabel.frame.origin.x, sexLabel.frame.origin.y, sculptureLabel.frame.size.width, sculptureLabel.frame.size.height)];
    identifyLabel.text = @"我的身份";
    identifyLabel.font = CFFONT16;
    [identify addSubview:identifyLabel];
    UIButton *identifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    identifyButton.frame = CGRectMake(rightButton.frame.origin.x, 46 * screenHeight , rightButton.frame.size.width, rightButton.frame.size.height);
    [identifyButton setImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
    identifyButton.tag = 1003;
    [identifyButton addTarget:self action:@selector(changeinformation:) forControlEvents:UIControlEventTouchUpInside];
    [identify addSubview:identifyButton];
    _identifyInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    _identifyInfo.tag = 1008;
    _identifyInfo.frame = CGRectMake(_sexInfo.frame.origin.x, _sexInfo.frame.origin.y, _sexInfo.frame.size.width, _sexInfo.frame.size.height);
    _identifyInfo.titleLabel.font = CFFONT16;
    [_identifyInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserRoleType"]] integerValue] == 1) {
        [_identifyInfo setTitle:@"农机手" forState:UIControlStateNormal];
    } else if ([[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserRoleType"]] integerValue] == 2) {
        [_identifyInfo setTitle:@"经销商" forState:UIControlStateNormal];
    } else if ([[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserRoleType"]] integerValue] == 3) {
        [_identifyInfo setTitle:@"销售员" forState:UIControlStateNormal];
    } else if ([[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserRoleType"]] integerValue] == 4) {
        [_identifyInfo setTitle:@"仓管" forState:UIControlStateNormal];
    }
    _identifyInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _identifyInfo.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_identifyInfo addTarget:self action:@selector(changeinformation:) forControlEvents:UIControlEventTouchUpInside];
    [identify addSubview:_identifyInfo];

    UIView *phone = [[UIView alloc]initWithFrame:CGRectMake(0, identify.frame.size.height + identify.frame.origin.y + screenHeight, sex.frame.size.width, sex.frame.size.height)];
    phone.backgroundColor = [UIColor whiteColor];
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(sculptureLabel.frame.origin.x, sexLabel.frame.origin.y, sculptureLabel.frame.size.width, sculptureLabel.frame.size.height)];
    phoneLabel.text = @"手机号";
    phoneLabel.font = CFFONT16;
    [phone addSubview:phoneLabel];
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(rightButton.frame.origin.x, 46 * screenHeight , rightButton.frame.size.width, rightButton.frame.size.height);
    [phoneButton setImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
    phoneButton.tag = 1004;
    [phoneButton addTarget:self action:@selector(changeinformation:) forControlEvents:UIControlEventTouchUpInside];
    [phone addSubview:phoneButton];
    _phoneInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneInfo.frame = CGRectMake(_sexInfo.frame.origin.x, _sexInfo.frame.origin.y, _sexInfo.frame.size.width, _sexInfo.frame.size.height);
    [_phoneInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_phoneInfo setTitle:[userDefault objectForKey:@"UserPhone"] forState:UIControlStateNormal];
    _phoneInfo.titleLabel.font = CFFONT16;
    _phoneInfo.tag = 1009;
    _phoneInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _phoneInfo.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_phoneInfo addTarget:self action:@selector(changeinformation:) forControlEvents:UIControlEventTouchUpInside];
    [phone addSubview:_phoneInfo];

    UIView *place = [[UIView alloc]initWithFrame:CGRectMake(0, phone.frame.size.height + phone.frame.origin.y + screenHeight, sex.frame.size.width, sex.frame.size.height)];
    place.backgroundColor = [UIColor whiteColor];
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(sculptureLabel.frame.origin.x, sexLabel.frame.origin.y, sculptureLabel.frame.size.width, sculptureLabel.frame.size.height)];
    placeLabel.text = @"所在地";
    placeLabel.font = CFFONT16;
    [place addSubview:placeLabel];
    UIButton *placeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    placeButton.frame = CGRectMake(rightButton.frame.origin.x, 46 * screenHeight , rightButton.frame.size.width, rightButton.frame.size.height);
    [placeButton setImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
    placeButton.tag = 1005;
    [placeButton addTarget:self action:@selector(changeinformation:) forControlEvents:UIControlEventTouchUpInside];
    [place addSubview:placeButton];
    _placeInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    _placeInfo.tag = 1010;
    _phoneInfo.titleLabel.font = CFFONT16;
    _placeInfo.frame = CGRectMake(_sexInfo.frame.origin.x, _sexInfo.frame.origin.y, _sexInfo.frame.size.width, _sexInfo.frame.size.height);
    [_placeInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _placeInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _placeInfo.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_placeInfo addTarget:self action:@selector(changeinformation:) forControlEvents:UIControlEventTouchUpInside];
    [place addSubview:_placeInfo];

    UIButton *quit = [UIButton buttonWithType:UIButtonTypeCustom];
    quit.frame = CGRectMake(30 * screenWidth, place.frame.size.height + place.frame.origin.y + 60 * screenHeight, 690 * screenWidth, 100 * screenHeight);
    [quit setBackgroundColor:ChangfaColor];
    [quit setTitle:@"退出登录" forState:UIControlStateNormal];
    [quit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quit.layer.cornerRadius = 20 * Width;
    [quit addTarget:self action:@selector(quitPersonAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sculpture];
//    [self.view addSubview:sex];
    [self.view addSubview:identify];
    [self.view addSubview:phone];
    [self.view addSubview:place];
    [self.view addSubview:quit];
    
    [self.view addSubview:self.backView];
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.pickViewSex];
    [self.view addSubview:self.pickViewID];
    [self.backView addGestureRecognizer:tapLabel];

    _areaPickView = [[CFPickView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight)];
    self.vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.areaPickView.cancelButton addTarget:self action:@selector(pickViewCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.areaPickView.sureButton addTarget:self action:@selector(pickViewsuerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_areaPickView];
    self.vagueView.hidden = YES;
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)changeinformation:(UIButton *)sender
{
    if (sender.tag == 1001 || sender.tag == 1006) {
        ChangImageViewController *change = [[ChangImageViewController alloc]init];
        change.imageUrl = self.headImageUrl;
        [self.navigationController pushViewController:change animated:YES];
    } else if (sender.tag == 1002 || sender.tag == 1007) {
        [self.pickViewSex show];
        _backView.hidden = NO;
    } else if (sender.tag == 1003 || sender.tag == 1008) {
//        [self.pickViewID show];
//        _backView.hidden = NO;
    } else if (sender.tag == 1004 || sender.tag == 1009) {
        
    } else if (sender.tag == 1005 || sender.tag == 1010) {
        _areaPickView.numberOfComponents = 3;
        _areaPickView.frame = CGRectMake(0, self.view.frame.size.height - 528 * screenHeight, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight);
//        _backView.hidden = NO;
//        [self.pickerView show];
    }
}

#pragma mark - AddressPickerViewDelegate
- (void)pickViewCancelButtonClick{
    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
}
- (void)pickViewsuerButtonClick{
    self.vagueView.hidden = YES;
    [_placeInfo setTitle:_areaPickView.selectedInfo forState:UIControlStateNormal];
    [_placeInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
}
//废弃
- (void)cancelBtnClick
{
    [self.pickerView hide];
    [self.pickViewID hide];
    [self.pickViewSex hide];
    _backView.hidden = YES;
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area
{
    [_placeInfo setTitle:[[province stringByAppendingString:city] stringByAppendingString:area] forState:UIControlStateNormal];
    [self.pickerView hide];
    _backView.hidden = YES;
}
- (void)sureBtnClickReturnSex:(NSString *)sex
{
    [_sexInfo setTitle:sex forState:UIControlStateNormal];
    [self.pickViewSex hide];
    _backView.hidden = YES;
}
- (void)sureBtnClickReturnIdentify:(NSString *)identify
{
    [_identifyInfo setTitle:identify forState:UIControlStateNormal];
    [self.pickViewID hide];
    _backView.hidden = YES;
}
- (void)tapLabelToChangeInfo:(UIButton *)sender
{
    self.backView.hidden = YES;
    [self.pickerView hide];
    [self.pickViewID hide];
    [self.pickViewSex hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -退出登录
- (void)quitPersonAccount{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出登录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    //    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
    //    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 2)];
    //    [alert setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self quitPersonAccountRequest];
    }];
    [sureAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
- (void)quitPersonAccountRequest{
    //1.获得NSUserDefaults文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //2.向文件中写入内容
    NSString *strtoken = [userDefaults objectForKey:@"UserToken"];
    NSLog(@"%@", strtoken);
    NSDictionary *dict = @{
                           @"channel":@"",
                           @"token":strtoken,
                           @"language":@"cn",
                           @"version":@"1.0",
                           };
    
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/LoginOut" Params:dict Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            
            [userDefaults setObject:@"" forKey:@"UserToken"];
            [userDefaults setObject:@""  forKey:@"UserUid"];
            [userDefaults setObject:@""  forKey:@"UserName"];
            
            [self.delegate quitPersonAccount];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else if ([[dict objectForKey:@"code"] integerValue] == 500) {
            [userDefaults setObject:@"" forKey:@"UserToken"];
            [userDefaults setObject:@""  forKey:@"UserUid"];
            [userDefaults setObject:@""  forKey:@"UserName"];
            
            [self.delegate quitPersonAccount];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }  else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"退出失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [userDefaults setObject:@"" forKey:@"UserToken"];
        [userDefaults setObject:@""  forKey:@"UserUid"];
        [userDefaults setObject:@""  forKey:@"UserName"];
        
        [self.delegate quitPersonAccount];
        [self.navigationController popToRootViewControllerAnimated:YES];
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
