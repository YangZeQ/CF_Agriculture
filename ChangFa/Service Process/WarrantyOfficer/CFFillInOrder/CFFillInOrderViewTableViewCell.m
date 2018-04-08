//
//  CFFillInOrderViewTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/3/21.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFFillInOrderViewTableViewCell.h"
#import "AddMachineCollectionViewCell.h"
@interface CFFillInOrderViewTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate>
@property (nonatomic, strong)UIImageView *editImage;

@property (nonatomic, strong)AddMachineCollectionViewCell *addCell;
@property (nonatomic, strong)UIButton *submitBackButton;
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
- (UIButton *)submitButton
{
    if (_submitButton == nil) {
        _submitBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBackButton.frame = CGRectMake(0, _photoColleectionView.frame.size.height + _photoColleectionView.frame.origin.y, _orderInfoLabel.frame.size.width, 412 * screenHeight - (_photoColleectionView.frame.size.height + _photoColleectionView.frame.origin.y));
        [_submitBackButton addTarget:self action:@selector(submitBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_orderInfoLabel addSubview:_submitBackButton];
        
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(_orderInfoLabel.frame.size.width / 2 - 100 * screenWidth, _photoColleectionView.frame.size.height + _photoColleectionView.frame.origin.y + 10 * screenHeight, 200 * screenWidth, 60 * screenHeight);
        _submitButton.layer.cornerRadius = 20 * screenWidth;
        _submitButton.backgroundColor = [UIColor grayColor];
        [_submitButton setEnabled:NO];
        [_submitButton setTitle:@"上传" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_orderInfoLabel addSubview:_submitButton];
    }
    return _submitButton;
}
- (CFReasonTextView *)reasonView
{
    if (_reasonView == nil) {
        _reasonView = [[CFReasonTextView alloc]initWithFrame:CGRectMake(30 * screenWidth, 120 * screenHeight, _orderInfoLabel.frame.size.width - 60 * screenWidth, 282 * screenHeight)];
        _reasonView.delegate = self;
        _reasonView.layer.cornerRadius = 20 * screenWidth;
        _reasonView.editable = YES;
        _reasonView.maxNumberOfLines = 10;
        _reasonView.backgroundColor = BackgroundColor;
        _reasonView.font = CFFONT15;
        [_orderInfoLabel addSubview:_reasonView];
    }
    return _reasonView;
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
    
    _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderInfoLabel.frame.size.width - 175 * screenWidth, _nameLabel.frame.origin.y, 100 * screenWidth, 50 * screenWidth)];
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
        default:
            break;
    }
}
- (void)packupView
{
    _orderInfoLabel.frame = CGRectMake(30 * screenWidth, 0, CF_WIDTH - 60 * screenWidth, 120 * screenHeight);
    self.photoColleectionView.hidden = YES;
    self.submitButton.hidden = YES;
    self.editImage.frame = CGRectMake(_orderInfoLabel.frame.size.width - 60 * screenWidth, 45 * screenHeight, 15 * screenWidth, 30 * screenHeight);
    self.editImage.image = [UIImage imageNamed:@"xiugai"];
}
- (void)addPhotoView
{
    _orderInfoLabel.frame = CGRectMake(30 * screenWidth, 0, CF_WIDTH - 60 * screenWidth, 412 * screenHeight);
    self.photoColleectionView.hidden = NO;
    self.submitButton.hidden = NO;
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
        _addCell.addImageView.image = [UIImage imageNamed:@"CF_Repairs_AddPhoto"];
        _addCell.style = 1;
        return _addCell;
    }
    _photoCell.deleteButton.hidden = NO;
    _photoCell.deleteButton.tag = 1000 + indexPath.row - 1;
    [_photoCell.deleteButton addTarget:self action:@selector(deletebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    if (_cellType) {
//        [_photoCell.repairsPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.photoArray[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"CF_RepairImage"]];
//    } else {
        _photoCell.repairsPhoto.image = self.photoArray[indexPath.row - 1];
//    }
    return _photoCell;
}
- (void)deletebuttonClick:(UIButton *)sender
{
    self.deleteImageBlock(sender.tag - 1000);
    if (self.photoArray.count < 1) {
        _submitButton.backgroundColor = [UIColor grayColor];
        [_submitButton setEnabled:NO];
    }
//    [self.photoArray removeObjectAtIndex:sender.tag - 1000];
    [self.photoColleectionView reloadData];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.photoArray.count < 9 && indexPath.row == 0) {
        self.itemBlock();
    }
}
- (void)editInfoView
{
    _orderInfoLabel.frame = CGRectMake(30 * screenWidth, 0, CF_WIDTH - 60 * screenWidth, 412 * screenHeight);
    self.reasonView.hidden = NO;
    self.editImage.frame = CGRectMake(_orderInfoLabel.frame.size.width - 67.5 * screenWidth, (45 + 7.5) * screenHeight, 30 * screenWidth, 15 * screenHeight);
    self.editImage.image = [UIImage imageNamed:@"CF_Progress_Button"];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"edit");
    self.textEditBlock(1);
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"%@", textView.text);
    NSString *textInfo = textView.text;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (textView.text.length > 0) {
            self.textInfoBlock(textInfo, _cellIndex);
            self.nameLabel.textColor = ChangfaColor;
        } else {
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
- (void)setCellType:(BOOL)cellType
{
    _cellType = cellType;
    [self.photoColleectionView reloadData];
}
- (void)setCellIndex:(NSInteger)cellIndex
{
    _cellIndex = cellIndex;
}
- (void)submitBackButtonClick
{
    
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
