//
//  NewsModel.m
//  ChangFa
//
//  Created by Developer on 2018/1/10.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel
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
+ (instancetype)newsModelWithDictionary:(NSDictionary *)dict{
    NewsModel *model = [[NewsModel alloc]initWithDictionary:dict];
    return model;
}
@end
