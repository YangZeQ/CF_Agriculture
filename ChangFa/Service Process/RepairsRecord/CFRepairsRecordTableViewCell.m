//
//  CFRepairsRecordTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/3/3.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsRecordTableViewCell.h"

@interface CFRepairsRecordTableViewCell()
@property (nonatomic, strong)UIImageView *machineImageView;
@property (nonatomic, strong)UILabel *machineName;
@property (nonatomic, strong)UILabel *machineType;
@property (nonatomic, strong)UILabel *machineNote;
@property (nonatomic, strong)UILabel *recordStatus;
@end

@implementation CFRepairsRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createRepairsRecordCell];
    }
    return self;
}
- (void)createRepairsRecordCell{
    //图片
    _machineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, 160 * screenWidth, 160 * screenHeight)];
    _machineImageView.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_machineImageView];
    //名称
    _machineName = [[UILabel alloc]initWithFrame:CGRectMake(_machineImageView.frame.size.width + _machineImageView.frame.origin.x + 20 * screenWidth, _machineImageView.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 176 * screenWidth, 50 * screenHeight)];
    _machineName.text = @"名称：";
    _machineName.font = CFFONT15;
    [self.contentView addSubview:_machineName];
    //类型
    _machineType = [[UILabel alloc]initWithFrame:CGRectMake(_machineName.frame.origin.x, _machineName.frame.size.height + _machineName.frame.origin.y + 5 * screenHeight, _machineName.frame.size.width, _machineName.frame.size.height)];
    _machineType.text = @"类型：";
    _machineType.font = CFFONT15;
    [self.contentView addSubview:_machineType];
    //状态
    _recordStatus = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 130 * screenWidth, _machineType.frame.origin.y, 100 * screenWidth, _machineName.frame.size.height)];
    _recordStatus.textAlignment = NSTextAlignmentRight;
    _recordStatus.text = @"";
    _recordStatus.font = CFFONT14;
    [self.contentView addSubview:_recordStatus];
    //备注
    _machineNote = [[UILabel alloc]initWithFrame:CGRectMake(_machineType.frame.origin.x, _machineType.frame.size.height + _machineType.frame.origin.y + 5 * screenHeight, _machineType.frame.size.width, _machineType.frame.size.height)];
    _machineNote.text = @"备注：";
    _machineNote.font = CFFONT15;
    [self.contentView addSubview:_machineNote];
}
//- (void)setMachineModel:(MachineModel *)machineModel
//{
//    switch ([machineModel.carType integerValue]) {
//        case 1:
//            _machineImageView.image = [UIImage imageNamed:@"CFTuoLaJi"];
//            break;
//        case 2:
//            _machineImageView.image = [UIImage imageNamed:@"CFShouGeJi"];
//            break;
//        case 3:
//            _machineImageView.image = [UIImage imageNamed:@"CFChaYangji"];
//            break;
//        case 4:
//            _machineImageView.image = [UIImage imageNamed:@"CFHongGanJi"];
//            break;
//        default:
//            break;
//    }
//}
- (void)setRecordModel:(CFRepairsRecordModel *)recordModel
{
    _recordModel = recordModel;
    switch ([recordModel.machineType integerValue]) {
        case 1:
            _machineImageView.image = [UIImage imageNamed:@"CFTuoLaJi"];
            break;
        case 2:
            _machineImageView.image = [UIImage imageNamed:@"CFShouGeJi"];
            break;
        case 3:
            _machineImageView.image = [UIImage imageNamed:@"CFChaYangji"];
            break;
        case 4:
            _machineImageView.image = [UIImage imageNamed:@"CFHongGanJi"];
            break;
        default:
            break;
    }
    switch ([recordModel.status integerValue]) {
        case 1:
            _recordStatus.text = @"已提交";
            _recordStatus.textColor = ChangfaColor;
            break;
        case 2:
            _recordStatus.text = @"审核通过";
            _recordStatus.textColor = ChangfaColor;
            break;
        case 3:
            _recordStatus.text = @"已接单";
            _recordStatus.textColor = ChangfaColor;
            break;
        case 4:
            _recordStatus.text = @"维修结束";
            _recordStatus.textColor = ChangfaColor;
            break;
        case 5:
            _recordStatus.text = @"待评价";
            _recordStatus.textColor = [UIColor redColor];
            break;
        case 6:
            _recordStatus.text = @"已完成";
            _recordStatus.textColor = [UIColor grayColor];
            break;
        default:
            break;
    }
    _machineName.text = [@"名称：" stringByAppendingString:recordModel.machineName];
    _machineType.text = [@"类型：" stringByAppendingString:recordModel.machineModel];
    _machineNote.text = [@"备注：" stringByAppendingString:recordModel.machineRemarks];
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
