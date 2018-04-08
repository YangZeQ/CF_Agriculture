//
//  CFFillInOrderModel.h
//  ChangFa
//
//  Created by Developer on 2018/4/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFFillInOrderModel : NSObject
@property (nonatomic, strong)NSString *customerOpinion;
@property (nonatomic, strong)NSString *disNum;
@property (nonatomic, strong)NSString *driveDistance;
@property (nonatomic, strong)NSString *examineStatus;
@property (nonatomic, strong)NSString *faultFileIds;
@property (nonatomic, strong)NSMutableArray *faultFilePath;
@property (nonatomic, strong)NSString *faultInstruction;
@property (nonatomic, strong)NSString *handleOpinion;
@property (nonatomic, strong)NSString *machineInstruction;
@property (nonatomic, strong)NSString *personFileIds;
@property (nonatomic, strong)NSMutableArray *personFilePath;
@property (nonatomic, strong)NSString *reason;
@property (nonatomic, strong)NSString *remarks;
@property (nonatomic, strong)NSString *repairId;
@property (nonatomic, strong)NSString *repairNum;
@property (nonatomic, strong)NSString *repairType;
@property (nonatomic, strong)NSString *useTime;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)fillInOrderModelWithDictionary:(NSDictionary *)dict;
@end
