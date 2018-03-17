//
//  LeftViewController.m
//  ChangFa
//
//  Created by dev on 2018/1/8.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "LeftViewController.h"
#import "CFMisteViewButton.h"
#import "PersonViewController.h"
#import <UIImageView+WebCache.h>
#import "CFRepairsViewController.h"
#import "CFRepairsRecordViewController.h"
@interface LeftViewController ()<UIGestureRecognizerDelegate, PersonViewControllerDelegate>
@property (nonatomic, strong)UIImageView *headerImage;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    [self createLeftView];
    // Do any additional setup after loading the view.
}
- (void)createLeftView{
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationToChangeHeadImage) name:@"ChangeHeadImage" object:nil];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 360 * screenHeight)];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = ChangfaColor;
   _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 170 * screenHeight, 160 * screenWidth, 160 * screenHeight)];
    _headerImage.userInteractionEnabled = YES;
    [_headerImage.layer setCornerRadius:CGRectGetHeight([self.headerImage bounds]) / 2];
    _headerImage.clipsToBounds = YES;
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", UserHeadUrl]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
//    headerImage.image = [UIImage imageNamed:@"touxiang"];
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadImage)];
    [_headerImage addGestureRecognizer:tapImage];
    if ([[userDefault objectForKey:@"UserRoleType"] integerValue] == 1) {
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(_headerImage.frame.size.width + _headerImage.frame.origin.x + 20 * screenWidth, _headerImage.frame.origin.y + 25 * screenHeight, 300 * screenWidth, 40 * screenHeight)];
        name.textColor = [UIColor whiteColor];
        name.font = [UIFont systemFontOfSize:[self autoScaleW:16]];
        name.text = [userDefault objectForKey:@"UserPhone"];
        UILabel *machineNumber = [[UILabel alloc]initWithFrame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height + 30 * screenHeight, name.frame.size.width, name.frame.size.height)];
        machineNumber.textColor = [UIColor whiteColor];
        machineNumber.font = [UIFont systemFontOfSize:[self autoScaleW:16]];
        machineNumber.text = [NSString stringWithFormat:@"农机(台)：%@", [userDefault objectForKey:@"UserBindNum"]];
        [headerView addSubview:_headerImage];
        [headerView addSubview:name];
        [headerView addSubview:machineNumber];
    } else {
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(_headerImage.frame.size.width + _headerImage.frame.origin.x + 20 * screenWidth, _headerImage.frame.origin.y + _headerImage.frame.size.height / 2 - 20 * screenHeight, 300 * screenWidth, 40 * screenHeight)];
        name.textColor = [UIColor whiteColor];
        name.font = [UIFont systemFontOfSize:[self autoScaleW:16]];
        name.text = [userDefault objectForKey:@"UserPhone"];
        [headerView addSubview:_headerImage];
        [headerView addSubview:name];
    }
    [self.view addSubview:headerView];
    
    if ([[NSString stringWithFormat:@"%@", [userDefault objectForKey:@"UserRoleType"]] integerValue] == 1) {
        CFMisteViewButton *repairs = [[CFMisteViewButton alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height + 30 * screenHeight, [UIScreen mainScreen].bounds.size.width, 120 * screenHeight)];
        repairs.imageName = @"CFRepairs";
        repairs.titleName = @"报修";
        repairs.titleLabel.font = CFFONT16;
        repairs.titleLabel.textColor = [UIColor grayColor];
        repairs.backgroundColor = [UIColor whiteColor];
        [repairs.misteViewButton addTarget:self action:@selector(repairsButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:repairs];
        
        CFMisteViewButton *repairsRecord = [[CFMisteViewButton alloc]initWithFrame:CGRectMake(0, repairs.frame.size.height + repairs.frame.origin.y + 2 * screenHeight, [UIScreen mainScreen].bounds.size.width, 120 * screenHeight)];
        repairsRecord.imageName = @"CFRepairsRecord";
        repairsRecord.titleName = @"报修记录";
        repairsRecord.titleLabel.font = CFFONT16;
        repairsRecord.titleLabel.textColor = [UIColor grayColor];
        repairsRecord.backgroundColor = [UIColor whiteColor];
        [repairsRecord.misteViewButton addTarget:self action:@selector(repairsRecordButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:repairsRecord];
        
        CFMisteViewButton *noteBook = [[CFMisteViewButton alloc]initWithFrame:CGRectMake(0, repairsRecord.frame.size.height + repairsRecord.frame.origin.y + 30 * screenHeight, [UIScreen mainScreen].bounds.size.width, 120 * screenHeight)];
        noteBook.imageName = @"noteBook";
        noteBook.titleName = @"产品手册";
        noteBook.titleLabel.font = CFFONT16;
        noteBook.titleLabel.textColor = [UIColor grayColor];
        noteBook.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:noteBook];
        
        CFMisteViewButton *policy = [[CFMisteViewButton alloc]initWithFrame:CGRectMake(0, noteBook.frame.size.height + noteBook.frame.origin.y + 2 * screenHeight, [UIScreen mainScreen].bounds.size.width, 120 * screenHeight)];
        policy.imageName = @"policy";
        policy.titleName = @"公司政策";
        policy.titleLabel.font = CFFONT16;
        policy.titleLabel.textColor = [UIColor grayColor];
        policy.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:policy];
        
        CFMisteViewButton *version = [[CFMisteViewButton alloc]initWithFrame:CGRectMake(0, policy.frame.size.height + policy.frame.origin.y + 30 * screenHeight, [UIScreen mainScreen].bounds.size.width, 120 * screenHeight)];
        version.imageName = @"version";
        version.titleName = @"版本检测";
        version.titleLabel.font = CFFONT16;
        version.titleLabel.textColor = [UIColor grayColor];
        version.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:version];
    } else {
        CFMisteViewButton *noteBook = [[CFMisteViewButton alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height + 30 * screenHeight, [UIScreen mainScreen].bounds.size.width, 120 * screenHeight)];
        noteBook.imageName = @"noteBook";
        noteBook.titleName = @"产品手册";
        noteBook.titleLabel.font = CFFONT16;
        noteBook.titleLabel.textColor = [UIColor grayColor];
        noteBook.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:noteBook];
        
        CFMisteViewButton *policy = [[CFMisteViewButton alloc]initWithFrame:CGRectMake(0, noteBook.frame.size.height + noteBook.frame.origin.y + 2 * screenHeight, [UIScreen mainScreen].bounds.size.width, 120 * screenHeight)];
        policy.imageName = @"policy";
        policy.titleName = @"公司政策";
        policy.titleLabel.font = CFFONT16;
        policy.titleLabel.textColor = [UIColor grayColor];
        policy.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:policy];
        
        CFMisteViewButton *version = [[CFMisteViewButton alloc]initWithFrame:CGRectMake(0, policy.frame.size.height + policy.frame.origin.y + 30 * screenHeight, [UIScreen mainScreen].bounds.size.width, 120 * screenHeight)];
        version.imageName = @"version";
        version.titleName = @"版本检测";
        version.titleLabel.font = CFFONT16;
        version.titleLabel.textColor = [UIColor grayColor];
        version.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:version];
    }
}
- (void)notificationToChangeHeadImage{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", UserHeadUrl]]];
}
- (void)tapHeadImage{
    PersonViewController *person = [[PersonViewController alloc]init];
    person.delegate = self;
    [self.navigationController pushViewController:person animated:YES];
//    [self presentViewController:person animated:YES completion:^{
//        
//    }];
}
- (void)quitPersonAccount{
    [self.delegate quitRootViewController];
//    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}
- (void)repairsButtonClick{
    CFRepairsViewController *repairs = [[CFRepairsViewController alloc]init];
    [self.navigationController pushViewController:repairs animated:YES];
}
- (void)repairsRecordButtonClick{
    CFRepairsRecordViewController *repairsRecord = [[CFRepairsRecordViewController alloc]init];
    [self.navigationController pushViewController:repairsRecord animated:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
