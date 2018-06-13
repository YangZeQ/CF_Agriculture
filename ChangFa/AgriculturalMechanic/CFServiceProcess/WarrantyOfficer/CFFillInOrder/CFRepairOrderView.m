//
//  CFRepairOrderView.m
//  ChangFa
//
//  Created by yang on 2018/6/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairOrderView.h"
#import "CFFaultView.h"
#import "CFRepairsPhotoCell.h"
#import "AddMachineCollectionViewCell.h"

typedef void(^textNumberBlock)(NSInteger number);

@interface CFRepairOrderView ()<UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, assign)FillViewStyle viewStyle;
@property (nonatomic, assign)NSInteger viewTag;

@property (nonatomic, strong)UIView *vagueView;
@property (nonatomic, strong)UIView *faultView;
@property (nonatomic, strong)CFRepairsPhotoCell *photoCell;
@property (nonatomic, strong)AddMachineCollectionViewCell *addCell;

@property (nonatomic, copy)textNumberBlock textNumberBlock;
@end

@implementation CFRepairOrderView

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
- (NSMutableArray *)partInfoArray
{
    if (_partInfoArray == nil) {
        _partInfoArray = [NSMutableArray array];
    }
    return _partInfoArray;
}
- (NSMutableArray *)photoArray
{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (CFRegisterTextFieldView *)hourTextField
{
    if (_hourTextField == nil) {
        _hourTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(30 * screenWidth, 0, CF_WIDTH - 120 * screenWidth, 98 * screenHeight) LabelWidth:278 * screenWidth LabelName:@"农机工作小时(h)   ：" PlaceHolder:@"请输入农机工作小时"];
        _hourTextField.textField.delegate = self;
        _hourTextField.textField.tag = 1001;
        _hourTextField.textField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _hourTextField;
}
- (CFRegisterTextFieldView *)mileageTextField
{
    if (_mileageTextField == nil) {
        _mileageTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(30 * screenWidth, 98 * screenHeight, CF_WIDTH - 120 * screenWidth, _hourTextField.frame.size.height) LabelWidth:278 * screenWidth LabelName:@"农机行驶里程(km)：" PlaceHolder:@"请输入行驶里程"];
        _mileageTextField.textField.delegate = self;
        _mileageTextField.textField.tag = 1002;
        _mileageTextField.textField.keyboardType = UIKeyboardTypePhonePad;
        _mileageTextField.lineLabel.hidden = YES;
    }
    return _mileageTextField;
}
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
    _statusImage.sd_layout.widthIs(15).topSpaceToView(self, 23).heightIs(15).rightSpaceToView(self, 22);
    _statusImage.image = [UIImage imageNamed:@"CF_CloseBtn"];
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
    _bodyView.sd_layout.heightIs(300 * screenHeight);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(30 * screenWidth, 50 * screenHeight, CF_WIDTH - 100 * screenWidth, 200 * screenHeight) collectionViewLayout:layout];
    _photoCollectionView.backgroundColor = [UIColor whiteColor];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(200 * screenWidth, 200 * screenHeight);
    layout.minimumLineSpacing = 10 * screenWidth;
    layout.minimumInteritemSpacing = 0 * screenWidth;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _photoCollectionView.showsHorizontalScrollIndicator = NO;
    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    [_photoCollectionView registerClass:[CFRepairsPhotoCell class] forCellWithReuseIdentifier:@"repairsPhotoCellId"];
    [_photoCollectionView registerClass:[AddMachineCollectionViewCell class] forCellWithReuseIdentifier:@"addRepairsPhotoCellId"];
    [_bodyView addSubview:_photoCollectionView];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.photoArray.count > 0) {
        self.titleLabel.textColor = ChangfaColor;
        self.statuslabel.hidden = NO;
    } else {
        self.titleLabel.textColor = UIColorWithRGBA(107, 107, 107, 1);
        self.statuslabel.hidden = YES;
    }
    return self.photoArray.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        _addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addRepairsPhotoCellId" forIndexPath:indexPath];
        _addCell.imageName= @"CF_Repairs_AddPhoto";
        return _addCell;
    }
    _photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"repairsPhotoCellId" forIndexPath:indexPath];
    _photoCell.deleteButton.hidden = NO;
    _photoCell.deleteButton.tag = 1000 + indexPath.row - 1;
    if ([self.photoArray[indexPath.row - 1] isKindOfClass:[NSString class]]) {
        [_photoCell.repairsPhoto sd_setImageWithURL:[NSURL URLWithString:self.photoArray[indexPath.row - 1]] placeholderImage:[UIImage imageNamed:@""]];
    } else {
        _photoCell.repairsPhoto.image = self.photoArray[indexPath.row - 1];
    }
    [_photoCell.deleteButton addTarget:self action:@selector(deletebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return _photoCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.addImageBlock();
}
- (void)deletebuttonClick:(UIButton *)sender
{
    
}
- (void)createMachineInfoView
{
    _bodyView.sd_layout.heightIs(200 * screenHeight);
    [_bodyView addSubview:self.hourTextField];
    [_bodyView addSubview:self.mileageTextField];
}
- (void)createResonView
{
    _bodyView.sd_layout.heightIs(448 * screenHeight);
    _reasonView = [[CFReasonTextView alloc]init];
    [_bodyView addSubview:_reasonView];
    _reasonView.delegate = self;
    _reasonView.editable = YES;
    _reasonView.maxNumberOfLines = 10;
    _reasonView.font = CFFONT13;
    _reasonView.sd_layout.topSpaceToView(_bodyView, 0).leftSpaceToView(_bodyView, 32 * screenWidth).rightSpaceToView(_bodyView, 32 * screenWidth).heightIs(448 * screenHeight);
    _reasonView.placeholderView.sd_layout.leftSpaceToView(_reasonView, 0).topSpaceToView(_reasonView, 0).rightSpaceToView(_reasonView, 0).heightIs(_reasonView.height);
    _reasonView.enablesReturnKeyAutomatically = NO;
    _reasonView.returnKeyType = UIReturnKeyDone;
}
- (void)createPartsView
{
    self.viewTag = 1000;
    _bodyView.sd_layout.heightIs(60);
    _partTypeView = [[UIView alloc]init];
    [_bodyView addSubview:_partTypeView];
    _partTypeView.sd_layout.leftSpaceToView(_bodyView, 0).heightIs(60).rightSpaceToView(_bodyView, 0).bottomSpaceToView(_bodyView, 0);
    UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_partTypeView addSubview:typeBtn];
    typeBtn.sd_layout.heightIs(60).leftSpaceToView(_partTypeView, 0).rightSpaceToView(_partTypeView, 0).bottomSpaceToView(_partTypeView, 0);
    typeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    typeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 34 * screenWidth, 0, 0);
    [typeBtn setTitle:@"选择类型" forState:UIControlStateNormal];
    [typeBtn setTitleColor:UIColorWithRGBA(175, 175, 175, 1) forState:UIControlStateNormal];;
    typeBtn.titleLabel.font = CFFONT14;
    [typeBtn addTarget:self action:@selector(typeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)addMachineFaultViewWithType:(FaultType)type
                     infoDictionary:(NSDictionary *)dcit
{
    self.viewTag++;
    __block CFFaultView *faultView = [[CFFaultView alloc]initWithType:type];
    [_bodyView addSubview:faultView];
    faultView.tag = self.viewTag;
    

    CFFaultView *fault = [self viewWithTag:self.viewTag - 1];
    switch (type) {
        case FaultTypeCommon:
            _bodyView.sd_layout.heightIs(_bodyView.height + 298);
            faultView.sd_layout.leftSpaceToView(_bodyView, 0).topSpaceToView(fault, 0).rightSpaceToView(_bodyView, 0).heightIs(298);
            break;
        case FaultTypePart:
            _bodyView.sd_layout.heightIs(_bodyView.height + 358);
            faultView.sd_layout.leftSpaceToView(_bodyView, 0).topSpaceToView(fault, 0).rightSpaceToView(_bodyView, 0).heightIs(358);
            break;
        default:
            break;
    }
    
    self.sd_layout.heightIs(60 + _bodyView.height);
    
    __block CFRepairOrderView *weakSelf = self;
    faultView.changeFrameBlock = ^(NSInteger type) {
        switch (type) {
            case 0:
                _bodyView.sd_layout.heightIs(_bodyView.height + 60);
                weakSelf.sd_layout.heightIs(weakSelf.height + 60);
                break;
            case 1:
                _bodyView.sd_layout.heightIs(_bodyView.height - 60);
                weakSelf.sd_layout.heightIs(weakSelf.height - 60);
                break;
            default:
                break;
        }
    };
    if (!(dcit == nil)) {
        faultView.partNameText.text = [dcit objectForKey:@"partNo"];
        faultView.reasonView.text = [dcit objectForKey:@"faultDes"];
        faultView.reasonView.placeholder = @"";
        self.sd_layout.heightIs(60);
        _bodyView.hidden = YES;
    }
}
#pragma mark -选择故障类型
- (void)typeBtnClick
{
    self.vagueView.hidden = NO;
}
- (void)partBtnClick
{
    self.vagueView.hidden = YES;
    [self addMachineFaultViewWithType:FaultTypePart infoDictionary:nil];
}
- (void)commonBtnClick
{
    self.vagueView.hidden = YES;
    [self addMachineFaultViewWithType:FaultTypeCommon infoDictionary:nil];
}
- (void)cancelBtnClick
{
    self.vagueView.hidden = YES;
}
- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        _bodyView.hidden = NO;
        self.sd_layout.heightIs(60 + _bodyView.height);
        _statusImage.image = [UIImage imageNamed:@"CF_OpenBtn"];
    } else {
        self.sd_layout.heightIs(60);
        _bodyView.hidden = YES;
        _statusImage.image = [UIImage imageNamed:@"CF_CloseBtn"];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.titleLabel.textColor = ChangfaColor;
        self.statuslabel.hidden = NO;
    } else {
        self.titleLabel.textColor = UIColorWithRGBA(107, 107, 107, 1);
        self.statuslabel.hidden = YES;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_hourTextField.textField.text.length > 0 && _mileageTextField.textField.text.length > 0) {
        self.titleLabel.textColor = ChangfaColor;
        self.statuslabel.hidden = NO;
    } else {
        self.titleLabel.textColor = UIColorWithRGBA(107, 107, 107, 1);
        self.statuslabel.hidden = YES;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }

    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return NO;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end
