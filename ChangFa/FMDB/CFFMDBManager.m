//
//  CFFMDBManager.m
//  ChangFa
//
//  Created by Developer on 2018/4/8.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFFMDBManager.h"
#import "FMDB.h"

static CFFMDBManager * manager=nil;

@interface CFFMDBManager ()
@property  (nonatomic, strong)FMDatabase *database;
@property  (nonatomic, assign)NSInteger imageCount;
@end
@implementation CFFMDBManager

+(instancetype)shareManager
{
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        manager=[[CFFMDBManager alloc]init];
    });
    return manager;
}
-(instancetype)init
{
    if (self=[super init]) {
        // 创建数据库，使用FMDB第三方框架
        // 创建数据库文件保存路径..../Documents/app.sqlite
        // sqlite数据库（轻量级的数据库），它就是一个普通的文件，txt是一样的，只不过其中的文件内容不一样。
        // 注：sqlite文件中定义了你的数据库表、数据内容
        // MySql、Oracle这些大型的数据库，它需要一个管理服务，是一整套的。
        
        // 获得Documents目录路径
        
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        // 文件路径
        
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
        //        NSString * dbPath=[NSString stringWithFormat:@"%@/Documents/app.sqlite",NSHomeDirectory()];
        NSLog(@"%@",filePath);
        // 创建FMDatabase
        // 如果在目录下没有这个数据库文件，将创建该文件。
        _database=[[FMDatabase alloc]initWithPath:filePath];
        
        if (_database) {
            if ([_database open]) {
                //第一步：创建信息表
                NSString *infoSql = @"CREATE TABLE 'info' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'imageTypeID' VARCHAR(255),'imageCount' VARCHAR(255), 'fileIds' varchar(255), 'repairID' varchar(255)) ";
                //第一步：创建图片表
                NSString * imageSql= @"CREATE TABLE 'image' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'imageID' VARCHAR(255),'imageString' VARCHAR(255),'imageTypeID' VARCHAR(255), 'repairID' varchar(255)) ";
                // FMDatabase执行sql语句
                // 当数据库文件创建完成时，首先创建数据表，如果没有这个表，就去创建，有了就不创建
                BOOL createInfoSucess=[_database executeUpdate:infoSql];
                BOOL createImageSucess=[_database executeUpdate:imageSql];
                NSLog(@"创建表%d %d", createInfoSucess, createImageSucess);
            }
            else
            {
                NSLog(@"打开数据库失败");
            }
        }
        else
        {
            NSLog(@"创建数据库失败");
        }
    }
    return self;
}
#pragma mark - 接口

- (void)addInfo:(CFUpdataInfoModel *)info
{
    [_database open];
//    NSNumber *maxID = @(0);
    
//    FMResultSet *res = [_database executeQuery:@"SELECT * FROM info "];
    //获取数据库中最大的ID
//    while ([res next]) {
//        if ([maxID integerValue] < [[res stringForColumn:@"person_id"] integerValue]) {
//            maxID = @([[res stringForColumn:@"person_id"] integerValue] ) ;
//        }
//
//    }
//    maxID = @([maxID integerValue] + 1);
    
    [_database executeUpdate:@"INSERT INTO info(imageTypeID, imageCount, fileIds, repairID)VALUES(?,?,?,?)", info.imageTypeID, info.imageCount, info.fileIds, info.repairID];

    [_database close];
}

- (void)deleteInfo:(CFUpdataInfoModel *)info
{
    [_database open];
    
    [_database executeUpdate:@"DELETE FROM info WHERE imageTypeID = ? AND repairID = ?", info.imageTypeID, info.repairID];
    
    [_database close];
}

- (void)updateInfo:(CFUpdataInfoModel *)info
{
    [_database open];
    if ([_database open]) {
        NSLog(@"openupdata");
    }
    [_database executeUpdate:@"UPDATE 'info' SET imageCount = ?  WHERE imageTypeID = ? AND repairID = ?", info.imageCount, info.imageTypeID, info.repairID];
    [_database executeUpdate:@"UPDATE 'info' SET fileIds = ?  WHERE imageTypeID = ? AND repairID = ?", info.fileIds, info.imageTypeID, info.repairID];
//    [_database executeUpdate:@"UPDATE 'info' SET person_number = ?  WHERE person_id = ? ",@(person.number + 1),person.ID];
    [_database close];
}

- (NSMutableArray *)getAllInfo
{
    [_database open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_database executeQuery:@"SELECT * FROM info"];
    
    while ([res next]) {
        CFUpdataInfoModel *info = [[CFUpdataInfoModel alloc] init];
        info.imageTypeID = [res stringForColumn:@"imageTypeID"];
        info.fileIds = [res stringForColumn:@"fileIds"];
        info.imageCount = [res stringForColumn:@"imageCount"];
        info.repairID = [res stringForColumn:@"repairID"];

        [dataArray addObject:info];
    }
    
    [_database close];

    return dataArray;

}
/**
 *  给person添加车辆
 *
 */
- (void)addImage:(CFUpdataImageModel *)image toInfo:(CFUpdataInfoModel *)info
{
    [_database open];
    if ([_database open]) {
        NSLog(@"openadd");
    }
//    [_database executeUpdate:@"INSERT INTO image(imageTypeID, imageID, imageString, repairID)VALUES(?,?,?,?)", image.imageTypeID, image.imageID, image.imageString, image.repairID];
    //根据person是否拥有car来添加car_id
//    NSNumber *maxID = @(0);
//
//    NSMutableArray *arr = [self getAllImagesFromInfo:info];
//    FMResultSet *res = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM image where imageID = %@", image.imageID]];
//
//    while ([res next]) {
//        if ([maxID integerValue] < [[res stringForColumn:@"car_id"] integerValue]) {
//            maxID = @([[res stringForColumn:@"car_id"] integerValue]);
//        }
//    }
//    maxID = @([maxID integerValue] + 1);
    NSString *imageID = [NSString stringWithFormat:@"%lu", ([image.imageID integerValue] + self.imageCount)];
    [_database executeUpdate:@"INSERT INTO image(imageID,imageString,imageTypeID,repairID)VALUES(?,?,?,?)", imageID, image.imageString, info.imageTypeID,image.repairID];

    [_database close];
    
}
/**
 *  给person删除车辆
 *
 */
- (void)deleteImage:(CFUpdataImageModel *)image fromInfo:(CFUpdataInfoModel *)info
{
    [_database open];
    
    [_database executeUpdate:@"DELETE FROM image WHERE imageTypeID = ? and imageID = ? and reapirID", info.imageTypeID, image.imageID, info.repairID];
    
    [_database close];
}
/**
 *  获取person的所有车辆
 *
 */
- (NSMutableArray *)getAllImagesFromInfo:(CFUpdataInfoModel *)info
{
    
    [_database open];
    if ([_database open]) {
        NSLog(@"openall");
    }
    NSMutableArray  *carArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM image where repairID = '%@' and imageTypeID = '%@'", info.repairID, info.imageTypeID]];
    while ([res next]) {
        CFUpdataImageModel *image = [[CFUpdataImageModel alloc] init];
        image.imageID = [res stringForColumn:@"imageID"];
        image.imageString = [res stringForColumn:@"imageString"];
        [carArray addObject:image];
        self.imageCount = [image.imageID integerValue];
        NSLog(@"%@", image.imageID);
    }
    [_database close];
//    self.imageCount = [[NSString stringWithFormat:@"%lu", (unsigned long)carArray.count] integerValue];
    NSLog(@"---%ld", (long)self.imageCount);
    return carArray;
    
}
- (void)deleteAllImagesFromInfo:(CFUpdataInfoModel *)info
{
    [_database open];
    
    [_database executeUpdate:@"DELETE FROM image WHERE imageTypeID = %@", info.imageTypeID];

    [_database close];
}
- (NSString *)getfileIdsFromInfoType:(CFUpdataInfoModel *)info
{
    [_database open];
    
    FMResultSet *res = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM info where imageTypeID = '%@' and repairID = '%@'", info.imageTypeID, info.repairID]];
    while ([res next]) {
        NSLog(@"res%@", [res stringForColumn:@"fileIds"]);
        NSLog(@"res%@", [res stringForColumn:@"imageTypeID"]);
        NSLog(@"res%@", [res stringForColumn:@"repairID"]);
    }
    [_database close];
    
    return @"111";
}

@end
