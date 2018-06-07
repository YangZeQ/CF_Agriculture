//
//  CFRepairOrderView.m
//  ChangFa
//
//  Created by yang on 2018/6/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairOrderView.h"

@interface CFRepairOrderView ()
@property (nonatomic, assign)FillViewStyle viewStyle;
//@property (nonatomic, strong)UIView *headerVeiw;


//@property (nonatomic, strong)UIImageView *statusImage;

@property (nonatomic, strong)UIView *bodyView;
@end
@implementation CFRepairOrderView

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
    _statusImage.sd_layout.leftSpaceToView(self, 320).topSpaceToView(self, 23).heightIs(15).rightSpaceToView(self, 25);
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
- (void)typeBtnClick
{
    self.chooseTypeBlock();
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
@end
