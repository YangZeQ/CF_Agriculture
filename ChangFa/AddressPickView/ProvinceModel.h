//
//  ProvinceModel.h
//  ChangFa
//
//  Created by Developer on 2018/1/28.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *level;
@property (nonatomic, copy)NSString *pid;
@property (nonatomic, copy)NSString *title;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)provinceModelWithDictionary:(NSDictionary *)dict;
@end
