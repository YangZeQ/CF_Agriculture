//
//  CFRegisterTextFieldView.m
//  ChangFa
//
//  Created by dev on 2017/12/28.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "CFRegisterTextFieldView.h"

@interface CFRegisterTextFieldView()<UITextFieldDelegate>
@property (nonatomic, strong)UIImageView *manImage;
@property (nonatomic, strong)UIImageView *womanImage;
@end
@implementation CFRegisterTextFieldView

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"error");
    }
    return self;
}
//有图
- (instancetype)initWithImageName:(NSString *)imageName
                      Placeholder:(NSString *)placeHolder
                          GetCode:(BOOL)getCode
                       SecretCode:(BOOL)secretCode
                            Frame:(CGRect)reframe
                       ScaleWidth:(float)scaleWidth
                      ScaleHeight:(float)scaleHeight
{
    self = [super init];
    if (self) {
//        _imageName = imageName;
//        _placeHolder = placeHolder;
//        _getCode = getCode;
//        _secretCode= secretCode;
//        _reframe = reframe;
        self.frame = reframe;
        [self creatViewWithImageName:imageName Placeholder:placeHolder GetCode:getCode SecretCode:secretCode Frame:reframe ScaleWidth:scaleWidth ScaleHeight:scaleHeight];
    }
    return self;
}
//无图
- (instancetype)initWithFrame:(CGRect)frame
                   LabelWidth:(float)width
                    LabelName:(NSString *)labelName
                  PlaceHolder:(NSString *)placeHolder
{
    if (self = [super init]) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        [self createViewWithLabelWidth:width LabelName:labelName Placeholder:placeHolder];
    }
    return self;
}
//按钮
- (instancetype)initWithFrame:(CGRect)frame
                      OriginX:(float)originY
                   LabelWidth:(float)width
                    LabelName:(NSString *)labelName
                  ButtonImage:(NSString *)buttonImage
{
    if (self = [super init]) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        [self createViewWithLabelName:labelName OriginX:originY LabelWidth:(float)width ButtonImage:buttonImage];
    }
    return self;
}
//性别
- (instancetype)initWithFrame:(CGRect)frame
                    LabelText:(NSString *)labelText
                   LabelWidth:(float)width
                     OriginX1:(float)originX1
                     OriginX2:(float)originX2
{
    if (self = [super init]) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        [self createChooseSexViewWithLabelText:labelText LabelWidth:width OriginX1:originX1 OriginX2:originX2];
    }
    return self;
}

- (void)creatViewWithImageName:(NSString *)imageName
                   Placeholder:(NSString *)placeHolder
                       GetCode:(BOOL)getCode
                    SecretCode:(BOOL)secretCode
                         Frame:(CGRect)reframe
                    ScaleWidth:(float)scaleWidth
                   ScaleHeight:(float)scaleHeight
{
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10 * scaleWidth, 26 * scaleHeight, 40 * scaleWidth, 37 * scaleHeight)];
    image.image = [UIImage imageNamed:imageName];
    [self addSubview:image];
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(98 * scaleWidth, 20 * scaleHeight, reframe.size.width - 98 * scaleWidth, 50 * scaleHeight)];
    _textField.delegate = self;
    _textField.placeholder = placeHolder;
    _textField.font = [UIFont systemFontOfSize:[self autoScaleW:16]];
    [self addSubview:_textField];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 2 * scaleHeight, self.frame.size.width, scaleHeight)];
    lineLabel.backgroundColor = BackgroundColor;
    [self addSubview:lineLabel];
    
    if (getCode == YES) {
        
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getCodeBtn.frame = CGRectMake(self.frame.size.width - (192 + 4) * scaleWidth, _textField.frame.origin.y, 192 * scaleWidth, 58 * scaleHeight);
        [_getCodeBtn setBackgroundColor:ChangfaColor];
        _getCodeBtn.layer.cornerRadius = 3;
        [_getCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:[self autoScaleW:14]]];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self addSubview:_getCodeBtn];
    }
    
    if (secretCode == YES) {
        _secretBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _secretBtn.frame = CGRectMake(self.frame.size.width - (4 + 50) * scaleWidth, 30 * scaleHeight, 30 * scaleWidth, 20 * scaleWidth);
        [_secretBtn setBackgroundImage:[UIImage imageNamed:@"biyan"] forState:UIControlStateNormal];
        [_secretBtn addTarget:self action:@selector(secretToCode:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_secretBtn];
    }
    NSLog(@"%f", scaleWidth);
}
- (void)createViewWithLabelWidth:(NSInteger)width
                       LabelName:(NSString *)labelName
                     Placeholder:(NSString *)placeHolder
{
    _label = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 0, width, self.frame.size.height)];
    _label.text = labelName;
    _label.font = CFFONT15;
    [self addSubview:_label];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(_label.frame.size.width + _label.frame.origin.x, _label.frame.origin.y, self.frame.size.width - 60 * screenWidth - _label.frame.size.width, _label.frame.size.height)];
    _textField.font = CFFONT15;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.placeholder = placeHolder;
    [_textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:_textField];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(_label.frame.origin.x, self.frame.size.height - 2 * screenWidth, self.frame.size.width - 2 * _label.frame.origin.x, 2 * screenWidth)];
    _lineLabel.backgroundColor = BackgroundColor;
    [self addSubview:_lineLabel];
}
- (void)createViewWithLabelName:(NSString *)labelName
                        OriginX:(float)originY
                     LabelWidth:(float)width
                    ButtonImage:(NSString *)buttonImage
{
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 0, self.frame.size.width, self.frame.size.height)];
    placeLabel.text = labelName;
    placeLabel.font = CFFONT15;
    [self addSubview:placeLabel];
    UIImageView *editImage = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45 * screenWidth, 34 * screenHeight , 15 * screenWidth, 30 * screenHeight)];
    editImage.image = [UIImage imageNamed:buttonImage];
    [self addSubview:editImage];
    _selecteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selecteButton.titleLabel.font = CFFONT15;
    _selecteButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _selecteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _selecteButton.contentEdgeInsets = UIEdgeInsetsMake(0, width, 0, 0);
    [self addSubview:_selecteButton];
}
- (void)createChooseSexViewWithLabelText:(NSString *)labelText
                              LabelWidth:(float)width
                                 OriginX1:(float)originX1
                                OriginX2:(float)originX2
{
    _label = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 0, width, self.frame.size.height)];
    _label.text = labelText;
    _label.font =  CFFONT16;
    [self addSubview:_label];
    
    _manImage = [[UIImageView alloc]initWithFrame:CGRectMake(originX1, (self.frame.size.height - 40 * screenHeight) / 2, 40 * screenWidth, 40 * screenHeight)];
    _manImage.image = [UIImage imageNamed:@"Sex_Unselected"];
    [self addSubview:_manImage];
    UILabel *manLabel = [[UILabel alloc]initWithFrame:CGRectMake(_manImage.frame.size.width + _manImage.frame.origin.x + 20 * screenWidth, _manImage.frame.origin.y, 35 * screenWidth, _manImage.frame.size.height)];
    manLabel.text = @"男";
    manLabel.font = CFFONT16;
    manLabel.textColor = [UIColor grayColor];
    [self addSubview:manLabel];
    UIButton *manButton = [UIButton buttonWithType:UIButtonTypeCustom];
    manButton.frame = CGRectMake(originX1, 0, manLabel.frame.size.width + manLabel.frame.origin.x - _manImage.frame.origin.x, self.frame.size.height);
    manButton.tag = 1001;
    [manButton addTarget:self action:@selector(selectImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:manButton];
    
    _womanImage = [[UIImageView alloc]initWithFrame:CGRectMake(originX2, (self.frame.size.height - 40 * screenHeight) / 2, 40 * screenWidth, 40 * screenHeight)];
    _womanImage.image = [UIImage imageNamed:@"Sex_Unselected"];
    [self addSubview:_womanImage];
    UILabel *womanLabel = [[UILabel alloc]initWithFrame:CGRectMake(_womanImage.frame.size.width + _womanImage.frame.origin.x + 20 * screenWidth, _womanImage.frame.origin.y, 35 * screenWidth, _womanImage.frame.size.height)];
    womanLabel.text = @"女";
    womanLabel.font = CFFONT16;
    womanLabel.textColor = [UIColor grayColor];
    [self addSubview:womanLabel];
    UIButton *womanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    womanButton.frame = CGRectMake(originX2, 0, womanLabel.frame.size.width + womanLabel.frame.origin.x - _womanImage.frame.origin.x, self.frame.size.height);
    womanButton.tag = 1002;
    [womanButton addTarget:self action:@selector(selectImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:womanButton];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(_label.frame.origin.x, self.frame.size.height - 2 * screenWidth, self.frame.size.width - 2 * _label.frame.origin.x, 2 * screenWidth)];
    _lineLabel.backgroundColor = BackgroundColor;
    [self addSubview:_lineLabel];
}
- (void)secretToCode:(UIButton *)sender{
    NSLog(@"secret");
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSString *secret = _textField.text;
        _textField.text = @"";
        [sender setBackgroundImage:[UIImage imageNamed:@"kaiyan"] forState:UIControlStateNormal];
        _textField.secureTextEntry = NO;
        _textField.text = secret;
    } else {
        NSString *secret = _textField.text;
        _textField.text = @"";
        [sender setBackgroundImage:[UIImage imageNamed:@"biyan"] forState:UIControlStateNormal];
        _textField.secureTextEntry = YES;
        _textField.text = secret;
    }
}
- (void)selectImageButtonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1001:
            _manImage.image = [UIImage imageNamed:@"Sex_Selected"];
            _womanImage.image = [UIImage imageNamed:@"Sex_Unselected"];
            break;
        case 1002:
            _manImage.image = [UIImage imageNamed:@"Sex_Unselected"];
            _womanImage.image = [UIImage imageNamed:@"Sex_Selected"];
            break;
        default:
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
