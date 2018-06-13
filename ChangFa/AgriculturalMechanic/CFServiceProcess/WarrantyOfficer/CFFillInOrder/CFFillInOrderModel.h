//
//  CFFillInOrderModel.h
//  ChangFa
//
//  Created by Developer on 2018/4/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFFillInOrderModel : NSObject
@property (nonatomic, copy)NSString *customerOpinion;
@property (nonatomic, copy)NSString *disNum;
@property (nonatomic, copy)NSString *driveDistance;
@property (nonatomic, copy)NSString *examineStatus;
@property (nonatomic, strong)NSMutableArray *faultFileInfo;
@property (nonatomic, copy)NSString *faultInstruction;
@property (nonatomic, copy)NSString *handleOpinion;
@property (nonatomic, copy)NSString *machineInstruction;
@property (nonatomic, strong)NSMutableArray *personFileInfo;
@property (nonatomic, copy)NSString *reason;
@property (nonatomic, copy)NSString *remarks;
@property (nonatomic, copy)NSString *repairId;
@property (nonatomic, copy)NSString *repairNum;
@property (nonatomic, copy)NSString *repairType;
@property (nonatomic, copy)NSString *useTime;
@property (nonatomic, strong)NSDictionary *faults;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)fillInOrderModelWithDictionary:(NSDictionary *)dict;
@end
