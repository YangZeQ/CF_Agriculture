//
//  CFFaultView.h
//  ChangFa
//
//  Created by yang on 2018/6/8.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFReasonTextView.h"

typedef void(^changeViewBlock)(NSInteger type);
typedef void(^changeFrameBlock)(NSInteger type);
typedef void(^scanBlock)(void);
typedef void(^getScanInfoBlock)(NSString *str);

@interface CFFaultView : UIView
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, assign)BOOL isCheck;

@property (nonatomic, strong)UIButton *titleBtn;
@property (nonatomic, strong)UITextField *partNameText;
@property (nonatomic, strong)CFReasonTextView *reasonView;
@property (nonatomic, strong)UIButton *scanBtn;
@property (nonatomic, strong)UIImageView *titleImage;

@property (nonatomic, copy)changeViewBlock changeViewBlock;
@property (nonatomic, copy)changeFrameBlock changeFrameBlock;
@property (nonatomic, copy)scanBlock scanBlock;
@property (nonatomic, copy)getScanInfoBlock getScanInfoBlock;
- (instancetype)initWithType:(NSInteger)type
                     IsCheck:(BOOL)isCheck;
@end
