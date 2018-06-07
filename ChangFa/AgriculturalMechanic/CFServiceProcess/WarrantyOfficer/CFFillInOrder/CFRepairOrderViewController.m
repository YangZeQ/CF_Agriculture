//
//  CFRepairOrderViewController.m
//  ChangFa
//
//  Created by yang on 2018/6/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairOrderViewController.h"
#import "CFRepairOrderView.h"
@interface CFRepairOrderViewController ()
@property (nonatomic, strong)UIView *vagueView;
@property (nonatomic, strong)UIScrollView *repairOrderScroll;
@property (nonatomic, strong)CFRepairOrderView *machineFaultView;
@end

@implementation CFRepairOrderViewController
- (UIView *)vagueView
{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _vagueView.hidden = YES;
        [[[UIApplication  sharedApplication] keyWindow] addSubview:_vagueView] ;
    }
    return _vagueView;
}
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
    groupPhotoView.sd_layout.leftSpaceToView(_repairOrderScroll, 20 * screenWidth).topSpaceToView(_repairOrderScroll, 20 * screenHeight).heightIs(120 * screenHeight).rightSpaceToView(_repairOrderScroll, 20 * screenWidth);
    groupPhotoView.isSelected = NO;
    groupPhotoView.tag = 1001;
    groupPhotoView.selectedButton.tag = 2001;
    groupPhotoView.titleLabel.text = @"人机合影";
    [groupPhotoView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CFRepairOrderView *faultPhotoView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStylePhoto];
    [_repairOrderScroll addSubview:faultPhotoView];
    faultPhotoView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(groupPhotoView, 20 * screenHeight).heightIs(120 * screenHeight).rightEqualToView(groupPhotoView);
    faultPhotoView.isSelected = NO;
    faultPhotoView.tag = 1002;
    faultPhotoView.selectedButton.tag = 2002;
    faultPhotoView.titleLabel.text = @"故障照片";
    [faultPhotoView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CFRepairOrderView *machineInfoView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleInfo];
    [_repairOrderScroll addSubview:machineInfoView];
    machineInfoView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(faultPhotoView, 20 * screenHeight).heightIs(120 * screenHeight).rightEqualToView(groupPhotoView);
    machineInfoView.isSelected = NO;
    machineInfoView.tag = 1003;
    machineInfoView.selectedButton.tag = 2003;
    machineInfoView.titleLabel.text = @"农机信息";
    [machineInfoView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CFRepairOrderView *machineUseView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleReason];
    [_repairOrderScroll addSubview:machineUseView];
    machineUseView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(machineInfoView, 20 * screenHeight).heightIs(120 * screenHeight).rightEqualToView(groupPhotoView);
    machineUseView.isSelected = NO;
    machineUseView.tag = 1004;
    machineUseView.selectedButton.tag = 2004;
    machineUseView.titleLabel.text = @"农机用途说明";
    [machineUseView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _machineFaultView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleParts];
    [_repairOrderScroll addSubview:_machineFaultView];
    _machineFaultView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(machineUseView, 20 * screenHeight).heightIs(120 * screenHeight).rightEqualToView(groupPhotoView);
    _machineFaultView.isSelected = NO;
    _machineFaultView.tag = 1005;
    _machineFaultView.selectedButton.tag = 2005;
    _machineFaultView.titleLabel.text = @"农机故障说明";
    [_machineFaultView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    __block CFRepairOrderViewController *weakself = self;
    _machineFaultView.chooseTypeBlock = ^{
        weakself.vagueView.hidden = NO;
    };
    
    CFRepairOrderView *userOpinionView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleReason];
    [_repairOrderScroll addSubview:userOpinionView];
    userOpinionView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(_machineFaultView, 20 * screenHeight).heightIs(120 * screenHeight).rightEqualToView(groupPhotoView);
    userOpinionView.isSelected = NO;
    userOpinionView.tag = 1006;
    userOpinionView.selectedButton.tag = 2006;
    userOpinionView.titleLabel.text = @"客户意见";
    [userOpinionView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CFRepairOrderView *handleOpinionView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleReason];
    [_repairOrderScroll addSubview:handleOpinionView];
    handleOpinionView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(userOpinionView, 20 * screenHeight).heightIs(120 * screenHeight).rightEqualToView(groupPhotoView);
    handleOpinionView.isSelected = NO;
    handleOpinionView.tag = 1007;
    handleOpinionView.selectedButton.tag = 2007;
    handleOpinionView.titleLabel.text = @"处理意见";
    [handleOpinionView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_repairOrderScroll sd_addSubviews:@[groupPhotoView,faultPhotoView,machineInfoView,machineUseView,_machineFaultView,userOpinionView,handleOpinionView]];
    _repairOrderScroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [_repairOrderScroll setupAutoContentSizeWithBottomView:handleOpinionView bottomMargin:20 * screenHeight];
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
