//
//  CFRepairsRecordCourseTableViewCell.h
//  ChangFa
//
//  Created by Developer on 2018/3/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"

@interface CFRepairsRecordCourseTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *lineTopLabel;
@property (nonatomic, strong)UILabel *lineBottomLabel;
@property (nonatomic, strong)UIImageView *courseImageView;
@property (nonatomic, strong)YYLabel *courseLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *dayLabel;
@property (nonatomic, strong)UILabel *dayTimeLabel;

@property (nonatomic, assign)NSInteger status;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Time:(BOOL)time;
@end
