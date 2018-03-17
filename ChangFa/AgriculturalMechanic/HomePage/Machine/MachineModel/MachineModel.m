//
//  MachineModel.m
//  ChangFa
//
//  Created by dev on 2018/1/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "MachineModel.h"

@implementation MachineModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //    if ([key isEqualToString:@"id"]) {
    ////        self.id = value;
    //    }
    //    if ([key isEqualToString:@"description"]) {
    ////        self.description = value;
    //    }
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)machineModelWithDictionary:(NSDictionary *)dict{
    MachineModel *model = [[MachineModel alloc]initWithDictionary:dict];
    return model;
}
@end
