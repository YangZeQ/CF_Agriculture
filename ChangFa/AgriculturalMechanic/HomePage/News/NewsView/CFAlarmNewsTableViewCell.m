//
//  CFAlarmNewsTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/3/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAlarmNewsTableViewCell.h"

@interface CFAlarmNewsTableViewCell()
@property (nonatomic, strong)UILabel *alarmReasonLabel;
@property (nonatomic, strong)UILabel *alarmCodeLabel;
@property (nonatomic, strong)UILabel *alarmResolveLabel;
@property (nonatomic, strong)UILabel *alarmTimeLabel;
@end
@implementation CFAlarmNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createAlarmNewsCell];
    }
    return self;
}
- (void)createAlarmNewsCell
{
    _alarmReasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, CF_WIDTH, 50 * screenHeight)];
    _alarmCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_alarmReasonLabel.frame.origin.x, _alarmReasonLabel.frame.size.height + _alarmReasonLabel.frame.origin.y + 20 * screenHeight, CF_WIDTH, 50 * screenHeight)];
    _alarmResolveLabel = [[UILabel alloc]initWithFrame:CGRectMake(_alarmReasonLabel.frame.origin.x, _alarmCodeLabel.frame.size.height + _alarmCodeLabel.frame.origin.y + 20 * screenHeight, CF_WIDTH, 50 * screenHeight)];
    _alarmTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_alarmReasonLabel.frame.origin.x, 20 * screenHeight, CF_WIDTH, 50 * screenHeight)];
    
    [self.contentView addSubview:_alarmReasonLabel];
    [self.contentView addSubview:_alarmCodeLabel];
    [self.contentView addSubview:_alarmResolveLabel];
    [self.contentView addSubview:_alarmTimeLabel];
}
- (void)setNewsModel:(NewsModel *)newsModel
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
