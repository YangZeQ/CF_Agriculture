//
//  CFWorkOrderModel.h
//  ChangFa
//
//  Created by Developer on 2018/3/19.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFWorkOrderModel : NSObject
@property (nonatomic, strong)NSString *dispatchId;
@property (nonatomic, strong)NSString *machineModel;
@property (nonatomic, strong)NSString *machineName;
@property (nonatomic, strong)NSString *machineType;
@property (nonatomic, strong)NSString *status;
@property (nonatomic, strong)NSString *buyTime;
@property (nonatomic, strong)NSString *updateTime;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)orderModelWithDictionary:(NSDictionary *)dict;
@end
