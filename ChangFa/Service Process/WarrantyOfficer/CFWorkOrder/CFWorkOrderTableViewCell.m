//
//  CFWorkOrderTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/3/19.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFWorkOrderTableViewCell.h"

@interface CFWorkOrderTableViewCell()
@property (nonatomic, strong)UIView *backView;

@end

@implementation CFWorkOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createWorkOrderCell];
    }
    return self;
}

- (void)createWorkOrderCell
{
    self.contentView.backgroundColor = BackgroundColor;
    _backView = [[UIView alloc]initWithFrame:CGRectMake(20 * screenWidth, 0, CF_WIDTH - 40 * screenWidth, 180 * screenHeight)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 20 * screenWidth;
    [self.contentView addSubview:_backView];
    
    _machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenWidth, 120 * screenWidth, 120 * screenHeight)];
    _machineImage.layer.cornerRadius = 60 * screenWidth;
    [_backView addSubview:_machineImage];
    
    _machineName = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.size.width + _machineImage.frame.origin.x + 20 * screenWidth, 40 * screenHeight, _backView.frame.size.width - 300 * screenWidth, 40 * screenHeight)];
    _machineName.text = @"";
    _machineName.font = CFFONT14;
    [_backView addSubview:_machineName];
    
    _machineType = [[UILabel alloc]initWithFrame:CGRectMake(_machineName.frame.origin.x, _machineName.frame.size.height + _machineName.frame.origin.y + 20 * screenHeight, _machineName.frame.size.width, _machineName.frame.size.height)];
    _machineType.text = @"";
    _machineType.font = CFFONT14;
    [_backView addSubview:_machineType];

    
    _orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(_backView.frame.size.width - 130 * screenWidth, _machineName.frame.origin.y, 100 * screenWidth, _machineName.frame.size.height)];
    _orderStatus.textColor = [UIColor redColor];
    _orderStatus.textAlignment = NSTextAlignmentRight;
    _orderStatus.font = CFFONT14;
    _orderStatus.text = @"未接单";
    [_backView addSubview:_orderStatus];
    
//    _residueTime = [[UILabel alloc]initWithFrame:CGRectMake(_orderStatus.frame.origin.x, _machineType.frame.origin.y, _orderStatus.frame.size.width, _orderStatus.frame.size.height)];
//    _residueTime.font = CFFONT14;
//    _residueTime.textAlignment = NSTextAlignmentRight;
//    _residueTime.textColor = [UIColor grayColor];
//    _residueTime.text = @"09:01";
//    [_backView addSubview:_residueTime];

}
- (void)setModel:(CFWorkOrderModel *)model
{
    _model = model;
    switch ([model.machineType integerValue]) {
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
    switch ([model.status integerValue]) {
        case 7:
            _orderStatus.text = @"未接单";
            _orderStatus.textColor = [UIColor redColor];
            break;
        case 8:
            _orderStatus.text = @"三包员已接单";
            _orderStatus.textColor = ChangfaColor;
            break;
        case 9:
            _orderStatus.text = @"出发";
            _orderStatus.textColor = ChangfaColor;
            break;
        case 10:
            _orderStatus.text = @"到达作业地点";
            _orderStatus.textColor = ChangfaColor;
            break;
        case 11:
            _orderStatus.text = @"上传故障照片";
            _orderStatus.textColor = ChangfaColor;
            break;
        case 12:
            _orderStatus.text = @"上传人机合影";
            _orderStatus.textColor = ChangfaColor;
            break;
        case 13:
            _orderStatus.text = @"填写维修单";
            _orderStatus.textColor = ChangfaColor;
            break;
        case 14:
            _orderStatus.text = @"待审核";
            _orderStatus.textColor = ChangfaColor;
            break;
        case 15:
            _orderStatus.text = @"审核通过";
            _orderStatus.textColor = ChangfaColor;
            break;
        case 16:
            _orderStatus.text = @"审核不通过";
            _orderStatus.textColor = [UIColor redColor];
            break;
        default:
            break;
    }
    _machineName.text = model.machineName;
    _machineType.text = model.machineModel;
}
- (void)setCellStyle:(NSInteger)cellStyle
{
    _cellStyle = cellStyle;
    switch (self.cellStyle) {
        case 1:
            _orderStatus.frame = CGRectMake(_backView.frame.size.width - 180 * screenWidth, _machineName.frame.origin.y, 150 * screenWidth, _machineName.frame.size.height * 2 + 20 * screenHeight);
            _orderStatus.textAlignment = NSTextAlignmentCenter;
            _orderStatus.numberOfLines = 2;
            _orderStatus.text = @"审核不通过";
            _orderStatus.font = CFFONT14;
            _residueTime.hidden = YES;
            break;
        case 2:
            _orderStatus.hidden = YES;
            _residueTime.hidden = YES;
        default:
            break;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
