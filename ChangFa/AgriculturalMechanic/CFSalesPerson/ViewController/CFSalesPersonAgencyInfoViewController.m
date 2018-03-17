//
//  CFSalesPersonAgencyInfoViewController.m
//  ChangFa
//
//  Created by Developer on 2018/1/26.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFSalesPersonAgencyInfoViewController.h"
#import "CFAgencySendingViewController.h"
#import "CFAgencyPutInStorageViewController.h"
#import "CFAgencySoldViewController.h"
#import "AgencyModel.h"
#import "CFSalesPersonAgencyInfoTableViewCell.h"
#import "CFSalesPersonStatusTableViewCell.h"
@interface CFSalesPersonAgencyInfoViewController ()<UIGestureRecognizerDelegate, UIScrollViewDelegate, UITableViewDelegate, CFAgencySendingViewControllerDelegate, CFAgencyPutInViewControllerDelegate, CFAgencySoldViewControllerDelegate>
@property (nonatomic, strong)UITableView *agencyInfoTableView;
@property (nonatomic, strong)UIButton *selectedButton;
@property (nonatomic, strong)UIScrollView *agencyScrollView;
@property (nonatomic, strong)UIScrollView *statusScrollView;
@property (nonatomic, strong)UIView *agencyCompanyView;
@property (nonatomic, strong)UILabel *agencyCompanyLabel;
@property (nonatomic, strong)UILabel *agencyTypeLabel;
@property (nonatomic, strong)UILabel *agencyProductLabel;
@property (nonatomic, strong)UILabel *agencyAddressLabel;
@property (nonatomic, strong)UILabel *agencyNameLabel;
@property (nonatomic, strong)UILabel *agencyPhoneLabel;
@property (nonatomic, strong)UIButton *agencyPhoneButton;
@property (nonatomic, strong)UIView *buttonView;
@property (nonatomic, strong)AgencyModel *model;

@property (nonatomic, strong)CFAgencySendingViewController *sending;
@property (nonatomic, strong)CFAgencyPutInStorageViewController *putin;
@property (nonatomic, strong)CFAgencySoldViewController *sold;

@property (nonatomic, assign)float sendContentY;
@property (nonatomic, assign)float putinContentY;
@property (nonatomic, assign)float soldContentY;
@end

@implementation CFSalesPersonAgencyInfoViewController

- (instancetype)init{
    if (self = [super init]) {
        [self createAgencyInfoView];
    }
    return self;
}
- (UIButton *)selectedButton{
    if (_selectedButton == nil) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedButton.backgroundColor = [UIColor whiteColor];
//        _selectedButton.titleLabel.font = CFFONT15;
    }
    return _selectedButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.view.backgroundColor = BackgroundColor;
//    [self createView];
    // Do any additional setup after loading the view.
}
- (void)createAgencyInfoView{
    self.agencyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.agencyScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 570 * screenHeight - navHeight);
    self.agencyScrollView.showsVerticalScrollIndicator = NO;
//    self.agencyScrollView.bounces = NO;
    self.agencyScrollView.delegate = self;
    self.agencyScrollView.backgroundColor = BackgroundColor;
    [self.view addSubview:self.agencyScrollView];
    _sendContentY = -navHeight;
    _putinContentY = -navHeight;
    _soldContentY = -navHeight;
    [self createAgencyCompanyInfoView];
    
}
- (void)createAgencyCompanyInfoView{
    _agencyCompanyView = [[UIView alloc]initWithFrame:CGRectMake(0, 30 * screenHeight, self.view.frame.size.width, 510 * screenHeight)];
    _agencyCompanyView.backgroundColor = [UIColor whiteColor];
    [_agencyScrollView addSubview:_agencyCompanyView];
    
    _agencyCompanyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 20 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 50 * screenHeight)];
    _agencyCompanyLabel.text = @"常州市常发集团公司";
    _agencyCompanyLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:[self autoScaleW:18]];
    [_agencyCompanyView addSubview:_agencyCompanyLabel];
    
    _agencyAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_agencyCompanyLabel.frame.origin.x, _agencyCompanyLabel.frame.size.height + _agencyCompanyLabel.frame.origin.y + 20 * screenHeight, _agencyCompanyLabel.frame.size.width, _agencyCompanyLabel.frame.size.height)];
    _agencyAddressLabel.text = @"地址：";
    _agencyAddressLabel.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [_agencyCompanyView addSubview:_agencyAddressLabel];
    
    _agencyTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_agencyCompanyLabel.frame.origin.x, _agencyAddressLabel.frame.size.height + _agencyAddressLabel.frame.origin.y + 20 * screenHeight, _agencyCompanyLabel.frame.size.width, _agencyCompanyLabel.frame.size.height)];
    _agencyTypeLabel.text = @"经销类型：";
    _agencyTypeLabel.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [_agencyCompanyView addSubview:_agencyTypeLabel];
    _agencyProductLabel = [[UILabel alloc]initWithFrame:CGRectMake(_agencyCompanyLabel.frame.origin.x, _agencyTypeLabel.frame.size.height + _agencyTypeLabel.frame.origin.y + 20 * screenHeight, _agencyCompanyLabel.frame.size.width, _agencyCompanyLabel.frame.size.height * 2)];
    _agencyProductLabel.text = @"经销产品：";
    _agencyProductLabel.numberOfLines = 2;
    _agencyProductLabel.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [_agencyCompanyView addSubview:_agencyProductLabel];
    
    _agencyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_agencyCompanyLabel.frame.origin.x, _agencyProductLabel.frame.size.height + _agencyProductLabel.frame.origin.y + 40 * screenHeight, _agencyCompanyLabel.frame.size.width - 50 * screenWidth, _agencyCompanyLabel.frame.size.height)];
    _agencyNameLabel.text = @"负责人：";
    _agencyNameLabel.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [_agencyCompanyView addSubview:_agencyNameLabel];
    
    _agencyPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(_agencyCompanyLabel.frame.origin.x, _agencyNameLabel.frame.size.height + _agencyNameLabel.frame.origin.y + 20 * screenHeight, _agencyNameLabel.frame.size.width, _agencyCompanyLabel.frame.size.height)];
    _agencyPhoneLabel.text = @"联系电话：";
    _agencyPhoneLabel.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [_agencyCompanyView addSubview:_agencyPhoneLabel];
    
    _agencyPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _agencyPhoneButton.frame = CGRectMake(_agencyNameLabel.frame.size.width + _agencyNameLabel.frame.origin.x - 55 * screenWidth, _agencyNameLabel.frame.origin.y + 20 * screenHeight, 50 * screenWidth, 50 * screenHeight);
    [_agencyPhoneButton setBackgroundImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];
    [_agencyPhoneButton addTarget:self action:@selector(callAgencyPhone) forControlEvents:UIControlEventTouchUpInside];
    [_agencyCompanyView addSubview:_agencyPhoneButton];
}
- (void)createMachineStatusView{
    _sending = [[CFAgencySendingViewController alloc]init];
    _sending.height = navHeight + 88 * screenHeight;
    _sending.distributorsID = _agencyModel.distributorsID;
    _sending.delegate = self;
    _putin = [[CFAgencyPutInStorageViewController alloc]init];
    _putin.height = navHeight + 88 * screenHeight;
    _putin.distributorsID = _agencyModel.distributorsID;
    _putin.delegate = self;
    _sold = [[CFAgencySoldViewController alloc]init];
    _sold.height = navHeight + 88 * screenHeight;
    _sold.distributorsID = _agencyModel.distributorsID;
    _sold.delegate = self;
    [self addChildViewController:_sending];
    [self addChildViewController:_putin];
    [self addChildViewController:_sold];
    
//    _buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, _agencyCompanyView.frame.size.height + _agencyCompanyView.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 88 * screenHeight)];
//    _buttonView.backgroundColor = [UIColor cyanColor];
//    [self.agencyScrollView addSubview:_buttonView];
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, self.agencyCompanyView.frame.size.height + self.agencyCompanyView.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 88 * screenHeight)];
    [self.agencyScrollView addSubview:buttonView];
    NSArray *statusButtonTitle = @[@"发往中", @"已入库", @"已售出"];
    for (int i = 0; i < 3; i++) {
        UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        statusButton.frame = CGRectMake(250 * screenWidth * i, 0, 250 * screenWidth, 88 * screenHeight);
        statusButton.tag = 1000 + i;
        statusButton.titleLabel.font = CFFONT15;
        if (i == 0) {
            self.selectedButton.frame = CGRectMake(250 * screenWidth * i, 0, 248 * screenWidth, 88 * screenHeight);
//            [self.selectedButton setBackgroundColor:BackgroundColor];
            [self.selectedButton setTitleColor:ChangfaColor forState:UIControlStateNormal];
            [self.selectedButton setTitle:statusButtonTitle[i] forState:UIControlStateNormal];
            self.selectedButton.tag = 2000;
            [self.selectedButton addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [statusButton setTitle:statusButtonTitle[i] forState:UIControlStateNormal];
        [statusButton setBackgroundColor:[UIColor whiteColor]];
        [statusButton addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [statusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [buttonView addSubview:statusButton];
        [buttonView addSubview:self.selectedButton];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(statusButton.frame.size.width * (i + 1) - screenWidth, 14 * screenHeight, 2 * screenWidth, 60 * screenHeight)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [buttonView addSubview:lineLabel];
    }
    self.statusScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.agencyCompanyView.frame.size.height + self.agencyCompanyView.frame.origin.y + 118 * screenHeight, self.view.frame.size.width, self.view.frame.size.height - 88 * screenHeight - navHeight)];
    self.statusScrollView.showsVerticalScrollIndicator = YES;
    self.statusScrollView.showsHorizontalScrollIndicator = YES;
//    self.statusScrollView.pagingEnabled = YES;
    self.statusScrollView.bounces = NO;
    self.statusScrollView.scrollEnabled = NO;
    self.statusScrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.childViewControllers.count, self.view.frame.size.height - navHeight - 88 * screenHeight);
    [self.agencyScrollView addSubview:self.statusScrollView];
    
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIView *childView = [[UIView alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.statusScrollView.frame.size.height)];
        [childView addSubview:self.childViewControllers[i].view];
        [self.statusScrollView addSubview:childView];
    }
    
}

- (void)statusButtonClick:(UIButton *)sender{
    self.selectedButton.frame = CGRectMake(sender.frame.origin.x, 0, 248 * screenWidth, 88 * screenHeight);
    [self.selectedButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
//    if (sender.tag == 1000) {
//        self.statusScrollView.contentOffset = CGPointMake(0, 0);
//        _sending.refresh = @"refresh";
//    } else if (sender.tag == 1001) {
//        self.statusScrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
//        _putin.refresh = @"refresh";
//    } else {
//        self.statusScrollView.contentOffset = CGPointMake(self.view.frame.size.width * 2, 0);
//        _sold.refresh = @"refresh";
//    }
    if (sender.tag == 1000 || sender.tag == 2000) {
        self.statusScrollView.contentOffset = CGPointMake(0, 0);
        self.selectedButton.tag = 2000;
        self.sending.refresh = @"refresh";
    } else if (sender.tag == 1001 || sender.tag == 2001) {
        self.statusScrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        self.selectedButton.tag = 2001;
        self.putin.refresh = @"refresh";
    } else {
        self.statusScrollView.contentOffset = CGPointMake(self.view.frame.size.width * 2, 0);
        self.selectedButton.tag = 2002;
        self.sold.refresh = @"refresh";
    }
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)callAgencyPhone{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@", _agencyModel.tel];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    });
}

#pragma mark -手势识别
//// 同时识别多个手势
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{\
//    return YES;
//}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_agencyScrollView.contentOffset.y >= 570 * screenHeight - navHeight - 80 * screenHeight) {
        [_agencyScrollView setContentOffset:CGPointMake(0, 570 * screenHeight - navHeight - 80 * screenHeight)];
    }
}
- (void)changeSendingTableViewStatus{
    NSLog(@"%f", navHeight);
    if (_sending.sendingTableView.contentOffset.y > 0 && _agencyScrollView.contentOffset.y <= 570 * screenHeight - navHeight - 80 * screenHeight) {
        if (_sending.sendingTableView.contentOffset.y + _agencyScrollView.contentOffset.y < 570 * screenHeight - navHeight - 80 * screenHeight) {
            self.sendContentY = self.sendContentY + _sending.sendingTableView.contentOffset.y;
            [_agencyScrollView setContentOffset:CGPointMake(0, self.sendContentY)];
        } else {
            self.sendContentY = 0;
            [_agencyScrollView setContentOffset:CGPointMake(0, 570 * screenHeight - navHeight - 80 * screenHeight)];
        }
        return;
    }  else if (_sending.sendingTableView.contentOffset.y < 0 && _agencyScrollView.contentOffset.y > - navHeight - 80 * screenHeight) {
        self.sendContentY = 0;
        if (_sending.sendingTableView.contentOffset.y + _agencyScrollView.contentOffset.y < - navHeight - 80 * screenHeight) {
            _agencyScrollView.contentOffset = CGPointMake(0, - navHeight - 80 * screenHeight);
        } else {
            [_agencyScrollView setContentOffset:CGPointMake(0, _sending.sendingTableView.contentOffset.y + _agencyScrollView.contentOffset.y)];
        }
//        [_sending.sendingTableView setContentOffset:CGPointMake(0, 0)];
    }
}
- (void)changePutInTableViewStatus{
    if (_putin.putinTableView.contentOffset.y > 0 && _agencyScrollView.contentOffset.y <= 570 * screenHeight - navHeight - 80 * screenHeight) {
        if (_putin.putinTableView.contentOffset.y + _agencyScrollView.contentOffset.y < 570 * screenHeight - navHeight - 80 * screenHeight) {
            self.putinContentY = self.putinContentY + _putin.putinTableView.contentOffset.y;
            [_agencyScrollView setContentOffset:CGPointMake(0, self.putinContentY)];
//            [_putin.putinTableView setContentOffset:CGPointZero];
        } else {
            self.putinContentY = 0;
            [_agencyScrollView setContentOffset:CGPointMake(0, 570 * screenHeight - navHeight - 80 * screenHeight)];
        }
        return;
    }  else if (_putin.putinTableView.contentOffset.y < 0 && _agencyScrollView.contentOffset.y > - navHeight - 80 * screenHeight) {
        self.putinContentY = 0;
        if (_putin.putinTableView.contentOffset.y + _agencyScrollView.contentOffset.y < - navHeight - 80 * screenHeight) {
            _agencyScrollView.contentOffset = CGPointMake(0, - navHeight - 80 * screenHeight);
        } else {
            [_agencyScrollView setContentOffset:CGPointMake(0, _putin.putinTableView.contentOffset.y + _agencyScrollView.contentOffset.y)];
        }
//        [_putin.putinTableView setContentOffset:CGPointMake(0, 0)];
    }
    NSLog(@"%f   %f",  _putin.putinTableView.contentOffset.y, _agencyScrollView.contentOffset.y);
}
- (void)changeSoldTableViewStatus{
    if (_sold.soldTableView.contentOffset.y > 0 && _agencyScrollView.contentOffset.y <= 570 * screenHeight - navHeight - 80 * screenHeight) {
        if (_sold.soldTableView.contentOffset.y + _agencyScrollView.contentOffset.y < 570 * screenHeight - navHeight - 80 * screenHeight) {
            self.soldContentY = self.soldContentY + _sold.soldTableView.contentOffset.y;
            [_agencyScrollView setContentOffset:CGPointMake(0, self.soldContentY)];
        } else {
            self.soldContentY = 0;
            [_agencyScrollView setContentOffset:CGPointMake(0, 570 * screenHeight - navHeight - 80 * screenHeight)];
        }
        return;
    }  else if (_sold.soldTableView.contentOffset.y < 0 && _agencyScrollView.contentOffset.y > - navHeight - 88 * screenHeight) {
        self.soldContentY = 0;
        if (_sold.soldTableView.contentOffset.y + _agencyScrollView.contentOffset.y < - navHeight - 80 * screenHeight) {
            _agencyScrollView.contentOffset = CGPointMake(0, - navHeight - 80 * screenHeight);
        } else {
            [_agencyScrollView setContentOffset:CGPointMake(0, _sold.soldTableView.contentOffset.y + _agencyScrollView.contentOffset.y)];
        }
//        [_sold.soldTableView setContentOffset:CGPointMake(0, 0)];
    }
}

- (void)setAgencyModel:(AgencyModel *)agencyModel{
    _agencyModel = agencyModel;
    _agencyCompanyLabel.text = [NSString stringWithFormat:@"%@", agencyModel.distributorsName];
    _agencyAddressLabel.text = [_agencyAddressLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", agencyModel.distributorsAddress]];
    if ([agencyModel.distributorsType integerValue] == 1) {
        _agencyTypeLabel.text = [@"经销类型：" stringByAppendingString:@"整机"];
    } else if ([agencyModel.distributorsType integerValue] == 2) {
        _agencyTypeLabel.text = [@"经销类型：" stringByAppendingString:@"动力"];
    }
    _agencyProductLabel.text = [_agencyProductLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", agencyModel.distributorsProduct]];
    _agencyNameLabel.text = [_agencyNameLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", agencyModel.contact]];
    _agencyPhoneLabel.text = [_agencyPhoneLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", agencyModel.tel]];
    [self createMachineStatusView];
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
