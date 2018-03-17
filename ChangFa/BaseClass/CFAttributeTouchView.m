//
//  CFAttributeTouchView.m
//  ChangFa
//
//  Created by Developer on 2018/3/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAttributeTouchView.h"

@interface CFAttributeTouchView()<UITextViewDelegate>

@end
@implementation CFAttributeTouchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createAttributeTouchView];
    }
    return self;
}
- (void)createAttributeTouchView
{
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 100 * screenHeight)];
    _textView.delegate = self;
    _textView.editable = NO;//必须禁止输入，否则点击将会弹出输入键盘
    _textView.scrollEnabled = NO;//可选的，视具体情况而定
//    _textView.selectable = NO;
    [self addSubview:_textView];
}

- (void)setContent:(NSString *)content
{
    _content = content;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:content];
    [attStr addAttribute:NSLinkAttributeName value:@"click://" range:NSMakeRange(4, 3)];
    [attStr addAttributes:@{NSFontAttributeName: CFFONT14} range:NSMakeRange(0, 4)];
    [attStr addAttributes:@{NSFontAttributeName: CFFONT20} range:NSMakeRange(4, 3)];
    _textView.attributedText = attStr;
    
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([[URL scheme] isEqualToString:@"click"]) {
        NSAttributedString *abStr = [textView.attributedText attributedSubstringFromRange:characterRange];
        self.eventBlock(abStr);
        return NO;
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
