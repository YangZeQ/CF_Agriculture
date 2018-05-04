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
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Time:(BOOL)time
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (time) {
            [self createRepairsRecordCourseCellWithTime];
        }
    }
    return self;
}
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
    
    _courseLabel = [[YYLabel alloc]initWithFrame:CGRectMake(44 * screenWidth + _lineTopLabel.frame.origin.x, 20 * screenHeight, CF_WIDTH - (114 * screenWidth + _lineTopLabel.frame.origin.x), 50 * screenHeight)];
    _courseLabel.font = CFFONT14;
    _courseLabel.textColor = [UIColor grayColor];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_courseLabel.frame.origin.x, _courseLabel.frame.size.height + _courseLabel.frame.origin.y + 10 * screenHeight, _courseLabel.frame.size.width, _courseLabel.frame.size.height)];
    _timeLabel.font = CFFONT13;
    _timeLabel.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_lineTopLabel];
    [self.contentView addSubview:_courseImageView];
    [self.contentView addSubview:_lineBottomLabel];
    [self.contentView addSubview:_courseLabel];
    [self.contentView addSubview:_timeLabel];
}
- (void)createRepairsRecordCourseCellWithTime
{
    _dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * screenWidth, 50 * screenHeight, 100 * screenWidth, 30 * screenHeight)];
    _dayLabel.text = @"昨天";
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.textColor = [UIColor grayColor];
    _dayLabel.font = CFFONT12;
    [self.contentView addSubview:_dayLabel];
    _dayTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_dayLabel.frame.origin.x, _dayLabel.frame.size.height + _dayLabel.frame.origin.y, _dayLabel.frame.size.width, _dayLabel.frame.size.height)];
    _dayTimeLabel.text = @"08:56";
    _dayTimeLabel.textAlignment = NSTextAlignmentCenter;
    _dayTimeLabel.textColor = [UIColor grayColor];
    _dayTimeLabel.font = CFFONT12;
    [self.contentView addSubview:_dayTimeLabel];
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_dayLabel.frame.origin.x, _dayLabel.frame.origin.y, _dayLabel.frame.size.width, _dayLabel.frame.size.height + _dayTimeLabel.frame.size.height)];
    _timeLabel.font = CFFONT12;
    _timeLabel.numberOfLines = 0;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_timeLabel];
    
    _lineTopLabel = [[UILabel alloc]initWithFrame:CGRectMake(130 * screenWidth, 0, 2 * screenWidth, 70 * screenHeight)];
    _lineTopLabel.backgroundColor = ChangfaColor;
    
    _courseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_dayLabel.frame.size.width + _dayLabel.frame.origin.x + 11 * screenWidth, _lineTopLabel.frame.size.height + _lineTopLabel.frame.origin.y, 20 * screenWidth, 20 * screenHeight)];
    _courseImageView.image = [UIImage imageNamed:@"CF_Course_Done"];
    
    _lineBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(_lineTopLabel.frame.origin.x, _courseImageView.frame.size.height + _courseImageView.frame.origin.y, _lineTopLabel.frame.size.width, 70 * screenHeight)];
    _lineBottomLabel.backgroundColor = ChangfaColor;
    
    _courseLabel = [[YYLabel alloc]initWithFrame:CGRectMake(20 * screenWidth + _lineTopLabel.frame.origin.x + _lineTopLabel.frame.size.width, _courseImageView.frame.origin.y - 15 * screenHeight, CF_WIDTH - (194 * screenWidth + _lineTopLabel.frame.origin.x), 50 * screenHeight)];
    _courseLabel.font = CFFONT14;
    
//    _courseLabel.text = @"到达";
    
    [self.contentView addSubview:_lineTopLabel];
    [self.contentView addSubview:_courseImageView];
    [self.contentView addSubview:_lineBottomLabel];
    [self.contentView addSubview:_courseLabel];
}
- (void)setStatus:(NSInteger)status
{
    switch (status) {
        case 7:
            _courseLabel.text = @"未接单";
//            _courseLabel.textColor = [UIColor redColor];
            break;
        case 8:
            _courseLabel.text = @"已接单";
//            _courseLabel.textColor = ChangfaColor;
            break;
        case 9:
            _courseLabel.text = @"出发";
//            _courseLabel.textColor = ChangfaColor;
            break;
        case 10:
            _courseLabel.text = @"到达作业地点";
//            _courseLabel.textColor = ChangfaColor;
            break;
        case 11:
            _courseLabel.text = @"上传故障照片";
//            _courseLabel.textColor = ChangfaColor;
            break;
        case 12:
            _courseLabel.text = @"上传人机合影";
//            _courseLabel.textColor = ChangfaColor;
            break;
        case 13:
            _courseLabel.text = @"填写维修单";
//            _courseLabel.textColor = ChangfaColor;
            break;
        case 14:
            _courseLabel.text = @"待审核";
//            _courseLabel.textColor = ChangfaColor;
            break;
        case 15:
            _courseLabel.text = @"审核通过";
            //            _courseLabel.textColor = ChangfaColor;
            break;
        case 16:
            _courseLabel.text = @"审核不通过";
            //            _courseLabel.textColor = ChangfaColor;
            break;
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
