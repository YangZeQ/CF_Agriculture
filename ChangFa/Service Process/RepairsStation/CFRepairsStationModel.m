//
//  CFRepairsStationModel.m
//  ChangFa
//
//  Created by Developer on 2018/3/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsStationModel.h"

@implementation CFRepairsStationModel
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
+ (instancetype)stationModelWithDictionary:(NSDictionary *)dict{
    CFRepairsStationModel *model = [[CFRepairsStationModel alloc]initWithDictionary:dict];
    return model;
}
@end
