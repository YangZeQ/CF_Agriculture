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

#import "AFHTTPSessionManager.h"
#import <Photos/Photos.h>
#import "CTAssetsPickerController/CTAssetsPickerController.h"

typedef void(^textNumberBlock)(NSInteger number);

@interface CFRepairOrderView ()<UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CTAssetsPickerControllerDelegate>
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
    _statusImage.sd_layout.widthIs(10).topSpaceToView(self, 23).heightIs(15).rightSpaceToView(self, 25);
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
    return _photoArray.count + 1;
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
    _photoCell.repairsPhoto.image = self.photoArray[indexPath.row - 1];
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
}
#pragma mark -选择故障类型
- (void)typeBtnClick
{
    self.vagueView.hidden = NO;
}
- (void)partBtnClick
{
    self.vagueView.hidden = YES;
    [self addMachineFaultViewWithType:FaultTypePart];
}
- (void)commonBtnClick
{
    self.vagueView.hidden = YES;
    [self addMachineFaultViewWithType:FaultTypeCommon];
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
    } else {
        self.sd_layout.heightIs(60);
        _bodyView.hidden = YES;
    }
}

#pragma mark - <CTAssetsPickerControllerDelegate>
-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
    NSInteger max = 9;
    if (picker.selectedAssets.count + self.photoArray.count >= max) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"最多选择%zd张图片", picker.selectedAssets.count] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [picker presentViewController:alert animated:YES completion:nil];
        // 这里不能使用self来modal别的控制器，因为此时self.view不在window上
        return NO;
    }
    return YES;
}
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    // 关闭图片选择界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 基本配置
    CGFloat scale = [UIScreen mainScreen].scale;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode   = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = YES;
    options.networkAccessAllowed = YES;
    // 遍历选择的所有图片
    for (NSInteger i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];
        CGSize size = CGSizeMake(asset.pixelWidth / scale, asset.pixelHeight / scale);
        // 获取图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [self.photoArray addObject:result];
        }];
    }
    
    [self uploadImagesArray];
}
#pragma mark-多图片上传
- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock
{
    // 构造 NSURLRequest
    NSError* error = NULL;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"file":@"",
                             @"userId":[userDefaults objectForKey:@"UserUid"],
//                             @"dispatchId":self.dispatchId,
                             @"token":[userDefaults objectForKey:@"UserToken"],
//                             @"type":[NSString stringWithFormat:@"%lu", (_selectedIndex + 1)],
                             };
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://192.168.31.68:8080/changfa_system/file/manyFileUpload.do?" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"avatar.png" mimeType:@"multipart/form-data"];
    } error:&error];
    
    // 可在此处配置验证信息
    
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    return uploadTask;
}
- (void)uploadImagesArray
{
    self.vagueView.hidden = YES;
    [MBManager showWaitingWithTitle:@"上传图片中"];
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    for (UIImage* image in self.photoArray) {
        [result addObject:[NSNull null]];
    }
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger i = 0; i < self.photoArray.count; i++) {
        
        dispatch_group_enter(group);
        
        NSURLSessionUploadTask* uploadTask = [self uploadTaskWithImage:self.photoArray[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                dispatch_group_leave(group);
            } else {
                NSLog(@"uploadimages%@", response);
                NSLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i] = responseObject;
                }
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传完成!");
        NSInteger ids = 0;
        for (id response in result) {
            NSLog(@"tupian%@", response);
           
            ids++;
        }

    });
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end
