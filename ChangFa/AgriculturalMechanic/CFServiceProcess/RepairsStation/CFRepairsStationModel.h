//
//  CFRepairsStationModel.h
//  ChangFa
//
//  Created by Developer on 2018/3/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFRepairsStationModel : NSObject
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *county;
@property (nonatomic, strong)NSString *distance;
@property (nonatomic, strong)NSString *level;
@property (nonatomic, strong)NSString *location;
@property (nonatomic, strong)NSString *province;
@property (nonatomic, strong)NSString *serviceCompany;
@property (nonatomic, strong)NSString *serviceId;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSString *companyType;
@property (nonatomic, strong)NSString *contactName;
@property (nonatomic, strong)NSString *contactMobile;

@property (nonatomic, strong)NSString *commentNum;
@property (nonatomic, strong)NSString *commentLevel;
@property (nonatomic, strong)NSString *commentContent;
@property (nonatomic, strong)NSString *commentTime;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)stationModelWithDictionary:(NSDictionary *)dict;
@end
