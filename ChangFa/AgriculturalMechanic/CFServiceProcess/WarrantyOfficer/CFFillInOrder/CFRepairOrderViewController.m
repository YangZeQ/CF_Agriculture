//
//  CFRepairOrderViewController.m
//  ChangFa
//
//  Created by yang on 2018/6/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairOrderViewController.h"
#import "CFRepairOrderView.h"
#import "CFFaultView.h"
@interface CFRepairOrderViewController ()
@property (nonatomic, strong)UIScrollView *repairOrderScroll;
@property (nonatomic, strong)CFRepairOrderView *machineFaultView;
@end

@implementation CFRepairOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    [self createRepairOrderView];
    // Do any additional setup after loading the view.
}
- (void)createRepairOrderView
{
    self.navigationItem.title = @"填写维修单";
    _repairOrderScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT - navHeight)];
    _repairOrderScroll.contentSize = CGSizeMake(0, 0);
    _repairOrderScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_repairOrderScroll];
    
    CFRepairOrderView *groupPhotoView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStylePhoto];
    [_repairOrderScroll addSubview:groupPhotoView];
    groupPhotoView.sd_layout.leftSpaceToView(_repairOrderScroll, 10).topSpaceToView(_repairOrderScroll, 10).heightIs(60).rightSpaceToView(_repairOrderScroll, 10);
    groupPhotoView.isSelected = NO;
    groupPhotoView.tag = 1001;
    groupPhotoView.selectedButton.tag = 2001;
    groupPhotoView.titleLabel.text = @"人机合影";
    groupPhotoView.statuslabel.hidden = YES;
    [groupPhotoView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CFRepairOrderView *faultPhotoView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStylePhoto];
    [_repairOrderScroll addSubview:faultPhotoView];
    faultPhotoView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(groupPhotoView, 10).heightIs(60).rightEqualToView(groupPhotoView);
    faultPhotoView.isSelected = NO;
    faultPhotoView.tag = 1002;
    faultPhotoView.selectedButton.tag = 2002;
    faultPhotoView.titleLabel.text = @"故障照片";
    faultPhotoView.statuslabel.hidden = YES;
    [faultPhotoView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CFRepairOrderView *machineInfoView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleInfo];
    [_repairOrderScroll addSubview:machineInfoView];
    machineInfoView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(faultPhotoView, 10).heightIs(60).rightEqualToView(groupPhotoView);
    machineInfoView.isSelected = NO;
    machineInfoView.tag = 1003;
    machineInfoView.selectedButton.tag = 2003;
    machineInfoView.titleLabel.text = @"农机信息";
    machineInfoView.statuslabel.hidden = YES;
    [machineInfoView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CFRepairOrderView *machineUseView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleReason];
    [_repairOrderScroll addSubview:machineUseView];
    machineUseView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(machineInfoView, 10).heightIs(60).rightEqualToView(groupPhotoView);
    machineUseView.isSelected = NO;
    machineUseView.tag = 1004;
    machineUseView.selectedButton.tag = 2004;
    machineUseView.titleLabel.text = @"农机用途说明";
    machineUseView.statuslabel.hidden = YES;
    [machineUseView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _machineFaultView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleParts];
    [_repairOrderScroll addSubview:_machineFaultView];
    _machineFaultView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(machineUseView, 10).heightIs(60).rightEqualToView(groupPhotoView);
    _machineFaultView.isSelected = NO;
    _machineFaultView.tag = 1005;
    _machineFaultView.selectedButton.tag = 2005;
    _machineFaultView.titleLabel.text = @"农机故障说明";
    _machineFaultView.statuslabel.hidden = YES;
    [_machineFaultView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    __block CFRepairOrderViewController *weakself = self;
//    _machineFaultView.chooseTypeBlock = ^{
//        weakself.vagueView.hidden = NO;
//    };
    
    CFRepairOrderView *userOpinionView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleReason];
    [_repairOrderScroll addSubview:userOpinionView];
    userOpinionView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(_machineFaultView, 10).heightIs(60).rightEqualToView(groupPhotoView);
    userOpinionView.isSelected = NO;
    userOpinionView.tag = 1006;
    userOpinionView.selectedButton.tag = 2006;
    userOpinionView.titleLabel.text = @"客户意见";
    userOpinionView.statuslabel.hidden = YES;
    [userOpinionView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CFRepairOrderView *handleOpinionView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleReason];
    [_repairOrderScroll addSubview:handleOpinionView];
    handleOpinionView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(userOpinionView, 10).heightIs(60).rightEqualToView(groupPhotoView);
    handleOpinionView.isSelected = NO;
    handleOpinionView.tag = 1007;
    handleOpinionView.selectedButton.tag = 2007;
    handleOpinionView.titleLabel.text = @"处理意见";
    handleOpinionView.statuslabel.hidden = YES;
    [handleOpinionView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_repairOrderScroll addSubview:submitBtn];
    submitBtn.sd_layout.leftEqualToView(groupPhotoView).rightEqualToView(groupPhotoView).topSpaceToView(handleOpinionView, 15).heightIs(44);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = CFFONT15;
    [submitBtn setBackgroundColor:ChangfaColor];
    [submitBtn addTarget:self action:@selector(submitBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 10 * screenWidth;
    
    
    [_repairOrderScroll sd_addSubviews:@[groupPhotoView,faultPhotoView,machineInfoView,machineUseView,_machineFaultView,userOpinionView,handleOpinionView, submitBtn]];
    _repairOrderScroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [_repairOrderScroll setupAutoContentSizeWithBottomView:submitBtn bottomMargin:20 * screenHeight];
}
- (void)selectedButtonClick:(UIButton *)sender
{
    CFRepairOrderView *view = [self.view viewWithTag:sender.tag - 1000];
    view.isSelected = !view.isSelected;
    for (CFRepairOrderView *view in _repairOrderScroll.subviews) {
        if ([view isMemberOfClass:[CFRepairOrderView class]] && view.tag != sender.tag - 1000) {
            view.isSelected = NO;
        }
    }
}

- (void)submitBtnClcik
{
    for (CFFaultView *view in _machineFaultView.bodyView.subviews) {
        NSLog(@"%@", _machineFaultView.bodyView.subviews);
        if ([view isMemberOfClass:[CFFaultView class]] && view.type == 0) {
            NSLog(@"typea%@", view.reasonView.text);
        } else if ([view isMemberOfClass:[CFFaultView class]] && view.type == 1) {
            NSLog(@"typeb%@", view.reasonView.text);
        }
    }
    return;
    NSDictionary *no1 = @{
                          @"faultDes":@"123",
                          @"partNo":@"CF003102",
                          };
    NSDictionary *no2 = @{
                          @"faultDes":@"456",
                          @"partNo":@"356802032218223",
                          };
    NSError *error = nil;
    NSArray *arr = [NSArray arrayWithObjects:no1, no2, nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *param = @{
                            @"disId":@"",
                            @"disNum":@"",
                            @"faultFileIds":@"",
                            @"personFileIds":@"",
                            @"token":@"",
                            @"useTime":@"",
                            @"driveDistance":@"",
                            @"machineInstruction":@"",
                            @"partFaultList":jsonString,
                            @"faultList":@"",
                            @"customerOpinion":@"",
                            @"handleOpinion":@"",
                            @"remarks":@"",
                            };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"repair/createRepair" Loading:0 Params:param Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
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
