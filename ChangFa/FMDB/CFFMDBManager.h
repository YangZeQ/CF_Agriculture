//
//  CFFMDBManager.h
//  ChangFa
//
//  Created by Developer on 2018/4/8.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFUpdataInfoModel.h"
#import "CFUpdataImageModel.h"
@interface CFFMDBManager : NSObject
+(instancetype)shareManager;
//添加一条数据到数据表中
-(BOOL)addDataWithModel:(CFUpdataInfoModel *)student ConditionString:(NSString *)conditionStr andconditionValue:(NSString *)conditionValue andtable:(NSString * )table;
//通过某个字段删除一条数据；
-(BOOL)deleteDataWithConditionString:(NSString *)conditionStr andconditionValue:(NSString *)conditionValue andtable:(NSString * )table;
//  删除所有的记录
- (BOOL)deleteAllDataWithtable:(NSString *)table;
//查询一条数据；
//1.查询全部数据，2根据特定字段查询数据；
-(NSArray * )getDataWithconditionString:(NSString * )conditionstr andConditionValue:(NSString *)conditionValue allData:(BOOL)isAllData andTable:(NSString *)table;
//修改某条数据
-(BOOL)updateDataWithString:(NSString*)NewStr andNewStrValue:(id)NewStrValue  andConditionStr:(NSString*)conditionStr andConditionValue:(NSString*)conditionValue andTable:(NSString*)table;

#pragma mark - Info
/**
 *  添加info
 *
 */
- (void)addInfo:(CFUpdataInfoModel *)info;
/**
 *  删除info
 *
 */
- (void)deleteInfo:(CFUpdataInfoModel *)info;
/**
 *  更新info
 *
 */
- (void)updateInfo:(CFUpdataInfoModel *)info;

/**
 *  获取所有数据
 *
 */
- (NSMutableArray *)getAllInfo;

#pragma mark - Image


/**
 *  给info添加image
 *
 */
- (void)addImage:(CFUpdataImageModel *)image toInfo:(CFUpdataInfoModel *)info;
/**
 *  给info删除image
 *
 */
- (void)deleteImage:(CFUpdataImageModel *)image fromInfo:(CFUpdataInfoModel *)info;
/**
 *  获取info的所有image
 *
 */
- (NSMutableArray *)getAllImagesFromInfo:(CFUpdataInfoModel *)info;
/**
 *  删除info的所有image
 *
 */
- (void)deleteAllImagesFromInfo:(CFUpdataInfoModel *)info;
/**
 *  获取info的fileIds
 *
 */
- (NSString *)getfileIdsFromInfoType:(CFUpdataInfoModel *)info;
@end
