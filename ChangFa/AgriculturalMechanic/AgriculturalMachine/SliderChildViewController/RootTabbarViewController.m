//
//  RootTabbarViewController.m
//  ChangFa
//
//  Created by dev on 2017/12/25.
//  Copyright © 2017年 dev. All rights reserved.
//

#import "RootTabbarViewController.h"
#import "CFHomePageViewController.h"
#import "MapViewController.h"
#import "CFMisteViewButton.h"
#import "PersonViewController.h"
#import "SystemNewsViewController.h"
@interface RootTabbarViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong)UIButton *leftBtn;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, strong)UIView *informationView;
@property (nonatomic, strong)UIView *mistsView;
@end

@implementation RootTabbarViewController


- (instancetype)initWithNavigationHeight:(float)navigationHeight{
    _navigationBarHeight = navigationHeight;
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"常发农装";
    
//    //设置导航栏背景图片为一个空的image，这样就透明了
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.title = @"农机手";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"gengduo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"xinxi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];

    // Do any additional setup after loading the view.
    //  tabbarController的子控制器 （可封装）
    CFHomePageViewController *homePageViewC = [[CFHomePageViewController alloc]init];
//    homePageViewC.delegate = self;
    homePageViewC.navigationViewHeight = self.navigationBarHeight;
    homePageViewC.tabBarItem.title = @"首页";
    [homePageViewC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [homePageViewC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ChangfaColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [homePageViewC.tabBarItem setImage:[UIImage imageNamed:@"shouye"]];
    [homePageViewC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"shouyeselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self addChildViewController:homePageViewC];
    
    MapViewController *mapViewC = [[MapViewController alloc]init];
    mapViewC.navigationViewHeight = self.navigationBarHeight;
    mapViewC.tabBarItem.title = @"地图";
    [mapViewC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [mapViewC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ChangfaColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [mapViewC.tabBarItem setImage:[UIImage imageNamed:@"map"]];
    [mapViewC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"mapselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self addChildViewController:mapViewC];
    
    
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    if ([item.title isEqualToString:@"首页"]) {
//        self.navigationItem.title = @"常发农装";
//
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"xinxi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
//    } else if ([item.title isEqualToString:@"地图"]) {
//        self.navigationItem.titleView.backgroundColor = [UIColor whiteColor];
//    }
}
- (void)rightButtonClick{
    SystemNewsViewController *system = [[SystemNewsViewController alloc]init];
    [self.navigationController pushViewController:system animated:YES];
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
