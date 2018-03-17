//
//  CFAgencySendingTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/1/24.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAgencySendingTableViewCell.h"
#import "CFAgencySendingViewController.h"
@interface CFAgencySendingTableViewCell ()
@property (nonatomic, strong)UIImageView *machineImage;
@property (nonatomic, strong)UILabel *machineName;
@property (nonatomic, strong)UILabel *machineType;
@property (nonatomic, strong)UILabel *machineNumber;

@end
@implementation CFAgencySendingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSendingCell];
        self.cellSelected = NO;
    }
    return self;
}
- (void)createSendingCell{
    _selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 100 * screenHeight, 40 * screenWidth, 40 * screenHeight)];
    _selectImage.image = [UIImage imageNamed:@"CFAgencySendingNotSelected"];
    [self.contentView addSubview:_selectImage];
    
    _machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(_selectImage.frame.size.width + _selectImage.frame.origin.x + 30 * screenWidth, 30 * screenHeight, 180 * screenWidth, 180 * screenHeight)];
    _machineImage.image = [UIImage imageNamed:@"machinePicture"];
    [self.contentView addSubview:_machineImage];
    
    _machineName = [[UILabel alloc]initWithFrame:CGRectMake(_machineImage.frame.size.width + _machineImage.frame.origin.x + 30 * screenWidth, 30 * screenHeight, 500 * screenWidth, 40 * screenHeight)];
    _machineName.text = @"名称：";
    _machineName.font = CFFONT14;
    [self.contentView addSubview:_machineName];
    
    _machineType = [[UILabel alloc]initWithFrame:CGRectMake(_machineName.frame.origin.x, _machineName.frame.size.height + _machineName.frame.origin.y + 30 * screenHeight, _machineName.frame.size.width, _machineName.frame.size.height)];
    _machineType.text = @"型号：";
    _machineType.font = CFFONT14;
    [self.contentView addSubview:_machineType];
    
    _machineNumber = [[UILabel alloc]initWithFrame:CGRectMake(_machineName.frame.origin.x, _machineType.frame.size.height + _machineType.frame.origin.y + 30 * screenHeight, _machineName.frame.size.width, _machineName.frame.size.height)];
    _machineNumber.text = @"车架号：";
    _machineNumber.font = CFFONT14;
    _machineNumber.textColor = [UIColor redColor];
    [self.contentView addSubview:_machineNumber];
}
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
    _machineName.text = [@"名称：" stringByAppendingString:[NSString stringWithFormat:@"%@", model.productName]];
    _machineType.text = [@"型号：" stringByAppendingString:[NSString stringWithFormat:@"%@", model.productModel]];
    _machineNumber.text = [@"车架号：" stringByAppendingString:[NSString stringWithFormat:@"%@", model.productBarCode]];
}
- (void)setCellSelected:(BOOL)cellSelected{
    if (cellSelected) {
        _cellSelected = cellSelected;
        _selectImage.image = [UIImage imageNamed:@"CFAgencySendingSelected"];
    } else {
        _cellSelected = cellSelected;
        _selectImage.image = [UIImage imageNamed:@"CFAgencySendingNotSelected"];
    }
}
//- (void)setCellCanScroll:(BOOL)cellCanScroll
//{
//    _cellCanScroll = cellCanScroll;
//    
//    for (CFAgencySendingViewController *VC in _viewControllers) {
//        VC.vcCanScroll = cellCanScroll;
//        if (!cellCanScroll) {//如果cell不能滑动，代表到了顶部，修改所有子vc的状态回到顶部
//            VC.tableView.contentOffset = CGPointZero;
//        }
//    }
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
