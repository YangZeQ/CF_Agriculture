//
//  CFWordOrderInfoModel.h
//  ChangFa
//
//  Created by Developer on 2018/3/29.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFWordOrderInfoModel : NSObject
@property (nonatomic, copy)NSString *buyTime;
@property (nonatomic, copy)NSString *commentId;
@property (nonatomic, copy)NSString *contactMobile;
@property (nonatomic, copy)NSString *contactName;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *descriptions;
@property (nonatomic, copy)NSString *disId;
@property (nonatomic, copy)NSString *disNum;
@property (nonatomic, strong)NSArray *filePath;
@property (nonatomic, copy)NSString *finishTime;
@property (nonatomic, copy)NSString *machineModel;
@property (nonatomic, copy)NSString *machineName;
@property (nonatomic, copy)NSString *machineType;
@property (nonatomic, copy)NSString *repairId;
@property (nonatomic, copy)NSString *reportTime;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, strong)NSArray *statusArray;
@property (nonatomic, copy)NSString *taskAddress;
@property (nonatomic, copy)NSString *taskLocation;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)orderInfoModelWithDictionary:(NSDictionary *)dict;
@end
