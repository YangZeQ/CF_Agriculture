//
//  ScanView.h
//  ChangFa
//
//  Created by dev on 2018/1/4.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class ScanView;

typedef void(^backPreView) (ScanView *preView);
typedef void(^putInNumber) (ScanView *preView);
typedef void(^presentView) (ScanView *preView);
@interface ScanView : UIView
@property(nonatomic, strong)AVCaptureSession    *session;//!< 渲染会话层
@property(nonatomic, copy)backPreView         backPreView;//!< 返回按钮回调
@property(nonatomic, strong)NSTimer             *timer;//!< <#value#>
@property(nonatomic, copy)putInNumber putInNumber;
@property(nonatomic, strong)UIImageView   *imageView;
- (instancetype)initWithFrame:(CGRect)frame
                     ScanType:(NSString *)scanType;
@end
