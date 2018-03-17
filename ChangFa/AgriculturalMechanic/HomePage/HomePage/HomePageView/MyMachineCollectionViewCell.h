//
//  MyMachineCollectionViewCell.h
//  ChangFa
//
//  Created by dev on 2018/1/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineModel.h"
@interface MyMachineCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView *machineImageView;
@property (nonatomic, strong)UIImageView *statusImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *typrLabel;
@property (nonatomic, strong)UILabel *remarkLabel;
@property (nonatomic, strong)MachineModel *model;
@end
