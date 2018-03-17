//
//  MyMachineCollectionViewCell.m
//  ChangFa
//
//  Created by dev on 2018/1/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "MyMachineCollectionViewCell.h"

@implementation MyMachineCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createMachineCellView];
    }
    return self;
}
- (void)createMachineCellView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 334 * screenWidth, 414 * screenHeight)];
    backImage.image = [UIImage imageNamed:@"juxing"];
    [self.contentView addSubview:backImage];
    self.machineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(87 * screenWidth, 57 * screenHeight, 160 * screenWidth, 160 * screenHeight)];
    self.machineImageView.image = [UIImage imageNamed:@"machinePicture"];
    [backImage addSubview:self.machineImageView];
    
    _statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, 60 * screenWidth, 35 * screenHeight)];
    _statusImageView.image = [UIImage imageNamed:@"CF_UserMachine_Offline"];
    [backImage addSubview:self.statusImageView];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(57 * screenWidth, 13 * screenHeight + _machineImageView.frame.origin.y + _machineImageView.frame.size.height, self.frame.size.width - 50 * 2 * screenWidth, 35 * screenHeight)];
    _nameLabel.font = [UIFont systemFontOfSize:[self autoScaleW:13]];
    _nameLabel.text = @"名称：";
    [backImage addSubview:_nameLabel];
    
    self.typrLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, 13 * screenHeight + _nameLabel.frame.origin.y + _nameLabel.frame.size.height,_nameLabel.frame.size.width, _nameLabel.frame.size.height)];
    _typrLabel.text = @"型号：";
    _typrLabel.font = [UIFont systemFontOfSize:[self autoScaleW:13]];
    [backImage addSubview:_typrLabel];
    
    self.remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, 13 * screenHeight + _typrLabel.frame.origin.y + _typrLabel.frame.size.height,_nameLabel.frame.size.width, _nameLabel.frame.size.height)];
    _remarkLabel.text = @"备注：";
    _remarkLabel.font = [UIFont systemFontOfSize:[self autoScaleW:13]];
    _remarkLabel.textColor = ChangfaColor;
    [backImage addSubview:_remarkLabel];

}
- (void)setModel:(MachineModel *)model{
    _model = model;
    switch ([model.carType integerValue]) {
        case 1:
            _machineImageView.image = [UIImage imageNamed:@"CFTuoLaJi"];
            break;
        case 2:
            _machineImageView.image = [UIImage imageNamed:@"CFShouGeJi"];
            break;
        case 3:
            _machineImageView.image = [UIImage imageNamed:@"CFChaYangji"];
            break;
        case 4:
            _machineImageView.image = [UIImage imageNamed:@"CFHongGanJi"];
            break;
        default:
            break;
    }
    switch ([model.carState integerValue]) {
        case 0:
            self.statusImageView.image = [UIImage imageNamed:@"CF_UserMachine_Offline"];
            break;
        case 1:
            self.statusImageView.image = [UIImage imageNamed:@"CF_UserMachine_Online"];
            break;
        default:
            break;
    }
    _nameLabel.text = [@"名称：" stringByAppendingString:[NSString stringWithFormat:@"%@", model.productName]];
    _typrLabel.text = [@"型号：" stringByAppendingString:[NSString stringWithFormat:@"%@", model.productModel]];
    _remarkLabel.text = [@"备注：" stringByAppendingString:[NSString stringWithFormat:@"%@", model.note]];
}
@end
