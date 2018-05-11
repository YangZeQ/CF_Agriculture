//
//  CFRepairsDetailInfoViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/1.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsDetailInfoViewController.h"
#import "CFRepairsStationInfoViewController.h"
#import "CFPreviewPhotoViewController.h"
#import "CFRegisterTextFieldView.h"
#import "CFPickView.h"
#import "CFReasonTextView.h"
#import "MachineModel.h"
#import "CFRepairsPhotoCell.h"
@interface CFRepairsDetailInfoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UIScrollView *repairsScrollView;
@property (nonatomic, strong)CFPickView *areaPickView;
@property (nonatomic, strong)UIView *vagueView; // 透明层

@property (nonatomic, strong)UIView *machineNumberView;
@property (nonatomic, strong)UILabel *machineNumber;
@property (nonatomic, strong)UILabel *photoNumberLabel;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UIButton *selecteButton;
@property (nonatomic, strong)MachineModel *model;

@property (nonatomic, strong)UICollectionView *repairsPhotoCollection;
@property (nonatomic, strong)CFRepairsPhotoCell *repairsPhotoCell;

@property (nonatomic, strong)CFReasonTextView *reasonTextView;
@property (nonatomic, strong)UIView *photoView;
@end

@implementation CFRepairsDetailInfoViewController
- (UIView *)vagueView{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [self.view addSubview:_vagueView];
    }
    return _vagueView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"报修详情";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Navigation_Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.view.backgroundColor = BackgroundColor;
    [self createRepairsView];
    // Do any additional setup after loading the view.
}
- (void)createRepairsView{
    _repairsScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _repairsScrollView.contentSize = CGSizeMake(0, 1550 * screenHeight);
    _repairsScrollView.backgroundColor = BackgroundColor;
    [self.view addSubview:_repairsScrollView];
    
    CFRegisterTextFieldView *nameTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 98 * screenHeight) LabelWidth:100 * screenWidth LabelName:@"姓名" PlaceHolder:@""];
    nameTextField.textField.text = self.recordModel.contactName;
    nameTextField.textField.enabled = NO;
    [_repairsScrollView addSubview:nameTextField];
    CFRegisterTextFieldView *phoneTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, nameTextField.frame.size.height, self.view.frame.size.width, nameTextField.frame.size.height) LabelWidth:100 * screenWidth LabelName:@"电话" PlaceHolder:@"请输入电话"];
    phoneTextField.textField.text = self.recordModel.contactMobile;
    phoneTextField.textField.enabled = NO;
    phoneTextField.textField.keyboardType = UIKeyboardTypePhonePad;
    [_repairsScrollView addSubview:phoneTextField];
    
    UILabel *repairsMachineLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, phoneTextField.frame.size.height + phoneTextField.frame.origin.y + 36 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 50 * screenHeight)];
    repairsMachineLabel.text = @"报修农机";
    repairsMachineLabel.font = CFFONT15;
    repairsMachineLabel.textColor = [UIColor darkGrayColor];
    [_repairsScrollView addSubview:repairsMachineLabel];
    
    _machineNumberView = [[UIView alloc]initWithFrame:CGRectMake(0, repairsMachineLabel.frame.size.height + repairsMachineLabel.frame.origin.y + 10 * screenHeight, self.view.frame.size.width, 225 * screenHeight)];
    _machineNumberView.backgroundColor = [UIColor whiteColor];
    [_repairsScrollView addSubview:_machineNumberView];
    [self layoutWorkerMachineNumberView];
    
    CFRegisterTextFieldView *repairsStation = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, _machineNumberView.frame.size.height + _machineNumberView.frame.origin.y + 20 * screenWidth, self.view.frame.size.width, nameTextField.frame.size.height) OriginX:30 * screenWidth LabelWidth:130 * screenWidth LabelName:@"维修站" ButtonImage:@"xiugai"];
    [repairsStation.selecteButton setTitle:_recordModel.serviceCompany forState:UIControlStateNormal];
    repairsStation.selecteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    repairsStation.selecteButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 75 * screenWidth);
    [repairsStation.selecteButton setTitleColor:ChangfaColor forState:UIControlStateNormal];
    [repairsStation.selecteButton addTarget:self action:@selector(repairsStationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_repairsScrollView addSubview:repairsStation];
    
    UILabel *reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(repairsMachineLabel.frame.origin.x, repairsStation.frame.size.height + repairsStation.frame.origin.y + 36 * screenHeight, repairsMachineLabel.frame.size.width, repairsMachineLabel.frame.size.height)];
    reasonLabel.text = @"故障描述";
    reasonLabel.font = CFFONT15;
    reasonLabel.textColor = [UIColor darkGrayColor];
    [_repairsScrollView addSubview:reasonLabel];
    
    UIView *reasonBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, reasonLabel.frame.size.height + reasonLabel.frame.origin.y + 10 * screenHeight, self.view.frame.size.width, 380 * screenHeight)];
    reasonBackgroundView.backgroundColor = [UIColor whiteColor];
    [_repairsScrollView addSubview:reasonBackgroundView];
    _reasonTextView = [[CFReasonTextView alloc]initWithFrame:CGRectMake(28 * screenWidth, 0, self.view.frame.size.width - 56 * screenWidth, 380 * screenHeight)];
    //    _reasonTextView.delegate = self;
    _reasonTextView.editable = NO;
    _reasonTextView.text = _recordModel.discription;
    _reasonTextView.maxNumberOfLines = 10;
    _reasonTextView.font = CFFONT15;
    [reasonBackgroundView addSubview:_reasonTextView];
    
    UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(repairsMachineLabel.frame.origin.x, reasonBackgroundView.frame.size.height + reasonBackgroundView.frame.origin.y + 36 * screenHeight, repairsMachineLabel.frame.size.width, repairsMachineLabel.frame.size.height)];
    photoLabel.text = @"故障照片";
    photoLabel.font = CFFONT15;
    photoLabel.textColor = [UIColor darkGrayColor];
    [_repairsScrollView addSubview:photoLabel];
    _photoNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(CF_WIDTH / 2, photoLabel.frame.origin.y, (CF_WIDTH - 60 * screenWidth) / 2, photoLabel.frame.size.height)];
    _photoNumberLabel.text = [[NSString stringWithFormat:@"%ld", self.recordModel.filePath.count] stringByAppendingString:@"/9"];
    _photoNumberLabel.textAlignment = NSTextAlignmentRight;
    _photoNumberLabel.font = CFFONT13;
    [self.repairsScrollView addSubview:_photoNumberLabel];
    
    _photoView = [[UIView alloc]initWithFrame:CGRectMake(0, photoLabel.frame.size.height + photoLabel.frame.origin.y + 30 * screenWidth, self.view.frame.size.width, 250 * screenHeight)];
    [_repairsScrollView addSubview:_photoView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _repairsPhotoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _photoView.frame.size.height) collectionViewLayout:layout];
    _repairsPhotoCollection.backgroundColor = BackgroundColor;
    layout.sectionInset = UIEdgeInsetsMake(0 * screenHeight, 20 * screenWidth, 0 * screenHeight, 20 * screenWidth);
    layout.itemSize = CGSizeMake(250 * screenWidth, 250 * screenHeight);
    layout.minimumLineSpacing = 20 * screenWidth;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _repairsPhotoCollection.showsHorizontalScrollIndicator = NO;
    _repairsPhotoCollection.delegate = self;
    _repairsPhotoCollection.dataSource = self;
    [_repairsPhotoCollection registerClass:[CFRepairsPhotoCell class] forCellWithReuseIdentifier:@"repairsPhotoCellId"];
    [_photoView addSubview:_repairsPhotoCollection];

}
// 布局农机信息
- (void)layoutWorkerMachineNumberView{
    UIImageView *machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(_lineView.frame.origin.x, _lineView.frame.size.height + _lineView.frame.origin.y + 12 * screenHeight, 200 * screenWidth, 200 * screenHeight)];
    switch ([_recordModel.machineType integerValue]) {
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
    [_machineNumberView addSubview:machineImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(machineImage.frame.size.width + machineImage.frame.origin.x + 30 * screenWidth, _lineView.frame.size.height + _lineView.frame.origin.y + 37 * screenHeight, self.view.frame.size.width - 260 * screenWidth, 30 * screenHeight)];
    nameLabel.text = [@"名称：" stringByAppendingString:[NSString stringWithFormat:@"%@",_recordModel.machineName]];
    nameLabel.font = CFFONT14;
    [_machineNumberView addSubview:nameLabel];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.size.height + nameLabel.frame.origin.y + 30 * screenHeight, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    typeLabel.text = [@"型号：" stringByAppendingString:[NSString stringWithFormat:@"%@",_recordModel.machineModel]];
    typeLabel.font = CFFONT14;
    [_machineNumberView addSubview:typeLabel];
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, typeLabel.frame.size.height + typeLabel.frame.origin.y + 30 * screenHeight, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    numberLabel.text = [@"备注："stringByAppendingString:[NSString stringWithFormat:@"%@",_recordModel.machineRemarks]];
    numberLabel.font = CFFONT14;
    numberLabel.textColor = ChangfaColor;
    [_machineNumberView addSubview:numberLabel];
}
#pragma mark -collectionViewDelegate/DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _recordModel.filePath.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    _repairsPhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"repairsPhotoCellId" forIndexPath:indexPath];
    [_repairsPhotoCell.repairsPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.recordModel.filePath[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"CF_RepairImage"]];
    return _repairsPhotoCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CFPreviewPhotoViewController *preview = [[CFPreviewPhotoViewController alloc]init];
    preview.photoArray = self.recordModel.filePath;
    preview.selectedIndex = indexPath.row;
    preview.headerHeight = navHeight;
    [self presentViewController:preview animated:YES completion:^{
        
    }];
}
- (void)selecteButtonClick{
    self.vagueView.hidden = NO;
}
- (void)repairsStationButtonClick
{
    CFRepairsStationInfoViewController *repairsStation = [[CFRepairsStationInfoViewController alloc]init];
    repairsStation.stationModel = [[CFRepairsStationModel alloc]init];
    repairsStation.stationModel.serviceId = self.recordModel.serviceId;
    repairsStation.stationModel.distance = self.recordModel.distance;
    repairsStation.stationModel.serviceCompany = self.recordModel.serviceCompany;
    repairsStation.stationModel.location = self.recordModel.serviceLocation;
    [self.navigationController pushViewController:repairsStation animated:YES];
}

- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
    [self.view endEditing:YES];
    [_reasonTextView endEditing:YES];
    [_repairsScrollView endEditing:YES];
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
