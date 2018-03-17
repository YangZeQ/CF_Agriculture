//
//  CFRepairsRecordModel.m
//  ChangFa
//
//  Created by Developer on 2018/3/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsRecordModel.h"

@implementation CFRepairsRecordModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
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
+ (instancetype)recordModelWithDictionary:(NSDictionary *)dict{
    CFRepairsRecordModel *model = [[CFRepairsRecordModel alloc]initWithDictionary:dict];
    return model;
}
@end
