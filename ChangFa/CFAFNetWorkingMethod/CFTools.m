//
//  CFTools.m
//  ChangFa
//
//  Created by Developer on 2018/1/12.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFTools.h"

@implementation CFTools
static CFTools *progressHUD;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    //    @synchronized (self) {
    //        // 为了防止多线程同时访问对象，造成多次分配内存空间，所以要加上线程锁
    //        if (_instance == nil) {
    //            _instance = [super allocWithZone:zone];
    //        }
    //        return _instance;
    //    }
        if (progressHUD == nil) {
            progressHUD = [super allocWithZone:zone];
        }
    return progressHUD;
}
// 为了使实例易于外界访问 我们一般提供一个类方法
// 类方法命名规范 share类名|default类名|类名
+(instancetype)shareCFMBProgressHUD
{
    //return _instance;
    // 最好用self 用CFTools他的子类调用时会出现错误
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progressHUD = [[self alloc]init];
    });
    return progressHUD;
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(struct _NSZone*)zone
{
    return progressHUD;
}
-(id)mutableCopyWithZone:(struct _NSZone*)zone
{
    return progressHUD;
}

@end
