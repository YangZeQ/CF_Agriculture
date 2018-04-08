//
//  CFAFNetWorkingMethod.m
//  ChangFa
//
//  Created by dev on 2018/1/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAFNetWorkingMethod.h"
#import "CFAFNetworkingManage.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "CFLoginViewController.h"
#import "MBManager.h"
@interface CFAFNetWorkingMethod ()<UIApplicationDelegate>
@end
@implementation CFAFNetWorkingMethod
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.url = @"";
        //用来设置请求需要的公共的参数 例如：version devtoken session_id udid ...
        self.baseParams = [[NSMutableDictionary alloc] init];
       
    }
    return self;
}
#pragma mark - 拼接完整的url
- (NSString *)getcCompleteUrl
{
    //获取一个baseUrl 拼接之后成一个完整的返回
    NSString * url = [NSString stringWithFormat:@"%@%@",onlineUrl,_url];
    return url;
}
- (NSString *)getcCompleteJavaUrl
{
    //获取一个baseUrl 拼接之后成一个完整的返回
    NSString * url = [NSString stringWithFormat:@"%@%@.do",onlineJavaUrl,_url];
    return url;
}
#pragma mark - 基本设置
//继承之后，这两个方法需要覆写
//请求的方式
- (RequestMethod)getRequestMethod:(NSString *)method
{
    if ([method isEqualToString:@"get"]) {
        return RequestMethodGET;
    } else {
        return RequestMethodPOST;
    }
//    return RequestMethodPOST;
}

//是否包含图片上传
- (RequestType)getRequestType:(NSString *)image
{
    if ([image isEqualToString:@"image"]) {
        return RequestTypeImage;
    } else {
        return RequestTypeOrdinary;
    }
//    return RequestTypeOrdinary;
}


#pragma mark - 组合参数
- (NSDictionary *)CombinationParams:(NSDictionary *)params
{
    [self.baseParams addEntriesFromDictionary:params];
    return self.baseParams;
}

#pragma mark - 发起请求
+ (NSURLSessionDataTask *)requestDataWithUrl:(NSString *)url
                                      Params:(NSDictionary *)params
                                      Method:(NSString *)method
                                       Image:(NSString *)image
                                     Success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     Failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    CFAFNetWorkingMethod *requestBase = [[self alloc] initWithDict:params];
    if (requestBase)
    {
        NSDictionary * allParams = [requestBase CombinationParams:params];
        if ([requestBase getRequestType:image] == RequestTypeOrdinary)
        {
            return [requestBase RequestUrl:url Params:allParams Method:method success:success failure:failure];
        }
        else
        {
            return [requestBase RequestImageUrl:url Params:allParams Image:image success:success failure:failure];
        }
    }
    return nil;
}
//请求（无菊花）
+ (NSURLSessionDataTask *)requestDataWithUrl:(NSString *)url
                                     Loading:(NSInteger)loading
                                      Params:(NSDictionary *)params
                                      Method:(NSString *)method
                                       Image:(NSString *)image
                                     Success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     Failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    CFAFNetWorkingMethod *requestBase = [[self alloc] initWithDict:params];
    if (requestBase)
    {
        NSDictionary * allParams = [requestBase CombinationParams:params];
        if ([requestBase getRequestType:image] == RequestTypeOrdinary)
        {
            return [requestBase RequestUrl:url Loading:loading Params:allParams Method:method success:success failure:failure];
        }
        else
        {
            return [requestBase RequestImageUrl:url Params:allParams Image:image success:success failure:failure];
        }
    }
    return nil;
}
#pragma mark - JavaRequest
+ (NSURLSessionDataTask *)requestDataWithJavaUrl:(NSString *)url
                                         Loading:(NSInteger)loading
                                          Params:(NSDictionary *)params
                                          Method:(NSString *)method
                                           Image:(NSString *)image
                                         Success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         Failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    CFAFNetWorkingMethod *requestBase = [[self alloc] initWithDict:params];
    if (requestBase)
    {
        NSDictionary * allParams = [requestBase CombinationParams:params];
        if ([requestBase getRequestType:image] == RequestTypeOrdinary)
        {
            return [requestBase RequestJavaUrl:url Loading:loading Params:allParams Method:method success:success failure:failure];
        }
        else
        {
            return [requestBase RequestImageUrl:url Params:allParams Image:image success:success failure:failure];
        }
    }
    return nil;
}
#pragma mark - Request no Image
- (NSURLSessionDataTask *)RequestUrl:(NSString *)url
                              Params:(NSDictionary *)params
                              Method:(NSString *)method
                             success:(void(^)(NSURLSessionDataTask * task,id responseObject))success
                             failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure
{
    [MBManager showLoading];
    self.url = url;
    CFAFNetworkingManage * manager = [CFAFNetworkingManage shareManage];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    NSString *str = [@"" stringByAppendingString:timeString];
    [str stringByAppendingString:@"M/vkPOWXgBa7GnRd73t7j+jsKfbZtb+f"];
    [str stringByAppendingString:[self dictionaryToJson:params]];
    //    设置请求内容的类型
    //    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    设置请求的编码类型
    //    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    //
    //    [manager.requestSerializer setValue:@"BA4E67519DF644D1B004D3CEB257FF58"forHTTPHeaderField:@"appId"];
    //    [manager.requestSerializer setValue:[self md5:str] forHTTPHeaderField:@"signature"];
    //    [manager.requestSerializer setValue:timeString forHTTPHeaderField:@"timestamp"];
    
    //1.获得NSUserDefaults文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [manager.requestSerializer setValue:[userDefaults objectForKey:@"UserToken"] forHTTPHeaderField:@"token"];

    if ([self getRequestMethod:method] == RequestMethodGET)
    {
        NSURLSessionDataTask * task = [manager GET:[self getcCompleteUrl] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBManager hideAlert];
            if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 505) {
                [userDefaults setObject:nil forKey:@"UserToken"];
                [userDefaults setObject:nil forKey:@"UserUid"];
                [userDefaults setObject:nil forKey:@"UserName"];
                [userDefaults setObject:nil forKey:@"UserPhone"];
                [userDefaults setObject:nil forKey:@"UserBindNum"];
                [userDefaults setObject:nil forKey:@"UserDistributorId"];
                [userDefaults setObject:nil forKey:@"UserHeadUrl"];
                //            [userDefaults setObject:nil forKey:@"UserLocation"];"<null>"
                [userDefaults setObject:nil forKey:@"UserRoleType"];
                [userDefaults setObject:nil forKey:@"UserLoginType"];
                CFLoginViewController *login = [[CFLoginViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
                [UIApplication sharedApplication].delegate.window.rootViewController = nav;
            }
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //在这里可以对请求出错做统一的处理
            [MBManager hideAlert];
            failure(task, error);
        }];
        return task;
    }
    else
    {
        NSURLSessionDataTask * task = [manager POST:[self getcCompleteUrl] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBManager hideAlert];
            success(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //在这里可以对请求出错做统一的处理
            [MBManager hideAlert];
            failure(task,error);
        }];
        
        return task;
    }
}
- (NSURLSessionDataTask *)RequestUrl:(NSString *)url
                             Loading:(NSInteger)loading
                              Params:(NSDictionary *)params
                              Method:(NSString *)method
                             success:(void(^)(NSURLSessionDataTask * task,id responseObject))success
                             failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure
{
    self.url = url;
    if (loading == 1) {
        [MBManager showLoading];
    }
    CFAFNetworkingManage * manager = [CFAFNetworkingManage shareManage];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    NSString *str = [@"" stringByAppendingString:timeString];
    [str stringByAppendingString:@"M/vkPOWXgBa7GnRd73t7j+jsKfbZtb+f"];
    [str stringByAppendingString:[self dictionaryToJson:params]];
    //    设置请求内容的类型
    //    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    设置请求的编码类型
    //    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    //
    //    [manager.requestSerializer setValue:@"BA4E67519DF644D1B004D3CEB257FF58"forHTTPHeaderField:@"appId"];
    //    [manager.requestSerializer setValue:[self md5:str] forHTTPHeaderField:@"signature"];
    //    [manager.requestSerializer setValue:timeString forHTTPHeaderField:@"timestamp"];
    
    //1.获得NSUserDefaults文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [manager.requestSerializer setValue:[userDefaults objectForKey:@"UserToken"] forHTTPHeaderField:@"token"];
    
    if ([self getRequestMethod:method] == RequestMethodGET)
    {
        NSURLSessionDataTask * task = [manager GET:[self getcCompleteUrl] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBManager hideAlert];
            if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 505) {
                [userDefaults setObject:nil forKey:@"UserToken"];
                [userDefaults setObject:nil forKey:@"UserUid"];
                [userDefaults setObject:nil forKey:@"UserName"];
                [userDefaults setObject:nil forKey:@"UserPhone"];
                [userDefaults setObject:nil forKey:@"UserBindNum"];
                [userDefaults setObject:nil forKey:@"UserDistributorId"];
                [userDefaults setObject:nil forKey:@"UserHeadUrl"];
                //            [userDefaults setObject:nil forKey:@"UserLocation"];"<null>"
                [userDefaults setObject:nil forKey:@"UserRoleType"];
                [userDefaults setObject:nil forKey:@"UserLoginType"];
                CFLoginViewController *login = [[CFLoginViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
                [UIApplication sharedApplication].delegate.window.rootViewController = nav;
            }
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //在这里可以对请求出错做统一的处理
            [MBManager hideAlert];
            failure(task, error);
        }];
        return task;
    }
    else
    {
        NSURLSessionDataTask * task = [manager POST:[self getcCompleteUrl] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBManager hideAlert];
            success(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //在这里可以对请求出错做统一的处理
            [MBManager hideAlert];
            failure(task,error);
        }];
        return task;
    }
}
#pragma mark - Java后台请求
- (NSURLSessionDataTask *)RequestJavaUrl:(NSString *)url
                                 Loading:(NSInteger)loading
                                  Params:(NSDictionary *)params
                                  Method:(NSString *)method
                                 success:(void(^)(NSURLSessionDataTask * task,id responseObject))success
                                 failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure
{
    if (loading == 1) {
        [MBManager showLoading];
    }
    self.url = url;
    CFAFNetworkingManage * manager = [CFAFNetworkingManage shareManage];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    NSString *str = [@"" stringByAppendingString:timeString];
    [str stringByAppendingString:@"M/vkPOWXgBa7GnRd73t7j+jsKfbZtb+f"];
    [str stringByAppendingString:[self dictionaryToJson:params]];
    //    设置请求内容的类型
    //    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    设置请求的编码类型
    //    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    //
    //    [manager.requestSerializer setValue:@"BA4E67519DF644D1B004D3CEB257FF58"forHTTPHeaderField:@"appId"];
    //    [manager.requestSerializer setValue:[self md5:str] forHTTPHeaderField:@"signature"];
    //    [manager.requestSerializer setValue:timeString forHTTPHeaderField:@"timestamp"];
    
    //1.获得NSUserDefaults文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [manager.requestSerializer setValue:[userDefaults objectForKey:@"UserToken"] forHTTPHeaderField:@"token"];
    
    if ([self getRequestMethod:method] == RequestMethodGET)
    {
        NSURLSessionDataTask * task = [manager GET:[self getcCompleteJavaUrl] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBManager hideAlert];
            if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 505) {
                [userDefaults setObject:nil forKey:@"UserToken"];
                [userDefaults setObject:nil forKey:@"UserUid"];
                [userDefaults setObject:nil forKey:@"UserName"];
                [userDefaults setObject:nil forKey:@"UserPhone"];
                [userDefaults setObject:nil forKey:@"UserBindNum"];
                [userDefaults setObject:nil forKey:@"UserDistributorId"];
                [userDefaults setObject:nil forKey:@"UserHeadUrl"];
                //            [userDefaults setObject:nil forKey:@"UserLocation"];"<null>"
                [userDefaults setObject:nil forKey:@"UserRoleType"];
                [userDefaults setObject:nil forKey:@"UserLoginType"];
                CFLoginViewController *login = [[CFLoginViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
                [UIApplication sharedApplication].delegate.window.rootViewController = nav;
            }
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //在这里可以对请求出错做统一的处理
            [MBManager hideAlert];
            failure(task, error);
        }];
        return task;
    }
    else
    {
        NSURLSessionDataTask * task = [manager POST:[self getcCompleteJavaUrl] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBManager hideAlert];
            success(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //在这里可以对请求出错做统一的处理
            [MBManager hideAlert];
            failure(task,error);
        }];
        return task;
    }
}

#pragma mark - Request Image
- (NSURLSessionDataTask *)RequestImageUrl:(NSString *)url
                                   Params:(NSDictionary *)params
                                    Image:(NSString *)image
                                  success:(void(^)(NSURLSessionDataTask * task,id responseObject))success
                                  failure:(void(^)(NSURLSessionDataTask * task,NSError * error))failure
{
    self.url = url;
    CFAFNetworkingManage * manager = [CFAFNetworkingManage shareManage];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    NSString *str = [@"" stringByAppendingString:timeString];
    [str stringByAppendingString:@"M/vkPOWXgBa7GnRd73t7j+jsKfbZtb+f"];
    [str stringByAppendingString:[self dictionaryToJson:params]];
    //    设置请求内容的类型
    //    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    设置请求的编码类型
    //    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    //
    //    [manager.requestSerializer setValue:@"BA4E67519DF644D1B004D3CEB257FF58"forHTTPHeaderField:@"appId"];
    //    [manager.requestSerializer setValue:[self md5:str] forHTTPHeaderField:@"signature"];
    //    [manager.requestSerializer setValue:timeString forHTTPHeaderField:@"timestamp"];
    
    //1.获得NSUserDefaults文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [manager.requestSerializer setValue:[userDefaults objectForKey:@"UserToken"] forHTTPHeaderField:@"token"];
    
    NSLog(@"%@", [self getcCompleteUrl]);
    NSURLSessionDataTask * task = [manager POST:[self getcCompleteUrl] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 构造body,告诉AF是什么类型文件
        for (NSString *key in params)
        {
            id value = params[key];
//            if ([value isKindOfClass:[NSData class]])
//            {
//                [formData appendPartWithFileData:value name:key fileName:[NSString stringWithFormat:@"%@.jpg",key] mimeType:@"image/jpeg"];
//            }
            if ([key isEqualToString:@"data"]) {
                
                NSData *data = [[params objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
                NSLog(@" %@, %@", [params objectForKey:@"data"], data);
                [formData appendPartWithFileData:data name:key fileName:[NSString stringWithFormat:@"%@.png",key] mimeType:@"image/png"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 505) {
            [userDefaults setObject:nil forKey:@"UserToken"];
            [userDefaults setObject:nil forKey:@"UserUid"];
            [userDefaults setObject:nil forKey:@"UserName"];
            [userDefaults setObject:nil forKey:@"UserPhone"];
            [userDefaults setObject:nil forKey:@"UserBindNum"];
            [userDefaults setObject:nil forKey:@"UserDistributorId"];
            [userDefaults setObject:nil forKey:@"UserHeadUrl"];
            //            [userDefaults setObject:nil forKey:@"UserLocation"];"<null>"
            [userDefaults setObject:nil forKey:@"UserRoleType"];
            [userDefaults setObject:nil forKey:@"UserLoginType"];
            CFLoginViewController *login = [[CFLoginViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
            [UIApplication sharedApplication].delegate.window.rootViewController = nav;
        }
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //在这里可以对请求出错做统一的处理
        failure(task,error);
    }];
    return task;
}

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError =nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
