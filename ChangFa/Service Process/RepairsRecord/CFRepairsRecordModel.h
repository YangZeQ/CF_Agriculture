//
//  CFRepairsRecordModel.h
//  ChangFa
//
//  Created by Developer on 2018/3/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFRepairsRecordModel : NSObject
@property (nonatomic, strong)NSString *fileIds;
@property (nonatomic, strong)NSString *imei;
@property (nonatomic, strong)NSString *machineModel;
@property (nonatomic, strong)NSString *machineName;
@property (nonatomic, strong)NSString *machineType;
@property (nonatomic, strong)NSString *machineRemarks;
@property (nonatomic, strong)NSString *reportId;
@property (nonatomic, strong)NSString *reportTime;
@property (nonatomic, strong)NSString *status;
@property (nonatomic, strong)NSString *userName;

@property (nonatomic, strong)NSString *contactMobile;
@property (nonatomic, strong)NSString *contactName;
@property (nonatomic, strong)NSString *createTime;
@property (nonatomic, strong)NSString *discription;
@property (nonatomic, strong)NSString *distance;
@property (nonatomic, strong)NSMutableArray *filePath;
@property (nonatomic, strong)NSString *ID;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSString *serviceCompany;
@property (nonatomic, strong)NSString *serviceId;
@property (nonatomic, strong)NSString *serviceLocation;
@property (nonatomic, strong)NSMutableArray *statusArray;
@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *userLocation;
@property (nonatomic, strong)NSString *commentTime;
@property (nonatomic, strong)NSString *commentLevel;
@property (nonatomic, strong)NSString *commentContent;

@property (nonatomic, strong)NSString *finishTime;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)recordModelWithDictionary:(NSDictionary *)dict;
@end
