//
//  SliderViewController.m
//  ChangFa
//
//  Created by dev on 2018/1/8.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "SliderViewController.h"
#import "SliderManager.h"
#import "LeftViewController.h"
@interface SliderViewController ()<UIGestureRecognizerDelegate, LeftViewControllerDelegate>{
    CGFloat _scalef;  //实时横向位移
}
@property (nonatomic, strong)UIView *leftTableview;
@property (nonatomic, strong)UIView *vagueView;
@end

@implementation SliderViewController

/**
 @brief 初始化侧滑控制器
 @param leftVC 左视图控制器
 mainVC 中间视图控制器
 @result instancetype 初始化生成的对象
 */
- (UIView *)vagueView{
    if (_vagueView == nil) {
        _vagueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _vagueView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:_vagueView];
    }
    return _vagueView;
}
- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainView:(UITabBarController *)mainVC
{
    if(self = [super init]){
        self.speedf = 0.7;
        self.leftVC = leftVC;
        self.mainVC = mainVC;
        
//        mainVC.delegate = self;
        [self addChildViewController:self.leftVC];
        [self addChildViewController:self.mainVC];
        //滑动手势
        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self.mainVC.view addGestureRecognizer:self.pan];

        [self.pan setCancelsTouchesInView:YES];
        self.pan.delegate = self;
        
        self.leftVC.view.hidden = YES;
        
        [self.view addSubview:self.leftVC.view];
        
        //蒙版
        UIView *view = [[UIView alloc] init];
        view.frame = self.leftVC.view.bounds;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
//        self.contentView = view;
//        [self.leftVC.view addSubview:view];
        
        //获取左侧tableview
        for (UIView *obj in self.leftVC.view.subviews) {
            if ([obj isKindOfClass:[UITableView class]]) {
                self.leftTableview = (UITableView *)obj;
            }
        }
        self.leftTableview.backgroundColor = [UIColor clearColor];
        self.leftTableview.frame = CGRectMake(100, ([[UIScreen mainScreen] bounds].size.height - 300)/2, [[UIScreen mainScreen] bounds].size.width - 100*1.5, 300);
        //设置左侧tableview的初始位置和缩放系数
        self.leftTableview.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [self.view addSubview:self.leftVC.view];
        [self.view addSubview:self.mainVC.view];
        self.closed = YES;//初始时侧滑窗关闭
        [SliderManager  sharedInstance].LeftSlideVC = self;
//        [MCLeftSliderManager sharedInstance].mainNavigationController = mainVC.viewControllers.firstObject;
        UITabBarController *mainVC = self.mainVC;
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 20, 44, 44);
        [leftButton setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [mainVC.view addSubview:leftButton];
    }
    
    [self.mainVC.view addSubview:self.vagueView];
    self.vagueView.hidden = YES;
    return self;
}
- (void)leftButtonClick{
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.mainVC.view.center = CGPointMake([[UIScreen mainScreen] bounds].size.width + [[UIScreen mainScreen] bounds].size.width * 1.0 / 2.0 - 100, [[UIScreen mainScreen] bounds].size.height / 2);
    self.closed = NO;
    self.vagueView.hidden = NO;
    
    self.leftVC.view.center = CGPointMake(([[UIScreen mainScreen] bounds].size.width ) * 0.5, [[UIScreen mainScreen] bounds].size.height * 0.5);
    self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
//    self.contentView.alpha = 0;
    
    [UIView commitAnimations];
    [self disableTapButton];
}
- (void)closeLeftView
{
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.mainVC.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    self.closed = YES;
    
    self.leftVC.view.center = CGPointMake(-50, [UIScreen mainScreen].bounds.size.height * 0.5);
    self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
//    self.contentView.alpha = 0.9;
    
    [UIView commitAnimations];
    [self removeSingleTap];
}
//滑动手势
- (void) handlePan: (UIPanGestureRecognizer *)rec{
    CGPoint point = [rec translationInView:self.view];
    _scalef = (point.x * self.speedf + _scalef);
    
    BOOL needMoveWithTap = YES;  //是否还需要跟随手指移动
    if (((self.mainVC.view.frame.origin.x <= 0) && (_scalef <= 0)) || ((self.mainVC.view.frame.origin.x >= ([UIScreen mainScreen].bounds.size.width - 100 )) && (_scalef >= 0)))
    {
        //边界值管控
        _scalef = 0;
        needMoveWithTap = NO;
    }
    
    //根据视图位置判断是左滑还是右边滑动
    if (needMoveWithTap && (rec.view.frame.origin.x >= 0) && (rec.view.frame.origin.x <= ([UIScreen mainScreen].bounds.size.width - 100)))
    {
        CGFloat recCenterX = rec.view.center.x + point.x * self.speedf;
        self.vagueView.hidden = NO;
        if (recCenterX < [UIScreen mainScreen].bounds.size.width * 0.5 - 2) {
            recCenterX = [UIScreen mainScreen].bounds.size.width * 0.5;
        }
        
        CGFloat recCenterY = rec.view.center.y;
        
        rec.view.center = CGPointMake(recCenterX,recCenterY);
        
        //scale 1.0~kMainPageScale
        CGFloat scale = 1 - (1 - 1.0) * (rec.view.frame.origin.x / ([UIScreen mainScreen].bounds.size.width));
        
        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,scale, scale);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        
        CGFloat leftTabCenterX =  + (([UIScreen mainScreen].bounds.size.width) * 0.5 - (-50)) * (rec.view.frame.origin.x / ([UIScreen mainScreen].bounds.size.width));
        
        
        //leftScale kLeftScale~1.0
        CGFloat leftScale = 1.0 + (1 - 1.0) * (rec.view.frame.origin.x / ([UIScreen mainScreen].bounds.size.width));
        
        self.leftVC.view.center = CGPointMake(leftTabCenterX, [UIScreen mainScreen].bounds.size.height * 0.5);
        self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale,leftScale);
        //tempAlpha kLeftAlpha~0
//        CGFloat tempAlpha = 0.9 - 0.9 * (rec.view.frame.origin.x / (kScreenWidth - 100));
//        self.contentView.alpha = tempAlpha;
        
    }
    else
    {
        //超出范围，
        if (self.mainVC.view.frame.origin.x < 0)
        {
            [self closeLeftView];
            _scalef = 0;
        }
        else if (self.mainVC.view.frame.origin.x > ([UIScreen mainScreen].bounds.size.width - 100))
        {
            [self leftButtonClick];
            _scalef = 0;
        }
    }
    
    //手势结束后修正位置,超过约一半时向多出的一半偏移
    if (rec.state == UIGestureRecognizerStateEnded) {
        if (fabs(_scalef) > ([UIScreen mainScreen].bounds.size.width - 100) / 2.0 - 40)
        {
            if (self.closed)
            {
                [self leftButtonClick];
                self.vagueView.hidden = NO;
            }
            else
            {
                [self closeLeftView];
                self.vagueView.hidden = YES;
            }
        }
        else
        {
            if (self.closed)
            {
                [self closeLeftView];
                self.vagueView.hidden = YES;
            }
            else
            {
                [self leftButtonClick];
                self.vagueView.hidden = NO;
            }
        }
        _scalef = 0;
    }
}
#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    
    if ((!self.closed) && (tap.state == UIGestureRecognizerStateEnded))
    {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        self.closed = YES;
        self.vagueView.hidden = YES;
        self.leftVC.view.center = CGPointMake(-50, [UIScreen mainScreen].bounds.size.height * 0.5);
        self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
//        self.contentView.alpha = kLeftAlpha;
        
        [UIView commitAnimations];
        _scalef = 0;
        [self removeSingleTap];
    }
    
}
#pragma mark - 行为收敛控制
- (void)disableTapButton
{
    for (UIButton *tempButton in [_mainVC.view subviews])
    {
        [tempButton setUserInteractionEnabled:NO];
    }
    //单击
    if (!self.sideslipTapGes)
    {
        //单击手势
        self.sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
        [self.sideslipTapGes setNumberOfTapsRequired:1];
        
        [self.mainVC.view addGestureRecognizer:self.sideslipTapGes];
        self.sideslipTapGes.cancelsTouchesInView = YES;  //点击事件盖住其它响应事件,但盖不住Button;
    }
}
//关闭行为收敛
- (void) removeSingleTap
{
    for (UIButton *tempButton in [self.mainVC.view  subviews])
    {
        [tempButton setUserInteractionEnabled:YES];
    }
    [self.mainVC.view removeGestureRecognizer:self.sideslipTapGes];
    self.sideslipTapGes = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.leftVC.view.hidden = NO;
//    self.navigationItem.title = @"常发农装";
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)quitRootViewController{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
