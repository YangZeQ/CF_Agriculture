//
//  CFWorkOrderModel.h
//  ChangFa
//
//  Created by Developer on 2018/3/19.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFWorkOrderModel : NSObject
@property (nonatomic, copy)NSString *dispatchId;
@property (nonatomic, copy)NSString *machineModel;
@property (nonatomic, copy)NSString *machineName;
@property (nonatomic, copy)NSString *machineType;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *buyTime;
@property (nonatomic, copy)NSString *updateTime;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)orderModelWithDictionary:(NSDictionary *)dict;
@end
