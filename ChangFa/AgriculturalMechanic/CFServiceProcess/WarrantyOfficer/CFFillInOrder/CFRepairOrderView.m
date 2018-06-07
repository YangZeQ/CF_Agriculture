//
//  CFRepairOrderView.m
//  ChangFa
//
//  Created by yang on 2018/6/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairOrderView.h"

#define MAX_LIMIT_NUMS 150

typedef void(^textNumberBlock)(NSInteger number);
@interface CFRepairOrderView ()<UITextViewDelegate, UITextFieldDelegate>
@property (nonatomic, assign)FillViewStyle viewStyle;
//@property (nonatomic, strong)UIView *headerVeiw;

@property (nonatomic, strong)UIView *faultView;
//@property (nonatomic, strong)UIImageView *statusImage;

@property (nonatomic, strong)UIView *bodyView;

@property (nonatomic, copy)textNumberBlock textNumberBlock;
@end
@implementation CFRepairOrderView

- (instancetype)initWithViewStyle:(FillViewStyle)viewStyle
{
    if (self = [super init]) {
        self.viewStyle = viewStyle;
        [self createBaseView];
        switch (viewStyle) {
            case FillViewStylePhoto:
                [self createPhotoView];
                break;
            case FillViewStyleInfo:
                [self createMachineInfoView];
                break;
            case FillViewStyleReason:
                [self createResonView];
                break;
            case FillViewStyleParts:
                [self createPartsView];
                break;
            default:
                break;
        }
    }
    return self;
}
- (void)createBaseView
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10 * screenWidth;
    
    _signImage = [[UIImageView alloc]init];
    [self addSubview:_signImage];
    _signImage.sd_layout.topSpaceToView(self, 26).leftSpaceToView(self, 20).heightIs(10).widthIs(10);
    _signImage.userInteractionEnabled = YES;
    _signImage.image = [UIImage imageNamed:@"CF_StarImage"];
    
    _titleLabel = [[UILabel alloc]init];
    [self addSubview:_titleLabel];
    _titleLabel.sd_layout.leftSpaceToView(self, 34).topSpaceToView(self, 23).heightIs(16);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:100];
    _titleLabel.font = CFFONT14;
    _titleLabel.userInteractionEnabled = YES;
    _titleLabel.textColor = UIColorWithRGBA(107, 107, 107, 1);
    
    _statuslabel = [[UILabel alloc]init];
    [self addSubview:_statuslabel];
    _statuslabel.sd_layout.topSpaceToView(self, 23).rightSpaceToView(self, 47).heightIs(16);
    [_statuslabel setSingleLineAutoResizeWithMaxWidth:30];
    _statuslabel.font = CFFONT14;
    _statuslabel.text = @"完成";
    _statuslabel.userInteractionEnabled = YES;
    _statuslabel.textColor = UIColorWithRGBA(175, 175, 175, 1);
    
    _statusImage = [[UIImageView alloc]init];
    [self addSubview:_statusImage];
    _statusImage.sd_layout.leftSpaceToView(self, 320).topSpaceToView(self, 23).heightIs(15).rightSpaceToView(self, 25);
    _statusImage.image = [UIImage imageNamed:@"xiugai"];
    _statusImage.userInteractionEnabled = YES;
    
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_selectedButton];
    _selectedButton.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).heightIs(60).rightSpaceToView(self, 0);
    
    _bodyView = [[UIView alloc]init];
    [self addSubview:_bodyView];
    _bodyView.sd_layout.topSpaceToView(self, 120 * screenHeight).leftSpaceToView(self, 0).heightIs(300 * screenHeight).rightSpaceToView(self, 0);
}
- (void)createPhotoView
{
    _bodyView.sd_layout.heightIs(150 * screenHeight);
}
- (void)createMachineInfoView
{
    _bodyView.sd_layout.heightIs(100 * screenHeight);
}
- (void)createResonView
{
    _bodyView.sd_layout.heightIs(224);
}
- (void)createPartsView
{
    _bodyView.sd_layout.heightIs(60);
    _partTypeView = [[UIView alloc]init];
    [_bodyView addSubview:_partTypeView];
    _partTypeView.sd_layout.leftSpaceToView(_bodyView, 0).heightIs(60).rightSpaceToView(_bodyView, 0).bottomSpaceToView(_bodyView, 0);
    UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_partTypeView addSubview:typeBtn];
    typeBtn.sd_layout.topSpaceToView(_partTypeView, 0).leftSpaceToView(_partTypeView, 0).rightSpaceToView(_partTypeView, 0).bottomSpaceToView(_partTypeView, 0);
    typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    typeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 34 * screenWidth, 0, 0);
    [typeBtn setTitle:@"选择类型" forState:UIControlStateNormal];
    [typeBtn setTitleColor:UIColorWithRGBA(175, 175, 175, 1) forState:UIControlStateNormal];;
    typeBtn.titleLabel.font = CFFONT14;
    [typeBtn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)addMachineFaultViewWithType:(FaultType)type
{
    UIView *faultView = [[UIView alloc]init];
    [_bodyView addSubview:faultView];
    
    UILabel *headerLineLabel = [[UILabel alloc]init];
    [faultView addSubview:headerLineLabel];
    headerLineLabel.sd_layout.leftSpaceToView(faultView, 15).topSpaceToView(faultView, 0).heightIs(1).rightSpaceToView(faultView, 15);
    headerLineLabel.backgroundColor = UIColorWithRGBA(175, 175, 175, 1);
    
    UILabel *footerLineLabel = [[UILabel alloc]init];
    [faultView addSubview:footerLineLabel];
    footerLineLabel.sd_layout.leftSpaceToView(faultView, 15).bottomSpaceToView(faultView, 0).heightIs(1).rightSpaceToView(faultView, 15);
    footerLineLabel.backgroundColor = UIColorWithRGBA(175, 175, 175, 1);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [faultView addSubview:titleLabel];
    titleLabel.sd_layout.topSpaceToView(faultView, 0).leftSpaceToView(faultView, 34).heightIs(60);
    [titleLabel setSingleLineAutoResizeWithMaxWidth:100];
    titleLabel.font = CFFONT14;
    titleLabel.textColor = UIColorWithRGBA(107, 107, 107, 1);
    
    __block UITextField *partNameText = [[UITextField alloc]init];
    [faultView addSubview:partNameText];
    partNameText.sd_layout.leftSpaceToView(faultView, 34).topSpaceToView(titleLabel, 0).heightIs(60).widthIs(250);
    partNameText.font = CFFONT14;
    partNameText.textColor = UIColorWithRGBA(107, 107, 107, 1);
    partNameText.placeholder = @"扫描故障零配件条码";
    
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [faultView addSubview:scanBtn];
    scanBtn.sd_layout.topSpaceToView(titleLabel, 20).rightSpaceToView(faultView, 25).heightIs(20).widthIs(20);
    
    CFReasonTextView *reasonView = [[CFReasonTextView alloc]init];
    [faultView addSubview:reasonView];
    reasonView.placeholder = @"请简短描述农机故障原因" ;
    reasonView.delegate = self;
    reasonView.editable = YES;
    reasonView.maxNumberOfLines = 10;
    reasonView.font = CFFONT13;
    
    switch (type) {
        case FaultTypeCommon:
            titleLabel.text = @"普通故障";
            partNameText.hidden = YES;
            scanBtn.hidden = YES;
            reasonView.sd_layout.leftSpaceToView(faultView, 34).topSpaceToView(faultView, 60).rightSpaceToView(faultView, 34).heightIs(237);
            _bodyView.sd_layout.heightIs(_bodyView.height + 298);
            NSLog(@"%f", _bodyView.height);
            faultView.sd_layout.topSpaceToView(_bodyView, 0).topSpaceToView(_bodyView, _bodyView.height - 358).rightSpaceToView(_bodyView, 0).heightIs(298);
            break;
        case FaultTypePart:
            titleLabel.text = @"零配件故障";
            partNameText.hidden = NO;
            scanBtn.hidden = NO;
            reasonView.sd_layout.leftSpaceToView(faultView, 34).topSpaceToView(faultView, 120).rightSpaceToView(faultView, 34).heightIs(237);
            _bodyView.sd_layout.heightIs(_bodyView.height + 358);
            NSLog(@"%f", _bodyView.height);
            faultView.sd_layout.topSpaceToView(_bodyView, 0).topSpaceToView(_bodyView, _bodyView.height - 418).rightSpaceToView(_bodyView, 0).heightIs(358);
            break;
        default:
            break;
    }
    
    __block UILabel *textNumberLabel = [[UILabel alloc]init];
    [reasonView addSubview:textNumberLabel];
    textNumberLabel.sd_layout.bottomSpaceToView(reasonView, 20).rightSpaceToView(reasonView, 0).heightIs(10);
    [textNumberLabel setSingleLineAutoResizeWithMaxWidth:100];
    textNumberLabel.textAlignment = NSTextAlignmentRight;
    textNumberLabel.textColor = [UIColor grayColor];
    textNumberLabel.font = CFFONT10;
    textNumberLabel.text = [NSString stringWithFormat:@"0/%d", MAX_LIMIT_NUMS];
    
    
    self.textNumberBlock = ^(NSInteger number) {
        textNumberLabel.text = [NSString stringWithFormat:@"%ld/%d", (long)number, MAX_LIMIT_NUMS];
    };
    
    self.sd_layout.heightIs(60 + _bodyView.height);
    
}
- (void)typeBtnClick
{
    self.chooseTypeBlock();
}
- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        _bodyView.hidden = NO;
        switch (_viewStyle) {
            case FillViewStylePhoto:
                self.sd_layout.heightIs(60 + _bodyView.height);
                break;
            case FillViewStyleInfo:
                self.sd_layout.heightIs(60 + _bodyView.height);
                break;
            case FillViewStyleReason:
                self.sd_layout.heightIs(60 + _bodyView.height);
                break;
            case FillViewStyleParts:
                self.sd_layout.heightIs(60 + _bodyView.height);
                break;
            default:
                break;
        }
    } else {
        self.sd_layout.heightIs(60);
        _bodyView.hidden = YES;
    }
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end
