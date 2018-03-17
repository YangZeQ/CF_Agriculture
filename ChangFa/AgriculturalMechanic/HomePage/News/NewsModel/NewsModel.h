//
//  NewsModel.h
//  ChangFa
//
//  Created by Developer on 2018/1/10.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property (nonatomic, strong)NSString *IsRead;
@property (nonatomic, strong)NSString *createDate;
@property (nonatomic, strong)NSString *createper;
@property (nonatomic, strong)NSString *ID;
@property (nonatomic, strong)NSString *title;


- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)newsModelWithDictionary:(NSDictionary *)dict;
@end
