//
//  MachinebarTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/1/17.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "MachinebarTableViewCell.h"

@interface MachinebarTableViewCell()
@property (nonatomic, strong)UILabel *barlabel;
@property (nonatomic, strong)UILabel *imeiLabel;
@end
@implementation MachinebarTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCellView];
    }
    return self;
}
- (void)createCellView{
    _imeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * screenWidth, 40 * screenHeight, [UIScreen mainScreen].bounds.size.width - 120 * screenWidth, 60 * screenHeight)];
    _barlabel = [[UILabel alloc]initWithFrame:CGRectMake(_imeiLabel.frame.origin.x, _imeiLabel.frame.origin.y + _imeiLabel.frame.size.height + 40 * screenHeight, _imeiLabel.frame.size.width, _imeiLabel.frame.size.height)];
    
    _imeiLabel.text = @"imei:";
    _barlabel.text = @"车架号：";
    
    _barlabel.textColor = [UIColor redColor];
    
    [self.contentView addSubview:_imeiLabel];
    [self.contentView addSubview:_barlabel];
}
- (void)setModel:(MachineModel *)model {
    _model = model;
    _barlabel.text = [_barlabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", model.productBarCode]];
    _imeiLabel.text = [_imeiLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", model.imei]];
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
