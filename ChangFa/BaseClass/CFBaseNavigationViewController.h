//
//  CFBaseNavigationViewController.h
//  ChangFa
//
//  Created by dev on 2018/1/3.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFBaseNavigationViewController : UIViewController
@property(nonatomic, strong)UIView *navigationView;
@property(nonatomic, strong)UILabel *navigationLable;
@property(nonatomic, strong)UIButton *leftButton;
@property(nonatomic, strong)UIButton *rightButton;
@end
