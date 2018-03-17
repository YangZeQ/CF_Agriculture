//
//  PersonViewController.h
//  ChangFa
//
//  Created by dev on 2018/1/7.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFBaseNavigationViewController.h"

@protocol PersonViewControllerDelegate

- (void)quitPersonAccount;

@end
@interface PersonViewController : UIViewController
@property (nonatomic, weak)id delegate;
@end
