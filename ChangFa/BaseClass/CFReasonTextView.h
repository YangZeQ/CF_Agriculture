//
//  CFReasonTextView.h
//  ChangFa
//
//  Created by Developer on 2018/2/23.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CF_textHeightChangedBlock)(NSString *text,CGFloat textHeight);
@interface CFReasonTextView : UITextView
/**
 *  UITextView作为placeholderView，使placeholderView等于UITextView的大小，字体重叠显示，方便快捷，解决占位符问题.
 */
@property (nonatomic, strong) UITextView *placeholderView;
/**
 *  占位文字
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 *  占位符字体大小
 */
@property (nonatomic,strong) UIFont *placeholderFont;

/**
 *  textView最大行数
 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

@property (nonatomic, strong)UILabel *textNumberLabel;
/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, strong) CF_textHeightChangedBlock textChangedBlock;
/**
 *  设置圆角
 */
@property (nonatomic, assign) NSUInteger cornerRadius;

- (void)textValueDidChanged:(CF_textHeightChangedBlock)block;

@end
