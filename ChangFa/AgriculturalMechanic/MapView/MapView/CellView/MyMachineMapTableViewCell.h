//
//  MyMachineMapTableViewCell.h
//  ChangFa
//
//  Created by dev on 2018/1/8.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineModel.h"
@interface MyMachineMapTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *name;
@property (nonatomic, strong)UILabel *style;
@property (nonatomic, strong)UILabel *remark;
@property (nonatomic, strong)MachineModel *model;
@end
