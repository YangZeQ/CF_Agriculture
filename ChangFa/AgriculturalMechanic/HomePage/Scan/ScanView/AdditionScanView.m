//
//  AdditionScanView.m
//  ChangFa
//
//  Created by Developer on 2018/4/25.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "AdditionScanView.h"
#import "CFRegisterTextFieldView.h"
#import "CFLoginTextField.h"
@interface AdditionScanView()<UIScrollViewDelegate>
@property (nonatomic, strong)UIImageView *identifyImage;
@property (nonatomic, strong)UILabel *secondLineLabel;
@property (nonatomic, strong)UIImageView *doneImage;
@property (nonatomic, strong)CFNumberTextField *imeiTextField;
@property (nonatomic, strong)MachineModel *machineModel;
@property (nonatomic, strong)UIView *machineView;
@property (nonatomic, strong)UIView *machineInfoView;
@property (nonatomic, strong)UIImageView *machineInfoImage;
@property (nonatomic, strong)UILabel *switchLabel;
@property (nonatomic, strong)UIImageView *switchImage;
@property (nonatomic, assign)BOOL switchStatus;
@property (nonatomic, strong)UILabel *fillInfoLabel;
@property (nonatomic, strong)UIView *userInfoView;
@property (nonatomic, assign)BOOL isTurning;
@property (nonatomic, assign)BOOL isReversed;
@property (nonatomic, assign)BOOL lightSelect;

@property (nonatomic, strong)UIView *bottomView;
@end
@implementation AdditionScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UserBackgroundColor;
        [self createAdditionScanViewWithFrame:frame];
    }
    return self;
}

- (void)createAdditionScanViewWithFrame:(CGRect)frame
{
    self.additionScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT)];
    self.additionScrollView.contentSize = CGSizeMake(0, 0);
    self.additionScrollView.delegate = self;
    [self addSubview:_additionScrollView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvent)];
    [self.additionScrollView addGestureRecognizer:tapGesture];
    
    UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, 160 * screenHeight)];
    progressView.backgroundColor = [UIColor whiteColor];
    [self.additionScrollView addSubview:progressView];
    UIImageView *imeiImage = [[UIImageView alloc]initWithFrame:CGRectMake(80 * screenWidth, 36 * screenHeight, 88 * screenWidth, 88 * screenHeight)];
    imeiImage.image = [UIImage imageNamed:@"Addition_IMEI"];
    [progressView addSubview:imeiImage];
    UILabel *firstLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(imeiImage.frame.size.width + imeiImage.frame.origin.x + 10 * screenWidth, 79 * screenHeight, 143 * screenWidth, 2 * screenHeight)];
    firstLineLabel.backgroundColor = ChangfaColor;
    [progressView addSubview:firstLineLabel];
    _identifyImage = [[UIImageView alloc]initWithFrame:CGRectMake(firstLineLabel.frame.size.width + firstLineLabel.frame.origin.x + 10 * screenWidth, imeiImage.frame.origin.y, 88 * screenWidth, 88 * screenHeight)];
    _identifyImage.image = [UIImage imageNamed:@"Addition_Identify_Gray"];
    [progressView addSubview:_identifyImage];
    _secondLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(_identifyImage.frame.size.width + _identifyImage.frame.origin.x + 10 * screenWidth, 79 * screenHeight, 143 * screenWidth, 2 * screenHeight)];
    _secondLineLabel.backgroundColor = [UIColor grayColor];
    [progressView addSubview:_secondLineLabel];
    _doneImage = [[UIImageView alloc]initWithFrame:CGRectMake(_secondLineLabel.frame.size.width + _secondLineLabel.frame.origin.x + 10 * screenWidth, imeiImage.frame.origin.y, 88 * screenWidth, 88 * screenHeight)];
    _doneImage.image = [UIImage imageNamed:@"Addition_Done_Gray"];
    [progressView addSubview:_doneImage];
    
    _scanView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, progressView.frame.size.height + progressView.frame.origin.y + 30 * screenHeight, CF_WIDTH - 60 * screenWidth, 986 * screenHeight)];
    _scanView.backgroundColor = [UIColor whiteColor];
    _scanView.layer.cornerRadius = 20 * screenWidth;
    [self.additionScrollView addSubview:_scanView];
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _scanView.frame.size.width, _scanView.frame.size.height)];
    [_scanView addSubview:_topView];
    [_scanView bringSubviewToFront:_topView];
    UILabel *scanTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 57 * screenHeight, _topView.frame.size.width, 30 * screenHeight)];
    scanTitleLabel.font = CFFONT14;
    scanTitleLabel.text = @"将条码/二维码放入框内即可自动扫描";
    scanTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:scanTitleLabel];
    
    _lightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, scanTitleLabel.frame.size.height + scanTitleLabel.frame.origin.y + 483 * screenHeight, _topView.frame.size.width, 30 * screenHeight)];
    _lightLabel.font = CFFONT14;
    _lightLabel.text = @"轻点照亮";
    _lightLabel.textAlignment = NSTextAlignmentCenter;
    _lightLabel.textColor = [UIColor whiteColor];
    [_topView addSubview:_lightLabel];
    UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lightButton.frame = CGRectMake(90 * screenWidth, 107 * screenHeight, 510 * screenWidth, 510 * screenHeight);
    [lightButton addTarget:self action:@selector(lightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:lightButton];
    _lightSelect = NO;
    
    UILabel *scanRemindLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 667 * screenHeight, _topView.frame.size.width, 30 * screenHeight)];
    scanRemindLabel.text = @"不能扫描？试试手动输入";
    scanRemindLabel.font = CFFONT14;
    scanRemindLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:scanRemindLabel];
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake(30 * screenWidth, _topView.frame.size.height - 158 * screenHeight, 240 * screenWidth, 58 * screenHeight);
    [scanButton setTitle:@"扫码" forState:UIControlStateNormal];
    [scanButton.layer setBorderColor:ChangfaColor.CGColor];
    [scanButton.layer setBorderWidth:1];
    scanButton.layer.cornerRadius = scanButton.frame.size.height / 2;
    [scanButton setTitleColor:ChangfaColor forState:UIControlStateNormal];
    [_topView addSubview:scanButton];
    
    UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
    textButton.frame = CGRectMake(_topView.frame.size.width - 270 * screenHeight, _topView.frame.size.height - 158 * screenHeight, 240 * screenWidth, 58 * screenHeight);
    [textButton setBackgroundImage:[UIImage imageNamed:@"Scan_TextInfo"] forState:UIControlStateNormal];
    [textButton setTitle:@"手动输入" forState:UIControlStateNormal];
    [textButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [textButton addTarget:self action:@selector(textButtonClcik) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:textButton];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _scanView.frame.size.width, _scanView.frame.size.height)];
    _bottomView.hidden = YES;
    _bottomView.layer.cornerRadius = 20 * screenWidth;
    [_scanView addSubview:_bottomView];
    [_scanView sendSubviewToBack:_bottomView];
    _imeiTextField = [[CFNumberTextField alloc]initWithFrame:CGRectMake(30 * screenWidth, 120 * screenHeight, _bottomView.frame.size.width - 60 * screenWidth, 98 * screenHeight)];
    _imeiTextField.backgroundColor = BackgroundColor;
    _imeiTextField.layer.cornerRadius = 20 * screenWidth;
    _imeiTextField.placeholder = @"输入条形码/二维码号";
    _imeiTextField.keyboardType = UIKeyboardTypeNumberPad;
    _imeiTextField.returnKeyType = UIReturnKeyDone;
    [_bottomView addSubview:_imeiTextField];
    UIButton *bottomSureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomSureButton.frame = CGRectMake(30 * screenWidth, 437 * screenHeight, _imeiTextField.frame.size.width, 89 * screenHeight);
    [bottomSureButton setBackgroundImage:[UIImage imageNamed:@"Bottom_Btn"] forState:UIControlStateNormal];
    [bottomSureButton setTitle:@"确定" forState:UIControlStateNormal];
    [bottomSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomSureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:bottomSureButton];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(60 * screenWidth, 618 * screenHeight, 36 * screenWidth, 34 * screenHeight)];
    backImage.image = [UIImage imageNamed:@"Bottom_Back"];
    backImage.userInteractionEnabled = YES;
    [_bottomView addSubview:backImage];
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(118 * screenWidth, backImage.frame.origin.y, 130 * screenWidth, backImage.frame.size.height)];
    backLabel.text = @"返回扫描";
    backLabel.font = CFFONT16;
    backLabel.textColor = ChangfaColor;
    backLabel.userInteractionEnabled = YES;
    [_bottomView addSubview:backLabel];
    UIButton *bottomBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBackButton.frame = CGRectMake(backImage.frame.origin.x, backImage.frame.origin.y, backLabel.frame.origin.x + backLabel.frame.size.width - backImage.frame.origin.x, backImage.frame.size.height);
    [bottomBackButton addTarget:self action:@selector(textButtonClcik) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:bottomBackButton];
    
    __block AdditionScanView *blockSelf = self;
    self.additionStepsBlock = ^(NSInteger step, MachineModel *model) {
        switch (step) {
            case AdditionStepScanIMEI:
                break;
            case AdditionStepBindMachine:
                blockSelf.machineModel = model;
                [blockSelf createBindMachineView];
                break;
            case AdditionStepDone:
                blockSelf.machineModel = model;
                [blockSelf createBindSucessView];
                break;
            default:
                break;
        }
    };
}
- (void)createBindMachineView
{
    __block AdditionScanView *blockSelf = self;
    blockSelf.scanView.hidden = YES;
    blockSelf.additionScrollView.contentSize = CGSizeMake(0, 1788 * screenHeight);
    blockSelf.identifyImage.image = [UIImage imageNamed:@"Addition_Identify"];
    blockSelf.secondLineLabel.backgroundColor = ChangfaColor;
    _machineView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, 190 * screenHeight, CF_WIDTH - 60 * screenWidth, 250 * screenHeight)];
    _machineView.backgroundColor = [UIColor whiteColor];
    _machineView.layer.cornerRadius = 20 * screenWidth;
    _machineView.layer.shadowColor = [UIColor blackColor].CGColor;
    _machineView.layer.shadowOpacity = 0.2;
    _machineView.layer.shadowRadius = 15 * screenWidth;
    _machineView.layer.shadowOffset = CGSizeMake(0, 2 * screenWidth);
    [blockSelf.additionScrollView addSubview:_machineView];
    
    UIImageView *machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 39 * screenHeight, 224 * screenWidth, 172 * screenHeight)];
    machineImage.image = [UIImage imageNamed:@"Machine_Image"];
    [_machineView addSubview:machineImage];
    UILabel *machineName = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.size.width + machineImage.frame.origin.x + 26 * screenWidth, 81 * screenHeight, _machineView.frame.size.width - machineImage.frame.size.width - 86 * screenWidth, 30 * screenHeight)];
    machineName.text = [NSString stringWithFormat:@"类型：%@",blockSelf.machineModel.productName];
    machineName.font = CFFONT16;
    [_machineView addSubview:machineName];
    UILabel *machineType = [[UILabel alloc]initWithFrame:CGRectMake(machineName.frame.origin.x, machineName.frame.size.height + machineName.frame.origin.y + 30 * screenHeight, machineName.frame.size.width, machineName.frame.size.height)];
    machineType.text = [NSString stringWithFormat:@"型号：%@", blockSelf.machineModel.productModel];
    machineType.font = CFFONT16;
    [_machineView addSubview:machineType];
    
    _machineInfoView = [[UIView alloc]initWithFrame:CGRectMake(_machineView.frame.origin.x, _machineView.frame.size.height + _machineView.frame.origin.y + 30 * screenHeight, _machineView.frame.size.width, 695 * screenHeight)];
    _machineInfoView.backgroundColor = [UIColor whiteColor];
    _machineInfoView.layer.cornerRadius = 20 * screenWidth;
    [blockSelf.additionScrollView addSubview:_machineInfoView];
    
    UILabel *machineInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, 300 * screenWidth, 30 * screenHeight)];
    machineInfoLabel.text = @"农机信息";
    machineInfoLabel.font = CFFONT16;
    [_machineInfoView addSubview:machineInfoLabel];
    _switchLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineInfoView.frame.size.width - 130 * screenWidth, machineInfoLabel.frame.origin.y, 80 * screenWidth, machineInfoLabel.frame.size.height)];
    _switchLabel.text = @"收起";
    _switchLabel.textColor = [UIColor grayColor];
    _switchLabel.font = CFFONT16;
    _switchLabel.userInteractionEnabled = YES;
    [_machineInfoView addSubview:_switchLabel];
    _switchImage = [[UIImageView alloc]initWithFrame:CGRectMake(_switchLabel.frame.size.width + _switchLabel.frame.origin.x - 7.5 * screenWidth, _switchLabel.frame.origin.y + 15 * screenHeight, 30 * screenWidth, 15 * screenHeight)];
    _switchImage.image = [UIImage imageNamed:@"CF_Progress_Button"];
    _switchImage.userInteractionEnabled = YES;
    _switchStatus = YES;
    [_machineInfoView addSubview:_switchImage];
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.frame = CGRectMake(_switchLabel.frame.origin.x, 0, 130 * screenWidth, 88 * screenHeight);
    [switchButton addTarget:self action:@selector(switchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_machineInfoView addSubview:switchButton];
    _machineInfoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 88 * screenHeight, _machineInfoView.frame.size.width, _machineInfoView.frame.size.height - 88 * screenHeight)];
    _machineInfoImage.image = [UIImage imageNamed:@"Machine_Active"];
    _machineInfoImage.userInteractionEnabled = YES;
    [_machineInfoView addSubview:_machineInfoImage];
    _activeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _activeButton.frame = CGRectMake((_machineInfoView.frame.size.width - 500 * screenWidth) / 2, 241 * screenHeight, 500 * screenWidth, 88 * screenHeight);
    [_activeButton setBackgroundImage:[UIImage imageNamed:@"Machine_ActiveBtn"] forState:UIControlStateNormal];
    [_activeButton setTitle:@"激活数据。了解更多" forState:UIControlStateNormal];
    [_activeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_machineInfoImage addSubview:_activeButton];
    
    _fillInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * screenWidth, _machineInfoView.frame.size.height + _machineInfoView.frame.origin.y + 48 * screenHeight, _machineInfoView.frame.size.width, 30 * screenHeight)];
    _fillInfoLabel.text = @"输入信息";
    _fillInfoLabel.font = CFFONT16;
    [blockSelf.additionScrollView addSubview:_fillInfoLabel];
    _userInfoView = [[UIView alloc]initWithFrame:CGRectMake(_machineInfoView.frame.origin.x, 20 * screenHeight + _fillInfoLabel.frame.size.height + _fillInfoLabel.frame.origin.y, _fillInfoLabel.frame.size.width, 480 * screenHeight)];
    _userInfoView.backgroundColor = [UIColor whiteColor];
    _userInfoView.layer.cornerRadius = 20 * screenWidth;
    [blockSelf.additionScrollView addSubview:_userInfoView];
    
    CFRegisterTextFieldView *identifyTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, 0, _userInfoView.frame.size.width, 120 * screenHeight) LabelWidth:200 * screenWidth LabelName:@"我的身份" PlaceHolder:@""];
    identifyTextField.textField.text = @"农机手";
    identifyTextField.userInteractionEnabled = NO;
    identifyTextField.layer.cornerRadius = 20 * screenWidth;
    [_userInfoView addSubview:identifyTextField];
    CFRegisterTextFieldView *userNameTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, identifyTextField.frame.size.height + identifyTextField.frame.origin.y, _userInfoView.frame.size.width, 120 * screenHeight) LabelWidth:200 * screenWidth LabelName:@"姓名" PlaceHolder:@"请输入姓名"];
    userNameTextField.layer.cornerRadius = 20 * screenWidth;
    [_userInfoView addSubview:userNameTextField];
    CFRegisterTextFieldView *phoneNumberTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, userNameTextField.frame.size.height + userNameTextField.frame.origin.y, _userInfoView.frame.size.width, 120 * screenHeight) LabelWidth:200 * screenWidth LabelName:@"联系电话" PlaceHolder:@"请输入电话"];
    [_userInfoView addSubview:phoneNumberTextField];
    CFRegisterTextFieldView *remarkTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, phoneNumberTextField.frame.size.height + phoneNumberTextField.frame.origin.y, _userInfoView.frame.size.width, 120 * screenHeight) LabelWidth:200 * screenWidth LabelName:@"农机备注" PlaceHolder:@"选填农机备注"];
    remarkTextField.layer.cornerRadius = 20 * screenWidth;
    remarkTextField.lineLabel.hidden = YES;
    [_userInfoView addSubview:remarkTextField];
    
    self.submitBlock = ^{
        [blockSelf.activeButton setTitle:@"申请已提交" forState:UIControlStateNormal];
        blockSelf.activeButton.userInteractionEnabled = NO;
        blockSelf.machineInfoImage.image = [UIImage imageNamed:@"Machine_Submit"];
    };
}

- (void)createBindSucessView
{
    __block AdditionScanView *blockSelf = self;
    blockSelf.doneImage.image = [UIImage imageNamed:@"Addition_Done"];
    blockSelf.additionScrollView.contentSize = CGSizeMake(0, 0);
    blockSelf.machineView.hidden = YES;
    blockSelf.machineInfoView.hidden = YES;
    blockSelf.fillInfoLabel.hidden = YES;
    blockSelf.userInfoView.hidden = YES;

    UIView *bindSuccessView = [[UIView alloc]initWithFrame:CGRectMake(60 * screenWidth, 274 * screenHeight, CF_WIDTH - 120 * screenWidth, 700 * screenHeight)];
    bindSuccessView.backgroundColor = [UIColor whiteColor];
    bindSuccessView.layer.cornerRadius = 20 * screenWidth;
    [_additionScrollView addSubview:bindSuccessView];
    
    UILabel *successLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 106 * screenHeight, bindSuccessView.frame.size.width, 30 * screenHeight)];
    successLabel.text = @"绑定成功";
    successLabel.font = CFFONT16;
    successLabel.textColor = ChangfaColor;
    successLabel.textAlignment = NSTextAlignmentCenter;
    [bindSuccessView addSubview:successLabel];
    UIImageView *bindMachineImage = [[UIImageView alloc]initWithFrame:CGRectMake((bindSuccessView.frame.size.width - 224 * screenWidth) / 2, successLabel.frame.size.height + successLabel.frame.origin.y + 81 * screenHeight, 224 * screenWidth, 172 * screenHeight)];
    bindMachineImage.image = [UIImage imageNamed:@"Machine_Image"];
    [bindSuccessView addSubview:bindMachineImage];
    UILabel *machineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(bindMachineImage.frame.origin.x, bindMachineImage.frame.size.height + bindMachineImage.frame.origin.y + 50 *screenHeight, bindSuccessView.frame.size.width - bindMachineImage.frame.origin.x - 30 * screenWidth, 30 * screenHeight)];
    machineNameLabel.text = [NSString stringWithFormat:@"类型：%@", blockSelf.machineModel.productName];
    machineNameLabel.font = CFFONT16;
    [bindSuccessView addSubview:machineNameLabel];
    UILabel *machineTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineNameLabel.frame.origin.x, machineNameLabel.frame.size.height + machineNameLabel.frame.origin.y + 30 *screenHeight, machineNameLabel.frame.size.width, 30 * screenHeight)];
    machineTypeLabel.text = [NSString stringWithFormat:@"型号：%@", blockSelf.machineModel.productModel];
    machineTypeLabel.font = CFFONT16;
    [bindSuccessView addSubview:machineTypeLabel];
    UILabel *machineRemarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineTypeLabel.frame.origin.x, machineTypeLabel.frame.size.height + machineTypeLabel.frame.origin.y + 30 *screenHeight, machineNameLabel.frame.size.width, 30 * screenHeight)];
    machineRemarkLabel.text = [NSString stringWithFormat:@"备注：%@", blockSelf.machineModel.note];
    machineRemarkLabel.font = CFFONT16;
    [bindSuccessView addSubview:machineRemarkLabel];
}

- (void)switchButtonClick
{
    CGRect machineInfoFrame = _machineInfoView.frame;
    if (_switchStatus) {
        self.additionScrollView.contentSize = CGSizeMake(0, 0);
        _switchImage.frame = CGRectMake(_switchLabel.frame.size.width + _switchLabel.frame.origin.x, _switchLabel.frame.origin.y, 15 * screenWidth, 30 * screenHeight);
        _machineInfoView.frame = CGRectMake(machineInfoFrame.origin.x, machineInfoFrame.origin.y, machineInfoFrame.size.width, 88 * screenHeight);
        _switchLabel.text = @"展开";
        _switchImage.image = [UIImage imageNamed:@"xiugai"];
        _machineInfoImage.hidden = YES;
        _fillInfoLabel.frame = CGRectMake(60 * screenWidth, _machineInfoView.frame.size.height + _machineInfoView.frame.origin.y + 48 * screenHeight, _machineInfoView.frame.size.width, 30 * screenHeight);
        _userInfoView.frame = CGRectMake(_machineInfoView.frame.origin.x, 20 * screenHeight + _fillInfoLabel.frame.size.height + _fillInfoLabel.frame.origin.y, _fillInfoLabel.frame.size.width, 480 * screenHeight);
    } else {
        self.additionScrollView.contentSize = CGSizeMake(0, 1788 * screenHeight);
        _switchImage.frame = CGRectMake(_switchLabel.frame.size.width + _switchLabel.frame.origin.x - 7.5 * screenWidth, _switchLabel.frame.origin.y + 1 * screenHeight, 30 * screenWidth, 15 * screenHeight);
        _machineInfoView.frame = CGRectMake(machineInfoFrame.origin.x, machineInfoFrame.origin.y, machineInfoFrame.size.width, 695 * screenHeight);
        _switchLabel.text = @"收起";
        _switchImage.image = [UIImage imageNamed:@"CF_Progress_Button"];
        _machineInfoImage.hidden = NO;
        _fillInfoLabel.frame = CGRectMake(60 * screenWidth, _machineInfoView.frame.size.height + _machineInfoView.frame.origin.y + 48 * screenHeight, _machineInfoView.frame.size.width, 30 * screenHeight);
        _userInfoView.frame = CGRectMake(_machineInfoView.frame.origin.x, 20 * screenHeight + _fillInfoLabel.frame.size.height + _fillInfoLabel.frame.origin.y, _fillInfoLabel.frame.size.width, 480 * screenHeight);
    }
    _switchStatus = !_switchStatus;
}
- (void)sureButtonClick
{
    [self endEditing:YES];
    if (_imeiTextField.text.length < 1) {
        [MBManager showBriefAlert:@"请输入条形码/二维码号" time:1.5];
    } else {
        self.textNumberBlock(_imeiTextField.text);
    }
}
- (void)textButtonClcik
{
    [self turnWithDuration:1.0 completion:^{
        NSLog(@"翻转完成");
    }];
}

- (void)tapGestureEvent
{
    [self endEditing:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endEditing:YES];      
}

/**
 翻转
 
 @param duration 翻转动画所需时间
 @param completion 动画结束后的回调
 */
- (void)turnWithDuration:(NSTimeInterval)duration completion:(void(^)(void))completion{
    if (!self.topView || !self.bottomView) {
        NSAssert(NO, @"未设置topView或bottomView");
    }
    
    // 正在动画中不能重复执行
    if (_isTurning) {
        return;
    }
    
    _isTurning = YES;
    
    if (_isReversed) {
        // 此时反面朝上
        // 从反面翻转到正面
        _topView.hidden = NO;
        _bottomView.hidden = YES;
        [UIView transitionFromView:self.bottomView toView:self.topView duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            !completion ?: completion();
            _isTurning  = NO;
            _isReversed = NO;
            self.stopSessionBlock(NO);
        }];
    } else {
        // 此时正面朝上
        // 从正面翻转到反面
        _topView.hidden = YES;
        _bottomView.hidden = NO;
        [UIView transitionFromView:self.topView toView:self.bottomView duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            !completion ?: completion();
            _isTurning  = NO;
            _isReversed = YES;
            self.stopSessionBlock(YES);
        }];
    }
}

- (void)lightButtonClick
{
    _lightSelect = !_lightSelect;
    if (_lightSelect) {
        _lightLabel.text = @"轻点关闭";
    } else {
        _lightLabel.text = @"轻点照亮";
    }
    self.lightBlock(_lightSelect);
}
@end
