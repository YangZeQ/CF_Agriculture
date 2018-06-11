
//
//  CFFaultView.m
//  ChangFa
//
//  Created by yang on 2018/6/8.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFFaultView.h"

#define MAX_LIMIT_NUMS 150

typedef void(^textNumberBlock)(NSInteger number);

@interface CFFaultView ()<UITextViewDelegate>
@property (nonatomic, strong)UIView *vagueView;

@property (nonatomic, copy)textNumberBlock textNumberBlock;

@end
@implementation CFFaultView
- (UIView *)vagueView
{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _vagueView.hidden = YES;
        [[[UIApplication  sharedApplication] keyWindow] addSubview:_vagueView] ;
        
        UIButton *partFaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vagueView addSubview:partFaultBtn];
        partFaultBtn.sd_layout.topSpaceToView(_vagueView, 477 * 2 * screenHeight).leftSpaceToView(_vagueView, 0).rightSpaceToView(_vagueView, 0).heightIs(60);
        [partFaultBtn setBackgroundColor:[UIColor whiteColor]];
        [partFaultBtn setTitle:@"零配件故障" forState:UIControlStateNormal];
        [partFaultBtn setTitleColor:UIColorWithRGBA(107, 107, 107, 1) forState:UIControlStateNormal];
        partFaultBtn.titleLabel.font = CFFONT15;
        [partFaultBtn addTarget:self action:@selector(partBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *commonFaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vagueView addSubview:commonFaultBtn];
        commonFaultBtn.sd_layout.topSpaceToView(partFaultBtn, 1).leftSpaceToView(_vagueView, 0).rightSpaceToView(_vagueView, 0).heightIs(60);
        [commonFaultBtn setBackgroundColor:[UIColor whiteColor]];
        [commonFaultBtn setTitle:@"普通故障" forState:UIControlStateNormal];
        [commonFaultBtn setTitleColor:UIColorWithRGBA(107, 107, 107, 1) forState:UIControlStateNormal];
        commonFaultBtn.titleLabel.font = CFFONT15;
        [commonFaultBtn addTarget:self action:@selector(commonBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vagueView addSubview:cancelBtn];
        cancelBtn.sd_layout.topSpaceToView(commonFaultBtn, 10).leftSpaceToView(_vagueView, 0).rightSpaceToView(_vagueView, 0).heightIs(60);
        [cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.titleLabel.font = CFFONT15;
    }
    return _vagueView;
}
- (instancetype)initWithType:(NSInteger)type
{
    if ([super init]) {
        self.type = type;
        [self createView];
    }
    return self;
}
- (void)createView
{
    UILabel *headerLineLabel = [[UILabel alloc]init];
    [self addSubview:headerLineLabel];
    headerLineLabel.sd_layout.leftSpaceToView(self, 15).topSpaceToView(self, 0).heightIs(1).rightSpaceToView(self, 15);
    headerLineLabel.backgroundColor = UIColorWithRGBA(175, 175, 175, 1);
    
    UILabel *footerLineLabel = [[UILabel alloc]init];
    [self addSubview:footerLineLabel];
    footerLineLabel.sd_layout.leftSpaceToView(self, 15).bottomSpaceToView(self, 0).heightIs(1).rightSpaceToView(self, 15);
    footerLineLabel.backgroundColor = UIColorWithRGBA(175, 175, 175, 1);
    
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_titleBtn];
    _titleBtn.sd_layout.topSpaceToView(self, 0).leftSpaceToView(self, 34).heightIs(60).widthIs(100);
    [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    _titleBtn.titleLabel.font = CFFONT14;
    [_titleBtn setTitleColor:UIColorWithRGBA(107, 107, 107, 1) forState:UIControlStateNormal];
    [_titleBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    __block UITextField *partNameText = [[UITextField alloc]init];
    [self addSubview:partNameText];
    partNameText.sd_layout.leftSpaceToView(self, 34).topSpaceToView(_titleBtn, 0).heightIs(60).widthIs(250);
    partNameText.font = CFFONT14;
    partNameText.textColor = UIColorWithRGBA(107, 107, 107, 1);
    partNameText.placeholder = @"扫描故障零配件条码";
    
    __block UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:scanBtn];
    scanBtn.sd_layout.topSpaceToView(_titleBtn, 20).rightSpaceToView(self, 25).heightIs(20).widthIs(20);
    
    _reasonView = [[CFReasonTextView alloc]init];
    [self addSubview:_reasonView];
    _reasonView.placeholder = @"请简短描述农机故障原因" ;
    _reasonView.delegate = self;
    _reasonView.editable = YES;
    _reasonView.maxNumberOfLines = 10;
    _reasonView.font = CFFONT13;
    
    switch (_type) {
        case 1:
            [_titleBtn setTitle:@"普通故障" forState:UIControlStateNormal];;
            partNameText.hidden = YES;
            scanBtn.hidden = YES;
            _reasonView.sd_layout.leftSpaceToView(self, 34).topSpaceToView(self, 60).rightSpaceToView(self, 34).heightIs(237);
            _reasonView.placeholderView.sd_layout.leftSpaceToView(_reasonView, 0).topSpaceToView(_reasonView, 0).rightSpaceToView(_reasonView, 0).heightIs(_reasonView.height);
            break;
        case 0:
            [_titleBtn setTitle:@"零配件故障" forState:UIControlStateNormal];
            partNameText.hidden = NO;
            scanBtn.hidden = NO;
            _reasonView.sd_layout.leftSpaceToView(self, 34).topSpaceToView(self, 120).rightSpaceToView(self, 34).heightIs(237);
            _reasonView.placeholderView.sd_layout.leftSpaceToView(_reasonView, 0).topSpaceToView(_reasonView, 0).rightSpaceToView(_reasonView, 0).heightIs(_reasonView.height);
            break;
        default:
            break;
    }
    __block CFFaultView *weakSelf = self;
    self.changeViewBlock = ^(NSInteger type) {
        
            weakSelf.type = type;
            switch (type) {
                case 1:
                    [weakSelf.titleBtn setTitle:@"普通故障" forState:UIControlStateNormal];;
                    partNameText.hidden = YES;
                    scanBtn.hidden = YES;
                    weakSelf.reasonView.sd_layout.leftSpaceToView(weakSelf, 34).topSpaceToView(weakSelf, 60).rightSpaceToView(weakSelf, 34).heightIs(237);
//                    weakSelf.bodyView.sd_layout.heightIs(weakSelf.bodyView.height - 60);
                    weakSelf.sd_layout.heightIs(298);
                    weakSelf.sd_layout.yIs(358);
                    break;
                case 0:
                    [weakSelf.titleBtn setTitle:@"零配件故障" forState:UIControlStateNormal];
                    partNameText.hidden = NO;
                    scanBtn.hidden = NO;
                    weakSelf.reasonView.sd_layout.leftSpaceToView(weakSelf, 34).topSpaceToView(weakSelf, 120).rightSpaceToView(weakSelf, 34).heightIs(237);
//                    weakSelf.bodyView.sd_layout.heightIs(weakSelf.bodyView.height + 60);
                    weakSelf.sd_layout.heightIs(358);
                    weakSelf.sd_layout.yIs(418);
                    break;
                default:
                    break;
            }
        
    };
    __block UILabel *textNumberLabel = [[UILabel alloc]init];
    [_reasonView addSubview:textNumberLabel];
    textNumberLabel.sd_layout.bottomSpaceToView(_reasonView, 20).rightSpaceToView(_reasonView, 0).heightIs(10);
    [textNumberLabel setSingleLineAutoResizeWithMaxWidth:100];
    textNumberLabel.textAlignment = NSTextAlignmentRight;
    textNumberLabel.textColor = [UIColor grayColor];
    textNumberLabel.font = CFFONT10;
    textNumberLabel.text = [NSString stringWithFormat:@"0/%d", MAX_LIMIT_NUMS];
    
    self.textNumberBlock = ^(NSInteger number) {
        textNumberLabel.text = [NSString stringWithFormat:@"%ld/%d", (long)number, MAX_LIMIT_NUMS];
    };
}
- (void)titleBtnClick
{
    self.vagueView.hidden = NO;
}
- (void)partBtnClick
{
    self.vagueView.hidden = YES;
    if (self.type == 0) {
        
    } else {
        self.changeViewBlock(0);
        self.changeFrameBlock(0);
    }
}
- (void)commonBtnClick
{
    self.vagueView.hidden = YES;

    if (self.type == 1) {
        
    } else {
        self.changeViewBlock(1);
        self.changeFrameBlock(1);
    }
}
- (void)cancelBtnClick
{
    self.vagueView.hidden = YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            //            self.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)MAX_LIMIT_NUMS, (long)MAX_LIMIT_NUMS];
            self.textNumberBlock(MAX_LIMIT_NUMS);
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    //    self.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0, existTextNum),MAX_LIMIT_NUMS];
    self.textNumberBlock(MAX(0, existTextNum));
}
@end
