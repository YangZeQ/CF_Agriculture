//
//  CFAFNetworkingManage.m
//  ChangFa
//
//  Created by Developer on 2018/1/12.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAFNetworkingManage.h"

//超时时间
static int const DEFAULT_REQUEST_TIME_OUT = 10;

@implementation CFAFNetworkingManage
static CFAFNetworkingManage *manage;
// 为了使实例易于外界访问 我们一般提供一个类方法
// 类方法命名规范 share类名|default类名|类名
+(instancetype)shareManage
{
    //return _instance;
    // 最好用self 用CFTools他的子类调用时会出现错误
//    return [[self alloc]init];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[self alloc] init];
    });
    
    return manage;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
        @synchronized (self) {
            // 为了防止多线程同时访问对象，造成多次分配内存空间，所以要加上线程锁
            if (manage == nil) {
                manage = [super allocWithZone:zone];
            }
            return manage;
        }
    // 也可以使用一次性代码
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (manage == nil) {
//            manage = [super allocWithZone:zone];
//        }
//    });
//    return manage;
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(struct _NSZone*)zone
{
    return manage;
}
-(id)mutableCopyWithZone:(struct _NSZone*)zone
{
    return manage;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        //1.创建会话管理者
        self.requestSerializer = [AFHTTPRequestSerializer new];
        self.requestSerializer = [AFHTTPRequestSerializer serializer];//请求
        self.responseSerializer = [AFJSONResponseSerializer serializer];//响应
        [self.requestSerializer setTimeoutInterval:DEFAULT_REQUEST_TIME_OUT];
    }
    return self;
}

@end
