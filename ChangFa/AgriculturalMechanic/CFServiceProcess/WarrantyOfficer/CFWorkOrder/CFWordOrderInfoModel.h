//
//  CFWordOrderInfoModel.h
//  ChangFa
//
//  Created by Developer on 2018/3/29.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFWordOrderInfoModel : NSObject
@property (nonatomic, strong)NSString *buyTime;
@property (nonatomic, strong)NSString *commentId;
@property (nonatomic, strong)NSString *contactMobile;
@property (nonatomic, strong)NSString *contactName;
@property (nonatomic, strong)NSString *createTime;
@property (nonatomic, strong)NSString *descriptions;
@property (nonatomic, strong)NSString *disId;
@property (nonatomic, strong)NSString *disNum;
@property (nonatomic, strong)NSArray *filePath;
@property (nonatomic, strong)NSString *finishTime;
@property (nonatomic, strong)NSString *machineModel;
@property (nonatomic, strong)NSString *machineName;
@property (nonatomic, strong)NSString *machineType;
@property (nonatomic, strong)NSString *repairId;
@property (nonatomic, strong)NSString *reportTime;
@property (nonatomic, strong)NSString *status;
@property (nonatomic, strong)NSArray *statusArray;
@property (nonatomic, strong)NSString *taskAddress;
@property (nonatomic, strong)NSString *taskLocation;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)orderInfoModelWithDictionary:(NSDictionary *)dict;
@end
