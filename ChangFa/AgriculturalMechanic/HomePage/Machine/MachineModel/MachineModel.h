//
//  MachineModel.h
//  ChangFa
//
//  Created by dev on 2018/1/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MachineModel : NSObject
@property (nonatomic, copy)NSString *carState;
@property (nonatomic, copy)NSString *outDate;
@property (nonatomic, copy)NSString *inputDate;
@property (nonatomic, copy)NSString *saleDate;
@property (nonatomic, copy)NSString *salesDate;
@property (nonatomic, copy)NSString *carType;
@property (nonatomic, copy)NSString *cardNumber;
@property (nonatomic, copy)NSString *imei;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *note;
@property (nonatomic, copy)NSString *productBarCode;
@property (nonatomic, copy)NSString *productModel;
@property (nonatomic, copy)NSString *productName;
@property (nonatomic, copy)NSString *productionDate;
@property (nonatomic, copy)NSString *tel;
@property (nonatomic, copy)NSString *bindType;
@property (nonatomic, copy)NSString *isOnLine;
@property (nonatomic, copy)NSString *ownedDealers;
@property (nonatomic, copy)NSString *distributorsName;
@property (nonatomic, copy)NSString *distributorsContact;
@property (nonatomic, copy)NSString *distributorsTel;
@property (nonatomic, copy)NSString *distributorsAddress;
@property (nonatomic, copy)NSString *apply_type;
@property (nonatomic, copy)NSString *apply_state;
@property (nonatomic, copy)NSString *applyId;
@property (nonatomic, copy)NSString *apply_time;
@property (nonatomic, copy)NSString *reason;
@property (nonatomic, copy)NSString *checkDate;

@property (nonatomic, copy)NSString *drivingSpeed;
@property (nonatomic, copy)NSString *height;
@property (nonatomic, copy)NSString *hydraulic;
@property (nonatomic, copy)NSString *speed;
@property (nonatomic, copy)NSString *temperature;
@property (nonatomic, copy)NSString *voltage;
@property (nonatomic, copy)NSString *workingHours;

@property (nonatomic, copy)NSString *currentTime;
@property (nonatomic, copy)NSString *lat;
@property (nonatomic, copy)NSString *lng;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)machineModelWithDictionary:(NSDictionary *)dict;
@end
