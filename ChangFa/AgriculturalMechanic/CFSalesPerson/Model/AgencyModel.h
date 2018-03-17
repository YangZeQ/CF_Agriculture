//
//  AgencyModel.h
//  ChangFa
//
//  Created by Developer on 2018/1/25.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgencyModel : NSObject
@property (nonatomic, strong)NSString *distributorsID;
@property (nonatomic, strong)NSString *distributorsCode;
@property (nonatomic, strong)NSString *distributorsName;
@property (nonatomic, strong)NSString *distributorsAddress;
@property (nonatomic, strong)NSString *distributorsType;
@property (nonatomic, strong)NSString *distributorsProduct;
@property (nonatomic, strong)NSString *contact;
@property (nonatomic, strong)NSString *tel;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)agencyModelWithDictionary:(NSDictionary *)dict;
@end
