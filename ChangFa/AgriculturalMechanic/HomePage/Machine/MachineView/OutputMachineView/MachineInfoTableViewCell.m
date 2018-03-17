//
//  MachineInfoTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/1/17.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "MachineInfoTableViewCell.h"

@interface MachineInfoTableViewCell()
@property (nonatomic, strong)UIImageView *machineImage;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *typeLabel;
@property (nonatomic, strong)UILabel *barlabel;
@property (nonatomic, strong)UILabel *imeiLabel;
@end

@implementation MachineInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCellView];
    }
    return self;
}
- (void)createCellView{

//    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, typeLabel.frame.size.height + typeLabel.frame.origin.y + 30 * screenHeight, nameLabel.frame.size.width, nameLabel.frame.size.height)];
//    numberLabel.text = [@"车架号："stringByAppendingString:[NSString stringWithFormat:@"%@",model.productBarCode]];
//    numberLabel.textColor = [UIColor redColor];
//    [_machineNumberView addSubview:numberLabel];
}
- (void)setModel:(MachineModel *)model{
    _model = model;
    _nameLabel.text = [_nameLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", model.productName]];
    _typeLabel.text = [_typeLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", model.productModel]];
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
