//
//  AgencyModel.h
//  ChangFa
//
//  Created by Developer on 2018/1/25.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgencyModel : NSObject
@property (nonatomic, copy)NSString *distributorsID;
@property (nonatomic, copy)NSString *distributorsCode;
@property (nonatomic, copy)NSString *distributorsName;
@property (nonatomic, copy)NSString *distributorsAddress;
@property (nonatomic, copy)NSString *distributorsType;
@property (nonatomic, copy)NSString *distributorsProduct;
@property (nonatomic, copy)NSString *contact;
@property (nonatomic, copy)NSString *tel;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)agencyModelWithDictionary:(NSDictionary *)dict;
@end
