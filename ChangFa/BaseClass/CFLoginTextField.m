//
//  CFLoginTextField.m
//  ChangFa
//
//  Created by Developer on 2018/2/22.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFLoginTextField.h"

@implementation CFLoginTextField

// 控制placeHolder的位置，左右缩20，但是光标位置不变
/*
 -(CGRect)placeholderRectForBounds:(CGRect)bounds
 {
 CGRect inset = CGRectMake(bounds.origin.x+100, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
 return inset;
 }
 */

// 修改文本展示区域，一般跟editingRectForBounds一起重写
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 65 * screenWidth, bounds.origin.y, bounds.size.width - 100 * screenWidth, bounds.size.height);//更好理解些
    return inset;
}

// 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 65 * screenWidth, bounds.origin.y, bounds.size.width - 100 * screenWidth, bounds.size.height);//更好理解些
    return inset;
}

@end

@implementation CFNumberTextField

// 控制placeHolder的位置，左右缩20，但是光标位置不变
/*
 -(CGRect)placeholderRectForBounds:(CGRect)bounds
 {
 CGRect inset = CGRectMake(bounds.origin.x+100, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
 return inset;
 }
 */

// 修改文本展示区域，一般跟editingRectForBounds一起重写
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 30 * screenWidth, bounds.origin.y, bounds.size.width - 60 * screenWidth, bounds.size.height);//更好理解些
    return inset;
}

// 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x + 30 * screenWidth, bounds.origin.y, bounds.size.width - 60 * screenWidth, bounds.size.height);//更好理解些
    return inset;
}

@end
