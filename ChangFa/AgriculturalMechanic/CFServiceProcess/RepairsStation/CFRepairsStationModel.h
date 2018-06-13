//
//  CFRepairsStationModel.h
//  ChangFa
//
//  Created by Developer on 2018/3/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFRepairsStationModel : NSObject
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *county;
@property (nonatomic, copy)NSString *distance;
@property (nonatomic, copy)NSString *level;
@property (nonatomic, copy)NSString *location;
@property (nonatomic, copy)NSString *province;
@property (nonatomic, copy)NSString *serviceCompany;
@property (nonatomic, copy)NSString *serviceId;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *companyType;
@property (nonatomic, copy)NSString *contactName;
@property (nonatomic, copy)NSString *contactMobile;

@property (nonatomic, copy)NSString *commentNum;
@property (nonatomic, copy)NSString *commentLevel;
@property (nonatomic, copy)NSString *commentContent;
@property (nonatomic, copy)NSString *commentTime;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)stationModelWithDictionary:(NSDictionary *)dict;
@end
