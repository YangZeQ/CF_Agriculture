//
//  CFPersonalCenterViewController.m
//  ChangFa
//
//  Created by Developer on 2018/4/28.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFPersonalCenterViewController.h"
#import "CFIntegralViewController.h"
#import "CFPersonalInfoViewController.h"
#import "CFMyMachineListViewController.h"
#import "CFPersonalCenterTableViewCell.h"

@interface CFPersonalCenterViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UIImageView *QRcodeContentImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIImageView *editBriefImage;
@property (nonatomic, strong)UILabel *editBriefLabel;
@property (nonatomic, strong)UIButton *editBriefButton;
@property (nonatomic, strong)UILabel *briefLabel;
@property (nonatomic, strong)UILabel *integralLabel;
@property (nonatomic, strong)UIButton *signButton;

@property (nonatomic, strong)UIView *vagueView;
@end

@implementation CFPersonalCenterViewController

- (UIView *)vagueView
{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _vagueView.hidden = YES;
        [self.view addSubview:_vagueView];
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, 405 * screenHeight, CF_WIDTH - 60 * screenWidth, 700 * screenHeight)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.cornerRadius = 20 * screenWidth;
        [_vagueView addSubview:whiteView];
        
        //1. 实例化二维码滤镜
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        // 2. 恢复滤镜的默认属性
        [filter setDefaults];
        // 3. 将字符串转换成NSData
        NSString *urlStr = @"imeiTest";
        NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
        // 4. 通过KVO设置滤镜inputMessage数据
        [filter setValue:data forKey:@"inputMessage"];
        // 5. 获得滤镜输出的图像
        CIImage *outputImage = [filter outputImage];
        // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
        self.QRcodeContentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(106 * screenWidth, 111 * screenHeight, CF_WIDTH - 272 * screenWidth, 478 * screenHeight)];
        self.QRcodeContentImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:170];//重绘二维码,使其显示清晰
        [whiteView addSubview:self.QRcodeContentImageView];
    }
    return _vagueView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UserBackgroundColor;
    [self createPersonalCenterView];
    // Do any additional setup after loading the view.
}

- (void)createPersonalCenterView
{
    UIImageView *personalHeaderImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, 442 * screenHeight)];
    personalHeaderImage.image = [UIImage imageNamed:@"Personal_HeaderImage"];
    personalHeaderImage.userInteractionEnabled = YES;
    [self.view addSubview:personalHeaderImage];
    
    UIButton *imeiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imeiButton.frame = CGRectMake(CF_WIDTH - 68 * screenWidth, 64 * screenHeight + 20, 38 * screenWidth, 38 * screenHeight);
    [imeiButton setBackgroundImage:[UIImage imageNamed:@"Personal_IMEIBtn"] forState:UIControlStateNormal];
    [imeiButton addTarget:self action:@selector(imeiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [personalHeaderImage addSubview:imeiButton];
    
    UIImageView *personalInfoImage = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 178 * screenHeight, CF_WIDTH - 60 * screenWidth, 360 * screenHeight)];
    personalInfoImage.image = [UIImage imageNamed:@"Personal_InfoImage"];
    personalInfoImage.userInteractionEnabled = YES;
    [self.view addSubview:personalInfoImage];
    
    UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake((CF_WIDTH - 180 * screenWidth) / 2, 89 * screenWidth, 180 * screenWidth, 180 * screenHeight)];
    [headerImage sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserHeadUrl"]] placeholderImage:[UIImage imageNamed:@"Person_HeaderPhoto"]];
    headerImage.layer.cornerRadius = 90 * screenWidth;
    headerImage.clipsToBounds = YES;
    headerImage.userInteractionEnabled = YES;
    [self.view addSubview:headerImage];
    UIButton *headerImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headerImageButton.frame = CGRectMake((CF_WIDTH - 180 * screenWidth) / 2, 89 * screenWidth, 180 * screenWidth, 180 * screenHeight);
    headerImageButton.layer.cornerRadius = 90 * screenWidth;
    [headerImageButton addTarget:self action:@selector(headerImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headerImageButton];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 120 * screenHeight, personalInfoImage.frame.size.width, 35 * screenHeight)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = @"李雷";
    [personalInfoImage addSubview:_nameLabel];
    
    _editBriefImage = [[UIImageView alloc]initWithFrame:CGRectMake(240 * screenWidth, 181 * screenHeight, 28 * screenWidth, 28 * screenHeight)];
    _editBriefImage.image = [UIImage imageNamed:@"Personal_Edit"];
    _editBriefImage.userInteractionEnabled = YES;
    [personalInfoImage addSubview:_editBriefImage];
    _editBriefLabel = [[UILabel alloc]initWithFrame:CGRectMake(280 * screenWidth, _editBriefImage.frame.origin.y, 250 * screenWidth, _editBriefImage.frame.size.height)];
    _editBriefLabel.text = @"编辑个人简介";
    _editBriefLabel.font = CFFONT14;
    _editBriefLabel.userInteractionEnabled = YES;
    _editBriefLabel.textColor = [UIColor grayColor];
    [personalInfoImage addSubview:_editBriefLabel];
    _editBriefButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBriefButton.frame = CGRectMake(_editBriefImage.frame.origin.x, _editBriefImage.frame.origin.y, _editBriefLabel.frame.origin.x - _editBriefImage.frame.origin.x + _editBriefLabel.frame.size.width, _editBriefImage.frame.size.height);
    [_editBriefButton addTarget:self action:@selector(editBriefButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [personalInfoImage addSubview:_editBriefButton];
    
    UIImageView *integralImage = [[UIImageView alloc]initWithFrame:CGRectMake(60 * screenWidth, 268 * screenHeight, 26 * screenWidth, 26 * screenHeight)];
    integralImage.image = [UIImage imageNamed:@"Personal_Integral"];
    integralImage.userInteractionEnabled = YES;
    [personalInfoImage addSubview:integralImage];
    _integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(107 * screenWidth, integralImage.frame.origin.y - 2 * screenHeight, 200 * screenWidth, 30 * screenHeight)];
    _integralLabel.textColor = ChangfaColor;
    _integralLabel.text = @"500积分";
    _integralLabel.font = CFFONT16;
    _integralLabel.userInteractionEnabled = YES;
    [personalInfoImage addSubview:_integralLabel];
    UIButton *integralButton = [UIButton buttonWithType:UIButtonTypeCustom];
    integralButton.frame = CGRectMake(integralImage.frame.origin.x, _integralLabel.frame.origin.y, _integralLabel.frame.origin.x - integralImage.frame.origin.x + _integralLabel.frame.size.width, _integralLabel.frame.size.height);
    [integralButton addTarget:self action:@selector(integralButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [personalInfoImage addSubview:integralButton];
    
    _signButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _signButton.frame = CGRectMake(394 * screenWidth, 252 * screenHeight, 236 * screenWidth, 58 * screenHeight);
    [_signButton setTitle:@"签到" forState:UIControlStateNormal];
    [_signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_signButton setBackgroundImage:[UIImage imageNamed:@"Personal_SignBtn"] forState:UIControlStateNormal];
    [_signButton addTarget:self action:@selector(signButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [personalInfoImage addSubview:_signButton];
    
    UITableView *personalTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 568 * screenHeight, CF_WIDTH, 500 * screenHeight) style:UITableViewStylePlain];
    personalTableView.delegate = self;
    personalTableView.dataSource = self;
    personalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    personalTableView.scrollEnabled = NO;
    [self.view addSubview:personalTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    CFPersonalCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFPersonalCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.cellImage.image = [UIImage imageNamed:@"Personal_Store"];
            cell.cellLabel.text = @"常发商城";
        } else {
            cell.imageFrameBlock(CGRectMake(33 * screenWidth, 33 * screenHeight, 50 * screenWidth, 54 * screenHeight));
            cell.cellImage.image = [UIImage imageNamed:@"Personal_Activity"];
            cell.cellLabel.text = @"线下活动";
            cell.lineLabel.hidden = YES;
        }
    } else {
        if (indexPath.row == 0) {
            cell.imageFrameBlock(CGRectMake(30 * screenWidth, 38 * screenHeight, 56 * screenWidth, 44 * screenHeight));
            cell.cellImage.image = [UIImage imageNamed:@"Personal_Machine"];
            cell.cellLabel.text = @"我的农机";
        } else {
            cell.cellImage.image = [UIImage imageNamed:@"Personal_Setting"];
            cell.cellLabel.text = @"设置";
            cell.lineLabel.hidden = YES;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        CFMyMachineListViewController *myMachine = [[CFMyMachineListViewController alloc]init];
        [self.navigationController pushViewController:myMachine animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120 * screenHeight;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, 20 * screenWidth)];
    footView.backgroundColor = UserBackgroundColor;
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 20 * screenHeight;
    }
    return 0.01f;
}

- (void)imeiButtonClick
{
    self.vagueView.hidden = NO;
}
- (void)headerImageButtonClick
{
    CFPersonalInfoViewController *personInfo = [[CFPersonalInfoViewController alloc]init];
    [self.navigationController pushViewController:personInfo animated:YES];
}
- (void)editBriefButtonClick
{
    
}
- (void)integralButtonClick
{
    CFIntegralViewController *integral = [[CFIntegralViewController alloc]init];
    [self.navigationController pushViewController:integral animated:YES];
}
- (void)signButtonClick
{
    [_signButton setBackgroundColor:[UIColor grayColor]];
    [_signButton setTitle:@"已签到" forState:UIControlStateNormal];
    [_signButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    _signButton.layer.cornerRadius = _signButton.frame.size.height / 2;
    _signButton.userInteractionEnabled = NO;
}
/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.vagueView.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
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
