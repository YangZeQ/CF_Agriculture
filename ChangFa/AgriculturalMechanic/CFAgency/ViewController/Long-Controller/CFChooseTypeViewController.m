//
//  CFChooseTypeViewController.m
//  ChangFa
//
//  Created by Developer on 2018/5/8.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFChooseTypeViewController.h"
#import "CFAgencySellViewController.h"
#import "CFAgencyRetreatViewController.h"
#import "CFAgencyExchangeViewController.h"
#import "CFAgencyReturnViewController.h"
#import "CFManagerTypeView.h"
@interface CFChooseTypeViewController ()

@end

@implementation CFChooseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择类型";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"申请记录" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.view.backgroundColor = BackgroundColor;
    [self createChooseTypeView];
    // Do any additional setup after loading the view.
}

- (void)createChooseTypeView
{
    UIView *machineView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, navHeight + 20 * screenHeight, CF_WIDTH - 60 * screenWidth, 220 * screenHeight)];
    machineView.backgroundColor = [UIColor whiteColor];
    machineView.layer.cornerRadius = 20 * screenWidth;
    [self.view addSubview:machineView];
    UIImageView *machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(20 * screenWidth, 20 * screenHeight, 180 * screenWidth, 180 * screenHeight)];
    switch ([_machineModel.carType integerValue]) {
        case 1:
            machineImage.image = [UIImage imageNamed:@"Agency_Tractors"];
            break;
        case 2:
            machineImage.image = [UIImage imageNamed:@"Agency_Harvester"];
            break;
        case 3:
            machineImage.image = [UIImage imageNamed:@"Agency_RiceTransplanter"];
            break;
        case 4:
            machineImage.image = [UIImage imageNamed:@"Agency_Dryer"];
            break;
        default:
            break;
    }
    [machineView addSubview:machineImage];
    UILabel *machineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.size.width + machineImage.frame.origin.x + 20 * screenWidth, 50 * screenHeight, machineView.frame.size.width - 240 * screenWidth, 26 * screenHeight)];
    machineNameLabel.text = [NSString stringWithFormat:@"名称：%@", _machineModel.productName];
    machineNameLabel.font = CFFONT14;
    [machineView addSubview:machineNameLabel];
    UILabel *machineTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineNameLabel.frame.origin.x, machineNameLabel.frame.size.height + machineNameLabel.frame.origin.y + 26 * screenHeight, machineNameLabel.frame.size.width, machineNameLabel.frame.size.height)];
    machineTypeLabel.text = [NSString stringWithFormat:@"型号：%@", _machineModel.productModel];
    machineTypeLabel.font = CFFONT14;
    [machineView addSubview:machineTypeLabel];
    UILabel *machineNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineNameLabel.frame.origin.x, machineTypeLabel.frame.size.height + machineTypeLabel.frame.origin.y + 26 * screenHeight, machineNameLabel.frame.size.width, machineNameLabel.frame.size.height)];
    machineNumberLabel.text = [NSString stringWithFormat:@"车架号：%@", _machineModel.productBarCode];
    machineNumberLabel.font = CFFONT14;
    machineNumberLabel.textColor = [UIColor grayColor];
    [machineView addSubview:machineNumberLabel];
    
    UILabel *chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(66 * screenWidth, machineView.frame.origin.y + machineView.frame.size.height + 60 * screenHeight, CF_WIDTH - 132 * screenWidth, 26 * screenHeight)];
    chooseLabel.text = @"请选择";
    chooseLabel.font = CFFONT14;
    [self.view addSubview:chooseLabel];
    
    if ([_machineModel.carState integerValue] == 2 || [_machineModel.carState integerValue] == 4) {
        CFManagerTypeView *sellView = [[CFManagerTypeView alloc]initWithFrame:CGRectMake(30 * screenWidth, chooseLabel.frame.size.height + chooseLabel.frame.origin.y + 30 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 160 * screenHeight) ViewImage:@"Agency_Sell" Title:@"出售" Text:@"出售农机给用户"];
        [sellView.viewButton addTarget:self action:@selector(sellMachine) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sellView];
        CFManagerTypeView *exchangeView = [[CFManagerTypeView alloc]initWithFrame:CGRectMake(sellView.frame.origin.x, sellView.frame.size.height + sellView.frame.origin.y + 20 * screenHeight, sellView.frame.size.width, sellView.frame.size.height) ViewImage:@"Agency_Retreat" Title:@"调拨" Text:@"农机调拨到其他经销商库"];
        [exchangeView.viewButton addTarget:self action:@selector(exchangeMachine) forControlEvents:UIControlEventTouchUpInside];
        CFManagerTypeView *returenView = [[CFManagerTypeView alloc]initWithFrame:CGRectMake(sellView.frame.origin.x, exchangeView.frame.size.height + exchangeView.frame.origin.y + 20 * screenHeight, sellView.frame.size.width, sellView.frame.size.height) ViewImage:@"Agency_Return" Title:@"返厂" Text:@"库存农机返厂"];
        [returenView.viewButton addTarget:self action:@selector(returnMachine) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sellView];
        [self.view addSubview:exchangeView];
        [self.view addSubview:returenView];
    } else {
        CFManagerTypeView *retreatView = [[CFManagerTypeView alloc]initWithFrame:CGRectMake(30 * screenWidth, chooseLabel.frame.size.height + chooseLabel.frame.origin.y + 30 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 160 * screenHeight) ViewImage:@"Agency_Exchange" Title:@"退换" Text:@"用户农机的退换"];
        [retreatView.viewButton addTarget:self action:@selector(retreateMachine) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:retreatView];
    }
    
    
}
- (void)sellMachine
{
    CFAgencySellViewController *sell = [[CFAgencySellViewController alloc]init];
    sell.machineModel = _machineModel;
    [self.navigationController pushViewController:sell animated:YES];
}
- (void)retreateMachine{
    CFAgencyRetreatViewController *retreat = [[CFAgencyRetreatViewController alloc]init];
    retreat.machineModel = _machineModel;
    [self.navigationController pushViewController:retreat animated:YES];
}
- (void)exchangeMachine{
    CFAgencyExchangeViewController *exchange = [[CFAgencyExchangeViewController alloc]init];
    exchange.machineModel = _machineModel;
    [self.navigationController pushViewController:exchange animated:YES];
}
- (void)returnMachine{
    CFAgencyReturnViewController *returnVC = [[CFAgencyReturnViewController alloc]init];
    returnVC.machineModel = _machineModel;
    [self.navigationController pushViewController:returnVC animated:YES];
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
