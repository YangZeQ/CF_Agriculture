//
//  CFRefillRepairOrderController.m
//  ChangFa
//
//  Created by yang on 2018/6/13.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRefillRepairOrderController.h"
#import "ScanViewController.h"
#import "CFRepairOrderView.h"
#import "CFFaultView.h"
#import "CFFillInOrderModel.h"
#import "CFLoginViewController.h"
#import "CFAFNetworkingManage.h"
#import <Photos/Photos.h>
#import "CTAssetsPickerController/CTAssetsPickerController.h"
@interface CFRefillRepairOrderController ()<CTAssetsPickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, scanViewControllerDelegate>
@property (nonatomic, strong)UIScrollView *repairOrderScroll;
@property (nonatomic, strong)UIView *titleView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)CFRepairOrderView *groupPhotoView;
@property (nonatomic, strong)CFRepairOrderView *faultPhotoView;
@property (nonatomic, strong)CFRepairOrderView *machineInfoView;
@property (nonatomic, strong)CFRepairOrderView *machineUseView;
@property (nonatomic, strong)CFRepairOrderView *machineFaultView;
@property (nonatomic, strong)CFRepairOrderView *userOpinionView;
@property (nonatomic, strong)CFRepairOrderView *handleOpinionView;
@property (nonatomic, strong)CFRepairOrderView *remarksView;
@property (nonatomic, strong)UIImagePickerController *imagePicker;
@property (nonatomic, strong)UIView *vagueView;

@property (nonatomic, strong)NSMutableArray *reasonArray;   // 不通过时，存储reason标识
@property (nonatomic, assign)NSInteger uploadImageType;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *groupPhotoArray;
@property (nonatomic, strong)NSMutableArray *faultPhotoArray;
@property (nonatomic, strong)NSMutableArray *groupPhotoIdsArray;
@property (nonatomic, strong)NSMutableArray *faultPhotoIdsArray;
@property (nonatomic, copy)NSString *groupPhotoIds;
@property (nonatomic, copy)NSString *faultPhotoIds;
@property (nonatomic, strong)CFFillInOrderModel *fillModel;
@end

@implementation CFRefillRepairOrderController

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
- (NSMutableArray *)reasonArray
{
    if (_reasonArray == nil) {
        _reasonArray = [NSMutableArray array];
    }
    return _reasonArray;
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
- (NSMutableArray *)groupPhotoIdsArray
{
    if (_groupPhotoIdsArray == nil) {
        _groupPhotoIdsArray = [NSMutableArray array];
    }
    return _groupPhotoIdsArray;
}
- (NSMutableArray *)faultPhotoIdsArray
{
    if (_faultPhotoIdsArray == nil) {
        _faultPhotoIdsArray = [NSMutableArray array];
    }
    return _faultPhotoIdsArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    
    [self createRepairOrderView];
    [self getFillInOrderWithReapirId:self.repairId];
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    //设置代理
    _imagePicker.delegate = self;
    //可编辑
    _imagePicker.allowsEditing=YES;
    
    // Do any additional setup after loading the view.
}
- (void)createRepairOrderView
{
    __block CFRefillRepairOrderController *weakSelf = self;
    self.navigationItem.title = @"填写维修单";
    _repairOrderScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT - navHeight)];
    _repairOrderScroll.contentSize = CGSizeMake(0, 0);
    _repairOrderScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_repairOrderScroll];
    
    UILabel *repairStyleLabel = [[UILabel alloc]init];
    [_repairOrderScroll addSubview:repairStyleLabel];
    repairStyleLabel.sd_layout.leftSpaceToView(_repairOrderScroll, 20 * screenWidth).topSpaceToView(_repairOrderScroll, 20 * screenHeight).rightSpaceToView(_repairOrderScroll, 20 * screenWidth).heightIs(120 * screenHeight);
    repairStyleLabel.backgroundColor = [UIColor whiteColor];
    repairStyleLabel.layer.cornerRadius = 20 * screenWidth;
    repairStyleLabel.clipsToBounds = YES;
    repairStyleLabel.text = @"外出服务";
    repairStyleLabel.font = CFFONT14;
    repairStyleLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *repairTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70 * screenWidth, 35 * screenHeight, 250 * screenWidth, 50 * screenHeight)];
    repairTitleLabel.sd_layout.leftSpaceToView(repairStyleLabel, 70 * screenWidth).topSpaceToView(repairStyleLabel, 35 * screenHeight).widthIs(120 * screenWidth).heightIs(50 * screenHeight);
    repairTitleLabel.textAlignment = NSTextAlignmentLeft;
    repairTitleLabel.text = @"维修类型";
    repairTitleLabel.font = CFFONT14;
    [repairStyleLabel addSubview:repairTitleLabel];
    
    _groupPhotoView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStylePhoto IsCheck:_isCheck];
    [_repairOrderScroll addSubview:_groupPhotoView];
    _groupPhotoView.sd_layout.leftSpaceToView(_repairOrderScroll, 10).topSpaceToView(repairStyleLabel, 10).heightIs(60).rightSpaceToView(_repairOrderScroll, 10);
    _groupPhotoView.isSelected = NO;
    _groupPhotoView.tag = 1001;
    _groupPhotoView.selectedButton.tag = 2001;
    _groupPhotoView.titleLabel.text = @"人机合影";
    _groupPhotoView.statuslabel.hidden = YES;
    _groupPhotoView.titleLabel.textColor = ChangfaColor;
    _groupPhotoView.statuslabel.hidden = NO;
    [_groupPhotoView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _groupPhotoView.addImageBlock = ^{
        [weakSelf addImageClick];
    };
    _groupPhotoView.deleteImageBlock = ^(NSInteger index) {
        [weakSelf.groupPhotoArray removeObjectAtIndex:index];
        [weakSelf.groupPhotoIdsArray removeObjectAtIndex:index];
        if (weakSelf.groupPhotoArray.count < 1) {
            weakSelf.groupPhotoView.titleLabel.textColor = UIColorWithRGBA(107, 107, 107, 1);
            weakSelf.groupPhotoView.statuslabel.hidden = YES;
        }
    };
    
    _faultPhotoView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStylePhoto IsCheck:_isCheck];
    [_repairOrderScroll addSubview:_faultPhotoView];
    _faultPhotoView.sd_layout.leftEqualToView(_groupPhotoView).topSpaceToView(_groupPhotoView, 10).heightIs(60).rightEqualToView(_groupPhotoView);
    _faultPhotoView.isSelected = NO;
    _faultPhotoView.tag = 1002;
    _faultPhotoView.selectedButton.tag = 2002;
    _faultPhotoView.titleLabel.text = @"故障照片";
    _faultPhotoView.statuslabel.hidden = YES;
    _faultPhotoView.titleLabel.textColor = ChangfaColor;
    _faultPhotoView.statuslabel.hidden = NO;
    [_faultPhotoView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _faultPhotoView.addImageBlock = ^{
        [weakSelf addImageClick];
    };
    _faultPhotoView.deleteImageBlock = ^(NSInteger index) {
        [weakSelf.faultPhotoArray removeObjectAtIndex:index];
        [weakSelf.faultPhotoIdsArray removeObjectAtIndex:index];
        if (weakSelf.faultPhotoArray.count < 1) {
            weakSelf.faultPhotoView.titleLabel.textColor = UIColorWithRGBA(107, 107, 107, 1);
            weakSelf.faultPhotoView.statuslabel.hidden = YES;
        }
    };
    
    _machineInfoView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleInfo IsCheck:_isCheck];
    [_repairOrderScroll addSubview:_machineInfoView];
    _machineInfoView.sd_layout.leftEqualToView(_groupPhotoView).topSpaceToView(_faultPhotoView, 10).heightIs(60).rightEqualToView(_groupPhotoView);
    _machineInfoView.isSelected = NO;
    _machineInfoView.tag = 1003;
    _machineInfoView.selectedButton.tag = 2003;
    _machineInfoView.titleLabel.text = @"农机信息";
    _machineInfoView.statuslabel.hidden = YES;
    _machineInfoView.titleLabel.textColor = ChangfaColor;
    _machineInfoView.statuslabel.hidden = NO;
    [_machineInfoView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _machineUseView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleReason IsCheck:_isCheck];
    [_repairOrderScroll addSubview:_machineUseView];
    _machineUseView.sd_layout.leftEqualToView(_groupPhotoView).topSpaceToView(_machineInfoView, 10).heightIs(60).rightEqualToView(_groupPhotoView);
    _machineUseView.isSelected = NO;
    _machineUseView.tag = 1004;
    _machineUseView.selectedButton.tag = 2004;
    _machineUseView.titleLabel.text = @"农机用途说明";
    _machineUseView.reasonView.placeholder = @"请简短描述农机用途说明";
    _machineUseView.statuslabel.hidden = YES;
    _machineUseView.titleLabel.textColor = ChangfaColor;
    _machineUseView.statuslabel.hidden = NO;
    [_machineUseView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _machineFaultView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleParts IsCheck:_isCheck];
    [_repairOrderScroll addSubview:_machineFaultView];
    _machineFaultView.sd_layout.leftEqualToView(_groupPhotoView).topSpaceToView(_machineUseView, 10).heightIs(60).rightEqualToView(_groupPhotoView);
    _machineFaultView.isSelected = NO;
    _machineFaultView.tag = 1005;
    _machineFaultView.selectedButton.tag = 2005;
    _machineFaultView.titleLabel.text = @"农机故障说明";
    _machineFaultView.statuslabel.hidden = YES;
    _machineFaultView.titleLabel.textColor = ChangfaColor;
    _machineFaultView.statuslabel.hidden = NO;
    [_machineFaultView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _machineFaultView.scanBlock = ^{
        ScanViewController *scan = [[ScanViewController alloc]init];
        scan.delegate = weakSelf;
        scan.getInfoType = @"partNumber";
        [weakSelf.navigationController presentViewController:scan animated:YES completion:^{
            
        }];
    };
    
    _userOpinionView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleReason IsCheck:_isCheck];
    [_repairOrderScroll addSubview:_userOpinionView];
    _userOpinionView.sd_layout.leftEqualToView(_groupPhotoView).topSpaceToView(_machineFaultView, 10).heightIs(60).rightEqualToView(_groupPhotoView);
    _userOpinionView.isSelected = NO;
    _userOpinionView.tag = 1006;
    _userOpinionView.selectedButton.tag = 2006;
    _userOpinionView.titleLabel.text = @"客户意见";
    _userOpinionView.reasonView.placeholder = @"请简短描述客户意见";
    _userOpinionView.statuslabel.hidden = YES;
    _userOpinionView.titleLabel.textColor = ChangfaColor;
    _userOpinionView.statuslabel.hidden = NO;
    [_userOpinionView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _handleOpinionView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleReason IsCheck:_isCheck];
    [_repairOrderScroll addSubview:_handleOpinionView];
    _handleOpinionView.sd_layout.leftEqualToView(_groupPhotoView).topSpaceToView(_userOpinionView, 10).heightIs(60).rightEqualToView(_groupPhotoView);
    _handleOpinionView.isSelected = NO;
    _handleOpinionView.tag = 1007;
    _handleOpinionView.selectedButton.tag = 2007;
    _handleOpinionView.titleLabel.text = @"处理意见";
    _handleOpinionView.reasonView.placeholder = @"请简短描述处理意见";
    _handleOpinionView.statuslabel.hidden = YES;
    _handleOpinionView.titleLabel.textColor = ChangfaColor;
    _handleOpinionView.statuslabel.hidden = NO;
    [_handleOpinionView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _remarksView = [[CFRepairOrderView alloc]initWithViewStyle:FillViewStyleReason IsCheck:_isCheck];
    [_repairOrderScroll addSubview:_remarksView];
    _remarksView.sd_layout.leftEqualToView(_groupPhotoView).topSpaceToView(_handleOpinionView, 10).heightIs(60).rightEqualToView(_groupPhotoView);
    _remarksView.isSelected = NO;
    _remarksView.tag = 1008;
    _remarksView.selectedButton.tag = 2008;
    _remarksView.titleLabel.text = @"备注";
    _remarksView.reasonView.placeholder = @"请简短描述备注";
    _remarksView.statuslabel.hidden = YES;
    _remarksView.signImage.hidden = YES;
    _remarksView.titleLabel.textColor = ChangfaColor;
    _remarksView.statuslabel.hidden = NO;
    [_remarksView.selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_repairOrderScroll addSubview:submitBtn];
    submitBtn.sd_layout.leftEqualToView(_groupPhotoView).rightEqualToView(_groupPhotoView).topSpaceToView(_remarksView, 15).heightIs(44);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = CFFONT15;
    [submitBtn setBackgroundColor:ChangfaColor];
    [submitBtn addTarget:self action:@selector(submitBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 10 * screenWidth;
    
    [_repairOrderScroll sd_addSubviews:@[repairStyleLabel,_groupPhotoView,_faultPhotoView,_machineInfoView,_machineUseView,_machineFaultView,_userOpinionView,_handleOpinionView,_remarksView,submitBtn]];
    _repairOrderScroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [_repairOrderScroll setupAutoContentSizeWithBottomView:submitBtn bottomMargin:20 * screenHeight];
    _repairOrderScroll.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [_repairOrderScroll setupAutoContentSizeWithBottomView:submitBtn bottomMargin:20 * screenHeight];
    
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight, CF_WIDTH, 60 * screenWidth)];
    _titleView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_titleView];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 0, CF_WIDTH - 100 * screenWidth, 60 * screenHeight)];
    _titleLabel.text = @"";
    _titleLabel.font = CFFONT11;
    [_titleView addSubview:_titleLabel];
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(_titleLabel.frame.size.width + _titleLabel.frame.origin.x, 10 * screenHeight, 40 * screenWidth, 40 * screenHeight);
    [titleButton setImage:[UIImage imageNamed:@"CF_HideMessage"] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:titleButton];
    
    _groupPhotoView.bodyView.userInteractionEnabled = NO;
    _faultPhotoView.bodyView.userInteractionEnabled = NO;
    _machineInfoView.bodyView.userInteractionEnabled = NO;
    _machineUseView.bodyView.userInteractionEnabled = NO;
    _machineFaultView.bodyView.userInteractionEnabled = NO;
    _userOpinionView.bodyView.userInteractionEnabled = NO;
    _handleOpinionView.bodyView.userInteractionEnabled = NO;
}
- (void)selectedButtonClick:(UIButton *)sender
{
    NSLog(@"%ld", sender.tag);
    [self.view endEditing:YES];
    CFRepairOrderView *view = [self.view viewWithTag:sender.tag - 1000];
    view.isSelected = !view.isSelected;
    for (CFRepairOrderView *view in _repairOrderScroll.subviews) {
        if ([view isMemberOfClass:[CFRepairOrderView class]] && view.tag != sender.tag - 1000) {
            view.isSelected = NO;
        }
    }
    switch (sender.tag) {
        case 2001:
            self.uploadImageType = 2;
            break;
        case 2002:
            self.uploadImageType = 1;
            break;
        default:
            break;
    }
}

- (void)submitBtnClcik
{
    NSMutableArray *partFaultArray = [NSMutableArray array];
    NSMutableArray *commonFaultArray = [NSMutableArray array];
    NSInteger partNo = 0;
    for (CFFaultView *view in _machineFaultView.bodyView.subviews) {
        if ([view isMemberOfClass:[CFFaultView class]] && view.type == 0) {
            NSDictionary *dict = @{
                                   @"faultDes":[view.reasonView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                   @"partNo":view.partNameText.text,
                                   };
            [partFaultArray addObject:dict];
        } else if ([view isMemberOfClass:[CFFaultView class]] && view.type == 1) {
            NSDictionary *dict = @{
                                   @"faultDes":[view.reasonView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                   @"partNo":[NSString stringWithFormat:@"%ld", (long)partNo],
                                   };
            partNo++;
            [commonFaultArray addObject:dict];
        }
    }
    NSDictionary *param = @{
                            @"disId":[NSString stringWithFormat:@"%@", self.disId],
                            @"disNum":self.disNum,
                            @"faultFileIds":[self.faultPhotoIdsArray componentsJoinedByString:@","],
                            @"personFileIds":[self.groupPhotoIdsArray componentsJoinedByString:@","],
                            @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserToken"],
                            @"useTime":_machineInfoView.hourTextField.textField.text,
                            @"driveDistance":_machineInfoView.mileageTextField.textField.text,
                            @"machineInstruction":[_machineUseView.reasonView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            @"partFault":partFaultArray,
                            @"commonFault":commonFaultArray,
                            @"customerOpinion":[_userOpinionView.reasonView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            @"handleOpinion":[_handleOpinionView.reasonView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            @"remarks":[_remarksView.reasonView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            };
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    [CFAFNetWorkingMethod postBossDemoWithUrl:@"http://192.168.0.100:8080/changfa_system/repair/createRepair.do" param:jsonString success:^(NSDictionary *dict) {
        NSLog(@"sdfasf%@   \n  %@   %@", [[dict objectForKey:@"head"] objectForKey:@"message"], dict, [dict objectForKey:@"message"]);
    } fail:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
- (void)scanGetInformation:(MachineModel *)model
{
    _machineFaultView.getScanInfoBlock(model.imei);
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    if (self.uploadImageType == 1) {
        [self.faultPhotoArray addObject:image];
        self.photoArray = self.faultPhotoArray;
    } else {
        [self.groupPhotoArray addObject:image];
        self.photoArray = self.groupPhotoArray;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self uploadImagesArray];
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
            if (self.uploadImageType == 1) {
                [self.faultPhotoArray addObject:result];
                self.photoArray = self.faultPhotoArray;
            } else {
                [self.groupPhotoArray addObject:result];
                self.photoArray = self.groupPhotoArray;
            }
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
    NSDictionary *params = @{
                             @"file":@"",
                             @"userId":[userDefaults objectForKey:@"UserUid"],
                             @"dispatchId":self.dispatchId,
                             @"token":[userDefaults objectForKey:@"UserToken"],
                             @"type":[NSString stringWithFormat:@"%@", @0],
                             };
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://192.168.0.100:8080/changfa_system/file/manyFileUpload.do?" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
    if (self.uploadImageType == 1) {
        _faultPhotoView.photoArray = _faultPhotoArray;
        [_faultPhotoView.photoCollectionView reloadData];
    } else {
        _groupPhotoView.photoArray = _groupPhotoArray;
        [_groupPhotoView.photoCollectionView reloadData];
    }
    [MBManager showWaitingWithTitle:@"上传图片中"];
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    NSInteger photoIndex = 0;
    for (UIImage *image in self.photoArray) {
        if ([image isKindOfClass:[NSString class]]) {
            continue;
        }
        photoIndex++;
        [result addObject:[NSNull null]];
    }
    dispatch_group_t group = dispatch_group_create();
    NSLog(@"%@", self.photoArray);
    for (NSInteger i = self.photoArray.count - photoIndex; i < self.photoArray.count; i++) {
        if ([self.photoArray[i] isKindOfClass:[NSString class]]) {
            continue;
        }
        dispatch_group_enter(group);
        
        NSURLSessionUploadTask* uploadTask = [self uploadTaskWithImage:self.photoArray[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                NSLog(@"第 %ld 张图片上传失败: %@", (int)i - photoIndex + 1, error);
                dispatch_group_leave(group);
            } else {
                NSLog(@"uploadimages%@", response);
                NSLog(@"第 %ld 张图片上传成功: %@", (int)i - photoIndex + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i - (self.photoArray.count - photoIndex)] = responseObject;
                }
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBManager hideAlert];
        NSLog(@"上传完成!");
        NSInteger ids = 0;
        for (id response in result) {
            NSLog(@"tupian%@", response);
            if (self.uploadImageType == 1) {
                [self.faultPhotoIdsArray addObject:[[[response objectForKey:@"body"] objectForKey:@"result"] objectForKey:@"fileIds"]];
                if (self.faultPhotoIds.length == 0) {
                    self.faultPhotoIds = [[[response objectForKey:@"body"] objectForKey:@"result"] objectForKey:@"fileIds"];
                } else {
                    self.faultPhotoIds = [[self.faultPhotoIds stringByAppendingString:@","] stringByAppendingString:[[[response objectForKey:@"body"] objectForKey:@"result"] objectForKey:@"fileIds"]];
                }
            } else {
                [self.groupPhotoIdsArray addObject:[[[response objectForKey:@"body"] objectForKey:@"result"] objectForKey:@"fileIds"]];
                if (self.groupPhotoIds.length == 0) {
                    self.groupPhotoIds = [[[response objectForKey:@"body"] objectForKey:@"result"] objectForKey:@"fileIds"];
                } else {
                    self.groupPhotoIds = [[self.groupPhotoIds stringByAppendingString:@","] stringByAppendingString:[[[response objectForKey:@"body"] objectForKey:@"result"] objectForKey:@"fileIds"]];
                }
            }
            ids++;
        }
        
    });
}
#pragma mark - 获取已填写维修单信息
- (void)getFillInOrderWithReapirId:(NSString *)repairId
{
    [MBManager showWaitingWithTitle:@"加载中"];
    NSDictionary *param = @{
                            @"repairId":repairId,
                            };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"repair/getRepairInfo" Loading:0 Params:param Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"dispatch%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            [MBManager hideAlert];
            self.fillModel = [CFFillInOrderModel fillInOrderModelWithDictionary:[[responseObject objectForKey:@"body"] objectForKey:@"result"]];
            [self fillInOrderInfo];
        } else {
            [MBManager hideAlert];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBManager showBriefAlert:@"加载失败" time:1.0];
    }];
}
- (void)fillInOrderInfo
{
    for (NSDictionary *dic in self.fillModel.faultFileInfo) {
        [self.faultPhotoIdsArray addObject:[dic objectForKey:@"fileId"]];
        if (self.faultPhotoIds.length == 0) {
            self.faultPhotoIds = [dic objectForKey:@"fileId"];
        } else {
            self.faultPhotoIds = [[self.faultPhotoIds stringByAppendingString:@","] stringByAppendingString:[dic objectForKey:@"fileId"]];
        }
        [self.faultPhotoArray addObject:[dic objectForKey:@"filePath"]];
        [_faultPhotoView.photoArray addObject:[dic objectForKey:@"filePath"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_faultPhotoView.photoCollectionView reloadData];
        });
    }
    
    for (NSDictionary *dic in self.fillModel.personFileInfo) {
        [self.groupPhotoIdsArray addObject:[dic objectForKey:@"fileId"]];
        if (self.groupPhotoIds.length == 0) {
            self.groupPhotoIds = [dic objectForKey:@"fileId"];
        } else {
            self.groupPhotoIds = [[self.groupPhotoIds stringByAppendingString:@","] stringByAppendingString:[dic objectForKey:@"fileId"]];
        }
        [self.groupPhotoArray addObject:[dic objectForKey:@"filePath"]];
        [_groupPhotoView.photoArray addObject:[dic objectForKey:@"filePath"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_groupPhotoView.photoCollectionView reloadData];
        });
    }
    
    if ([_fillModel.useTime integerValue] >= 0) {
        _machineInfoView.hourTextField.textField.text = [NSString stringWithFormat:@"%@", _fillModel.useTime];
    }
    if ([_fillModel.driveDistance integerValue] >= 0) {
        _machineInfoView.mileageTextField.textField.text = [NSString stringWithFormat:@"%@", _fillModel.driveDistance];
    }

    _machineUseView.reasonView.textString = [self.fillModel.machineInstruction stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _userOpinionView.reasonView.textString = [self.fillModel.customerOpinion stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _handleOpinionView.reasonView.textString = [self.fillModel.handleOpinion stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _remarksView.reasonView.textString = [self.fillModel.remarks stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (self.fillModel.remarks.length < 1) {
        self.remarksView.reasonView.textString = @"无";
    }
    for (NSDictionary *dict in [self.fillModel.faults objectForKey:@"partFaults"]) {
        [_machineFaultView addMachineFaultViewWithType:0 infoDictionary:dict];
    }
    for (NSDictionary *dict in [self.fillModel.faults objectForKey:@"commonFaults"]) {
        [_machineFaultView addMachineFaultViewWithType:1 infoDictionary:dict];
    }
    
    self.reasonArray = [NSMutableArray arrayWithArray:[self.fillModel.reason componentsSeparatedByString:@","]];
    switch ([self.reasonArray[0] integerValue]) {
        case 17:
            _titleLabel.text = @"故障图片与实际情况不符，请重新上传真实故障图片。";
            break;
        case 18:
            _titleLabel.text = @"人机合影图片与实际情况不符，请重新上传真实人机合影图片。";
            break;
        case 19:
            _titleLabel.text = @"车辆用途说明不准确，请重新准确填写车辆用途说明。";
            break;
        case 20:
            _titleLabel.text = @"车辆故障说明不准确，请重新准确填写车辆故障说明。";
            break;
        case 21:
            _titleLabel.text = @"客户意见不符合实际情况，请重新填写客户意见。";
            break;
        case 22:
            _titleLabel.text = @"处理意见不符合实际情况，请重新填写处理意见。";
            break;
        default:
            break;
    }
    for (NSString *str in self.reasonArray) {
        if ([str integerValue] == 17) {
            _faultPhotoView.titleLabel.textColor = [UIColor redColor];
            _faultPhotoView.bodyView.userInteractionEnabled = YES;
            _faultPhotoView.statuslabel.hidden = YES;
            _faultPhotoView.isRefill = YES;
            _faultPhotoView.isCheck = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_faultPhotoView.photoCollectionView reloadData];
            });
        } else if ([str integerValue] == 18) {
            _groupPhotoView.titleLabel.textColor = [UIColor redColor];
            _groupPhotoView.bodyView.userInteractionEnabled = YES;
            _groupPhotoView.statuslabel.hidden = YES;
            _groupPhotoView.isRefill = YES;
            _groupPhotoView.isCheck = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_groupPhotoView.photoCollectionView reloadData];
            });
        } else if ([str integerValue] == 19) {
            _machineUseView.titleLabel.textColor = [UIColor redColor];
            _machineUseView.bodyView.userInteractionEnabled = YES;
            _machineUseView.statuslabel.hidden = YES;
            _machineUseView.isCheck = NO;
        } else if ([str integerValue] == 20) {
            _machineFaultView.titleLabel.textColor = [UIColor redColor];
            _machineFaultView.bodyView.userInteractionEnabled = YES;
            _machineFaultView.statuslabel.hidden = YES;
            _machineFaultView.isCheck = NO;
        } else if ([str integerValue] == 21) {
            _userOpinionView.titleLabel.textColor = [UIColor redColor];
            _userOpinionView.bodyView.userInteractionEnabled = YES;
            _userOpinionView.statuslabel.hidden = YES;
            _userOpinionView.isCheck = NO;
        } else if ([str integerValue] == 22) {
            _handleOpinionView.titleLabel.textColor = [UIColor redColor];
            _handleOpinionView.bodyView.userInteractionEnabled = YES;
            _handleOpinionView.statuslabel.hidden = YES;
            _handleOpinionView.isCheck = NO;
        }
    }
    
}
- (void)titleButtonClick
{
    self.titleView.hidden = YES;
}
- (void)leftButtonClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出编辑吗" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [sureAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
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
