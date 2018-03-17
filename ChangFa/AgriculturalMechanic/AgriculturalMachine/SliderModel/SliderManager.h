//
//  SliderManager.h
//  ChangFa
//
//  Created by dev on 2018/1/8.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SliderViewController.h"
@interface SliderManager : NSObject
+(instancetype)sharedInstance;
@property (strong, nonatomic) SliderViewController *LeftSlideVC;

@end
