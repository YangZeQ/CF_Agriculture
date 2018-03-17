//
//  CFAgencyReturnStatusViewController.h
//  ChangFa
//
//  Created by Developer on 2018/2/7.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineModel.h"
@interface CFAgencyReturnStatusViewController : UIViewController
- (instancetype)initWithSubmitTime:(NSString *)time;
- (instancetype)initWithModel:(MachineModel *)model;
@property (nonatomic, strong)NSString *applyId;
@property (nonatomic, strong)NSString *submitTime;
@property (nonatomic, strong)MachineModel *model;
@property (nonatomic, strong)NSString *returnReason;
@property (nonatomic, strong)NSString *returnReasonText;
@end
