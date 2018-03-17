//
//  CFRepairsMachineTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/3/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsMachineTableViewCell.h"

@interface CFRepairsMachineTableViewCell()
@property (nonatomic, strong)UIImageView *machineImageView;
@property (nonatomic, strong)UILabel *machineNameLabel;
@property (nonatomic, strong)UILabel *machineTypeLabel;
@property (nonatomic, strong)UILabel *machineNoteLabel;
@end

@implementation CFRepairsMachineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createRepairsMachineCell];
    }
    return self;
}
- (void)createRepairsMachineCell
{
    
}
- (void)setMachineModel:(MachineModel *)machineModel
{
    
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
