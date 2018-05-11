//
//  CFRepairsViewController.m
//  ChangFa
//
//  Created by Developer on 2018/2/27.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsViewController.h"
#import "CFRegisterTextFieldView.h"
#import "CFPickView.h"
#import "CFReasonTextView.h"
#import "ScanViewController.h"
#import "CFPreviewPhotoViewController.h"
#import "AddMachineCollectionViewCell.h"
#import "CFRepairsPhotoCell.h"
#import "MachineModel.h"
#import "CFRepairsStationModel.h"
#import <Photos/Photos.h>
#import "CTAssetsPickerController/CTAssetsPickerController.h"
#import "AFHTTPSessionManager.h"
#import "CFRepairsStationViewController.h"
#import "CFRepairsRecordInfoViewController.h"
#import "CFRepairsRecordModel.h"

#import "MAMapKit/MAMapKit.h"
#import "AMapFoundationKit/AMapFoundationKit.h"
#import <AMapLocationKit/AMapLocationKit.h>
//#import "AMapLocationManager.h"
#define MAX_LIMIT_PHOTONUMBER 9
#define MAX_LIMIT_NUMS 150
@interface CFRepairsViewController ()<UIScrollViewDelegate, scanViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CTAssetsPickerControllerDelegate, AMapLocationManagerDelegate, MAMapViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong)CFRegisterTextFieldView *nameTextField;
@property (nonatomic, strong)CFRegisterTextFieldView *phoneTextField;
@property (nonatomic, strong)CFRegisterTextFieldView *placeTextField;
@property (nonatomic, strong)UIScrollView *repairsScrollView;
@property (nonatomic, strong)CFPickView *areaPickView;
@property (nonatomic, strong)CFPickView *reapirsStaionPickView;
@property (nonatomic, strong)UILabel *photoNumberLabel;
@property (nonatomic, strong)UIView *vagueView; // 透明层

@property (nonatomic, strong)UIView *machineNumberView;
@property (nonatomic, strong)UIView *machineView;
@property (nonatomic, strong)UILabel *machineNumber;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UIButton *selecteButton;
@property (nonatomic, strong)MachineModel *model;

@property (nonatomic, strong)CFRegisterTextFieldView *repairsStation;
@property (nonatomic, strong)CFRepairsStationModel *stationModel;
@property (nonatomic, strong)CFReasonTextView *reasonTextView;
@property (nonatomic, strong)UILabel *textNumberLabel;
@property (nonatomic, strong)UIView *photoView;
@property (nonatomic, strong)UICollectionView *repairsPhotoCollection;
@property (nonatomic, strong)CFRepairsPhotoCell *repairsPhotoCell;
@property (nonatomic, strong)AddMachineCollectionViewCell *addRepairsPhotoCell;
@property (nonatomic, strong)NSMutableArray *photoArray;

@property (nonatomic, strong)NSString *fileIds;
@property (nonatomic, strong)NSString *province;
@property (nonatomic, strong)NSString *city;
// 定位
@property (nonatomic, strong)AMapLocationManager *locationManager;
@property (nonatomic, assign)double latitude;
@property (nonatomic, assign)double longitude;
@property (nonatomic, strong)NSString *machineLat;
@property (nonatomic, strong)NSString *machineLng;
//@property (nonatomic, strong)UIImagePickerController *imagePicker;
@end

@implementation CFRepairsViewController
- (NSMutableArray *)photoArray
{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (UIView *)vagueView
{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [self.view addSubview:_vagueView];
    }
    return _vagueView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"报修";
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Navigation_Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submitButtonClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ChangfaColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.view.backgroundColor = BackgroundColor;
    [self createRepairsView];
    [self configLocationManager];
    // Do any additional setup after loading the view.
}
- (void)createRepairsView
{
    _repairsScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _repairsScrollView.contentSize = CGSizeMake(0, 1900 * screenHeight);
    _repairsScrollView.backgroundColor = BackgroundColor;
    _repairsScrollView.delegate = self;
    _repairsScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_repairsScrollView];
    
    _nameTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 98 * screenHeight) LabelWidth:100 * screenWidth LabelName:@"姓名" PlaceHolder:@"请输入姓名"];
    _nameTextField.textField.tag = 1001;
    [_nameTextField.textField addTarget:self action:@selector(textFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
    [_repairsScrollView addSubview:_nameTextField];
    _phoneTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, _nameTextField.frame.size.height, self.view.frame.size.width, _nameTextField.frame.size.height) LabelWidth:100 * screenWidth LabelName:@"电话" PlaceHolder:@"请输入电话"];
    _phoneTextField.textField.tag = 1002;
    [_phoneTextField.textField addTarget:self action:@selector(textFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
    _phoneTextField.textField.keyboardType = UIKeyboardTypePhonePad;
    [_repairsScrollView addSubview:_phoneTextField];
    _placeTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, _phoneTextField.frame.size.height + _phoneTextField.frame.origin.y, self.view.frame.size.width, _nameTextField.frame.size.height) OriginX:30 * screenWidth LabelWidth:130 * screenWidth LabelName:@"地址" ButtonImage:@"xiugai"];
    [_placeTextField.selecteButton setTitle:@"请选择省/市" forState:UIControlStateNormal];
    [_placeTextField.selecteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_placeTextField.selecteButton addTarget:self action:@selector(choosePlaceInfo) forControlEvents:UIControlEventTouchUpInside];
    [_repairsScrollView addSubview:_placeTextField];
    
    self.vagueView.hidden = YES;
    _areaPickView = [[CFPickView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight)];
    [self.areaPickView.cancelButton addTarget:self action:@selector(pickViewCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.areaPickView.sureButton addTarget:self action:@selector(pickViewsuerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_areaPickView];
    _reapirsStaionPickView = [[CFPickView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight)];
    [self.reapirsStaionPickView.cancelButton addTarget:self action:@selector(machinePickViewCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.reapirsStaionPickView.sureButton addTarget:self action:@selector(machinePickViewsuerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_reapirsStaionPickView];
    
    UILabel *repairsMachineLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, _placeTextField.frame.size.height + _placeTextField.frame.origin.y + 36 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 50 * screenHeight)];
    repairsMachineLabel.text = @"报修农机";
    repairsMachineLabel.font = CFFONT15;
    repairsMachineLabel.userInteractionEnabled = YES;
    repairsMachineLabel.textColor = [UIColor darkGrayColor];
    [_repairsScrollView addSubview:repairsMachineLabel];
    
    [self scanViewWithText:@"农机信息" Place:@"扫一扫" ScanText:@"" ScanImage:@"" ViewFrame:CGRectMake(0, repairsMachineLabel.frame.size.height + repairsMachineLabel.frame.origin.y + 10 * screenHeight, self.view.frame.size.width, 407 * screenHeight) ScanButtonFrame:CGRectMake(0, 0, self.view.frame.size.width, 325 * screenHeight) scanType:@""];

    _repairsStation = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, _machineNumberView.frame.size.height + _machineNumberView.frame.origin.y + 20 * screenWidth, self.view.frame.size.width, _nameTextField.frame.size.height) OriginX:30 * screenWidth LabelWidth:130 * screenWidth LabelName:@"维修站" ButtonImage:@"xiugai"];
    [_repairsStation.selecteButton setTitle:@"点击选择维修站点" forState:UIControlStateNormal];
    _repairsStation.selecteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _repairsStation.selecteButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 75 * screenWidth);
    [_repairsStation.selecteButton setTitleColor:ChangfaColor forState:UIControlStateNormal];
    [_repairsStation.selecteButton addTarget:self action:@selector(repairsStationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_repairsScrollView addSubview:_repairsStation];
    
    UILabel *reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(repairsMachineLabel.frame.origin.x, _repairsStation.frame.size.height + _repairsStation.frame.origin.y + 36 * screenHeight, repairsMachineLabel.frame.size.width, repairsMachineLabel.frame.size.height)];
    reasonLabel.text = @"输入故障描述";
    reasonLabel.font = CFFONT15;
    reasonLabel.textColor = BlackTextColor;
    [_repairsScrollView addSubview:reasonLabel];
    
    UIView *reasonBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, reasonLabel.frame.size.height + reasonLabel.frame.origin.y + 10 * screenHeight, self.view.frame.size.width, 380 * screenHeight)];
    reasonBackgroundView.backgroundColor = [UIColor whiteColor];
    [_repairsScrollView addSubview:reasonBackgroundView];
    _reasonTextView = [[CFReasonTextView alloc]initWithFrame:CGRectMake(28 * screenWidth, 0, self.view.frame.size.width - 56 * screenWidth, 380 * screenHeight)];
    _reasonTextView.delegate = self;
    _reasonTextView.placeholder = @"故障描述：（必填，150字以内）";
    _reasonTextView.maxNumberOfLines = 10;
    _reasonTextView.font = CFFONT15;
    [reasonBackgroundView addSubview:_reasonTextView];
    [_reasonTextView textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        CGRect frame = _reasonTextView.frame;
        frame.size.height = textHeight;
        _reasonTextView.frame = frame;
    }];
    _textNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_reasonTextView.frame.size.width - 100 * screenWidth, _reasonTextView.frame.size.height - 30 * screenHeight, 100 * screenWidth, 20 * screenHeight)];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.textColor = [UIColor grayColor];
    _textNumberLabel.font = CFFONT12;
    _textNumberLabel.text = [NSString stringWithFormat:@"0/%d", MAX_LIMIT_NUMS];
    [_reasonTextView addSubview:_textNumberLabel];
    
    UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(repairsMachineLabel.frame.origin.x, reasonBackgroundView.frame.size.height + reasonBackgroundView.frame.origin.y + 36 * screenHeight, repairsMachineLabel.frame.size.width, repairsMachineLabel.frame.size.height)];
    photoLabel.text = @"上传故障照片";
    photoLabel.font = CFFONT15;
    photoLabel.textColor = BlackTextColor;
    [_repairsScrollView addSubview:photoLabel];
    _photoNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(CF_WIDTH / 2, photoLabel.frame.origin.y, (CF_WIDTH - 60 * screenWidth) / 2, photoLabel.frame.size.height)];
    _photoNumberLabel.text = [NSString stringWithFormat:@"0/%d", MAX_LIMIT_PHOTONUMBER];
    _photoNumberLabel.textColor = [UIColor grayColor];
    _photoNumberLabel.textAlignment = NSTextAlignmentRight;
    _photoNumberLabel.font = CFFONT13;
    [_repairsScrollView addSubview:_photoNumberLabel];
    _photoView = [[UIView alloc]initWithFrame:CGRectMake(0, photoLabel.frame.size.height + photoLabel.frame.origin.y + 10 * screenWidth, self.view.frame.size.width, 300 * screenHeight)];
//    _photoView.backgroundColor = [UIColor whiteColor];
    [_repairsScrollView addSubview:_photoView];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _repairsPhotoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 25 * screenHeight, self.view.frame.size.width, 200 * screenHeight) collectionViewLayout:layout];
    _repairsPhotoCollection.backgroundColor = BackgroundColor;
    layout.sectionInset = UIEdgeInsetsMake(0, 30 * screenWidth, 0, 30 * screenWidth);
    layout.itemSize = CGSizeMake(200 * screenWidth, 200 * screenHeight);
    layout.minimumLineSpacing = 10 * screenWidth;
    layout.minimumInteritemSpacing = 0 * screenWidth;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _repairsPhotoCollection.showsHorizontalScrollIndicator = NO;
    _repairsPhotoCollection.delegate = self;
    _repairsPhotoCollection.dataSource = self;
    [_repairsPhotoCollection registerClass:[CFRepairsPhotoCell class] forCellWithReuseIdentifier:@"repairsPhotoCellId"];
    [_repairsPhotoCollection registerClass:[AddMachineCollectionViewCell class] forCellWithReuseIdentifier:@"addRepairsPhotoCellId"];
    [_photoView addSubview:_repairsPhotoCollection];
    
}
- (void)scanViewWithText:(NSString *)text
                   Place:(NSString *)place
                ScanText:(NSString *)scanText
               ScanImage:(NSString *)scanImage
               ViewFrame:(CGRect)viewFrame
         ScanButtonFrame:(CGRect)scanButtonFrame
                scanType:(NSString *)scanType
{
    _machineNumberView = [[UIView alloc]initWithFrame:viewFrame];
    _machineNumberView.userInteractionEnabled = YES;
    _machineNumberView.backgroundColor = [UIColor whiteColor];
    [_repairsScrollView addSubview:_machineNumberView];
    
    _machineNumber = [[UILabel alloc]init];
    _machineNumber.frame = CGRectMake(30 * screenWidth, 20 * screenHeight, 400 * screenWidth, 40 * screenHeight);
    _machineNumber.text = text;
    _machineNumber.font = CFFONT15;
    _machineNumber.textColor = BlackTextColor;
    _machineNumber.textAlignment = NSTextAlignmentLeft;
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(putInMachineNumber)];
    _machineNumber.userInteractionEnabled = YES;
//    [_machineNumber addGestureRecognizer:tapGesture];
    [_machineNumberView addSubview:_machineNumber];
    
    UIButton *machineNumberPlace = [UIButton buttonWithType:UIButtonTypeCustom];
    machineNumberPlace.frame = CGRectMake(self.view.frame.size.width -  330 * screenWidth, _machineNumber.frame.origin.y, 285 * screenWidth, _machineNumber.frame.size.height);
    [machineNumberPlace setTitle:place forState:UIControlStateNormal];
    machineNumberPlace.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    machineNumberPlace.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20 * screenWidth);
    [machineNumberPlace setTitleColor:ChangfaColor forState:UIControlStateNormal];
    machineNumberPlace.titleLabel.font = CFFONT15;
    [machineNumberPlace addTarget:self action:@selector(scanGetMachineInfo) forControlEvents:UIControlEventTouchUpInside];
    [_machineNumberView addSubview:machineNumberPlace];

    UIImageView *editImage = [[UIImageView alloc]initWithFrame:CGRectMake(machineNumberPlace.frame.size.width + machineNumberPlace.frame.origin.x, 26 * screenHeight, 15 * screenWidth, 30 * screenHeight)];
    editImage.image = [UIImage imageNamed:@"xiugai"];
    [_machineNumberView addSubview:editImage];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(_machineNumber.frame.origin.x, _machineNumber.frame.size.height + _machineNumber.frame.origin.y + 20 * screenHeight, self.view.frame.size.width - _machineNumber.frame.origin.x * 2, 2 * screenHeight)];
    _lineView.backgroundColor = BackgroundColor;
    [_machineNumberView addSubview:_lineView];
//
    _machineView = [[UIView alloc]initWithFrame:CGRectMake(0, _lineView.frame.size.height + _lineView.frame.origin.y, CF_WIDTH, 325 * screenHeight)];
    [_machineNumberView addSubview:_machineView];
    
    _selecteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selecteButton.frame = scanButtonFrame;
    [_selecteButton setTitle:@"点击选择报修农机" forState:UIControlStateNormal];
    [_selecteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_selecteButton addTarget:self action:@selector(chooseMachine) forControlEvents:UIControlEventTouchUpInside];
    [_machineView addSubview:_selecteButton];
}
#pragma mark - 选择农机地址
- (void)choosePlaceInfo
{
    [self.view endEditing:YES];
    _areaPickView.style = 1;
    _areaPickView.numberOfComponents = 2;
    _areaPickView.frame = CGRectMake(0, self.view.frame.size.height - 528 * screenHeight, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight);
    _vagueView.hidden = NO;
}
- (void)pickViewCancelButtonClick
{
    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
}
- (void)pickViewsuerButtonClick
{
    self.vagueView.hidden = YES;
    self.province = _areaPickView.province;
    self.city = _areaPickView.city;
    [_placeTextField.selecteButton setTitle:_areaPickView.selectedInfo forState:UIControlStateNormal];
    [_placeTextField.selecteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
}
- (void)scanGetMachineInfo
{
    ScanViewController *scan = [[ScanViewController alloc]init];
    scan.getInfoType = @"repair";
    scan.delegate = self;
    [self presentViewController:scan animated:YES completion:^{
        
    }];
}
#pragma mark - 选择农机
- (void)chooseMachine
{
    [self.view endEditing:YES];
    NSDictionary *dict = @{
                           @"userName":@"",
                           @"userpwd":@"",
                           @"loginType":@0,
                           @"accessToken":@"",
                           @"openId":@"",
                           };
    
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/getUserBindCar" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            for (NSDictionary *dic in [[responseObject objectForKey:@"body"] objectForKey:@"resultList"]) {
                MachineModel *model = [MachineModel machineModelWithDictionary:dic];
                [_reapirsStaionPickView.areaArray addObject:model];
            }
            _reapirsStaionPickView.style = 3;
            _reapirsStaionPickView.numberOfComponents = 1;
            _reapirsStaionPickView.frame = CGRectMake(0, self.view.frame.size.height - 528 * screenHeight, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight);
            _vagueView.hidden = NO;
        } else if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 300) {
            
        }  else {
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
#pragma mark -获取农机位置
- (void)getMachineLocation:(NSString *)string{
    NSDictionary *param = @{ @"imei":string,
                                  @"carBar":@"",
                                  };
    [CFAFNetWorkingMethod requestDataWithUrl:@"accounts/getUserCarLoaction?" Params:param Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"getlocation%@", responseObject);
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            self.model = [MachineModel machineModelWithDictionary:[responseObject objectForKey:@"body"]];
            [self reloadWorkerMachineNumberView:self.model];
            CGRect pickViewFrame = self.reapirsStaionPickView.frame;
            [UIView animateWithDuration:0.3 animations:^{
                self.reapirsStaionPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
            }];
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
- (void)machinePickViewCancelButtonClick
{
    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.reapirsStaionPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.reapirsStaionPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
}
- (void)machinePickViewsuerButtonClick
{
    self.model = _reapirsStaionPickView.machineModel;
    self.vagueView.hidden = YES;
    [self getMachineLocation:self.model.imei];
}
#pragma mark -代理扫描实现方法
- (void)scanGetInformation:(MachineModel *)model
{
        self.model = model;
        [self reloadWorkerMachineNumberView:model];
}
// 代理重新布局农机手农机信息
- (void)reloadWorkerMachineNumberView:(MachineModel *)model
{
    [_machineView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _selecteButton.hidden = YES;
    UIImageView *machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(_lineView.frame.origin.x, 12 * screenHeight, 200 * screenWidth, 200 * screenHeight)];
    switch ([model.carType integerValue]) {
        case 1:
            machineImage.image = [UIImage imageNamed:@"CFTuoLaJi"];
            break;
        case 2:
            machineImage.image = [UIImage imageNamed:@"CFShouGeJi"];
            break;
        case 3:
            machineImage.image = [UIImage imageNamed:@"CFChaYangji"];
            break;
        case 4:
            machineImage.image = [UIImage imageNamed:@"CFHongGanJi"];
            break;
        default:
            break;
    }
    [_machineView addSubview:machineImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.size.width + machineImage.frame.origin.x + 30 * screenWidth, 37 * screenHeight, self.view.frame.size.width - 260 * screenWidth, 30 * screenHeight)];
    nameLabel.text = [@"名称：" stringByAppendingString:[NSString stringWithFormat:@"%@",model.productName]];
    nameLabel.font = CFFONT14;
    nameLabel.textColor = BlackTextColor;
    [_machineView addSubview:nameLabel];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.size.height + nameLabel.frame.origin.y + 30 * screenHeight, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    typeLabel.text = [@"型号：" stringByAppendingString:[NSString stringWithFormat:@"%@",model.productModel]];
    typeLabel.font = CFFONT14;
    typeLabel.textColor = BlackTextColor;
    [_machineView addSubview:typeLabel];
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, typeLabel.frame.size.height + typeLabel.frame.origin.y + 30 * screenHeight, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    numberLabel.text = [@"备注："stringByAppendingString:[NSString stringWithFormat:@"%@",model.note]];
    numberLabel.font = CFFONT14;
    numberLabel.textColor = ChangfaColor;
    [_machineView addSubview:numberLabel];
    UILabel *buyTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.origin.x, machineImage.frame.size.height + machineImage.frame.origin.y + 20 * screenHeight, CF_WIDTH - 60 * screenWidth, nameLabel.frame.size.height)];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.salesDate doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate: date];
    buyTimeLabel.text = [@"购买时间："stringByAppendingString:[NSString stringWithFormat:@"%@",dateString]];
    buyTimeLabel.font = CFFONT13;
    buyTimeLabel.textColor = BlackTextColor;
    [_machineView addSubview:buyTimeLabel];
    UILabel *expireTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(buyTimeLabel.frame.origin.x, buyTimeLabel.frame.size.height + buyTimeLabel.frame.origin.y + 10 * screenHeight, buyTimeLabel.frame.size.width, nameLabel.frame.size.height)];
    NSString *expireString = [dateString stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:[NSString stringWithFormat:@"%ld", [[dateString substringWithRange:NSMakeRange(0, 4)] integerValue] + 2]];
    expireTimeLabel.text = [@"三  包  期："stringByAppendingString:[NSString stringWithFormat:@"%@",expireString]];
    expireTimeLabel.font = CFFONT13;
    expireTimeLabel.textColor = BlackTextColor;
    [_machineView addSubview:expireTimeLabel];
}
#pragma mark -collectionViewDelegate/DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    collectionView.backgroundColor = BackgroundColor;
    _repairsPhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"repairsPhotoCellId" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        _addRepairsPhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addRepairsPhotoCellId" forIndexPath:indexPath];
        _addRepairsPhotoCell.imageName = @"CF_Repairs_AddPhoto";
        return _addRepairsPhotoCell;
    }
    _repairsPhotoCell.deleteButton.hidden = NO;
    _repairsPhotoCell.deleteButton.tag = 1000 + indexPath.row - 1;
    [_repairsPhotoCell.deleteButton addTarget:self action:@selector(deleteImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _repairsPhotoCell.repairsPhoto.image = self.photoArray[indexPath.row - 1];
    _repairsPhotoCell.backgroundColor = [UIColor whiteColor];
    return _repairsPhotoCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (self.photoArray.count == MAX_LIMIT_PHOTONUMBER) {
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
    } else {
        CFPreviewPhotoViewController *preview = [[CFPreviewPhotoViewController alloc]init];
        preview.photoArray = self.photoArray;
        preview.selectedIndex = indexPath.row - 1;
        preview.headerHeight = navHeight;
        [self presentViewController:preview animated:YES completion:^{
                
        }];
    }
}
// 删除图片
- (void)deleteImageButtonClick:(UIButton *)sender
{
    [self.photoArray removeObjectAtIndex:sender.tag - 1000];
    [self.repairsPhotoCollection reloadData];
    [self uploadImagesArray];
}
#pragma mark - <CTAssetsPickerControllerDelegate>
-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
    if (picker.selectedAssets.count + self.photoArray.count >= MAX_LIMIT_PHOTONUMBER) {
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
    [self.repairsPhotoCollection reloadData];
    [self uploadImagesArray];
}

#pragma mark - 选择维修站点
- (void)repairsStationButtonClick
{
    [self.view endEditing:YES];
    if (self.city.length < 1) {
        [MBManager showBriefAlert:@"请选择省/市" time:1.5];
        return;
    }
    if (_model.imei.length < 1) {
        [MBManager showBriefAlert:@"请选择维修农机" time:1.5];
        return;
    }
    [self getRepairsStationInfo];
}
#pragma mark - 获取维修站点
- (void)getRepairsStationInfo
{
    NSLog(@"%ld", [self.model.lat integerValue]);
    if ([[NSString stringWithFormat:@"%@", self.model.lat] length] < 1 || [[NSString stringWithFormat:@"%@", self.model.lng] length] < 1) {
        [MBManager showBriefAlert:@"请重新扫描获取农机信息" time:1.5];
        return;
    }
    NSDictionary *params = @{
                             @"city":self.city,
                             @"userLat":[NSNumber numberWithDouble:self.latitude],
                             @"userLng":[NSNumber numberWithDouble:self.longitude],
                             @"machineLat":self.model.lat,
                             @"machineLng":self.model.lng,
                             @"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"UserUid"],
                             };
    [self.view endEditing:YES];
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"serviceInfo/getNearestService" Loading:1 Params:params Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@,  %@", responseObject, [[responseObject objectForKey:@"head"] objectForKey:@"message"]);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
           CFRepairsStationViewController *repairsStation = [[CFRepairsStationViewController alloc]init];
            for (NSDictionary *dic in [[responseObject objectForKey:@"body"] objectForKey:@"resultList"]) {
                CFRepairsStationModel *model = [CFRepairsStationModel stationModelWithDictionary:dic];
                [repairsStation.stationArray addObject:model];
            }
            // 回传model
            repairsStation.stationBlock = ^(CFRepairsStationModel *model){
                _stationModel = model;
                [_repairsStation.selecteButton setTitle:model.serviceCompany forState:UIControlStateNormal];
            };
           [self.navigationController pushViewController:repairsStation animated:YES];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark - 提交报修
- (void)submitButtonClick
{
    [MBManager hideAlert];
    if (_nameTextField.textField.text.length < 1) {
        [MBManager showBriefAlert:@"请填写姓名" time:1.5];
        return;
    }
    if (![CFClassMethod methodToJudgeTheMobile:_phoneTextField.textField.text]) {
        [MBManager showBriefAlert:@"请输入正确的手机号码" time:1.5];
        return;
    }
    if (_model.imei.length < 1) {
        [MBManager showBriefAlert:@"请选择维修农机" time:1.5];
        return;
    }
    if (_stationModel.location.length < 1) {
        [MBManager showBriefAlert:@"请选择维修站点" time:1.5];
        return;
    }
    if (_reasonTextView.text.length < 1) {
        [MBManager showBriefAlert:@"请输入故障描述" time:1.5];
        return;
    }
    [self submitRepairsinfo];
}
#pragma mark-多图片上传
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
        _photoNumberLabel.text = [NSString stringWithFormat:@"%ld/%d", self.photoArray.count, MAX_LIMIT_PHOTONUMBER];
        NSLog(@"%@", self.fileIds);
        [MBManager hideAlert];
    });
}
- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock
{
    [MBManager showWaitingWithTitle:@"上传图片中"];
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
#pragma mark - 图片上传完毕,提交报修
- (void)submitRepairsinfo
{
    [MBManager hideAlert];
    if (_fileIds.length < 1) {
        [MBManager showBriefAlert:@"请上传故障照片" time:1.5];
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = @{
                             @"token":[userDefaults objectForKey:@"UserToken"],
                             @"userLat":[NSNumber numberWithDouble:self.latitude],
                             @"userLng":[NSNumber numberWithDouble:self.longitude],
                             @"machineLat":self.model.lat,
                             @"machineLng":self.model.lng,
                             @"description":_reasonTextView.text,
                             @"barCode":_model.productBarCode,
                             @"imei":_model.imei,
                             @"serviceId":self.stationModel.serviceId,
                             @"fileIds":self.fileIds,
                             @"distance":self.stationModel.distance,
                             @"serviceLocation":self.stationModel.location,
                             @"contactName":self.nameTextField.textField.text,
                             @"contactMobile":self.phoneTextField.textField.text,
                             };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"reportRepair/saveReport" Loading:1 Params:params Method:@"post" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"submit%@, %@", responseObject, [[responseObject objectForKey:@"head"] objectForKey:@"message"]);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            CFRepairsRecordInfoViewController *repairRecord = [[CFRepairsRecordInfoViewController alloc]init];
            repairRecord.setTitle = YES;
            repairRecord.recordModel = [[CFRepairsRecordModel alloc]init];
            repairRecord.recordModel.reportId = [[[responseObject objectForKey:@"body"] objectForKey:@"result"] objectForKey:@"reportId"];
            repairRecord.recordModel.machineType = _model.carType;
            repairRecord.recordModel.machineName = _model.productName;
            repairRecord.recordModel.machineModel = _model.productModel;
            repairRecord.recordModel.machineRemarks = _model.note;
            repairRecord.recordModel.machineName = _model.productName;
            [self.navigationController pushViewController:repairRecord animated:YES];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark -定位
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];

    [self startSerialLocation];
}
- (void)startSerialLocation
{
    //开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)stopSerialLocation
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
        self.reapirsStaionPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
    [self.view endEditing:YES];
    [_reasonTextView endEditing:YES];
    [_repairsScrollView endEditing:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
        [self.view endEditing:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self stopSerialLocation];
}
- (void)textFieldDidChangeValue:(UITextField *)textField
{
    if (textField.tag  == 1001) {
        if (textField.text.length > 30) {
            textField.text = [textField.text substringToIndex:30];
        }
    } else {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)MAX_LIMIT_NUMS, (long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    self.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0, existTextNum),MAX_LIMIT_NUMS];
}
- (void)dealloc
{
    NSLog(@"DEALLOC");
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
