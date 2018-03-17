
//
//  PersonModel.m
//  ChangFa
//
//  Created by Developer on 2018/1/16.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
       
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
+ (instancetype)personModelWithDictionary:(NSDictionary *)dict{
    PersonModel *model = [[PersonModel alloc]initWithDictionary:dict];
    return model;
}
@end
