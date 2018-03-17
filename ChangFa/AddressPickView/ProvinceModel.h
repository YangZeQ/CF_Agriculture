//
//  ProvinceModel.h
//  ChangFa
//
//  Created by Developer on 2018/1/28.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject
@property (nonatomic, strong)NSString *ID;
@property (nonatomic, strong)NSString *level;
@property (nonatomic, strong)NSString *pid;
@property (nonatomic, strong)NSString *title;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)provinceModelWithDictionary:(NSDictionary *)dict;
@end
