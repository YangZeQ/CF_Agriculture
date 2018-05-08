//
//  ScanView.m
//  ChangFa
//
//  Created by dev on 2018/1/4.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "ScanView.h"
@interface ScanView ()
{

    UIImageView   *_lineImageView;
    UIButton      *_backBtn;
}

@end

@implementation ScanView


// 修改当前View 的图层类别
//+(Class)layerClass {
//
//    return [AVCaptureVideoPreviewLayer class];
//}
//
//-(void)setSession:(AVCaptureSession *)session {
//
//    _session = session;
//    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)self.layer;
//    layer.session = session;
//}


- (instancetype)initWithFrame:(CGRect)frame ScanType:(NSString *)scanType
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUiConfigWithScanType:scanType];
    }
    return self;
}
- (void)initUiConfigWithScanType:(NSString *)scanType {
    self.userInteractionEnabled = YES;
    UILabel *navigationLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];

    navigationLable.textAlignment = NSTextAlignmentCenter;
    navigationLable.userInteractionEnabled = YES;
    navigationLable.textColor = [UIColor whiteColor];
    navigationLable.font = [UIFont systemFontOfSize:[self autoScaleW:20]];
    [self addSubview:navigationLable];

    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    [_backBtn setImage:[UIImage imageNamed:@"fanhuiwhite"] forState:UIControlStateNormal];
    [_backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backButtonDid) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(115 * screenWidth, 330 * screenHeight, 510 * screenWidth, 30 * screenHeight)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = CFFONT14;
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saomiaokuang"]];
    _imageView.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 20 * screenHeight, titleLabel.frame.size.width, 510 * screenHeight);
    [self addSubview:_imageView];
    
    _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30 * screenWidth, 15 * screenHeight, 460 * screenWidth, 3 * screenHeight)];
    _lineImageView.image = [UIImage imageNamed:@"pickline"];
    [_imageView addSubview:_lineImageView];
    
    UILabel *lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, _imageView.frame.size.height + _imageView.frame.origin.y + 200 * screenHeight, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    lastLabel.textAlignment = NSTextAlignmentCenter;
    lastLabel.font = CFFONT14;
    lastLabel.textColor = [UIColor whiteColor];
    [self addSubview:lastLabel];
    
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake(60 * screenWidth, self.bounds.size.height - 188 * screenHeight, 200 * screenWidth, 68 * screenHeight);
//    [scanButton.layer setBorderColor:ChangfaColor.CGColor];
//    [scanButton.layer setBorderWidth:1];
    [scanButton setBackgroundColor:ChangfaColor];
    scanButton.layer.cornerRadius = 10 * screenWidth;
    [scanButton.layer setMasksToBounds:YES];
    [scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scanButton.titleLabel.font = CFFONT16;
    
//    [scanButton addTarget:self action:@selector(buttonClickChangeColor:) forControlEvents:UIControlEventTouchDown];
//    [self addSubview:scanButton];
    UIButton *putInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    putInButton.frame = CGRectMake((CF_WIDTH - 240 * screenWidth) / 2, lastLabel.frame.size.height + lastLabel.frame.origin.y + 50 * screenHeight, 240 * screenWidth, 58 * screenHeight);
//    [putInButton.layer setBorderColor:ChangfaColor.CGColor];
//    [putInButton.layer setBorderWidth:1];
    putInButton.layer.cornerRadius = 5 * screenWidth;
    [putInButton.layer setMasksToBounds:YES];
    [putInButton setBackgroundColor:ChangfaColor];
    [putInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [putInButton setTitleColor:ChangfaColor forState:UIControlStateNormal];
    putInButton.titleLabel.font = CFFONT16;
    
    [putInButton addTarget:self action:@selector(buttonClickChangeColor:) forControlEvents:UIControlEventTouchDown];
    [putInButton addTarget:self action:@selector(putInNumberClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:putInButton];
    
    navigationLable.text = @"二维码/条码";
    titleLabel.text = @"将二维码/条码放入框内，即可自动扫描";
    lastLabel.text = @"未扫到二维码/条码？点击输入";
    [scanButton setTitle:@"扫描" forState:UIControlStateNormal];
    [putInButton setTitle:@"手动输入" forState:UIControlStateNormal];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(animation) userInfo:nil repeats:YES];
}
- (void)animation
{
    [UIView animateWithDuration:2.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _lineImageView.frame = CGRectMake(30 * screenWidth, 500 * screenHeight, 460 * screenWidth, 3 * screenHeight);
        
    } completion:^(BOOL finished) {
        _lineImageView.frame = CGRectMake(30 * screenWidth, 10 * screenHeight, 460 * screenWidth, 3 * screenHeight);
    }];
}

- (void)backButtonDid {
    
    if (self.backPreView){
        self.backPreView(self);
    }
}
- (void)putInNumberClick:(UIButton *)sender{
    sender.backgroundColor = [UIColor clearColor];
    [sender setTitleColor:ChangfaColor  forState:UIControlStateNormal];
    if (self.putInNumber) {
        self.putInNumber(self);
    }
}
- (void)buttonClickChangeColor:(UIButton *)sender{
    sender.backgroundColor = ChangfaColor;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)drawRect:(CGRect)rect{
    //整个二维码扫描界面的颜色
//    CGSize screenSize = self.frame.size;
    CGRect screenDrawRect =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height                                                                                                                                );
    
    //中间清空的矩形框
    CGRect clearDrawRect = _imageView.frame;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self addScreenFillRect:ctx rect:screenDrawRect];
    
    [self addCenterClearRect:ctx rect:clearDrawRect];
//    [self addWhiteRect:ctx rect:clearDrawRect];
//
//    [self addCornerLineWithContext:ctx rect:clearDrawRect];
}
- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 40 / 255.0, 40 / 255.0, 40 / 255.0, 0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}
//- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
//
//    CGContextStrokeRect(ctx, rect);
//    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
//    CGContextSetLineWidth(ctx, 0.8);
//    CGContextAddRect(ctx, rect);
//    CGContextStrokePath(ctx);
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
