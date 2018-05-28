
//
//  CFMapTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/3/20.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFMapTableViewCell.h"

@interface CFMapTableViewCell ()

@end
@implementation CFMapTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createMapCell];
        self.backgroundColor = BackgroundColor;
    }
    return self;
}
- (void)createMapCell
{
    _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, 100 * screenHeight)];
    _infoLabel.backgroundColor = [UIColor whiteColor];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_infoLabel];
}
- (void)setFrame:(CGRect)frame
{
    _infoLabel.frame = CGRectMake(0, 0, CF_WIDTH, 100 * screenHeight);
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
