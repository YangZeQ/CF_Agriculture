//
//  MyMachineMapTableViewCell.m
//  ChangFa
//
//  Created by dev on 2018/1/8.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "MyMachineMapTableViewCell.h"

@implementation MyMachineMapTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCellView];
    }
    return self;
}
- (void)createCellView{
    _name = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 10 * screenHeight, self.contentView.frame.size.width - 60 * screenWidth, 50 * screenHeight)];
    _name.text = @"农机：";
    _name.font = [UIFont systemFontOfSize:[self autoScaleW:14]];
    _style = [[UILabel alloc]initWithFrame:CGRectMake(_name.frame.origin.x, _name.frame.origin.y + _name.frame.size.height + 5 * screenHeight, _name.frame.size.width, _name.frame.size.height)];
    _style.text = @"型号：";
    _style.font = [UIFont systemFontOfSize:[self autoScaleW:14]];
    _remark = [[UILabel alloc]initWithFrame:CGRectMake(_name.frame.origin.x, _style.frame.origin.y + _style.frame.size.height + 5 * screenHeight, _name.frame.size.width, _name.frame.size.height)];
    _remark.textColor = ChangfaColor;
    _remark.text = @"备注：";
    _remark.font = [UIFont systemFontOfSize:[self autoScaleW:14]];
    [self.contentView addSubview:_name];
    [self.contentView addSubview:_style];
    [self.contentView addSubview:_remark];
}
- (void)setModel:(MachineModel *)model{
    _model = model;
    _name.text = [_name.text stringByAppendingString:model.productName];
    _style.text = [_style.text stringByAppendingString:[NSString stringWithFormat:@"%@", model.productModel]];
    _remark.text = [_remark.text stringByAppendingString:model.note];
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
