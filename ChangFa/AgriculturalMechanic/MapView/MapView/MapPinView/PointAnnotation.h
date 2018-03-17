//
//  PointAnnotation.h
//  ChangFa
//
//  Created by Developer on 2018/1/11.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "MachineModel.h"
@interface PointAnnotation : MAPointAnnotation
@property (nonatomic, strong) MachineModel *model;
@end
