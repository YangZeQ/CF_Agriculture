//
//  CFWordOrderInfoModel.m
//  ChangFa
//
//  Created by Developer on 2018/3/29.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFWordOrderInfoModel.h"

@implementation CFWordOrderInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //    if ([key isEqualToString:@"id"]) {
    ////        self.id = value;
    //    }
        if ([key isEqualToString:@"description"]) {
            _descriptions = value;
        }
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)orderInfoModelWithDictionary:(NSDictionary *)dict{
    CFWordOrderInfoModel *model = [[CFWordOrderInfoModel alloc]initWithDictionary:dict];
    return model;
}
@end
