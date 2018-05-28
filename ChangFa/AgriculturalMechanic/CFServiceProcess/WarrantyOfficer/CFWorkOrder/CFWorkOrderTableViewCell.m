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

    
    _orderStatus = [[YYLabel alloc]initWithFrame:CGRectMake(_backView.frame.size.width - 180 * screenWidth, _machineName.frame.origin.y, 150 * screenWidth, _machineName.frame.size.height)];
    _orderStatus.textColor = [UIColor redColor];
    _orderStatus.textAlignment = NSTextAlignmentRight;
    _orderStatus.font = CFFONT12;
    _orderStatus.text = @"未接单";
    [_backView addSubview:_orderStatus];
    
    _residueTime = [[UILabel alloc]initWithFrame:CGRectMake(_backView.frame.size.width - 230 * screenWidth, _machineType.frame.origin.y, 200 * screenWidth, _orderStatus.frame.size.height)];
    _residueTime.font = CFFONT12;
    _residueTime.textAlignment = NSTextAlignmentRight;
    _residueTime.textColor = [UIColor grayColor];
    _residueTime.text = @"09:01";
    [_backView addSubview:_residueTime];

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
    NSDate *nowDate = [NSDate date]; // 当前时间
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    dayFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *dayCreat = [dayFormatter dateFromString:[model.updateTime substringWithRange:NSMakeRange(0, 10)]]; // 传入的时间
    
    NSCalendar *dayCalendar = [NSCalendar currentCalendar];
    NSCalendarUnit dayUnit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *dayCompas = [dayCalendar components:dayUnit fromDate:dayCreat toDate:nowDate options:0];
    NSLog(@"year=%zd  month=%zd  day=%zd",dayCompas.year,dayCompas.month,dayCompas.day);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *creat = [formatter dateFromString:model.updateTime]; // 传入的时间
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compas = [calendar components:unit fromDate:creat toDate:nowDate options:0];
    NSLog(@"year=%zd  month=%zd  day=%zd hour=%zd  minute=%zd",compas.year,compas.month,compas.day,compas.hour,compas.minute);
    
    if ([[NSString stringWithFormat:@"%zd", dayCompas.day] integerValue] > 2) {
        _residueTime.text = [model.updateTime substringWithRange:NSMakeRange(5, 5)];
        _residueTime.text = [model.updateTime substringWithRange:NSMakeRange(11, 5)];
    } else {
        if ([[NSString stringWithFormat:@"%zd", dayCompas.day] integerValue] > 0) {
            if ([[NSString stringWithFormat:@"%zd", dayCompas.day] integerValue] > 0 && [[NSString stringWithFormat:@"%zd", dayCompas.day] integerValue] < 2) {
                _residueTime.text = [@"昨天" stringByAppendingString:[model.updateTime substringWithRange:NSMakeRange(11, 5)]];
            } else if ([[NSString stringWithFormat:@"%zd", dayCompas.day] integerValue] > 1 && [[NSString stringWithFormat:@"%zd", dayCompas.day] integerValue] < 3) {
                _residueTime.text = [@"前天" stringByAppendingString:[model.updateTime substringWithRange:NSMakeRange(11, 5)]];
            } else {
                _residueTime.text = [NSString stringWithFormat:@"%zd天前", dayCompas.day];
            }
        } else if ([[NSString stringWithFormat:@"%zd", compas.hour] integerValue] > 0) {
            _residueTime.text = [model.updateTime substringWithRange:NSMakeRange(11, 5)];
        } else if ([[NSString stringWithFormat:@"%zd", compas.minute] integerValue] > 0) {
            _residueTime.text = [NSString stringWithFormat:@"%zd分钟前", compas.minute];
        } else {
            _residueTime.text = @"刚刚";
        }
    }
}
- (void)setCellStyle:(NSInteger)cellStyle
{
    _cellStyle = cellStyle;
    switch (self.cellStyle) {
        case 1:
            _orderStatus.frame = CGRectMake(_backView.frame.size.width - 180 * screenWidth, _machineName.frame.origin.y, 150 * screenWidth, _machineName.frame.size.height);
//            _orderStatus.numberOfLines = 2;
            _orderStatus.font = CFFONT12;
            break;
        case 2:
            _orderStatus.hidden = YES;
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
