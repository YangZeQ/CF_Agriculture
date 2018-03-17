//
//  AgencyModel.m
//  ChangFa
//
//  Created by Developer on 2018/1/25.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "AgencyModel.h"

@implementation AgencyModel
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
+ (instancetype)agencyModelWithDictionary:(NSDictionary *)dict{
    AgencyModel *model = [[AgencyModel alloc]initWithDictionary:dict];
    return model;
}

@end
