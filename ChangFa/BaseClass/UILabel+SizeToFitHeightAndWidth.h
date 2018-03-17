//
//  UILabel+SizeToFitHeightAndWidth.h
//  ChangFa
//
//  Created by Developer on 2018/2/23.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SizeToFitHeightAndWidth)
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

@end
