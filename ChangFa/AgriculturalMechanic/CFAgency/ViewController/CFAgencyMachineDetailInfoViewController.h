//
//  CFAgencyMachineDetailInfoViewController.h
//  ChangFa
//
//  Created by Developer on 2018/1/25.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineModel.h"
#import "PersonModel.h"
@interface CFAgencyMachineDetailInfoViewController : UIViewController
@property (nonatomic, strong)MachineModel *machineModel;
@property (nonatomic, strong)PersonModel *personModel;
@property (nonatomic, copy)NSString *viewType;
@end
