
//
//  BindAndOutput.m
//  ChangFa
//
//  Created by Developer on 2018/1/18.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "BindAndOutputView.h"

@interface BindAndOutputView()
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *typeLabel;
@property (nonatomic, strong)UILabel *barLabel;
@property (nonatomic, strong)UILabel *imeiLabel;
@property (nonatomic, strong)UILabel *statusInfo;
@property (nonatomic, strong)UILabel *addressInfo;
@property (nonatomic, strong)UILabel *agencyInfo;
@property (nonatomic, strong)UILabel *addressLabel;
@property (nonatomic, strong)UILabel *agencyLabel;
@property (nonatomic, strong)UIImageView *machineImage;
@end
@implementation BindAndOutputView

- (instancetype)initWithFrame:(CGRect)frame
                    ViewStyle:(NSString *)style{
    if (self = [super initWithFrame:frame]) {
        if ([style isEqualToString:@"imei"]) {
            [self createBindIMEISeccussView];
        } else if ([style isEqualToString:@"relieve"]) {
            [self creatRelieveBindIMEIView];
        } else if ([style isEqualToString:@"outputSuccess"]) {
            [self createOutputMachineSuccessView];
        }
    }
    return self;
}

// 绑定IMEI号成功
- (void)createBindIMEISeccussView{
    self.backgroundColor = BackgroundColor;
    UIView *bindView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, self.frame.size.width - 60 * screenWidth, 622 * screenHeight)];
    bindView.backgroundColor = [UIColor whiteColor];
    bindView.layer.cornerRadius = 20 * screenWidth;
    [self addSubview:bindView];
    
    _machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, 236 * screenWidth, 236 * screenHeight)];
    _machineImage.image = [UIImage imageNamed:@"machinePicture"];
    [bindView addSubview:_machineImage];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.size.width + _machineImage.frame.origin.x + 30 * screenWidth, 63 * screenHeight, self.frame.size.width - 346 * screenWidth, 100 * screenHeight)];
   _nameLabel.numberOfLines = 0;
    _nameLabel.text = @"名称：";
    _nameLabel.font = CFFONT15;
    [bindView addSubview:_nameLabel];
    _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.size.height + _nameLabel.frame.origin.y + 10 * screenHeight, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
    _typeLabel.text = @"型号：";
    _typeLabel.font = CFFONT15;
    [bindView addSubview:_typeLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(_machineImage.frame.origin.x, _machineImage.frame.origin.y + _machineImage.frame.size.height + 30 * screenHeight, self.frame.size.width - 60 * screenWidth, 2 * screenHeight)];
    lineView.backgroundColor = BackgroundColor;
    [bindView addSubview:lineView];
    
    _imeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.origin.x, lineView.frame.size.height + lineView.frame.origin.y + 50 * screenHeight, lineView.frame.size.width, 52 * screenHeight)];
    _imeiLabel.text = @"IMEI：";
    _imeiLabel.font = CFFONT15;
    [bindView addSubview:_imeiLabel];
    _barLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.origin.x, _imeiLabel.frame.origin.y + _imeiLabel.frame.size.height + 40 * screenHeight, lineView.frame.size.width, _imeiLabel.frame.size.height)];
    _barLabel.text = @"车架号：";
    _barLabel.font = CFFONT15;
    _barLabel.textColor = [UIColor redColor];
    [bindView addSubview:_barLabel];
    
    UIImageView *imageSucess = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 + 50 * screenWidth, _barLabel.frame.size.height + _barLabel.frame.origin.y + 30 * screenHeight, 214 * screenWidth, 174 * screenHeight)];
    imageSucess.image = [UIImage imageNamed:@"bindIMEI"];
    [bindView addSubview:imageSucess];
    
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeButton.frame = CGRectMake(30 * screenWidth, self.frame.size.height - 400 * screenHeight, self.frame.size.width - 60 * screenWidth, 100 * screenHeight);
    _completeButton.layer.cornerRadius = 20 * screenWidth;
    [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_completeButton setBackgroundColor:ChangfaColor];
    [self addSubview:_completeButton];
    
    _outputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _outputButton.frame = CGRectMake(30 * screenWidth, _completeButton.frame.size.height + _completeButton.frame.origin.y + 60 * screenHeight, self.frame.size.width - 60 * screenWidth, 100 * screenHeight);
    [_outputButton setTitle:@"出库" forState:UIControlStateNormal];
    [_outputButton setTitleColor:ChangfaColor forState:UIControlStateNormal];
    _outputButton.layer.borderColor = ChangfaColor.CGColor;
    _outputButton.layer.cornerRadius = 20 * screenWidth;
    _outputButton.layer.borderWidth = 1;
    [_outputButton.layer setMasksToBounds:YES];
    [self addSubview:_outputButton];
    
}
// 出库成功
- (void)createOutputMachineSuccessView {
    self.backgroundColor = BackgroundColor;
    UIView *bindView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, self.frame.size.width - 60 * screenWidth, 900 * screenHeight)];
    bindView.backgroundColor = [UIColor whiteColor];
    bindView.layer.cornerRadius = 20 * screenWidth;
    [self addSubview:bindView];
    
    _machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, 236 * screenWidth, 236 * screenHeight)];
    _machineImage.image = [UIImage imageNamed:@"machinePicture"];
    [bindView addSubview:_machineImage];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.size.width + _machineImage.frame.origin.x + 30 * screenWidth, 63 * screenHeight, self.frame.size.width - 376 * screenWidth, 100 * screenHeight)];
    _nameLabel.numberOfLines = 0;
    _nameLabel.text = @"名称：";
    _nameLabel.font = CFFONT15;
    [bindView addSubview:_nameLabel];
    _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.size.height + _nameLabel.frame.origin.y + 10 * screenHeight, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
    _typeLabel.text = @"型号：";
    _typeLabel.font = CFFONT15;
    [bindView addSubview:_typeLabel];
    
    _imeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.origin.x, _machineImage.frame.size.height + _machineImage.frame.origin.y + 40 * screenHeight, self.frame.size.width - 60 * screenWidth, 50 * screenHeight)];
    _imeiLabel.text = @"IMEI：";
    _imeiLabel.font = CFFONT15;
    [bindView addSubview:_imeiLabel];
    _barLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.origin.x, _imeiLabel.frame.origin.y + _imeiLabel.frame.size.height + 30 * screenHeight, _imeiLabel.frame.size.width, _imeiLabel.frame.size.height)];
    _barLabel.text = @"车架号：";
    _barLabel.font = CFFONT15;
    _barLabel.textColor = [UIColor redColor];
    [bindView addSubview:_barLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(_machineImage.frame.origin.x, _barLabel.frame.origin.y + _barLabel.frame.size.height + 30 * screenHeight, _barLabel.frame.size.width, 2 * screenHeight)];
    lineView.backgroundColor = BackgroundColor;
    [bindView addSubview:lineView];
    
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.origin.x, lineView.frame.size.height + lineView.frame.origin.y + 50 * screenHeight, lineView.frame.size.width, 50 * screenHeight)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"农机状态：已出库"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, 3)];
    statusLabel.attributedText = attributedString;
    [bindView addSubview:statusLabel];
    
    _statusInfo = [[UILabel alloc]initWithFrame:CGRectMake(statusLabel.frame.size.width + statusLabel.frame.origin.x, statusLabel.frame.origin.y, self.frame.size.width - 296 * screenWidth, statusLabel.frame.size.height)];
    [bindView addSubview:_statusInfo];
    
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.origin.x, statusLabel.frame.size.height + statusLabel.frame.origin.y + 50 * screenHeight, self.frame.size.width - 120 * screenWidth, 100 * screenHeight)];
    _addressLabel.numberOfLines = 2;
    _addressLabel.text = @"地址：";
    _addressLabel.font = CFFONT15;
    [bindView addSubview:_addressLabel];
//    _addressInfo = [[UILabel alloc]initWithFrame:CGRectMake(_statusInfo.frame.origin.x, _addressLabel.frame.origin.y, self.frame.size.width - 296 * screenWidth, statusLabel.frame.size.height)];
//    [bindView addSubview:_addressInfo];
    
    _agencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.origin.x, _addressLabel.frame.size.height + _addressLabel.frame.origin.y + 20 * screenHeight, self.frame.size.width - 120 * screenWidth, 50 * screenHeight)];
    _agencyLabel.text = @"经销商：";
    _agencyLabel.font = CFFONT15;
    [bindView addSubview:_agencyLabel];
//    _agencyInfo = [[UILabel alloc]initWithFrame:CGRectMake(_statusInfo.frame.origin.x, _agencyLabel.frame.origin.y, self.frame.size.width - 296 * screenWidth, statusLabel.frame.size.height)];
//    [bindView addSubview:_agencyInfo];
//    _agencyInfo.backgroundColor = [UIColor cyanColor];
    
    _imageStatus = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 + 50 * screenWidth, _agencyLabel.frame.size.height + _agencyLabel.frame.origin.y + 30 * screenHeight, 214 * screenWidth, 174 * screenHeight)];
    _imageStatus.image = [UIImage imageNamed:@"outputSuccess"];
    [bindView addSubview:_imageStatus];
    
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeButton.frame = CGRectMake(30 * screenWidth, self.frame.size.height - 240 * screenHeight, self.frame.size.width - 60 * screenWidth, 100 * screenHeight);
    _completeButton.layer.cornerRadius = 20 * screenWidth;
    [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_completeButton setBackgroundColor:ChangfaColor];
    [self addSubview:_completeButton];
}
// 取消绑定IMEI
- (void)creatRelieveBindIMEIView{
    UIView *relieveView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, [UIScreen mainScreen].bounds.size.width - 60 * screenWidth, 733 * screenHeight)];
    relieveView.backgroundColor = [UIColor whiteColor];
    relieveView.layer.cornerRadius = 20 * screenWidth;
    [self addSubview:relieveView];
    
    UIImageView *relieveImage = [[UIImageView alloc]initWithFrame:CGRectMake(310 * screenWidth, 60 * screenHeight, 70 * screenWidth, 56 * screenHeight)];
    relieveImage.image = [UIImage imageNamed:@"jiechubangding"];
    [relieveView addSubview:relieveImage];
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, relieveImage.frame.size.height + relieveImage.frame.origin.y + 30 * screenHeight, self.frame.size.width, 50 * screenHeight)];
    statusLabel.text = @"解除绑定IMEI号审核中...";
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.textColor = [UIColor redColor];
    [relieveView addSubview:statusLabel];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, statusLabel.frame.size.height + statusLabel.frame.origin.y + 140 * screenHeight, self.frame.size.width - 30 * 2 * screenWidth, 50 * screenHeight)];
    _nameLabel.numberOfLines = 2;
    _nameLabel.text = @"名称";
    [relieveView addSubview:_nameLabel];
    _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.size.height + _nameLabel.frame.origin.y + 30 * screenHeight, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
    _typeLabel.text = @"型号";
    [relieveView addSubview:_typeLabel];
    _imeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _typeLabel.frame.size.height + _typeLabel.frame.origin.y + 30 * screenHeight, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
    _imeiLabel.text = @"IMEI：";
    [relieveView addSubview:_imeiLabel];
    _barLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _imeiLabel.frame.size.height + _imeiLabel.frame.origin.y + 60 * screenHeight, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
    _barLabel.text = @"车架号";
    _barLabel.textColor = [UIColor redColor];
    [relieveView addSubview:_barLabel];
    
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeButton.frame = CGRectMake(30 * screenWidth, self.frame.size.height - 240 * screenHeight, self.frame.size.width - 60 * screenWidth, 100 * screenHeight);
    _completeButton.layer.cornerRadius = 20 * screenWidth;
    [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_completeButton setBackgroundColor:ChangfaColor];
    [self addSubview:_completeButton];
}

//- (void)createFillOutputInfoView{
//    self.backgroundColor = BackgroundColor;
//    UIView *outputView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 622 * screenHeight)];
//    outputView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:outputView];
//}
- (void)setModel:(MachineModel *)model{
    _model = model;
    switch ([model.carType integerValue]) {
        case 1:
            _machineImage.image = [UIImage imageNamed:@"CFTuoLaJi"];
            break;
        case 2:
            _machineImage.image = [UIImage imageNamed:@"CFShouGeJi"];
            break;
        case 3:
            _machineImage.image = [UIImage imageNamed:@"CFChaYangji"];
            break;
        case 4:
            _machineImage.image = [UIImage imageNamed:@"CFHongGanJi"];
            break;
        default:
            break;
    }
    _nameLabel.text = [_nameLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@",_model.productName]];
    _typeLabel.text = [_typeLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@",_model.productModel]];
    _barLabel.text = [_barLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@",_model.productBarCode]];
    _imeiLabel.text = [_imeiLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@",_model.imei]];
}
- (void)setAgencyModel:(AgencyModel *)agencyModel{
    _agencyModel = agencyModel;
    _addressLabel.text = [_addressLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@",_agencyModel.distributorsAddress]];
    _agencyLabel.text = [_agencyLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@",_agencyModel.distributorsName]];
}
@end
