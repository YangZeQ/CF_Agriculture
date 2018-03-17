//
//  PersonTableViewCell.m
//  ChangFa
//
//  Created by dev on 2018/1/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createPersonCell];
    }
    return self;
}
- (void)createPersonCell{
    _labelInfo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.contentView addSubview:_labelInfo];
}
- (void)setInfo:(NSString *)info{
    _labelInfo.text = info;
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
