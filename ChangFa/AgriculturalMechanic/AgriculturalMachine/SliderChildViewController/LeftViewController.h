//
//  LeftViewController.h
//  ChangFa
//
//  Created by dev on 2018/1/8.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftViewControllerDelegate
- (void)quitRootViewController;
@end
@interface LeftViewController : UIViewController
@property (nonatomic, weak)id delegate;
@end
