//
//  NewsModel.h
//  ChangFa
//
//  Created by Developer on 2018/1/10.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property (nonatomic, copy)NSString *IsRead;
@property (nonatomic, copy)NSString *createDate;
@property (nonatomic, copy)NSString *createper;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *title;


- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)newsModelWithDictionary:(NSDictionary *)dict;
@end
