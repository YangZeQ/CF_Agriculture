//
//  CFCommentModel.h
//  ChangFa
//
//  Created by Developer on 2018/3/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFCommentModel : NSObject
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *commentTime;
@property (nonatomic, strong)NSMutableArray *filePath;
@property (nonatomic, copy)NSString *level;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *fileIds;
@property (nonatomic, copy)NSString *userId;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)commentModelWithDictionary:(NSDictionary *)dict;
@end
