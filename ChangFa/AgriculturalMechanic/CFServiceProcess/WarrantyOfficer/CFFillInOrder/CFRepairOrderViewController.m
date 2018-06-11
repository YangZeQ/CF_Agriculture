//
//  CFRepairOrderViewController.m
//  ChangFa
//
//  Created by yang on 2018/6/6.
//  Copyright © 2018年 dev. All rights reserved.
//
#import "CFRepairOrderViewController.h"
#import "CFRepairOrderView.h"
#import "CFFaultView.h"

#import "AFHTTPSessionManager.h"
#import <Photos/Photos.h>
#import "CTAssetsPickerController/CTAssetsPickerController.h"
@interface CFRepairOrderViewController ()<CTAssetsPickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong)UIScrollView *repairOrderScroll;
@property (nonatomic, strong)CFRepairOrderView *machineFaultView;
@property (nonatomic, strong)UIImagePickerController *imagePicker;
@property (nonatomic, strong)UIView *vagueView;

@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *groupPhotoArray;
@property (nonatomic, strong)NSMutableArray *faultPhotoArray;
@property (nonatomic, strong)NSMutableArray *groupPhotoIds;
@property (nonatomic, strong)NSMutableArray *faultPhotoIds;
@end

@implementation CFRepairOrderViewController
- (UIView *)vagueView
{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _vagueView.hidden = YES;
        [self.view addSubview:_vagueView];
        
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraBtn.frame = CGRectMake(0, CF_HEIGHT - 312 * screenHeight, CF_WIDTH, 100 * screenHeight);
        cameraBtn.backgroundColor = [UIColor whiteColor];
        cameraBtn.titleLabel.font = CFFONT15;
        [cameraBtn addTarget:self action:@selector(cameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [cameraBtn setTitle:@"拍照" forState:UIControlStateNormal];
        [cameraBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.vagueView addSubview:cameraBtn];
        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        photoBtn.frame = CGRectMake(0, cameraBtn.frame.size.height + cameraBtn.frame.origin.y + 2 * screenHeight, CF_WIDTH, cameraBtn.frame.size.height);
        photoBtn.backgroundColor = [UIColor whiteColor];
        photoBtn.titleLabel.font = CFFONT15;
        [photoBtn addTarget:self action:@selector(photoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [photoBtn setTitle:@"从手机相册中选择" forState:UIControlStateNormal];
        [photoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.vagueView addSubview:photoBtn];
        UIButton *cancelStyleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelStyleButton.frame = CGRectMake(0, photoBtn.frame.size.height + photoBtn.frame.origin.y + 10 * screenHeight, CF_WIDTH, photoBtn.frame.size.height);
        cancelStyleButton.backgroundColor = [UIColor whiteColor];
        [cancelStyleButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelStyleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelStyleButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.vagueView addSubview:cancelStyleButton];
    }
    return _vagueView;
}
- (NSMutableArray *)photoArray
{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (NSMutableArray *)groupPhotoArray
{
    if (_groupPhotoArray == nil) {
        _groupPhotoArray = [NSMutableArray array];
    }
    return _groupPhotoArray;
}
- (NSMutableArray *)faultPhotoArray
{
    if (_faultPhotoArray == nil) {
        _faultPhotoArray = [NSMutableArray array];
    }
    return _faultPhotoArray;
}
- (NSMutableArray *)groupPhotoIds
{
    if (_groupPhotoIds == nil) {
        _groupPhotoIds = [NSMutableArray array];
    }
    return _groupPhotoIds;
}
- (NSMutableArray *)faultPhotoIds
{
    if (_faultPhotoIds == nil) {
        _faultPhotoIds = [NSMutableArray array];
    }
    return _faultPhotoIds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    [self createRepairOrderView];
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    //设置代理
    _imagePicker.delegate = self;
    //可编辑
    _imagePicker.allowsEditing=YES;
    
    // Do any additional setup after loading the view.
}
- (void)createRepairOrderView
{
    __block CFRepairOrderViewController *weakSelf = self;
    self.navigationItem.title = @"填写维修单";
    _repairOrderScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT - navHeight)];
    _repairOrderScroll.contentSize = CGSizeMake(0, 0);
    _repairOrderScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_repairOrderScroll];
    
    CFRepairOrderView *groupPhotoView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStylePhoto];
    [_repairOrderScroll addSubview:groupPhotoView];
    groupPhotoView.sd_layout.leftSpaceToView(_repairOrderScroll, 10).topSpaceToView(_repairOrderScroll, 10).heightIs(60).rightSpaceToView(_repairOrderScroll, 10);
    groupPhotoView.isSelected = NO;
    groupPhotoView.tag = 1001;
    groupPhotoView.selectedButton.tag = 2001;
    groupPhotoView.titleLabel.text = @"人机合影";
    groupPhotoView.statuslabel.hidden = YES;
    [groupPhotoView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    groupPhotoView.addImageBlock = ^{
        [weakSelf addImageClick];
    };
    
    CFRepairOrderView *faultPhotoView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStylePhoto];
    [_repairOrderScroll addSubview:faultPhotoView];
    faultPhotoView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(groupPhotoView, 10).heightIs(60).rightEqualToView(groupPhotoView);
    faultPhotoView.isSelected = NO;
    faultPhotoView.tag = 1002;
    faultPhotoView.selectedButton.tag = 2002;
    faultPhotoView.titleLabel.text = @"故障照片";
    faultPhotoView.statuslabel.hidden = YES;
    [faultPhotoView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    faultPhotoView.addImageBlock = ^{
        [weakSelf addImageClick];
    };
    
    CFRepairOrderView *machineInfoView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleInfo];
    [_repairOrderScroll addSubview:machineInfoView];
    machineInfoView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(faultPhotoView, 10).heightIs(60).rightEqualToView(groupPhotoView);
    machineInfoView.isSelected = NO;
    machineInfoView.tag = 1003;
    machineInfoView.selectedButton.tag = 2003;
    machineInfoView.titleLabel.text = @"农机信息";
    machineInfoView.statuslabel.hidden = YES;
    [machineInfoView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CFRepairOrderView *machineUseView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleReason];
    [_repairOrderScroll addSubview:machineUseView];
    machineUseView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(machineInfoView, 10).heightIs(60).rightEqualToView(groupPhotoView);
    machineUseView.isSelected = NO;
    machineUseView.tag = 1004;
    machineUseView.selectedButton.tag = 2004;
    machineUseView.titleLabel.text = @"农机用途说明";
    machineUseView.reasonView.placeholder = @"请简短描述农机用途说明";
    machineUseView.statuslabel.hidden = YES;
    [machineUseView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _machineFaultView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleParts];
    [_repairOrderScroll addSubview:_machineFaultView];
    _machineFaultView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(machineUseView, 10).heightIs(60).rightEqualToView(groupPhotoView);
    _machineFaultView.isSelected = NO;
    _machineFaultView.tag = 1005;
    _machineFaultView.selectedButton.tag = 2005;
    _machineFaultView.titleLabel.text = @"农机故障说明";
    _machineFaultView.statuslabel.hidden = YES;
    [_machineFaultView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CFRepairOrderView *userOpinionView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleReason];
    [_repairOrderScroll addSubview:userOpinionView];
    userOpinionView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(_machineFaultView, 10).heightIs(60).rightEqualToView(groupPhotoView);
    userOpinionView.isSelected = NO;
    userOpinionView.tag = 1006;
    userOpinionView.selectedButton.tag = 2006;
    userOpinionView.titleLabel.text = @"客户意见";
    userOpinionView.reasonView.placeholder = @"请简短描述客户意见";
    userOpinionView.statuslabel.hidden = YES;
    [userOpinionView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CFRepairOrderView *handleOpinionView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleReason];
    [_repairOrderScroll addSubview:handleOpinionView];
    handleOpinionView.sd_layout.leftEqualToView(groupPhotoView).topSpaceToView(userOpinionView, 10).heightIs(60).rightEqualToView(groupPhotoView);
    handleOpinionView.isSelected = NO;
    handleOpinionView.tag = 1007;
    handleOpinionView.selectedButton.tag = 2007;
    handleOpinionView.titleLabel.text = @"处理意见";
    handleOpinionView.reasonView.placeholder = @"请简短描述处理意见";
    handleOpinionView.statuslabel.hidden = YES;
    [handleOpinionView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_repairOrderScroll addSubview:submitBtn];
    submitBtn.sd_layout.leftEqualToView(groupPhotoView).rightEqualToView(groupPhotoView).topSpaceToView(handleOpinionView, 15).heightIs(44);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = CFFONT15;
    [submitBtn setBackgroundColor:ChangfaColor];
    [submitBtn addTarget:self action:@selector(submitBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 10 * screenWidth;
    
    
    [_repairOrderScroll sd_addSubviews:@[groupPhotoView,faultPhotoView,machineInfoView,machineUseView,_machineFaultView,userOpinionView,handleOpinionView, submitBtn]];
    _repairOrderScroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [_repairOrderScroll setupAutoContentSizeWithBottomView:submitBtn bottomMargin:20 * screenHeight];
}
- (void)selectedButtonClick:(UIButton *)sender
{
    CFRepairOrderView *view = [self.view viewWithTag:sender.tag - 1000];
    view.isSelected = !view.isSelected;
    for (CFRepairOrderView *view in _repairOrderScroll.subviews) {
        if ([view isMemberOfClass:[CFRepairOrderView class]] && view.tag != sender.tag - 1000) {
            view.isSelected = NO;
        }
    }
}

- (void)submitBtnClcik
{
    for (CFFaultView *view in _machineFaultView.bodyView.subviews) {
        NSLog(@"%@", _machineFaultView.bodyView.subviews);
        if ([view isMemberOfClass:[CFFaultView class]] && view.type == 0) {
            NSLog(@"typea%@", view.reasonView.text);
        } else if ([view isMemberOfClass:[CFFaultView class]] && view.type == 1) {
            NSLog(@"typeb%@", view.reasonView.text);
        }
    }
    return;
    NSDictionary *no1 = @{
                          @"faultDes":@"123",
                          @"partNo":@"CF003102",
                          };
    NSDictionary *no2 = @{
                          @"faultDes":@"456",
                          @"partNo":@"356802032218223",
                          };
    NSError *error = nil;
    NSArray *arr = [NSArray arrayWithObjects:no1, no2, nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *param = @{
                            @"disId":@"",
                            @"disNum":@"",
                            @"faultFileIds":@"",
                            @"personFileIds":@"",
                            @"token":@"",
                            @"useTime":@"",
                            @"driveDistance":@"",
                            @"machineInstruction":@"",
                            @"partFaultList":jsonString,
                            @"faultList":@"",
                            @"customerOpinion":@"",
                            @"handleOpinion":@"",
                            @"remarks":@"",
                            };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"repair/createRepair" Loading:0 Params:param Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark - <CTAssetsPickerControllerDelegate>
- (void)addImageClick
{
    self.vagueView.hidden = NO;
}
- (void)cameraButtonClick
{
    if (self.photoArray.count == 9) {
        [MBManager showBriefAlert:@"最多上传9张图片" time:1.5];
        return;
    }
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
- (void)photoButtonClick
{
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
- (void)cancelButtonClick
{
    self.vagueView.hidden = YES;
}
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
