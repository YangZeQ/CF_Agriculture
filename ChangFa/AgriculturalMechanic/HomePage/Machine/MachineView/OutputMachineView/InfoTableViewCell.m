//
//  InfoTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/1/17.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "InfoTableViewCell.h"

@interface InfoTableViewCell()

@end
@implementation InfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCellView];
    }
    return self;
}
- (void)createCellView{
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * screenWidth, 30 * screenHeight, 206 * screenWidth, 60 * screenHeight)];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width, _nameLabel.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 326 * screenWidth, _nameLabel.frame.size.height)];
    self.titleLabel.textColor = BackgroundColor;
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_titleLabel];
}
- (void)setModel:(PersonModel *)model{
    _model = model;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = model.location;
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
