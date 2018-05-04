//
//  ScanViewController.m
//  ChangFa
//
//  Created by dev on 2018/1/4.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <SafariServices/SafariServices.h>
#import "ScanView.h"
#import "PutNumberViewController.h"
#import "CFAFNetWorkingMethod.h"
@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, PutNumberViewControllerDelegate>
@property (nonatomic, strong)AVCaptureDeviceInput *deviceInput;// 摄像头输入
@property (nonatomic, strong)AVCaptureMetadataOutput *metadataOutput;// 输出
@property (nonatomic, strong)AVCaptureSession *session;// 会话
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewlayer;// 预览
@property (nonatomic, strong)ScanView *scanView;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfing];
    // Do any additional setup after loading the view.
}
- (void)initConfing{
    // 默认为后置摄像头
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.deviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:device error:NULL];
    
    // 解析输入的数据
    self.metadataOutput = [[AVCaptureMetadataOutput alloc]init];
    [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.metadataOutput.rectOfInterest = CGRectMake(([UIScreen mainScreen].bounds.size.height / 2 - 270 * screenHeight) / [UIScreen mainScreen].bounds.size.height, 115 * screenWidth / [UIScreen mainScreen].bounds.size.width, 520 * screenHeight / [UIScreen mainScreen].bounds.size.height, 520 * screenWidth / [UIScreen mainScreen].bounds.size.width);
    // 会话
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canAddInput:self.deviceInput]){
        [self.session addInput:self.deviceInput];
    }
    if([self.session canAddOutput:self.metadataOutput]){
        [self.session addOutput:self.metadataOutput];
    }
    
    // 设置数据采集质量
    self.session.sessionPreset = AVCaptureSessionPresetHigh;

    // 设置需要解析的数据类型，二维码
    self.metadataOutput.metadataObjectTypes = @[
                                                AVMetadataObjectTypeDataMatrixCode,
                                                AVMetadataObjectTypeITF14Code,
                                                AVMetadataObjectTypeInterleaved2of5Code,
                                                AVMetadataObjectTypeAztecCode,
                                                AVMetadataObjectTypeQRCode,
                                                AVMetadataObjectTypePDF417Code,
                                                AVMetadataObjectTypeCode128Code,
                                                AVMetadataObjectTypeCode93Code,
                                                AVMetadataObjectTypeEAN8Code,
                                                AVMetadataObjectTypeEAN13Code,
                                                AVMetadataObjectTypeCode39Mod43Code,
                                                AVMetadataObjectTypeCode39Code,
                                                AVMetadataObjectTypeUPCECode,
                                                ];
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    layer.videoGravity=AVLayerVideoGravityResize;
    
    layer.frame=self.view.layer.bounds;
    
    ScanView *preView = [[ScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) ScanType:self.scanType];
    self.scanView = preView;
    preView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:preView];
//    preView.session = self.session;
    [self.view.layer insertSublayer:layer atIndex:0];

    preView.backPreView = ^(ScanView *backPreView){
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        // 销毁定时器
        if (backPreView.timer){
            [backPreView.timer invalidate];
            backPreView.timer = nil;
        }
    };
    
    preView.putInNumber = ^(ScanView *puInNumber){
        PutNumberViewController *put = [[PutNumberViewController alloc]init];
        put.delegate = self;
        [self presentViewController:put animated:YES completion:^{
            
        }];
    };
    
    [self.session startRunning];

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // org.iso.Code39 条码
    // org.iso.QRCode 二维码
    for (AVMetadataMachineReadableCodeObject *obj in metadataObjects) {
        NSLog(@"%@", obj);
//        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:obj.stringValue]];
//        [self presentViewController:safariVC animated:YES completion:nil];
        if ([self.scanType isEqualToString:@"BarCode"] && [obj.type isEqualToString:@"org.iso.QRCode"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请扫描有效条形码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.session startRunning];
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            [self.session stopRunning];
            return;
        }
        if ([self.scanType isEqualToString:@"QRCode"] && [obj.type isEqualToString:@"org.iso.Code39"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请扫描有效二维码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [self.session startRunning];
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            [self.session stopRunning];
            return;
        }
        if (!([obj.type isEqualToString:@"org.iso.Code39"] || [obj.type isEqualToString:@"org.iso.QRCode"] || [obj.type isEqualToString:@"org.ansi.Interleaved2of5"] || [obj.type isEqualToString:@"org.iso.Code128"])) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请扫描有效条形码/二维码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.session startRunning];
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            [self.session stopRunning];
            return;
        }
        if ([self.getInfoType isEqualToString:@"retreat"]) {
            [self getRetreatDetailMachineInformation:obj.stringValue];
        } else if ([self.getInfoType isEqualToString:@"repair"]){
            [self getMachineLocation:obj.stringValue];
        } else {
            [self getDetailMachineInformation:obj.stringValue];
        }
        [self.session stopRunning];
        break;
    }
}
#pragma mark -获取农机详情
- (void)getDetailMachineInformation:(NSString *)string{
    NSMutableDictionary *dictPost = [NSMutableDictionary dictionary];
    if (string.length == 15) {
        NSDictionary *strDic = @{ @"imei":string,
                                  @"carBar":@"",
                                  };
        dictPost = [NSMutableDictionary dictionaryWithDictionary:strDic];
    } else {
        NSDictionary *strDic = @{ @"imei":@"",
                                  @"carBar":string,
                                  };
       dictPost = [NSMutableDictionary dictionaryWithDictionary:strDic];
    }

    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/getCarInfo" Params:dictPost Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            MachineModel *model = [MachineModel machineModelWithDictionary:[responseObject objectForKey:@"body"]];
            if ([self.scanType isEqualToString:@"sell"] && ([model.carState integerValue] != 2 && [model.carState integerValue] != 4)) {
                
            } else {
                [self.delegate scanGetInformation:model];
            }
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.scanType isEqualToString:@"sell"]) {
                    [self.delegate scanGetInformation:model];
                } else {
                    
                }
            }];
        } else if ([[dict objectForKey:@"code"] integerValue] == 300) {
            NSLog(@"%lu", [[dict objectForKey:@"message"] length]);
            if ([self.scanType isEqualToString:@"worker"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.session startRunning];
                }];
                [alert addAction:alertAction];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            } else {
                MachineModel *model = [[MachineModel alloc]init];
                model.imei = string;
                model.bindType = [NSString stringWithFormat:@"%@", @"3"];
                [self.delegate scanGetInformation:model];
                [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            }
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.session startRunning];
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"获取信息失败，请重新扫描" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.session startRunning];
        }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        [self.session stopRunning];
    }];
}
#pragma mark -获取退换农机详情
- (void)getRetreatDetailMachineInformation:(NSString *)string{
    NSMutableDictionary *dictPost = [NSMutableDictionary dictionary];
    if (string.length == 15) {
        NSDictionary *strDic = @{ @"imei":string,
                                  @"carBar":@"",
                                  @"distributorsID":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDistributorId"],
                                  @"distributorsName":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDistributorName"],
                                  };
        dictPost = [NSMutableDictionary dictionaryWithDictionary:strDic];
    } else{
        NSDictionary *strDic = @{ @"imei":@"",
                                  @"carBar":string,
                                  @"distributorsID":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDistributorId"],
                                  @"distributorsName":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDistributorName"],
                                  };
        dictPost = [NSMutableDictionary dictionaryWithDictionary:strDic];
    }
    
    [CFAFNetWorkingMethod requestDataWithUrl:@"machinery/sweepCodeGetCarInfo?" Params:dictPost Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            MachineModel *model = [MachineModel machineModelWithDictionary:[responseObject objectForKey:@"body"]];
            [self.delegate scanGetInformation:model];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.session startRunning];
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark -获取农机位置
- (void)getMachineLocation:(NSString *)string{
    NSMutableDictionary *dictPost = [NSMutableDictionary dictionary];
    if (string.length == 15) {
        NSDictionary *strDic = @{ @"imei":string,
                                  @"carBar":@"",
                                  };
        dictPost = [NSMutableDictionary dictionaryWithDictionary:strDic];
    } else{
        NSDictionary *strDic = @{ @"imei":@"",
                                  @"carBar":string,
                                  };
        dictPost = [NSMutableDictionary dictionaryWithDictionary:strDic];
    }
    
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/getUserCarLoaction?" Params:dictPost Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            MachineModel *model = [MachineModel machineModelWithDictionary:[responseObject objectForKey:@"body"]];
            [self.delegate scanGetInformation:model];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.session startRunning];
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)bandMachineAccordingNumber:(NSString *)sender{
    [self getDetailMachineInformation:sender];
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
