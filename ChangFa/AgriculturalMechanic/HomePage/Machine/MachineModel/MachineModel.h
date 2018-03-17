//
//  MachineModel.h
//  ChangFa
//
//  Created by dev on 2018/1/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MachineModel : NSObject
@property (nonatomic, strong)NSString *carState;
@property (nonatomic, strong)NSString *outDate;
@property (nonatomic, strong)NSString *inputDate;
@property (nonatomic, strong)NSString *saleDate;
@property (nonatomic, strong)NSString *carType;
@property (nonatomic, strong)NSString *cardNumber;
@property (nonatomic, strong)NSString *imei;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *note;
@property (nonatomic, strong)NSString *productBarCode;
@property (nonatomic, strong)NSString *productModel;
@property (nonatomic, strong)NSString *productName;
@property (nonatomic, strong)NSString *productionDate;
@property (nonatomic, strong)NSString *tel;
@property (nonatomic, strong)NSString *bindType;
@property (nonatomic, strong)NSString *isOnLine;
@property (nonatomic, strong)NSString *ownedDealers;
@property (nonatomic, strong)NSString *distributorsName;
@property (nonatomic, strong)NSString *distributorsContact;
@property (nonatomic, strong)NSString *distributorsTel;
@property (nonatomic, strong)NSString *distributorsAddress;
@property (nonatomic, strong)NSString *apply_type;
@property (nonatomic, strong)NSString *apply_state;
@property (nonatomic, strong)NSString *applyId;
@property (nonatomic, strong)NSString *apply_time;
@property (nonatomic, strong)NSString *reason;
@property (nonatomic, strong)NSString *checkDate;

@property (nonatomic, strong)NSString *drivingSpeed;
@property (nonatomic, strong)NSString *height;
@property (nonatomic, strong)NSString *hydraulic;
@property (nonatomic, strong)NSString *speed;
@property (nonatomic, strong)NSString *temperature;
@property (nonatomic, strong)NSString *voltage;
@property (nonatomic, strong)NSString *workingHours;

@property (nonatomic, strong)NSString *currentTime;
@property (nonatomic, strong)NSString *lat;
@property (nonatomic, strong)NSString *lng;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)machineModelWithDictionary:(NSDictionary *)dict;
@end
