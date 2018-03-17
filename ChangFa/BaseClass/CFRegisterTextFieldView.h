//
//  CFRegisterTextFieldView.h
//  ChangFa
//
//  Created by dev on 2017/12/28.
//  Copyright © 2017年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFRegisterTextFieldView : UIView
//@property (nonatomic, strong)NSString *imageName;
//@property (nonatomic, strong)NSString *placeHolder;
//@property (nonatomic, assign)BOOL getCode;
//@property (nonatomic, assign)BOOL secretCode;
//@property (nonatomic, assign)CGRect reframe;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIButton *getCodeBtn;
@property (nonatomic, strong)UIButton *secretBtn;
@property (nonatomic, strong)UIButton *selecteButton;
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
                    LabelName:(NSString *)labelName
                  PlaceHolder:(NSString *)placeHolder;
//按钮
- (instancetype)initWithFrame:(CGRect)frame
                      OriginX:(float)originY
                    LabelName:(NSString *)labelName
                  ButtonImage:(NSString *)buttonImage;

@end
