//
//  CFRepairsRecordModel.h
//  ChangFa
//
//  Created by Developer on 2018/3/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFRepairsRecordModel : NSObject
@property (nonatomic, copy)NSString *fileIds;
@property (nonatomic, copy)NSString *imei;
@property (nonatomic, copy)NSString *machineModel;
@property (nonatomic, copy)NSString *machineName;
@property (nonatomic, copy)NSString *machineType;
@property (nonatomic, copy)NSString *machineRemarks;
@property (nonatomic, copy)NSString *reportId;
@property (nonatomic, copy)NSString *reportTime;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *contactMobile;
@property (nonatomic, copy)NSString *contactName;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *discription;
@property (nonatomic, copy)NSString *distance;
@property (nonatomic, strong)NSMutableArray *filePath;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *repairMobile;
@property (nonatomic, copy)NSString *repairUserName;
@property (nonatomic, copy)NSString *serviceCompany;
@property (nonatomic, copy)NSString *serviceId;
@property (nonatomic, copy)NSString *serviceLocation;
@property (nonatomic, strong)NSMutableArray *statusArray;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *userLocation;
@property (nonatomic, copy)NSString *commentTime;
@property (nonatomic, copy)NSString *commentLevel;
@property (nonatomic, copy)NSString *commentContent;

@property (nonatomic, copy)NSString *finishTime;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)recordModelWithDictionary:(NSDictionary *)dict;
@end
