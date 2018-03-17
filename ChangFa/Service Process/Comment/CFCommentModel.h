//
//  CFCommentModel.h
//  ChangFa
//
//  Created by Developer on 2018/3/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFCommentModel : NSObject
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *commentTime;
@property (nonatomic, strong)NSMutableArray *filePath;
@property (nonatomic, strong)NSString *level;
@property (nonatomic, strong)NSString *mobile;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)commentModelWithDictionary:(NSDictionary *)dict;
@end
