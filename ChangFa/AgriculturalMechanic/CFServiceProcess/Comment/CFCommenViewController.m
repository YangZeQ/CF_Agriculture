//
//  CFCommenViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/3.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFCommenViewController.h"
#import "CFPreviewPhotoViewController.h"
#import "CFRepairsPhotoCell.h"
#import "AddMachineCollectionViewCell.h"
#import "CFReasonTextView.h"
#import "HCSStarRatingView.h"
#import <Photos/Photos.h>
#import "CTAssetsPickerController/CTAssetsPickerController.h"
#import "AFHTTPSessionManager.h"
#import "CFRepairsRecordViewController.h"
@interface CFCommenViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CTAssetsPickerControllerDelegate>
@property (nonatomic, strong)HCSStarRatingView *starView;
@property (nonatomic, strong)UILabel *starLabel;
@property (nonatomic, strong)CFReasonTextView *commentTexView;
@property (nonatomic, strong)UICollectionView *commentPhotoCollection;
@property (nonatomic, strong)CFRepairsPhotoCell *commentPhotoCell;
@property (nonatomic, strong)AddMachineCollectionViewCell *addCommentPhotoCell;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, copy)NSString *fileIds;
@end

@implementation CFCommenViewController
- (NSMutableArray *)photoArray
{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.title = @"评论";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Navigation_Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(uploadImagesArray)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ChangfaColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [self createCommentView];
}
- (void)createCommentView{
    UIView *machineInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width, 142 * screenHeight)];
    machineInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:machineInfoView];
    
    UILabel *machineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 10 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 50 * screenHeight)];
    machineNameLabel.text = [@"名称：" stringByAppendingString:_recordModel.machineName];
    machineNameLabel.font = CFFONT15;
    
    [machineInfoView addSubview:machineNameLabel];
    UILabel *machineTypeLable = [[UILabel alloc]initWithFrame:CGRectMake(machineNameLabel.frame.origin.x, machineNameLabel.frame.size.height + machineNameLabel.frame.origin.y + 6 * screenHeight, machineNameLabel.frame.size.width, machineNameLabel.frame.size.height)];
    machineTypeLable.text = [@"型号：" stringByAppendingString:_recordModel.machineModel];
    machineTypeLable.font = CFFONT15;
    [machineInfoView addSubview:machineTypeLable];
    
    UIView *commentView = [[UIView alloc]initWithFrame:CGRectMake(0, machineInfoView.frame.size.height + 20 * screenHeight + navHeight, self.view.frame.size.width, 716 * screenHeight)];
    commentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:commentView];
    UILabel *serveLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 20 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 50 * screenHeight)];
    serveLabel.text = @"服务";
    serveLabel.userInteractionEnabled = YES;
    [commentView addSubview:serveLabel];
    _starView = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(120 * screenWidth, serveLabel.frame.origin.y + 10 * screenHeight, 350 * screenWidth, serveLabel.frame.size.height - 20 * screenHeight)];
    _starView.maximumValue = 5;
    _starView.minimumValue = 1;
    _starView.value = 5.0;
    _starView.emptyStarImage = [[UIImage imageNamed:@"CF_Comment_Star_Empty"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//UIImageRenderingModeAlwaysTemplate 始终根据Tint Color绘制图片，忽略图片的颜色信息。
    _starView.filledStarImage = [[UIImage imageNamed:@"CF_Comment_Star_Full"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_starView addTarget:self action:@selector(didStarComment:) forControlEvents:UIControlEventValueChanged];
    [commentView addSubview:_starView];

    _starLabel = [[UILabel alloc]initWithFrame:CGRectMake(_starView.frame.size.width + _starView.frame.origin.x + 30 * screenWidth, serveLabel.frame.origin.y, 100 * screenWidth, serveLabel.frame.size.height)];
    _starLabel.text = @"5.0";
    [commentView addSubview:_starLabel];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, serveLabel.frame.size.height + serveLabel.frame.origin.y + 20 * screenHeight, self.view.frame.size.width, 2 * screenHeight)];
    lineLabel.backgroundColor = BackgroundColor;
    [commentView addSubview:lineLabel];
    
    _commentTexView = [[CFReasonTextView alloc]initWithFrame:CGRectMake(30 * screenWidth, lineLabel.frame.size.height + lineLabel.frame.origin.y + 20 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 407 * screenHeight)];
    //    _reasonTextView.delegate = self;
    _commentTexView.placeholder = @"输入你对本次服务的评价";
    _commentTexView.maxNumberOfLines = 10;
    _commentTexView.font = [UIFont systemFontOfSize:18];
    [commentView addSubview:_commentTexView];
    [_commentTexView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        CGRect frame = _commentTexView.frame;
        frame.size.height = textHeight;
        _commentTexView.frame = frame;
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _commentPhotoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _commentTexView.frame.size.height + _commentTexView.frame.origin.y + 20 * screenHeight, self.view.frame.size.width, 314 * screenHeight) collectionViewLayout:layout];
    _commentPhotoCollection.backgroundColor = [UIColor whiteColor];
    layout.sectionInset = UIEdgeInsetsMake(0 * screenHeight, 20 * screenWidth, 0 * screenHeight, 20 * screenWidth);
    layout.itemSize = CGSizeMake(200 * screenWidth, 200 * screenHeight);
    layout.minimumLineSpacing = 10 * screenWidth;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _commentPhotoCollection.showsHorizontalScrollIndicator = NO;
    _commentPhotoCollection.delegate = self;
    _commentPhotoCollection.dataSource = self;
    [_commentPhotoCollection registerClass:[CFRepairsPhotoCell class] forCellWithReuseIdentifier:@"repairsPhotoCellId"];
    [_commentPhotoCollection registerClass:[AddMachineCollectionViewCell class] forCellWithReuseIdentifier:@"addRepairsPhotoCellId"];
    [commentView addSubview:_commentPhotoCollection];
    
}
#pragma mark -collectionViewDelegate/DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    _commentPhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"repairsPhotoCellId" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        _addCommentPhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addRepairsPhotoCellId" forIndexPath:indexPath];
        _addCommentPhotoCell.imageName = @"CF_AddPhoto";
        return _addCommentPhotoCell;
    }
    _commentPhotoCell.repairsPhoto.image = self.photoArray[indexPath.row - 1];
    _commentPhotoCell.deleteButton.hidden = NO;
    _commentPhotoCell.deleteButton.tag = 1000 + indexPath.row;
    [_commentPhotoCell.deleteButton addTarget:self action:@selector(deleteImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return _commentPhotoCell;
}
// 删除图片
- (void)deleteImageButtonClick:(UIButton *)sender
{
    [self.photoArray removeObjectAtIndex:sender.tag - 1000 - 1];
    [self.commentPhotoCollection reloadData];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
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
                                                   @(PHAssetCollectionSubtypeAlbumRegular)
                                                   ];
                // 不需要显示空的相册
                picker.showsEmptyAlbums = NO;
                [self presentViewController:picker animated:YES completion:nil];
            });
        }];
    } else {
        CFPreviewPhotoViewController *preview = [[CFPreviewPhotoViewController alloc]init];
        preview.photoArray = self.photoArray;
        preview.selectedIndex = indexPath.row - 1;
        preview.headerHeight = navHeight;
        [self presentViewController:preview animated:YES completion:^{
                
        }];
    }
}
#pragma mark - <CTAssetsPickerControllerDelegate>
-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
    NSInteger max = 9 - self.photoArray.count;
    if (picker.selectedAssets.count >= max) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"还可选择%zd张图片", max] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [picker presentViewController:alert animated:YES completion:nil];
        // 这里不能使用self来modal别的控制器，因为此时self.view不在window上
        return NO;
    }
    return YES;
}
-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [self.photoArray removeAllObjects];
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
    [self.commentPhotoCollection reloadData];
}
#pragma mark-多图片上传
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
        self.fileIds = @"";
        NSInteger ids = 0;
        for (id response in result) {
            NSLog(@"tupian%@", response);
            if (ids == 0) {
                self.fileIds = [[[response objectForKey:@"body"] objectForKey:@"result"] objectForKey:@"fileIds"];
            } else {
                self.fileIds = [[self.fileIds stringByAppendingString:@","] stringByAppendingString:[[[response objectForKey:@"body"] objectForKey:@"result"] objectForKey:@"fileIds"]];
            }
            ids++;
        }
        NSLog(@"%@", self.fileIds);
        [self releaseButtonClick];
    });
}
- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock
{
    
    // 构造 NSURLRequest
    NSError* error = NULL;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{@"file":@"",
                             @"userId":[userDefaults objectForKey:@"UserUid"],
                             @"dispatchId":@"",
                             @"token":@"",
                             @"type":@"0",
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
#pragma mark - 评论星级
- (void)didStarComment:(HCSStarRatingView *)sender
{
    _starLabel.text = [[NSString stringWithFormat:@"%f", sender.value] substringToIndex:3];
}
- (void)releaseButtonClick{
    NSLog(@"%@ %@", _commentTexView.text, [_starLabel.text substringToIndex:1]);
    NSDictionary *params = @{
                             @"content":_commentTexView.text,
                             @"level":[_starLabel.text substringToIndex:1],
                             @"serviceId":_recordModel.serviceId,
                             @"reportId":_recordModel.reportId,
                             @"fileIds":self.fileIds,
                             };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"reportComment/saveReportComment" Loading:1 Params:params Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"评价成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                for (UIViewController *viewController in self.navigationController.childViewControllers) {
                    if ([viewController isKindOfClass:[CFRepairsRecordViewController class]]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                        return;
                    }
                }
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
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
