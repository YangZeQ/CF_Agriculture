//
//  CFFillInOrderModel.m
//  ChangFa
//
//  Created by Developer on 2018/4/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFFillInOrderModel.h"

@implementation CFFillInOrderModel
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
+ (instancetype)fillInOrderModelWithDictionary:(NSDictionary *)dict{
    CFFillInOrderModel *model = [[CFFillInOrderModel alloc]initWithDictionary:dict];
    return model;
}
@end
