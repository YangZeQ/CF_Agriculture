//
//  CFRegisterTextFieldView.h
//  ChangFa
//
//  Created by dev on 2017/12/28.
//  Copyright © 2017年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFRegisterTextFieldView : UIView
//@property (nonatomic, copy)NSString *imageName;
//@property (nonatomic, copy)NSString *placeHolder;
//@property (nonatomic, assign)BOOL getCode;
//@property (nonatomic, assign)BOOL secretCode;
//@property (nonatomic, assign)CGRect reframe;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIButton *getCodeBtn;
@property (nonatomic, strong)UIButton *secretBtn;
@property (nonatomic, strong)UIButton *selecteButton;
@property (nonatomic, strong)UILabel *lineLabel;
//有图
- (instancetype)initWithImageName:(NSString *)imageName
                       Placeholder:(NSString *)placeHolder
                           GetCode:(BOOL)getCode
                        SecretCode:(BOOL)secretCode
                             Frame:(CGRect)reframe
                        ScaleWidth:(float)scaleWidth
                       ScaleHeight:(float)scaleHeight;
//无图
- (instancetype)initWithFrame:(CGRect)frame
                   LabelWidth:(float)width
                    LabelName:(NSString *)labelName
                  PlaceHolder:(NSString *)placeHolder;
//按钮
- (instancetype)initWithFrame:(CGRect)frame
                      OriginX:(float)originY
                   LabelWidth:(float)width
                    LabelName:(NSString *)labelName
                  ButtonImage:(NSString *)buttonImage;
//选择男女
- (instancetype)initWithFrame:(CGRect)frame
                    LabelText:(NSString *)labelText
                   LabelWidth:(float)width
                     OriginX1:(float)originX1
                     OriginX2:(float)originX2;
@end
