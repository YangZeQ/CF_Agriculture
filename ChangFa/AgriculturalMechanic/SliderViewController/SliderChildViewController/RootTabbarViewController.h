//
//  RootTabbarViewController.h
//  ChangFa
//
//  Created by dev on 2017/12/25.
//  Copyright © 2017年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTabbarViewController : UITabBarController
@property (nonatomic, assign)float navigationBarHeight;
@property (nonatomic, copy)NSString *str;

- (instancetype)initWithNavigationHeight:(float)navigationHeight;
@end
