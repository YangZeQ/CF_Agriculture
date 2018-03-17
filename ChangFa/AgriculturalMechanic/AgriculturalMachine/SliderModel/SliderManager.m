//
//  SliderManager.m
//  ChangFa
//
//  Created by dev on 2018/1/8.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "SliderManager.h"

@implementation SliderManager
static id _instance;

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
@end
