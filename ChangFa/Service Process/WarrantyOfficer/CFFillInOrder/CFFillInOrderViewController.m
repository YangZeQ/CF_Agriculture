//
//  CFFillInOrderViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/21.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFFillInOrderViewController.h"
#import "CFRegisterTextFieldView.h"
#import "CFFillInOrderViewTableViewCell.h"
#import "CFFillInOrderModel.h"

#import "AFHTTPSessionManager.h"
#import <Photos/Photos.h>
#import "CTAssetsPickerController/CTAssetsPickerController.h"
typedef void(^reloadCollectionItemBlock)(NSMutableArray *photoArray);
@interface CFFillInOrderViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CTAssetsPickerControllerDelegate, UITextFieldDelegate>
@property (nonatomic, strong)CFFillInOrderModel *fillModel;
@property (nonatomic, strong)UIScrollView *fillScrollView;
@property (nonatomic, strong)CFRegisterTextFieldView *hourTextField;
@property (nonatomic, strong)CFRegisterTextFieldView *mileageTextField;
@property (nonatomic, strong)CFRegisterTextFieldView *typeTextField;
@property (nonatomic, strong)UITableView *orderTableView;
@property (nonatomic, strong)UIButton *submitButton;

@property (nonatomic, strong)NSArray *infoArray;
@property (nonatomic, assign)NSInteger selectedIndex; // 点击cell下标
@property (nonatomic, strong)NSMutableArray *signArray; // 存储cell的选定标识
@property (nonatomic, strong)NSArray *styleArray;

@property (nonatomic, strong)UIView *vagueView;
@property (nonatomic, assign)NSInteger vagueViewStyle;   // 1、选择维修类型。2、选择上传图片方式
@property (nonatomic, assign)NSInteger repairStyle;
@property (nonatomic, strong)UIButton *firstStyleButton; //
@property (nonatomic, strong)UIButton *secondStyleButton;

@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *faultPhotoArray;
@property (nonatomic, strong)NSMutableArray *personPhotoArray;
@property (nonatomic, strong)NSMutableArray *faultPhotoPathArray;
@property (nonatomic, strong)NSMutableArray *personPhotoPathArray;
@property (nonatomic, strong)NSString *fileIds;
@property (nonatomic, strong)NSString *faultFileIds;
@property (nonatomic, strong)NSString *personFileIds;
@property (nonatomic, strong)NSString *machineInstruction;
@property (nonatomic, strong)NSString *faultInstruction;
@property (nonatomic, strong)NSString *customerOpinion;
@property (nonatomic, strong)NSString *handleOpinion;
@property (nonatomic, strong)NSString *remarks;

@property (nonatomic, strong)UIImagePickerController *imagePicker;
@property (nonatomic, copy)reloadCollectionItemBlock reloadCollectionItemBlock;
@end

@implementation CFFillInOrderViewController

- (NSArray *)infoArray
{
    if (_infoArray == nil) {
        _infoArray = [NSArray arrayWithObjects:@"故障照片", @"人机合影", @"农机用途说明", @"农机故障说明", @"客户意见", @"处理意见", @"备注", nil];
    }
    return _infoArray;
}
- (NSMutableArray *)signArray
{
    if (_signArray == nil) {
        _signArray = [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, nil];
    }
    return _signArray;
}
- (NSArray *)styleArray
{
    if (_styleArray == nil) {
        _styleArray = [NSArray arrayWithObjects:@1, @1, @2, @2, @2, @2, @2, nil];
    }
    return _styleArray;
}
- (UIView *)vagueView
{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _vagueView.hidden = YES;
        [self.view addSubview:_vagueView];
    }
    return _vagueView;
}
- (NSMutableArray *)photoArray{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (NSMutableArray *)faultPhotoArray{
    if (_faultPhotoArray == nil) {
        _faultPhotoArray = [NSMutableArray array];
    }
    return _faultPhotoArray;
}
- (NSMutableArray *)personPhotoArray{
    if (_personPhotoArray == nil) {
        _personPhotoArray = [NSMutableArray array];
    }
    return _personPhotoArray;
}
- (NSMutableArray *)faultPhotoPathArray
{
    if (_faultPhotoPathArray == nil) {
        _faultPhotoPathArray = [NSMutableArray array];
    }
    return _faultPhotoPathArray;
}
- (NSMutableArray *)personPhotoPathArray
{
    if (_personPhotoPathArray == nil) {
        _personPhotoPathArray = [NSMutableArray array];
    }
    return _personPhotoPathArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.title = @"填写维修单";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    //设置代理
    _imagePicker.delegate=self;
    //可编辑
    
    _imagePicker.allowsEditing=YES;
    [self createFillInOrderView];
    [self getFillInOrderWithReapirId:self.repairId];
    // Do any additional setup after loading the view.
}
- (void)createFillInOrderView
{
    self.selectedIndex = 0;
    [self.signArray replaceObjectAtIndex:self.selectedIndex withObject:@1];
    
    _fillScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _fillScrollView.contentSize = CGSizeMake(0, 1750 * screenHeight);
    _fillScrollView.backgroundColor = BackgroundColor;
    _fillScrollView.delegate = self;
    [self.view addSubview:_fillScrollView];
    
    _hourTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 98 * screenHeight) LabelWidth:278 * screenWidth LabelName:@"农机工作小时" PlaceHolder:@"请输入农机工作小时"];
    _hourTextField.textField.delegate = self;
    _hourTextField.textField.tag = 1001;
     _hourTextField.textField.keyboardType = UIKeyboardTypePhonePad;
    [_fillScrollView addSubview:_hourTextField];
    _mileageTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, _hourTextField.frame.size.height, self.view.frame.size.width, _hourTextField.frame.size.height) LabelWidth:278 * screenWidth LabelName:@"行驶里程" PlaceHolder:@"请输入行驶里程"];
    _mileageTextField.textField.delegate = self;
    _mileageTextField.textField.tag = 1002;
    _mileageTextField.textField.keyboardType = UIKeyboardTypePhonePad;
    [_fillScrollView addSubview:_mileageTextField];
    _typeTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, _mileageTextField.frame.size.height + _mileageTextField.frame.origin.y, self.view.frame.size.width, _hourTextField.frame.size.height) OriginX:30 * screenWidth LabelWidth:308 * screenWidth LabelName:@"维修类型" ButtonImage:@"xiugai"];
    [_typeTextField.selecteButton setTitle:@"请选择维修类型" forState:UIControlStateNormal];
    [_typeTextField.selecteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_typeTextField.selecteButton addTarget:self action:@selector(chooseTypeInfo) forControlEvents:UIControlEventTouchUpInside];
    [_fillScrollView addSubview:_typeTextField];
    
    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _typeTextField.frame.size.height + _typeTextField.frame.origin.y, CF_WIDTH, (120 +  20) * 7 * screenHeight + 292 * screenHeight)];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.showsVerticalScrollIndicator = NO;
    _orderTableView.scrollEnabled = NO;
    _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_fillScrollView addSubview:_orderTableView];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(0, CF_HEIGHT - 100 * screenHeight, CF_WIDTH, 100 * screenHeight);
//    _submitButton.layer.cornerRadius = 20 * Width;
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setBackgroundColor:ChangfaColor];
    [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
    self.vagueView.hidden = YES;
    self.firstStyleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.firstStyleButton.frame = CGRectMake(0, CF_HEIGHT - 312 * screenHeight, CF_WIDTH, 100 * screenHeight);
    self.firstStyleButton.backgroundColor = [UIColor whiteColor];
    self.firstStyleButton.titleLabel.font = CFFONT15;
    [self.firstStyleButton addTarget:self action:@selector(firstStyleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.vagueView addSubview:self.firstStyleButton];
    self.secondStyleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.secondStyleButton.frame = CGRectMake(0, self.firstStyleButton.frame.size.height + self.firstStyleButton.frame.origin.y + 2 * screenHeight, CF_WIDTH, self.firstStyleButton.frame.size.height);
    self.secondStyleButton.backgroundColor = [UIColor whiteColor];
    self.secondStyleButton.titleLabel.font = CFFONT15;
    [self.secondStyleButton addTarget:self action:@selector(secondStyleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.vagueView addSubview:self.secondStyleButton];
    UIButton *cancelStyleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelStyleButton.frame = CGRectMake(0, self.secondStyleButton.frame.size.height + self.secondStyleButton.frame.origin.y + 10 * screenHeight, CF_WIDTH, self.secondStyleButton.frame.size.height);
    cancelStyleButton.backgroundColor = [UIColor whiteColor];
    [cancelStyleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelStyleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelStyleButton addTarget:self action:@selector(cancelStyleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.vagueView addSubview:cancelStyleButton];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.infoArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    CFFillInOrderViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFFillInOrderViewTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.statusLabel.hidden = YES;
    if ([self.signArray[indexPath.section] integerValue] == 1) {
        cell.selected = YES;
        if (indexPath.section > 1) {
            cell.styleStatus = 2;
            cell.cellIndex = indexPath.section;
            cell.reasonPlaceholder = @"点击填写内容";
            cell.textInfoBlock = ^(NSString *textInfo, NSInteger index) {
                [self getTextInfoWithText:textInfo CellIndex:index];
            };
            cell.textEditBlock = ^(NSInteger status){
                [self changeScrollViewOriginYWithStatus:status];
            };
        } else {
            cell.styleStatus = 1;
            cell.itemBlock = ^{
                [self selectedToUploadImage];
            };
            cell.deleteImageBlock = ^(NSInteger sender) {
                [self deleteImage:sender];
            };
            self.reloadCollectionItemBlock = ^(NSMutableArray *photoArray) {
                cell.reloadPhotoArray = photoArray;
            };
            self.uploadImageBlock = ^(BOOL changeStatus){
                if (self.photoArray.count > 0 && changeStatus) {
                    [cell.submitButton setBackgroundColor:ChangfaColor];
                    [cell.submitButton setEnabled:YES];
                } else {
                    [cell.submitButton setBackgroundColor:[UIColor grayColor]];
                    [cell.submitButton setEnabled:NO];
                }
            };
            [cell.submitButton addTarget:self action:@selector(imageUploadButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        cell.styleStatus = 0;
    }    
    cell.nameLabel.text = _infoArray[indexPath.section];
    switch (indexPath.section) {
        case 0:
            if (self.fillModel.faultFilePath.count > 0 || self.faultFileIds.length > 0) {
                cell.nameLabel.textColor =ChangfaColor;
                cell.statusLabel.hidden = NO;
                cell.submitButton.hidden = YES;
                cell.cellType = 0;
            }
            break;
        case 1:
            if (self.fillModel.personFilePath.count > 0 || self.personFileIds.length > 0) {
                cell.nameLabel.textColor =ChangfaColor;
                cell.statusLabel.hidden = NO;
                cell.submitButton.hidden = YES;
                cell.cellType = 0;
            }
            break;
        case 2:
            if (self.fillModel.machineInstruction.length > 0) {
                cell.reasonView.text = self.fillModel.machineInstruction;
                cell.reasonView.placeholder = @"";
                cell.nameLabel.textColor =ChangfaColor;
                cell.statusLabel.hidden = NO;
            }
            if (self.machineInstruction.length > 0) {
                cell.reasonView.text = self.machineInstruction;
                cell.reasonView.placeholder = @"";
                cell.nameLabel.textColor =ChangfaColor;
                cell.statusLabel.hidden = NO;
            }
            break;
        case 3:
            if (self.fillModel.faultInstruction.length > 0) {
                cell.reasonView.text = self.fillModel.faultInstruction;
                cell.reasonView.placeholder = @"";
                cell.nameLabel.textColor =ChangfaColor;
                cell.statusLabel.hidden = NO;
            }
            if (self.faultInstruction.length > 0) {
                cell.reasonView.text = self.faultInstruction;
                cell.reasonView.placeholder = @"";
                cell.nameLabel.textColor =ChangfaColor;
                cell.statusLabel.hidden = NO;
            }
            break;
        case 4:
            if (self.fillModel.customerOpinion.length > 0) {
                cell.reasonView.text = self.fillModel.customerOpinion;
                cell.reasonView.placeholder = @"";
                cell.nameLabel.textColor =ChangfaColor;
                cell.statusLabel.hidden = NO;
            }
            if (self.customerOpinion.length > 0) {
                cell.reasonView.text = self.customerOpinion;
                cell.reasonView.placeholder = @"";
                cell.nameLabel.textColor =ChangfaColor;
                cell.statusLabel.hidden = NO;
            }
            break;
        case 5:
            if (self.fillModel.handleOpinion.length > 0) {
                cell.reasonView.text = self.fillModel.handleOpinion;
                cell.reasonView.placeholder = @"";
                cell.nameLabel.textColor =ChangfaColor;
                cell.statusLabel.hidden = NO;
            }
            if (self.handleOpinion.length > 0) {
                cell.reasonView.text = self.handleOpinion;
                cell.reasonView.placeholder = @"";
                cell.nameLabel.textColor =ChangfaColor;
                cell.statusLabel.hidden = NO;
            }
            break;
        case 6:
            if (self.fillModel.remarks.length > 0) {
                cell.reasonView.text = self.fillModel.remarks;
                cell.reasonView.placeholder = @"";
                cell.nameLabel.textColor =ChangfaColor;
                cell.statusLabel.hidden = NO;
            }
            if (self.remarks.length > 0) {
                cell.reasonView.text = self.remarks;
                cell.reasonView.placeholder = @"";
                cell.nameLabel.textColor =ChangfaColor;
                cell.statusLabel.hidden = NO;
            }
            break;
        default:
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.signArray[indexPath.section] integerValue] == 1) {
        return (120 + 292) * screenHeight;
    }
    return 120 * screenHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _orderTableView.frame.size.width, 20 * screenHeight)];
    headView.backgroundColor = BackgroundColor;
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i < self.signArray.count; i++) {
        [self.signArray replaceObjectAtIndex:i withObject:@0];
    }
    [self.signArray replaceObjectAtIndex:indexPath.section withObject:@1];
    CGRect viewFrame = _orderTableView.frame;
    if (self.selectedIndex == indexPath.section) {// 点击同一个收回
        [self.signArray replaceObjectAtIndex:indexPath.section withObject:@0];
        self.selectedIndex = 1000;
        _orderTableView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, (120 +  20) * 7 * screenHeight);
        [self.orderTableView reloadData];
        return;
    }
    _orderTableView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, (120 +  20) * 7 * screenHeight + 292 * screenHeight);
    [_orderTableView reloadData];
    self.selectedIndex = indexPath.section;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    CFFillInOrderViewTableViewCell *orderInfoCell = [tableView cellForRowAtIndexPath:indexPath];
    orderInfoCell.selected = NO;
    orderInfoCell.styleStatus = 0;
    [self.orderTableView reloadData];
}
// 删除图片
- (void)deleteImage:(NSInteger)sender
{
    if (self.selectedIndex == 0) {
        [self.faultPhotoArray removeObjectAtIndex:sender];
        self.photoArray = self.faultPhotoArray;
    } else {
        [self.personPhotoArray removeObjectAtIndex:sender];
        self.photoArray = self.personPhotoArray;
    }
//    self.reloadCollectionItemBlock(self.photoArray);
}
- (void)chooseTypeInfo
{
    [self.view endEditing:YES];
    self.vagueView.hidden = NO;
    self.vagueViewStyle = 1;
    [_firstStyleButton setTitle:@"普通维修" forState:UIControlStateNormal];
    [_secondStyleButton setTitle:@"外出维修" forState:UIControlStateNormal];
    [_firstStyleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_secondStyleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (void)firstStyleButtonClick
{
    if (_vagueViewStyle == 1) {
        [_typeTextField.selecteButton setTitle:self.firstStyleButton.titleLabel.text forState:UIControlStateNormal];
        [_typeTextField.selecteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.vagueView.hidden = YES;
        self.repairStyle = 0;
    } else {
        if (self.photoArray.count == 9) {
            [MBManager showBriefAlert:@"最多上传9张图片" time:1.5];
            return;
        }
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}
- (void)secondStyleButtonClick
{
    if (_vagueViewStyle == 1) {
        [_typeTextField.selecteButton setTitle:self.secondStyleButton.titleLabel.text forState:UIControlStateNormal];
        [_typeTextField.selecteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.vagueView.hidden = YES;
        self.repairStyle = 1;
    } else {
        if (self.photoArray.count == 9) {
            [MBManager showBriefAlert:@"最多上传9张图片" time:1.5];
            return;
        }
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            if (status != PHAuthorizationStatusAuthorized) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
                picker.delegate = self;
                // 显示选择的索引
                picker.showsSelectionIndex = YES;
                // 设置相册的类型：相机胶卷 + 自定义相册
                picker.assetCollectionSubtypes = @[
                                                   @(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                                   @(PHAssetCollectionSubtypeAlbumRegular)];
                // 不需要显示空的相册
                picker.showsEmptyAlbums = NO;
                [self presentViewController:picker animated:YES completion:nil];
            });
        }];
    }
    
}
- (void)cancelStyleButtonClick
{
    self.vagueView.hidden = YES;
}
- (void)imageUploadButtonClick
{
    [self uploadImagesArray];
}
- (void)submitButtonClick
{
    [self submitOrderInfo];
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    if (self.selectedIndex == 0) {
        [self.faultPhotoArray addObject:image];
        self.photoArray = self.faultPhotoArray;
        self.uploadImageBlock(1);
    } else {
        [self.personPhotoArray addObject:image];
        self.photoArray = self.personPhotoArray;
        self.uploadImageBlock(1);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    self.reloadCollectionItemBlock(self.photoArray);
}
- (void)getTextInfoWithText:(NSString *)textInfo
                  CellIndex:(NSInteger)cellIndex
{
    switch (cellIndex) {
        case 2:
            self.machineInstruction = textInfo;
            break;
        case 3:
            self.faultInstruction = textInfo;
            break;
        case 4:
            self.customerOpinion = textInfo;
            break;
        case 5:
            self.handleOpinion = textInfo;
            break;
        case 6:
            self.remarks = textInfo;
            break;
        default:
            break;
    }
}
- (void)changeScrollViewOriginYWithStatus:(NSInteger)status
{
    if (status == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            _fillScrollView.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            _fillScrollView.frame =CGRectMake(0, -300 * screenHeight, self.view.frame.size.width, self.view.frame.size.height);
        }];
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
            if (self.selectedIndex == 0) {
                [self.faultPhotoArray addObject:result];
            } else {
                [self.personPhotoArray addObject:result];
            }
        }];
    }
    if (self.selectedIndex == 0) {
        self.photoArray = self.faultPhotoArray;
        self.uploadImageBlock(1);
    } else {
        self.photoArray = self.personPhotoArray;
        self.uploadImageBlock(1);
    }
    self.reloadCollectionItemBlock(self.photoArray);
}
#pragma mark-多图片上传
- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock
{
    // 构造 NSURLRequest
    NSError* error = NULL;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"file":@"",
                             @"userId":[userDefaults objectForKey:@"UserUid"],
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
        self.uploadImageBlock(0);
        NSLog(@"上传完成!");
        self.fileIds = @"";
        NSInteger ids = 0;
        for (id response in result) {
            NSLog(@"tupian%@", response);
            if (ids == 0) {
                self.fileIds = [[response objectForKey:@"body"] objectForKey:@"fileIds"];
            } else {
                self.fileIds = [[self.fileIds stringByAppendingString:@","] stringByAppendingString:[[response objectForKey:@"body"] objectForKey:@"fileIds"]];
            }
            ids++;
        }
        switch (self.selectedIndex) {
            case 0:
                self.faultFileIds = self.fileIds;
                break;
            case 1:
                self.personFileIds = self.fileIds;
                break;
            default:
                break;
        }
        NSLog(@"%@", self.fileIds);
    });
}
#pragma mark - 获取已填写维修单信息
- (void)getFillInOrderWithReapirId:(NSString *)repairId
{
    NSDictionary *param = @{
                            @"repairId":repairId,
                            };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"repair/getRepairInfo" Loading:0 Params:param Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"dispatch%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            self.fillModel = [CFFillInOrderModel fillInOrderModelWithDictionary:[[responseObject objectForKey:@"body"] objectForKey:@"result"]];
            [self fillInOrderInfo];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark - 提交维修单信息
//派工单id String disId
//派工单编号 String disNum
//派工类型 String repairType
//故障图片id String faultFileIds
//人机合影图片id String personFileIds
//用户登录token String token
//使用时长 String useTime
//行驶里程 String driveDistance
//农机用途说明 String machineInstruction
//故障描述 String faultInstruction
//客户意见 String customerOpinion
//处理意见 String handleOpinion
- (void)submitOrderInfo
{
    NSString *disIdStr = [NSString stringWithFormat:@"%d", [self.disId intValue]];
    
    if (self.hourTextField.textField.text.length < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入农机工作时长" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    }
    if (self.mileageTextField.textField.text.length < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入农机行驶里程" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    }
    if (_typeTextField.selecteButton.titleLabel.text.length < 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择维修类型" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    }
    if (self.faultFileIds.length < 1) {
        self.faultFileIds = @"";
    }
    if (self.personFileIds.length < 1) {
        self.personFileIds = @"";
    }
    if (self.machineInstruction.length < 1) {
        self.machineInstruction = @"";
    }
    if (self.faultInstruction.length < 1) {
        self.faultInstruction = @"";
    }
    if (self.customerOpinion.length < 1) {
        self.customerOpinion = @"";
    }
    if (self.handleOpinion.length < 1) {
        self.handleOpinion = @"";
    }
    if (self.remarks.length < 1) {
        self.remarks = @"";
    }
    NSLog(@"%@", [self.hourTextField.textField.text stringByReplacingOccurrencesOfString:@" h" withString:@""]);
    NSDictionary *param = @{
                            @"disId":disIdStr,
                            @"disNum":self.disNum,
                            @"repairType":[NSString stringWithFormat:@"%ld", self.repairStyle],
                            @"faultFileIds":self.faultFileIds,
                            @"personFileIds":self.personFileIds,
                            @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserToken"],
                            @"useTime":[self.hourTextField.textField.text stringByReplacingOccurrencesOfString:@" h" withString:@""],
                            @"driveDistance":[self.mileageTextField.textField.text stringByReplacingOccurrencesOfString:@" km" withString:@""],
                            @"machineInstruction":self.machineInstruction,
                            @"faultInstruction":self.faultInstruction,
                            @"customerOpinion":self.customerOpinion,
                            @"handleOpinion":self.handleOpinion,
                            @"remarks":self.remarks,
                            };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"repair/createRepair" Loading:1 Params:param Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"提交成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                for (UIViewController *viewController in self.navigationController.childViewControllers) {
//                    if ([viewController isKindOfClass:[CFRepairsRecordViewController class]]) {
//                        [self.navigationController popToViewController:viewController animated:YES];
//                        return;
//                    }
//                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[[responseObject objectForKey:@"head"]objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)fillInOrderInfo
{
    self.faultFileIds = self.fillModel.faultFileIds;
    self.personFileIds = self.fillModel.personFileIds;
    _hourTextField.textField.text = [NSString stringWithFormat:@"%@ h", _fillModel.useTime];
    _mileageTextField.textField.text = [NSString stringWithFormat:@"%@ km", _fillModel.driveDistance];
    switch ([_fillModel.repairType integerValue]) {
        case 0:
            [_typeTextField.selecteButton setTitle:@"普通维修" forState:UIControlStateNormal];
            break;
        case 1:
            [_typeTextField.selecteButton setTitle:@"外出维修" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [_typeTextField.selecteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.orderTableView reloadData];
    });
}
- (void)selectedToUploadImage
{
    self.vagueView.hidden = NO;
    self.vagueViewStyle = 2;
    [_firstStyleButton setTitle:@"拍照" forState:UIControlStateNormal];
    [_secondStyleButton setTitle:@"从手机相册中选择" forState:UIControlStateNormal];
    [_firstStyleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_secondStyleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1001) {
        [textField.text stringByReplacingOccurrencesOfString:@"h" withString:@""];
        textField.text = [textField.text stringByAppendingString:@" h"];
    } else {
        [textField.text stringByReplacingOccurrencesOfString:@"km" withString:@""];
        textField.text = [textField.text stringByAppendingString:@" km"];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    self.vagueView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
