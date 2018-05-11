//
//  CFPersonalInfoViewController.m
//  ChangFa
//
//  Created by Developer on 2018/4/28.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFPersonalInfoViewController.h"
#import "CFRegisterTextFieldView.h"
#import "PickView.h"
#import "CFPickView.h"
@interface CFPersonalInfoViewController ()
@property (nonatomic, strong)UIImageView *lineView;
@property (nonatomic, strong)UIButton *placeInfo;

@property (nonatomic, strong)CFPickView *areaPickView;
@property (nonatomic, strong)UIView *vagueView; // 透明层
@end

@implementation CFPersonalInfoViewController

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
    //获取导航栏下面黑线
    _lineView = [self getLineViewInNavigationBar:self.navigationController.navigationBar];
    
    self.view.backgroundColor = UserBackgroundColor;
    self.navigationItem.title = @"个人信息";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Navigation_Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, CFFONT16, NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self createPersonInfoView];
    // Do any additional setup after loading the view.
}
//视图将要显示时隐藏
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _lineView.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)createPersonInfoView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, navHeight, CF_WIDTH, 230 * screenHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake((CF_WIDTH - 150 * screenWidth) / 2, 40 * screenHeight, 150 * screenWidth, 150 * screenHeight)];
    [headerImage sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserHeadUrl"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    headerImage.userInteractionEnabled = YES;
    headerImage.clipsToBounds = YES;
    headerImage.layer.cornerRadius = 75 * screenHeight;
    [headerView addSubview:headerImage];
    UIButton *headerImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headerImageButton.frame = headerImage.frame;
    [headerImageButton addTarget:self action:@selector(headerImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headerImageButton];
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake(417 * screenWidth, 139 * screenHeight, 46 * screenWidth, 46 * screenHeight);
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"Personal_CameraBtn"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(headerImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cameraButton];
    
    CFRegisterTextFieldView *nameTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, 250 * screenWidth + navHeight, CF_WIDTH, 130 * screenHeight) LabelWidth:170 * screenWidth LabelName:@"昵称" PlaceHolder:@""];
    nameTextField.label.textColor = [UIColor blackColor];
    nameTextField.textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    [self.view addSubview:nameTextField];
    CFRegisterTextFieldView *briefTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, nameTextField.frame.size.height + nameTextField.frame.origin.y, CF_WIDTH, 130 * screenHeight) LabelWidth:170 * screenWidth LabelName:@"简介" PlaceHolder:@"个人简介"];
    briefTextField.label.textColor = [UIColor blackColor];
    [self.view addSubview:briefTextField];
    CFRegisterTextFieldView *sexTextField = [[CFRegisterTextFieldView alloc]initWithFrame:CGRectMake(0, briefTextField.frame.size.height + briefTextField.frame.origin.y, CF_WIDTH, 130 * screenHeight) LabelText:@"性别" LabelWidth:170 * screenWidth OriginX1:203 * screenWidth OriginX2:477 * screenWidth];
    [self.view addSubview:sexTextField];
    
    UIView *place = [[UIView alloc]initWithFrame:CGRectMake(0, sexTextField.frame.size.height + sexTextField.frame.origin.y, sexTextField.frame.size.width, sexTextField.frame.size.height)];
    place.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:place];
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 0, 170 * screenWidth, place.frame.size.height)];
    placeLabel.text = @"地区";
    placeLabel.font = CFFONT16;
    [place addSubview:placeLabel];
    UIButton *placeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    placeButton.frame = CGRectMake(702 * screenWidth, 50 * screenHeight, 18 * screenWidth, 30 * screenHeight);
    [placeButton setImage:[UIImage imageNamed:@"xiugai"] forState:UIControlStateNormal];
    [placeButton addTarget:self action:@selector(changeinformation:) forControlEvents:UIControlEventTouchUpInside];
    [place addSubview:placeButton];
    _placeInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    _placeInfo.titleLabel.font = CFFONT16;
    _placeInfo.frame = CGRectMake(placeLabel.frame.size.width + placeLabel.frame.origin.x, 0, CF_WIDTH - (placeLabel.frame.size.width + placeLabel.frame.origin.x), place.frame.size.height);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserLocation"] length] > 0) {
        [_placeInfo setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserLocation"] forState:UIControlStateNormal];
    }
    [_placeInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _placeInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _placeInfo.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_placeInfo addTarget:self action:@selector(changeinformation:) forControlEvents:UIControlEventTouchUpInside];
    [place addSubview:_placeInfo];
    
    self.vagueView.hidden = YES;
    _areaPickView = [[CFPickView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight)];
    [self.areaPickView.cancelButton addTarget:self action:@selector(pickViewCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.areaPickView.sureButton addTarget:self action:@selector(pickViewsuerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_areaPickView];
}
- (void)headerImageButtonClick
{
    
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonClick
{
    
}
- (void)changeinformation:(UIButton *)sender
{
    _areaPickView.numberOfComponents = 3;
    _areaPickView.frame = CGRectMake(0, self.view.frame.size.height - 528 * screenHeight, [UIScreen mainScreen].bounds.size.width, 528 * screenHeight);
    self.vagueView.hidden = NO;
}
#pragma mark - AddressPickerViewDelegate
- (void)pickViewCancelButtonClick{
    self.vagueView.hidden = YES;
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
}
- (void)pickViewsuerButtonClick{
    self.vagueView.hidden = YES;
    [_placeInfo setTitle:_areaPickView.selectedInfo forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:_areaPickView.selectedInfo forKey:@"UserLocation"];
    [_placeInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CGRect pickViewFrame = self.areaPickView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        self.areaPickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, pickViewFrame.size.width, pickViewFrame.size.height);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//视图将要消失时取消隐藏
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _lineView.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}
//找到导航栏最下面黑线视图
- (UIImageView *)getLineViewInNavigationBar:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
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
