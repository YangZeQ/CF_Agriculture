//
//  CFPersonalCenterTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/4/28.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFPersonalCenterTableViewCell.h"

@implementation CFPersonalCenterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createPersonalCenterTableViewCell];
    }
    return self;
}

- (void)createPersonalCenterTableViewCell
{
    _cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(33 * screenWidth, 35 * screenHeight, 50 * screenWidth, 50 * screenHeight)];
    [self.contentView addSubview:_cellImage];
    
    _cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(_cellImage.frame.origin.x + _cellImage.frame.size.width + 33 * screenWidth, 45 * screenHeight, 200 * screenWidth, 30 * screenHeight)];
    _cellLabel.font = CFFONT16;
    [self.contentView addSubview:_cellLabel];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 118 * screenHeight, CF_WIDTH - 60 * screenWidth, 2 * screenHeight)];
    _lineLabel.backgroundColor = BackgroundColor;
    [self.contentView addSubview:_lineLabel];
    
    __block CFPersonalCenterTableViewCell *blockSelf = self;
    self.imageFrameBlock = ^(CGRect imageFrame) {
        blockSelf.cellImage.frame = imageFrame;
    };
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
