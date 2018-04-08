//
//  CFRegisterTextFieldView.m
//  ChangFa
//
//  Created by dev on 2017/12/28.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "CFRegisterTextFieldView.h"

@interface CFRegisterTextFieldView()<UITextFieldDelegate>

@end
@implementation CFRegisterTextFieldView

- (instancetype)init{
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
                       ScaleHeight:(float)scaleHeight{
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
                  PlaceHolder:(NSString *)placeHolder{
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
                  ButtonImage:(NSString *)buttonImage{
    if (self = [super init]) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        [self createViewWithLabelName:labelName OriginX:originY LabelWidth:(float)width ButtonImage:buttonImage];
    }
    return self;
}
- (void)creatViewWithImageName:(NSString *)imageName
                   Placeholder:(NSString *)placeHolder
                       GetCode:(BOOL)getCode
                    SecretCode:(BOOL)secretCode
                         Frame:(CGRect)reframe
                    ScaleWidth:(float)scaleWidth
                   ScaleHeight:(float)scaleHeight{
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
                     Placeholder:(NSString *)placeHolder{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 0, width, self.frame.size.height)];
    label.text = labelName;
    label.font = CFFONT15;
    [self addSubview:label];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(label.frame.size.width + label.frame.origin.x, label.frame.origin.y, self.frame.size.width - 60 * screenWidth - label.frame.size.width, label.frame.size.height)];
    _textField.font = CFFONT15;
    _textField.placeholder = placeHolder;
    [_textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:_textField];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x, self.frame.size.height - 2 * screenWidth, self.frame.size.width - 2 * label.frame.origin.x, 2 * screenWidth)];
    lineLabel.backgroundColor = BackgroundColor;
    [self addSubview:lineLabel];
}
- (void)createViewWithLabelName:(NSString *)labelName
                        OriginX:(float)originY
                     LabelWidth:(float)width
                    ButtonImage:(NSString *)buttonImage{
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
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    if (!textField.window.isKeyWindow) {
//        [textField.window makeKeyAndVisible];
//    }
//    [textField becomeFirstResponder];
//}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self endEditing:YES];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
