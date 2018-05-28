//
//  CFFillInOrderViewTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/3/21.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFFillInOrderViewTableViewCell.h"
#import "AddMachineCollectionViewCell.h"
#import "CFPreviewPhotoViewController.h"

#define MAX_LIMIT_NUMS 150
@interface CFFillInOrderViewTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong)UIImageView *editImage;

@property (nonatomic, strong)AddMachineCollectionViewCell *addCell;
@property (nonatomic, strong)UIButton *submitBackButton;
@property (nonatomic, strong)NSString *textInfo;

@end
@implementation CFFillInOrderViewTableViewCell
- (UILabel *)orderInfoLabel
{
    if (_orderInfoLabel == nil) {
        _orderInfoLabel = [[UILabel alloc]init];
    }
    return _orderInfoLabel;
}
- (UICollectionView *)photoColleectionView
{
    if (_photoColleectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _photoColleectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(30 * screenWidth, 120 * screenHeight, _orderInfoLabel.frame.size.width - 60 * screenWidth, 200 * screenHeight) collectionViewLayout:layout];
        _photoColleectionView.backgroundColor = [UIColor whiteColor];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(200 * screenWidth, 200 * screenHeight);
        layout.minimumLineSpacing = 10 * screenWidth;
        layout.minimumInteritemSpacing = 0 * screenWidth;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _photoColleectionView.showsHorizontalScrollIndicator = NO;
        _photoColleectionView.delegate = self;
        _photoColleectionView.dataSource = self;
        [_photoColleectionView registerClass:[CFRepairsPhotoCell class] forCellWithReuseIdentifier:@"repairsPhotoCellId"];
        [_photoColleectionView registerClass:[AddMachineCollectionViewCell class] forCellWithReuseIdentifier:@"addRepairsPhotoCellId"];
        [_orderInfoLabel addSubview:_photoColleectionView];
    }
    return _photoColleectionView;
}
- (CFReasonTextView *)reasonView
{
    if (_reasonView == nil) {
        _reasonView = [[CFReasonTextView alloc]initWithFrame:CGRectMake(30 * screenWidth, 100 * screenHeight, _orderInfoLabel.frame.size.width - 60 * screenWidth, 282 * screenHeight)];
        _reasonView.delegate = self;
//        _reasonView.layer.cornerRadius = 20 * screenWidth;
        _reasonView.editable = YES;
        _reasonView.maxNumberOfLines = 10;
//        _reasonView.backgroundColor = BackgroundColor;
        _reasonView.font = CFFONT13;
        [_orderInfoLabel addSubview:_reasonView];
        
        _textNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_reasonView.frame.size.width - 100 * screenWidth, _reasonView.frame.size.height - 20 * screenHeight, 100 * screenWidth, 20 * screenHeight)];
        _textNumberLabel.textAlignment = NSTextAlignmentRight;
        _textNumberLabel.textColor = [UIColor grayColor];
        _textNumberLabel.font = CFFONT12;
        _textNumberLabel.text = [NSString stringWithFormat:@"0/%d", MAX_LIMIT_NUMS];
        [_reasonView addSubview:_textNumberLabel];
    }
    return _reasonView;
}
- (CFRegisterTextFieldView *)hourTextField
{
    if (_hourTextField == nil) {
        _hourTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(30 * screenWidth, 120 * screenHeight, _orderInfoLabel.frame.size.width - 60 * screenWidth, 98 * screenHeight) LabelWidth:278 * screenWidth LabelName:@"农机工作小时(h)   ：" PlaceHolder:@"请输入农机工作小时"];
        _hourTextField.textField.delegate = self;
        _hourTextField.textField.tag = 1001;
        _hourTextField.textField.keyboardType = UIKeyboardTypePhonePad;
        [_orderInfoLabel addSubview:_hourTextField];
    }
    return _hourTextField;
}
- (CFRegisterTextFieldView *)mileageTextField
{
    if (_mileageTextField == nil) {
        _mileageTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(30 * screenWidth, 120 * screenHeight + 98 * screenHeight, _orderInfoLabel.frame.size.width - 60 * screenWidth, _hourTextField.frame.size.height) LabelWidth:278 * screenWidth LabelName:@"农机行驶里程(km)：" PlaceHolder:@"请输入行驶里程"];
        _mileageTextField.textField.delegate = self;
        _mileageTextField.textField.tag = 1002;
        _mileageTextField.textField.keyboardType = UIKeyboardTypePhonePad;
        [_orderInfoLabel addSubview:_mileageTextField];
    }
    return _mileageTextField;
}
- (NSMutableArray *)photoArray
{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createOrderViewCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createOrderViewCell
{
    self.contentView.backgroundColor = BackgroundColor;
    self.orderInfoLabel.frame = CGRectMake(30 * screenWidth, 0, CF_WIDTH - 60 * screenWidth, 120 * screenHeight);
    self.orderInfoLabel.userInteractionEnabled = YES;
    self.styleStatus = 0;
    _cellType = 1;
    _orderInfoLabel.userInteractionEnabled = YES;
    _orderInfoLabel.backgroundColor = [UIColor whiteColor];
    _orderInfoLabel.layer.cornerRadius = 20 * screenWidth;
    _orderInfoLabel.userInteractionEnabled = YES;
    [_orderInfoLabel.layer setMasksToBounds:YES];
    [self.contentView addSubview:_orderInfoLabel];
    
    _starImage = [[UIImageView alloc]initWithFrame:CGRectMake(40 * screenWidth, 50 * screenHeight, 20 * screenWidth, 20 * screenHeight)];
    _starImage.image = [UIImage imageNamed:@"CF_StarImage"];
    _starImage.userInteractionEnabled = YES;
    [_orderInfoLabel addSubview:_starImage];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_starImage.frame.size.width + _starImage.frame.origin.x + 10 * screenWidth, 35 * screenHeight, 250 * screenWidth, 50 * screenWidth)];
    _nameLabel.userInteractionEnabled = YES;
    _nameLabel.font = CFFONT14;
    [_orderInfoLabel addSubview:_nameLabel];
    
    _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderInfoLabel.frame.size.width - 425 * screenWidth, _nameLabel.frame.origin.y, 350 * screenWidth, 50 * screenWidth)];
    _statusLabel.userInteractionEnabled = YES;
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.font = CFFONT14;
    _statusLabel.text = @"完成";
    _statusLabel.textColor = [UIColor grayColor];
    [_orderInfoLabel addSubview:_statusLabel];
    
    _editImage = [[UIImageView alloc]initWithFrame:CGRectMake(_orderInfoLabel.frame.size.width - 60 * screenWidth, 45 * screenHeight, 15 * screenWidth, 30 * screenHeight)];
    _editImage.image = [UIImage imageNamed:@"xiugai"];
    _editImage.userInteractionEnabled = YES;
    [_orderInfoLabel addSubview:_editImage];
    
}
- (void)setStyleStatus:(NSInteger)styleStatus
{
    _styleStatus = styleStatus;
    switch (styleStatus) {
        case 0:
            [self packupView];
            break;
        case 1:
            [self addPhotoView];
            break;
        case 2:
            [self editInfoView];
            break;
        case 3:
            [self textFiledInfoView];
        default:
            break;
    }
}
- (void)packupView
{
    _orderInfoLabel.frame = CGRectMake(30 * screenWidth, 0, CF_WIDTH - 60 * screenWidth, 120 * screenHeight);
    self.photoColleectionView.hidden = YES;
    self.reasonView.hidden = YES;
    self.editImage.frame = CGRectMake(_orderInfoLabel.frame.size.width - 60 * screenWidth, 45 * screenHeight, 15 * screenWidth, 30 * screenHeight);
    self.editImage.image = [UIImage imageNamed:@"xiugai"];
}
- (void)addPhotoView
{
    _orderInfoLabel.frame = CGRectMake(30 * screenWidth, 0, CF_WIDTH - 60 * screenWidth, 412 * screenHeight);
    self.photoColleectionView.hidden = NO;
    self.editImage.frame = CGRectMake(_orderInfoLabel.frame.size.width - 67.5 * screenWidth, (45 + 7.5) * screenHeight, 30 * screenWidth, 15 * screenHeight);
    self.editImage.image = [UIImage imageNamed:@"CF_Progress_Button"];
}
- (void)editInfoView
{
    _orderInfoLabel.frame = CGRectMake(30 * screenWidth, 0, CF_WIDTH - 60 * screenWidth, 412 * screenHeight);
    self.reasonView.hidden = NO;
    self.editImage.frame = CGRectMake(_orderInfoLabel.frame.size.width - 67.5 * screenWidth, (45 + 7.5) * screenHeight, 30 * screenWidth, 15 * screenHeight);
    self.editImage.image = [UIImage imageNamed:@"CF_Progress_Button"];
}
- (void)textFiledInfoView
{
    _orderInfoLabel.frame = CGRectMake(30 * screenWidth, 0, CF_WIDTH - 60 * screenWidth, 316 * screenHeight);
    self.hourTextField.hidden = NO;
    self.mileageTextField.hidden = NO;
    self.editImage.frame = CGRectMake(_orderInfoLabel.frame.size.width - 67.5 * screenWidth, (45 + 7.5) * screenHeight, 30 * screenWidth, 15 * screenHeight);
    self.editImage.image = [UIImage imageNamed:@"CF_Progress_Button"];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_cellType == 1) {
        return self.photoArray.count + 1;
    } else {
        return self.photoArray.count;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    _photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"repairsPhotoCellId" forIndexPath:indexPath];
    if (indexPath.row == 0 && _cellType == 1) {
        _addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addRepairsPhotoCellId" forIndexPath:indexPath];
        _addCell.imageName= @"CF_Repairs_AddPhoto";
//        _addCell.style = 1;
        return _addCell;
    }
    _photoCell.deleteButton.hidden = NO;
    _photoCell.deleteButton.tag = 1000 + indexPath.row - 1;
    [_photoCell.deleteButton addTarget:self action:@selector(deletebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (_cellType >= 1 && indexPath.row > 0) {
        if ([[[NSString stringWithFormat:@"%@", _photoArray[indexPath.row - 1]] substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"http"]) {
            [_photoCell.repairsPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.photoArray[indexPath.row - 1]]] placeholderImage:[UIImage imageNamed:@"CF_RepairImage"]];
        } else {
            _photoCell.repairsPhoto.image = _photoArray[indexPath.row - 1];
        }
    } else {
//        _photoCell.deleteButton.hidden = YES;
        [_photoCell.repairsPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.photoArray[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"CF_RepairImage"]];
    }
    if (_cellType >= 1 ) {
        _photoCell.deleteButton.hidden = NO;
    }
    return _photoCell;
}
- (void)deletebuttonClick:(UIButton *)sender
{
    self.deleteImageBlock(sender.tag - 1000);
    [self.photoColleectionView reloadData];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellStyle == 1) {
        self.clickImageBlock(indexPath.row - 1);
    } else {
        if (self.photoArray.count < 9 && indexPath.row == 0) {
            self.itemBlock();
        } else {
            self.clickImageBlock(indexPath.row);
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"edit");
    self.textEditBlock(1);
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    _textInfo = textView.text;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_textInfo.length > 0) {
            self.textInfoBlock(_textInfo, _cellIndex);
            self.nameLabel.textColor = ChangfaColor;
            self.statusLabel.hidden = NO;
        } else {
            self.statusLabel.hidden = YES;
            self.nameLabel.textColor = [UIColor blackColor];
        }
        self.textEditBlock(0);
    });
}
- (void)setReasonPlaceholder:(NSString *)reasonPlaceholder
{
    _reasonView.placeholder = reasonPlaceholder;
}
- (void)setReloadPhotoArray:(NSMutableArray *)reloadPhotoArray
{
    _photoArray = reloadPhotoArray;
    [self.photoColleectionView reloadData];
}
- (void)setInfoType:(NSInteger)infoType
{
    _infoType = infoType;
}
- (void)setCellType:(NSInteger)cellType
{
    _cellType = cellType;
    [self.photoColleectionView reloadData];
}
- (void)setCellIndex:(NSInteger)cellIndex
{
    _cellIndex = cellIndex;
}
- (void)setOriginX:(double)originX
{
    CGRect nameRect = self.nameLabel.frame;
    self.nameLabel.frame = CGRectMake(originX, nameRect.origin.y, nameRect.size.width, nameRect.size.height);
}
- (void)submitBackButtonClick
{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length > 7) {
        textField.text = [textField.text substringToIndex:7];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _textInfo = textField.text;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_textInfo.length > 0) {
            self.textInfoBlock(_textInfo, textField.tag);
            if (_hourTextField.textField.text.length > 0 && _mileageTextField.textField.text.length > 0) {
                self.nameLabel.textColor = ChangfaColor;
                self.statusLabel.hidden = NO;
            } else {
                self.statusLabel.hidden = YES;
                self.nameLabel.textColor = [UIColor blackColor];
            }
        }
        self.textEditBlock(0);
    });
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
            self.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)MAX_LIMIT_NUMS, (long)MAX_LIMIT_NUMS];
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
    self.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0, existTextNum),MAX_LIMIT_NUMS];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
