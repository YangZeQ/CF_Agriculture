//
//  UIViewController+CFAdjustFont.m
//  ChangFa
//
//  Created by Developer on 2018/1/31.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "UIViewController+CFGlobalMethod.h"

@implementation UIViewController (CFGlobalMethod)
- (CGFloat)autoScaleW:(CGFloat)w{
    
    return w * [UIScreen mainScreen].bounds.size.width / 375;
    
}

- (CGFloat)autoScaleH:(CGFloat)h{
    return h * [UIScreen mainScreen].bounds.size.height / 667;
}

@end
