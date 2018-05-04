//
//  CFIntegralTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/4/28.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFIntegralTableViewCell.h"

@interface CFIntegralTableViewCell ()
@property (nonatomic, strong)UILabel *eventLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *scoreLabel;
@end

@implementation CFIntegralTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createIntegralTableViewCell];
    }
    return self;
}

- (void)createIntegralTableViewCell
{
    _eventLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenWidth, 200 * screenWidth, 30 * screenHeight)];
    _eventLabel.text = @"发布动态";
    _eventLabel.font = CFFONT16;
    [self.contentView addSubview:_eventLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 80 * screenHeight, 250 * screenWidth, 20 * screenHeight)];
    _timeLabel.text = @"2018.4.3 11:26:50";
    _timeLabel.font = CFFONT12;
    _timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_timeLabel];
    
    _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(CF_WIDTH - 180 * screenWidth, 52 * screenHeight, 150 * screenWidth, 25 * screenHeight)];
    _scoreLabel.text = @"+ 50";
    _scoreLabel.font = CFFONT16;
    _scoreLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_scoreLabel];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 128 * screenHeight, CF_WIDTH - 60 * screenWidth, 2 * screenHeight)];
    lineLabel.backgroundColor = BackgroundColor;
    [self.contentView addSubview:lineLabel];
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
