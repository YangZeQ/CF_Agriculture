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
@interface CFFaultView : UIView
@property (nonatomic, assign)NSInteger type;

@property (nonatomic, strong)UIButton *titleBtn;
@property (nonatomic, strong)CFReasonTextView *reasonView;

@property (nonatomic, copy)changeViewBlock changeViewBlock;
@property (nonatomic, copy)changeFrameBlock changeFrameBlock;
- (instancetype)initWithType:(NSInteger)type;
@end
