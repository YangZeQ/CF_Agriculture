//
//  CFBasePageControl.m
//  ChangFa
//
//  Created by dev on 2017/12/29.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "CFBasePageControl.h"

@implementation CFBasePageControl
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //计算圆点间距
    int dotW = 18 * [UIScreen mainScreen].bounds.size.width / 750;
    int magrin = 20 * [UIScreen mainScreen].bounds.size.height / 1334;
    CGFloat marginX = dotW + magrin;
    
    //计算整个pageControll的宽度
    CGFloat newW = (self.subviews.count - 1 ) * marginX;
    
    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);
    
    //设置居中
    CGPoint center = self.center;
    center.x = self.superview.center.x;
    self.center = center;
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView *dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) {
            //                    dot.image = [UIImage imageNamed:@"click"];
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotW)];
        }else {
            //            dot.image = [UIImage imageNamed:@"notclick"];
            [dot setFrame:CGRectMake(i * marginX, dot.frame.origin.y, dotW, dotW)];
        }
    }
}

@end
