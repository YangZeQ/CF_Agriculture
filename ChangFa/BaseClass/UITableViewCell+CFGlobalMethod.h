//
//  UITableViewCell+CFAdjustFont.h
//  ChangFa
//
//  Created by Developer on 2018/1/31.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (CFGlobalMethod)
//自适应宽度的
- (CGFloat)autoScaleW:(CGFloat)w;
//自适应高度的
- (CGFloat)autoScaleH:(CGFloat)h;
//cell自适应
- (float)autoCalculateWidthOrHeight:(float)height
                              width:(float)width
                           fontsize:(float)fontsize
                            content:(NSString*)content;
@end
