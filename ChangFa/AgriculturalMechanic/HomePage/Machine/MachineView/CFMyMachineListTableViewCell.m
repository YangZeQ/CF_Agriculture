//
//  CFMyMachineListTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/5/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFMyMachineListTableViewCell.h"

@interface CFMyMachineListTableViewCell ()
@property (nonatomic, strong)UIImageView *machineImage;
@property (nonatomic, strong)UILabel *machineNameLabel;
@property (nonatomic, strong)UILabel *machineTypeLabel;
@property (nonatomic, strong)UILabel *machineRemarkLabel;
@end
@implementation CFMyMachineListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createMyMachineListCell];
    }
    return self;
}

- (void)createMyMachineListCell
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, 0, CF_WIDTH - 60 * screenWidth, 224 * screenHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 20 * screenWidth;
    [self.contentView addSubview:backView];
    
    _machineImage = [[UIImageView alloc]initWithFrame:CGRectMake(20 * screenWidth, 32 * screenHeight, 200 * screenWidth, 160 * screenHeight)];
    [backView addSubview:_machineImage];
    _machineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(250 * screenWidth, 50 * screenHeight, backView.frame.size.width - 270 * screenWidth, 30 * screenHeight)];
    _machineNameLabel.text = @"类型：谷物联合收割机";
    _machineNameLabel.font = CFFONT16;
    [backView addSubview:_machineNameLabel];
    _machineTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineNameLabel.frame.origin.x, _machineNameLabel.frame.size.height + _machineNameLabel.frame.origin.y + 20 * screenHeight, _machineNameLabel.frame.size.width, _machineNameLabel.frame.size.height)];
    _machineTypeLabel.text = @"型号：CF808M";
    _machineTypeLabel.font = CFFONT16;
    [backView addSubview:_machineTypeLabel];
    _machineRemarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(_machineNameLabel.frame.origin.x, _machineTypeLabel.frame.size.height + _machineTypeLabel.frame.origin.y + 20 * screenHeight, _machineNameLabel.frame.size.width, _machineNameLabel.frame.size.height)];
    _machineRemarkLabel.text = @"备注：";
    _machineRemarkLabel.font = CFFONT14;
    _machineRemarkLabel.textColor = [UIColor grayColor];
    [backView addSubview:_machineRemarkLabel];
}

- (void)setMachineModel:(MachineModel *)machineModel
{
    _machineModel = machineModel;
    _machineNameLabel.text = [NSString stringWithFormat:@"类型：%@", machineModel.productName];
    _machineTypeLabel.text = [NSString stringWithFormat:@"型号：%@", machineModel.productModel];
    _machineRemarkLabel.text = [NSString stringWithFormat:@"备注：%@", machineModel.note];
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
