//
//  CFInstallTerminalViewController.h
//  ChangFa
//
//  Created by Developer on 2018/4/26.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^installTerminalBlock)(void);
@interface CFInstallTerminalViewController : UIViewController
@property (nonatomic, copy)installTerminalBlock installTerminalBlock;
@end
