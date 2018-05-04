//
//  CFWorkOrderTableViewCell.h
//  ChangFa
//
//  Created by Developer on 2018/3/19.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFWorkOrderModel.h"
#import "YYText.h"
@interface CFWorkOrderTableViewCell : UITableViewCell
@property (nonatomic, strong)CFWorkOrderModel *model;
@property (nonatomic, assign)NSInteger cellStyle;    // 1、派工单  2、已完成派工单
@property (nonatomic, strong)UIImageView *machineImage;
@property (nonatomic, strong)UILabel *machineName;
@property (nonatomic, strong)UILabel *machineType;
@property (nonatomic, strong)YYLabel *orderStatus;
@property (nonatomic, strong)UILabel *residueTime;
@end
