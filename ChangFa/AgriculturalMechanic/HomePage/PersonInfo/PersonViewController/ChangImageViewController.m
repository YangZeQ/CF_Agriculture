//
//  ChangImageViewController.m
//  ChangFa
//
//  Created by Developer on 2018/1/15.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "ChangImageViewController.h"
#import "UIImageView+WebCache.h"
#import "CFAFNetWorkingMethod.h"
#import "AFHTTPSessionManager.h"

@interface ChangImageViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong)UIImageView *userImage;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIImagePickerController *imagePicker;
@end

@implementation ChangImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更改头像";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"diangengduo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    //设置代理
    _imagePicker.delegate=self;
    //可编辑
    
    _imagePicker.allowsEditing=YES;
    // Do any additional setup after loading the view.
    [self showTheImage];
}
- (void)showTheImage{
    _userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - self.view.frame.size.width)/ 2, self.view.frame.size.width, self.view.frame.size.width)];
    [_userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _imageUrl]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    [self.view addSubview:_userImage];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 400 * screenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = BackgroundColor;
    [self.view addSubview:self.tableView];
    
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonClick{
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = CGRectMake(0, self.view.frame.size.height - 400 * screenHeight, self.view.frame.size.width, 400 * screenHeight);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"拍照";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"从手机相册选择";
        } else {
            cell.textLabel.text = @"保存图片";
        }
    } else {
        cell.textLabel.text = @"取消";
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    } else {
        return 50 * screenHeight;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self performSelector:@selector(presentViweController) withObject:self afterDelay:0];
        } else if (indexPath.row == 1) {
            _imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self performSelector:@selector(presentViweController) withObject:self afterDelay:0];
        } else {
            [self saveImageToPhotos:_userImage.image];
        }
    } else{
         self.tableView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 400 * screenHeight);
    }
}
-(void) presentViweController{
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    _userImage.image=image;
    [self uploadUserHeadImage:image];
    //2. 利用时间戳当做图片名字
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyyMMddHHmmss";
//    NSString *imageName = [formatter stringFromDate:[NSDate date]];
//    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",imageName];
//
//    //3. 图片二进制文件
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.7f);
//    NSDictionary *dict = @{
//                           @"data":[[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding],
//                           };
//    NSLog(@"%@", imageData);
//    [CFAFNetWorkingMethod requestDataWithUrl:@"Common/uploadAvatarFile" Params:dict Method:@"post" Image:@"image" Success:^(NSURLSessionDataTask *task, id responseObject) {
//
//    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//    }];
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)uploadUserHeadImage:(UIImage *)image {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *imageName = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png",imageName];
    // 获得网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置请求参数
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [manager.requestSerializer setValue:[userDefaults objectForKey:@"UserToken"] forHTTPHeaderField:@"token"];
    NSLog(@"%@", [userDefaults objectForKey:@"UserToken"]);
    NSDictionary *params = @{@"channel":@"",
                             @"token":[userDefaults objectForKey:@"UserToken"],
                             @"language":@"",
                             @"version":@"",
                                    };
    [manager POST:@"http://47.96.20.14:8085/api/v1/Common/uploadAvatarFile" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:@"file" fileName:@"avatar.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 返回结果
        NSLog(@"%@", responseObject);
        NSLog(@"%@", [[responseObject objectForKey:@"head"] objectForKey:@"message"]);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:[[responseObject objectForKey:@"body"] objectForKey:@"attachUrl"] forKey:@"UserHeadUrl"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeHeadImage" object:nil userInfo:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
//    [manager POST:@"http://47.96.20.14:8085/api/v1/Common/uploadAvatarData" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//        // 获取图片数据
//        NSData *fileData = UIImageJPEGRepresentation(image, 1.0);
//
//        // 设置上传图片的名字
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//
//        [formData appendPartWithFileData:fileData name:@"image" fileName:fileName mimeType:@"image/jpeg"];
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"%@", uploadProgress);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        // 返回结果
//        NSLog(@"%@", responseObject);
//        NSLog(@"%@", [[responseObject objectForKey:@"head"] objectForKey:@"message"]);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
}
//实现该方法
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
}
//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:alertAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.tableView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 400 * screenHeight);
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
