//
//  ProvinceModel.m
//  ChangFa
//
//  Created by Developer on 2018/1/28.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "ProvinceModel.h"

@implementation ProvinceModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
        if ([key isEqualToString:@"id"]) {
            _ID = value;
        }
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
+ (instancetype)provinceModelWithDictionary:(NSDictionary *)dict{
    ProvinceModel *model = [[ProvinceModel alloc]initWithDictionary:dict];
    return model;
}
@end
