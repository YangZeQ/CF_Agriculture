//
//  CFAgencyRetreatStatusViewController.h
//  ChangFa
//
//  Created by Developer on 2018/2/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineModel.h"
@interface CFAgencyRetreatStatusViewController : UIViewController
- (instancetype)initWithSubmitTime:(NSString *)time;
- (instancetype)initWithModel:(MachineModel *)model;
@property (nonatomic, copy)NSString *applyId;
@property (nonatomic, copy)NSString *submitTime;
@property (nonatomic, strong)MachineModel *model;
@property (nonatomic, copy)NSString *retreatReason;
@property (nonatomic, copy)NSString *retreatReasonText;
@end
