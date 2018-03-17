//
//  PersonModel.h
//  ChangFa
//
//  Created by Developer on 2018/1/16.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject
@property (nonatomic, strong)NSString *uname;
@property (nonatomic, strong)NSString *uid;
@property (nonatomic, strong)NSString *phone;
@property (nonatomic, strong)NSString *headUrl;
@property (nonatomic, strong)NSString *location;
@property (nonatomic, strong)NSString *roleType;
@property (nonatomic, strong)NSString *distributorId;
@property (nonatomic, strong)NSString *identify;
 
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)personModelWithDictionary:(NSDictionary *)dict;
@end
