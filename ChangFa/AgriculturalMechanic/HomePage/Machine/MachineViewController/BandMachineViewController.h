//
//  BandMachineViewController.h
//  ChangFa
//
//  Created by dev on 2018/1/3.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BandMachineViewControllerDelegate
- (void)bindMachineSuccess;
@end
@interface BandMachineViewController : UIViewController
@property (nonatomic, copy)NSString *userType;
@property (nonatomic, weak)id delegate;
@end
