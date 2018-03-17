//
//  CFAdjustFont.m
//  ChangFa
//
//  Created by Developer on 2018/1/31.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFMBProgressHUD.h"
#import <MBProgressHUD.h>

@interface CFMBProgressHUD()
@property (nonatomic, strong)MBProgressHUD *progress;
@end
@implementation CFMBProgressHUD
- (instancetype)init{
    if (self = [super init]) {
        [self createProgressHUD];
    }
    return self;
}
- (void)createProgressHUD{
    self.progress = [[MBProgressHUD alloc]init];
    self.progress.mode = MBProgressHUDModeIndeterminate;
    //1,设置背景框的透明度  默认0.8
    _progress.opacity = 0.8;
    //2,设置背景框的背景颜色和透明度， 设置背景颜色之后opacity属性的设置将会失效
    _progress.color = [UIColor clearColor];
//    _progress.color = [_progress.color colorWithAlphaComponent:1];
    //3,设置背景框的圆角值，默认是10
//    _progress.cornerRadius = 20.0 ;
    //4,设置提示信息 信息颜色，字体
//    _progress.labelColor = [UIColor blackColor];
//    _progress.labelFont = [UIFont systemFontOfSize:13];
//    _progress.labelText = @"Loading...";
    //5,设置提示信息详情 详情颜色，字体
//    _progress.detailsLabelColor = [UIColor blackColor];
//    _progress.detailsLabelFont = [UIFont systemFontOfSize:13];
//    _progress.detailsLabelText = @"LoadingLoading...";
    //6，设置菊花颜色  只能设置菊花的颜色
    _progress.activityIndicatorColor = [UIColor cyanColor];
    //7,设置一个渐变层
    _progress.dimBackground = YES;
    //8,设置动画的模式
    //    HUD.mode = MBProgressHUDModeIndeterminate;
    //9，设置提示框的相对于父视图中心点的偏移，正值 向右下偏移，负值左上
    _progress.xOffset = 0;
    _progress.yOffset = 0;
    //10，设置各个元素距离矩形边框的距离
    _progress.margin = 0;
    //11，背景框的最小大小
    _progress.minSize = CGSizeMake(50, 50);
    //12设置背景框的实际大小   readonly
    CGSize size = _progress.size;
    //13,是否强制背景框宽高相等
    _progress.square = YES;
    //14,设置显示和隐藏动画类型  有三种动画效果，如下
    //    HUD.animationType = MBProgressHUDAnimationFade; //默认类型的，渐变
    //    HUD.animationType = MBProgressHUDAnimationZoomOut; //HUD的整个view后退 然后逐渐的后退
    _progress.animationType = MBProgressHUDAnimationZoomIn; //和上一个相反，前近，最后淡化消失
    //15,设置最短显示时间，为了避免显示后立刻被隐藏   默认是0
    //    HUD.minShowTime = 10;
    //16,
    /*
     // 这个属性设置了一个宽限期，它是在没有显示HUD窗口前被调用方法可能运行的时间。
     // 如果被调用方法在宽限期内执行完，则HUD不会被显示。
     // 这主要是为了避免在执行很短的任务时，去显示一个HUD窗口。
     // 默认值是0。只有当任务状态是已知时，才支持宽限期。具体我们看实现代码。
     @property (assign) float graceTime;
     
     // 这是一个标识位，标明执行的操作正在处理中。这个属性是配合graceTime使用的。
     // 如果没有设置graceTime，则这个标识是没有太大意义的。在使用showWhileExecuting:onTarget:withObject:animated:方法时，
     // 会自动去设置这个属性为YES，其它情况下都需要我们自己手动设置。
     @property (assign) BOOL taskInProgress;
     */
    //17,设置隐藏的时候是否从父视图中移除，默认是NO
    _progress.removeFromSuperViewOnHide = NO;
    //18,进度指示器  模式是0，取值从0.0————1.0
    //    HUD.progress = 0.5;
    //19,隐藏时候的回调 隐藏动画结束之后
    _progress.completionBlock = ^(){
        NSLog(@"abnnfsfsf");
    };
    //设置任务，在hud上显示任务的进度
    [_progress showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
    
    //    [HUD show:YES];
    
    //两种隐藏的方法
    //    [HUD hide:YES];
//    [_progress hide:YES afterDelay:5];
}
- (void)myProgressTask {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        _progress.progress = progress;
        usleep(50000);
    }
}
+ (MBProgressHUD *)createMBProgressHUD{
    CFMBProgressHUD *progress = [[CFMBProgressHUD alloc]init];
    return progress.progress;
}
@end
