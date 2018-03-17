//
//  UITableViewCell+CFAdjustFont.m
//  ChangFa
//
//  Created by Developer on 2018/1/31.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "UITableViewCell+CFGlobalMethod.h"

@implementation UITableViewCell (CFGlobalMethod)

//- ()

- (CGFloat)autoScaleW:(CGFloat)w{
    return w * [UIScreen mainScreen].bounds.size.width / 375;
}

- (CGFloat)autoScaleH:(CGFloat)h{
    return h * [UIScreen mainScreen].bounds.size.height / 667;
}

- (float)autoCalculateWidthOrHeight:(float)height
                             width:(float)width
                          fontsize:(float)fontsize
                           content:(NSString*)content
{
    //计算出rect
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]}
                                        context:nil];
    //判断计算的是宽还是高
    if (height == MAXFLOAT) {
        return rect.size.height;
    } else {
        return rect.size.width;
    }
}
@end
