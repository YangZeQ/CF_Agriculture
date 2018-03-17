//
//  CFAgencySendingTableViewCell.h
//  ChangFa
//
//  Created by Developer on 2018/1/24.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineModel.h"
@interface CFAgencySendingTableViewCell : UITableViewCell
@property (nonatomic, strong)MachineModel *model;
@property (nonatomic, strong)UIImageView *selectImage;
@property (nonatomic, assign)BOOL cellSelected;
@end
