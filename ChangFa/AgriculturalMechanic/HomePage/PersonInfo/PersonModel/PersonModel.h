//
//  PersonModel.h
//  ChangFa
//
//  Created by Developer on 2018/1/16.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject
@property (nonatomic, copy)NSString *uname;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *headUrl;
@property (nonatomic, copy)NSString *location;
@property (nonatomic, copy)NSString *roleType;
@property (nonatomic, copy)NSString *distributorId;
@property (nonatomic, copy)NSString *identify;
 
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)personModelWithDictionary:(NSDictionary *)dict;
@end
