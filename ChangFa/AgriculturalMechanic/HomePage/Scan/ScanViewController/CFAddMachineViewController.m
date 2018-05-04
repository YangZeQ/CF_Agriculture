//
//  CFAddMachineViewController.m
//  ChangFa
//
//  Created by Developer on 2018/4/25.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAddMachineViewController.h"
#import "CFInstallTerminalViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <SafariServices/SafariServices.h>
#import "AdditionScanView.h"
@interface CFAddMachineViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong)AVCaptureDeviceInput *deviceInput;// 摄像头输入
@property (nonatomic, strong)AVCaptureMetadataOutput *metadataOutput;// 输出
@property (nonatomic, strong)AVCaptureSession *session;// 会话
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewlayer;// 预览
@property (nonatomic, strong)AdditionScanView *additionView;
@property (nonatomic, strong)MachineModel *machineModel;
@end

@implementation CFAddMachineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UserBackgroundColor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"添加农机";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Navigation_Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    [self initScanConfig];
    // Do any additional setup after loading the view.
}
- (void)initScanConfig
{
    
    _additionView = [[AdditionScanView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT - navHeight)];
    [self.view addSubview:_additionView];
    
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
    
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    layer.frame = CGRectMake(90 * screenWidth, 107 * screenHeight, CF_WIDTH - 240 * screenWidth, 510 * screenHeight);
    
    [_additionView.topView.layer insertSublayer:layer atIndex:0];
    
    UIImageView *scanBoxImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, layer.frame.size.width, layer.frame.size.height)];
    scanBoxImage.image = [UIImage imageNamed:@"Scan_Box"];
    [layer addSublayer:scanBoxImage.layer];
    
    __block CFAddMachineViewController *blockSelf = self;
    self.additionView.textNumberBlock = ^(NSString *text) {
        [blockSelf getDetailMachineInformation:text];
    };
    self.additionView.stopSessionBlock = ^(BOOL isStop) {
        if (isStop) {
            [blockSelf.session stopRunning];
        } else {
            [blockSelf.session startRunning];
        }
    };
    [self.session startRunning];
    
}
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataMachineReadableCodeObject *obj in metadataObjects) {
        NSLog(@"%@", obj);
        [self.session stopRunning];
        [self getDetailMachineInformation:obj.stringValue];
        
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
            self.machineModel = [MachineModel machineModelWithDictionary:[responseObject objectForKey:@"body"]];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"绑定" style:UIBarButtonItemStyleDone target:self action:@selector(rightBindButtonClick)];
            [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ChangfaColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
            self.additionView.additionStepsBlock(AdditionStepBindMachine, _machineModel);
            [_additionView.activeButton addTarget:self action:@selector(installTerminalButtonClick) forControlEvents:UIControlEventTouchUpInside];
        } else if ([[dict objectForKey:@"code"] integerValue] == 300) {
           
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[dict objectForKey:@"message"] message:@"" preferredStyle:UIAlertControllerStyleAlert];
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
    }];
}

- (void)installTerminalButtonClick
{
    CFInstallTerminalViewController *installTerminal = [[CFInstallTerminalViewController alloc]init];
    __block CFAddMachineViewController *blockSelf = self;
    installTerminal.installTerminalBlock = ^{
        blockSelf.additionView.submitBlock();
    };
    [self.navigationController pushViewController:installTerminal animated:YES];
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBindButtonClick
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightDoneButtonClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ChangfaColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.additionView.additionStepsBlock(AdditionStepDone, self.machineModel);
}

- (void)rightDoneButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.additionView.scanView endEditing:YES];
    [self.view endEditing:YES];
}
- (void)dealloc
{
    NSLog(@"CFADD_Block");
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
