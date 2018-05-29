//
//  CFAFNetWorkingMethod.h
//  ChangFa
//
//  Created by dev on 2018/1/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFAFNetWorkingMethod : NSObject
typedef NS_ENUM(NSUInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST
};

typedef NS_ENUM(NSUInteger, RequestType) {
    RequestTypeOrdinary,
    RequestTypeImage
};


@property(nonatomic, strong) NSString * url;    //请求的地址
@property (nonatomic, strong) NSMutableDictionary * baseParams;    //请求的公共参数

//请求(菊花)
+ (NSURLSessionDataTask *)requestDataWithUrl:(NSString *)url
                                      Params:(NSDictionary *)params
                                      Method:(NSString *)method
                                       Image:(NSString *)image
                                     Success:(void(^)(NSURLSessionDataTask * task,id responseObject))success
                                     Failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;
//请求(无菊花)
+ (NSURLSessionDataTask *)requestDataWithUrl:(NSString *)url
                                     Loading:(NSInteger)loading
                                      Params:(NSDictionary *)params
                                      Method:(NSString *)method
                                       Image:(NSString *)image
                                     Success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     Failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
//Java请求
+ (NSURLSessionDataTask *)requestDataWithJavaUrl:(NSString *)url
                                         Loading:(NSInteger)loading
                                          Params:(NSDictionary *)params
                                          Method:(NSString *)method
                                           Image:(NSString *)image
                                         Success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         Failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
