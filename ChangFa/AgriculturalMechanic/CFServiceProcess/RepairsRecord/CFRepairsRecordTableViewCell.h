//
//  CFRepairsRecordTableViewCell.h
//  ChangFa
//
//  Created by Developer on 2018/3/3.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineModel.h"
#import "CFRepairsRecordModel.h"
@interface CFRepairsRecordTableViewCell : UITableViewCell
@property (nonatomic, strong)MachineModel *machineModel;
@property (nonatomic, strong)CFRepairsRecordModel *recordModel;
@end
