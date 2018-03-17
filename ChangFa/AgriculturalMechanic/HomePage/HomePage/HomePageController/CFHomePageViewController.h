//
//  CFHomePageViewController.h
//  ChangFa
//
//  Created by dev on 2017/12/29.
//  Copyright © 2017年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTabbarViewController.h"

@protocol homePageDelegate

@end
@interface CFHomePageViewController : UIViewController
@property (nonatomic, assign)float navigationViewHeight;
@property (nonatomic, weak)id delegate;
@end
