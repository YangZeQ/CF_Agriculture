//
//  CFRepairOrderView.m
//  ChangFa
//
//  Created by yang on 2018/6/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairOrderView.h"
#import "CFFaultView.h"

typedef void(^textNumberBlock)(NSInteger number);

@interface CFRepairOrderView ()<UITextViewDelegate, UITextFieldDelegate>
@property (nonatomic, assign)FillViewStyle viewStyle;
@property (nonatomic, assign)BOOL isChangeView;
@property (nonatomic, assign)NSInteger viewTag;
//@property (nonatomic, strong)UIView *headerVeiw;
@property (nonatomic, strong)UIView *vagueView;
@property (nonatomic, strong)UIView *faultView;
//@property (nonatomic, strong)UIImageView *statusImage;


@property (nonatomic, copy)textNumberBlock textNumberBlock;
@property (nonatomic, copy)changeViewBlock changeViewBlock;
@end

@implementation CFRepairOrderView

- (UIView *)vagueView
{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _vagueView.hidden = YES;
        [[[UIApplication  sharedApplication] keyWindow] addSubview:_vagueView] ;
        
        UIButton *partFaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vagueView addSubview:partFaultBtn];
        partFaultBtn.sd_layout.topSpaceToView(_vagueView, 477 * 2 * screenHeight).leftSpaceToView(_vagueView, 0).rightSpaceToView(_vagueView, 0).heightIs(60);
        [partFaultBtn setBackgroundColor:[UIColor whiteColor]];
        [partFaultBtn setTitle:@"零配件故障" forState:UIControlStateNormal];
        [partFaultBtn setTitleColor:UIColorWithRGBA(107, 107, 107, 1) forState:UIControlStateNormal];
        partFaultBtn.titleLabel.font = CFFONT15;
        [partFaultBtn addTarget:self action:@selector(partBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *commonFaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vagueView addSubview:commonFaultBtn];
        commonFaultBtn.sd_layout.topSpaceToView(partFaultBtn, 1).leftSpaceToView(_vagueView, 0).rightSpaceToView(_vagueView, 0).heightIs(60);
        [commonFaultBtn setBackgroundColor:[UIColor whiteColor]];
        [commonFaultBtn setTitle:@"普通故障" forState:UIControlStateNormal];
        [commonFaultBtn setTitleColor:UIColorWithRGBA(107, 107, 107, 1) forState:UIControlStateNormal];
        commonFaultBtn.titleLabel.font = CFFONT15;
        [commonFaultBtn addTarget:self action:@selector(commonBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vagueView addSubview:cancelBtn];
        cancelBtn.sd_layout.topSpaceToView(commonFaultBtn, 10).leftSpaceToView(_vagueView, 0).rightSpaceToView(_vagueView, 0).heightIs(60);
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.titleLabel.font = CFFONT15;
    }
    return _vagueView;
}
- (NSMutableArray *)partInfoArray
{
    if (_partInfoArray == nil) {
        _partInfoArray = [NSMutableArray array];
    }
    return _partInfoArray;
}
- (instancetype)initWithViewStyle:(FillViewStyle)viewStyle
{
    if (self = [super init]) {
        self.viewStyle = viewStyle;
        [self createBaseView];
        switch (viewStyle) {
            case FillViewStylePhoto:
                [self createPhotoView];
                break;
            case FillViewStyleInfo:
                [self createMachineInfoView];
                break;
            case FillViewStyleReason:
                [self createResonView];
                break;
            case FillViewStyleParts:
                [self createPartsView];
                break;
            default:
                break;
        }
    }
    return self;
}
- (void)createBaseView
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10 * screenWidth;
    
    _signImage = [[UIImageView alloc]init];
    [self addSubview:_signImage];
    _signImage.sd_layout.topSpaceToView(self, 26).leftSpaceToView(self, 20).heightIs(10).widthIs(10);
    _signImage.userInteractionEnabled = YES;
    _signImage.image = [UIImage imageNamed:@"CF_StarImage"];
    
    _titleLabel = [[UILabel alloc]init];
    [self addSubview:_titleLabel];
    _titleLabel.sd_layout.leftSpaceToView(self, 34).topSpaceToView(self, 23).heightIs(16);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:100];
    _titleLabel.font = CFFONT14;
    _titleLabel.userInteractionEnabled = YES;
    _titleLabel.textColor = UIColorWithRGBA(107, 107, 107, 1);
    
    _statuslabel = [[UILabel alloc]init];
    [self addSubview:_statuslabel];
    _statuslabel.sd_layout.topSpaceToView(self, 23).rightSpaceToView(self, 47).heightIs(16);
    [_statuslabel setSingleLineAutoResizeWithMaxWidth:30];
    _statuslabel.font = CFFONT14;
    _statuslabel.text = @"完成";
    _statuslabel.userInteractionEnabled = YES;
    _statuslabel.textColor = UIColorWithRGBA(175, 175, 175, 1);
    
    _statusImage = [[UIImageView alloc]init];
    [self addSubview:_statusImage];
    _statusImage.sd_layout.widthIs(10).topSpaceToView(self, 23).heightIs(15).rightSpaceToView(self, 25);
    _statusImage.image = [UIImage imageNamed:@"xiugai"];
    _statusImage.userInteractionEnabled = YES;
    
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_selectedButton];
    _selectedButton.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).heightIs(60).rightSpaceToView(self, 0);
    
    _bodyView = [[UIView alloc]init];
    [self addSubview:_bodyView];
    _bodyView.sd_layout.topSpaceToView(self, 120 * screenHeight).leftSpaceToView(self, 0).heightIs(300 * screenHeight).rightSpaceToView(self, 0);
}
- (void)createPhotoView
{
    _bodyView.sd_layout.heightIs(150 * screenHeight);
}
- (void)createMachineInfoView
{
    _bodyView.sd_layout.heightIs(100 * screenHeight);
}
- (void)createResonView
{
    _bodyView.sd_layout.heightIs(224);
}
- (void)createPartsView
{
    self.viewTag = 1000;
    _bodyView.sd_layout.heightIs(60);
    _partTypeView = [[UIView alloc]init];
    [_bodyView addSubview:_partTypeView];
    _partTypeView.sd_layout.leftSpaceToView(_bodyView, 0).heightIs(60).rightSpaceToView(_bodyView, 0).bottomSpaceToView(_bodyView, 0);
    UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_partTypeView addSubview:typeBtn];
    typeBtn.sd_layout.topSpaceToView(_partTypeView, 0).leftSpaceToView(_partTypeView, 0).rightSpaceToView(_partTypeView, 0).bottomSpaceToView(_partTypeView, 0);
    typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    typeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 34 * screenWidth, 0, 0);
    [typeBtn setTitle:@"选择类型" forState:UIControlStateNormal];
    [typeBtn setTitleColor:UIColorWithRGBA(175, 175, 175, 1) forState:UIControlStateNormal];;
    typeBtn.titleLabel.font = CFFONT14;
    [typeBtn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)addMachineFaultViewWithType:(FaultType)type
{
    self.viewTag++;
    __block CFFaultView *faultView = [[CFFaultView alloc]initWithType:type];
    [_bodyView addSubview:faultView];
    [faultView.titleBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    faultView.tag = self.viewTag;
//    __block UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [faultView addSubview:titleBtn];
//    titleBtn.sd_layout.topSpaceToView(faultView, 0).leftSpaceToView(faultView, 34).heightIs(60).widthIs(100);
//    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    titleBtn.titleLabel.font = CFFONT14;
//    [titleBtn setTitleColor:UIColorWithRGBA(107, 107, 107, 1) forState:UIControlStateNormal];
//    [titleBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
//
//    __block UITextField *partNameText = [[UITextField alloc]init];
//    [faultView addSubview:partNameText];
//    partNameText.sd_layout.leftSpaceToView(faultView, 34).topSpaceToView(titleBtn, 0).heightIs(60).widthIs(250);
//    partNameText.font = CFFONT14;
//    partNameText.textColor = UIColorWithRGBA(107, 107, 107, 1);
//    partNameText.placeholder = @"扫描故障零配件条码";
//
//    __block UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [faultView addSubview:scanBtn];
//    scanBtn.sd_layout.topSpaceToView(titleBtn, 20).rightSpaceToView(faultView, 25).heightIs(20).widthIs(20);
//
//    __block CFReasonTextView *reasonView = [[CFReasonTextView alloc]init];
//    [faultView addSubview:reasonView];
//    reasonView.placeholder = @"请简短描述农机故障原因" ;
//    reasonView.delegate = self;
//    reasonView.editable = YES;
//    reasonView.maxNumberOfLines = 10;
//    reasonView.font = CFFONT13;
    
    switch (type) {
        case FaultTypeCommon:
//            [titleBtn setTitle:@"普通故障" forState:UIControlStateNormal];;
//            partNameText.hidden = YES;
//            scanBtn.hidden = YES;
//            reasonView.sd_layout.leftSpaceToView(faultView, 34).topSpaceToView(faultView, 60).rightSpaceToView(faultView, 34).heightIs(237);
            _bodyView.sd_layout.heightIs(_bodyView.height + 298);
            NSLog(@"%f", _bodyView.height);
            faultView.sd_layout.topSpaceToView(_bodyView, 0).topSpaceToView(_bodyView, _bodyView.height - 358).rightSpaceToView(_bodyView, 0).heightIs(298);
            break;
        case FaultTypePart:
//            [titleBtn setTitle:@"零配件故障" forState:UIControlStateNormal];
//            partNameText.hidden = NO;
//            scanBtn.hidden = NO;
//            reasonView.sd_layout.leftSpaceToView(faultView, 34).topSpaceToView(faultView, 120).rightSpaceToView(faultView, 34).heightIs(237);
            _bodyView.sd_layout.heightIs(_bodyView.height + 358);
            NSLog(@"%f", _bodyView.height);
            faultView.sd_layout.topSpaceToView(_bodyView, 0).topSpaceToView(_bodyView, _bodyView.height - 418).rightSpaceToView(_bodyView, 0).heightIs(358);
            break;
        default:
            break;
    }
    self.sd_layout.heightIs(60 + _bodyView.height);
    
}
- (void)typeBtnClick
{
//    self.chooseTypeBlock();
    self.vagueView.hidden = NO;
}
- (void)titleBtnClick
{
    self.vagueView.hidden = NO;
    self.isChangeView = YES;
}
- (void)partBtnClick
{
    self.vagueView.hidden = YES;
    if (_isChangeView) {
        self.changeViewBlock(FaultTypePart);
    } else {
        [self addMachineFaultViewWithType:FaultTypePart];
    }
}
- (void)commonBtnClick
{
    self.vagueView.hidden = YES;
    if (_isChangeView) {
        self.changeViewBlock(FaultTypeCommon);
    } else {
        [self addMachineFaultViewWithType:FaultTypeCommon];
    }
}
- (void)cancelBtnClick
{
    self.vagueView.hidden = YES;
}
- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        _bodyView.hidden = NO;
        switch (_viewStyle) {
            case FillViewStylePhoto:
                self.sd_layout.heightIs(60 + _bodyView.height);
                break;
            case FillViewStyleInfo:
                self.sd_layout.heightIs(60 + _bodyView.height);
                break;
            case FillViewStyleReason:
                self.sd_layout.heightIs(60 + _bodyView.height);
                break;
            case FillViewStyleParts:
                self.sd_layout.heightIs(60 + _bodyView.height);
                break;
            default:
                break;
        }
    } else {
        self.sd_layout.heightIs(60);
        _bodyView.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end
