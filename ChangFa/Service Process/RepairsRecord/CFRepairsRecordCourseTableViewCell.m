//
//  CFRepairsRecordCourseTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/3/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsRecordCourseTableViewCell.h"
@interface CFRepairsRecordCourseTableViewCell()

@end
@implementation CFRepairsRecordCourseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createRepairsRecordCourseCell];
    }
    return self;
}
- (void)createRepairsRecordCourseCell
{
    _lineTopLabel = [[UILabel alloc]initWithFrame:CGRectMake(72 * screenWidth, 0, 2 * screenWidth, 35 * screenHeight)];
    _lineTopLabel.backgroundColor = ChangfaColor;
    
    _courseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(63 * screenWidth, _lineTopLabel.frame.size.height, 20 * screenWidth, 20 * screenHeight)];
    _courseImageView.image = [UIImage imageNamed:@"CF_Course_Done"];
    
    _lineBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(_lineTopLabel.frame.origin.x, _courseImageView.frame.size.height + _courseImageView.frame.origin.y, _lineTopLabel.frame.size.width, 105 * screenHeight)];
    _lineBottomLabel.backgroundColor = ChangfaColor;
    
    _courseLabel = [[UILabel alloc]initWithFrame:CGRectMake(44 * screenWidth + _lineTopLabel.frame.origin.x, 20 * screenHeight, CF_WIDTH - (194 * screenWidth + _lineTopLabel.frame.origin.x), 50 * screenHeight)];
    _courseLabel.font = CFFONT14;
    _courseview = [[CFAttributeTouchView alloc]initWithFrame:CGRectMake(44 * screenWidth + _lineTopLabel.frame.origin.x, 20 * screenHeight, CF_WIDTH - (194 * screenWidth + _lineTopLabel.frame.origin.x), 40 * screenHeight)];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_courseLabel.frame.origin.x, _courseLabel.frame.size.height + _courseLabel.frame.origin.y + 10 * screenHeight, _courseLabel.frame.size.width, _courseLabel.frame.size.height)];
    _timeLabel.font = CFFONT13;
    _timeLabel.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_lineTopLabel];
    [self.contentView addSubview:_courseImageView];
    [self.contentView addSubview:_lineBottomLabel];
    [self.contentView addSubview:_courseview];
    [self.contentView addSubview:_courseLabel];
    [self.contentView addSubview:_timeLabel];
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
