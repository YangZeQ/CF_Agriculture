//
//  CFCommentModel.m
//  ChangFa
//
//  Created by Developer on 2018/3/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFCommentModel.h"

@implementation CFCommentModel
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
+ (instancetype)commentModelWithDictionary:(NSDictionary *)dict{
    CFCommentModel *model = [[CFCommentModel alloc]initWithDictionary:dict];
    return model;
}

@end
