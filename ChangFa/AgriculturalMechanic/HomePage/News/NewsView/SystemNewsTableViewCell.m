//
//  SystemNewsTableViewCell.m
//  ChangFa
//
//  Created by dev on 2018/1/3.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "SystemNewsTableViewCell.h"

@implementation SystemNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSystemNewsCell];
    }
    return self;
}
- (void)createSystemNewsCell{
    
    self.backgroundColor = BackgroundColor;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, 10 * screenHeight, [UIScreen mainScreen].bounds.size.width - 60 * screenWidth, 148 * screenHeight)];
    backView.backgroundColor= [UIColor whiteColor];
    backView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:backView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 20 * screenHeight, backView.frame.size.width - 60 * screenWidth, 58 * screenHeight)];
    self.titleLabel.font = [UIFont systemFontOfSize:[self autoScaleW:16]];
    [backView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 10 * screenHeight, _titleLabel.frame.size.width, 50 * screenHeight)];
    self.timeLabel.font = CFFONT13;
    self.timeLabel.textColor = [UIColor grayColor];
    [backView addSubview:self.timeLabel];
    
    self.readNews = [[UIImageView alloc]initWithFrame:CGRectMake(backView.frame.size.width - 46 * screenWidth, 66 * screenHeight, 16 * screenWidth, 16 * screenHeight)];
    self.readNews.hidden = YES;
    self.readNews.image = [UIImage imageNamed:@"read"];
    [backView addSubview:self.readNews];
}

- (void)setModel:(NewsModel *)model{
    _model = model;
    _titleLabel.text = model.title;
    _timeLabel.text = [[model.createDate substringWithRange:NSMakeRange(0, 19)] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    if ([model.IsRead integerValue] == 0) {
        self.readNews.hidden = NO;
    } else {
        self.readNews.hidden = YES;
    }
    self.readNews.hidden = YES;
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
