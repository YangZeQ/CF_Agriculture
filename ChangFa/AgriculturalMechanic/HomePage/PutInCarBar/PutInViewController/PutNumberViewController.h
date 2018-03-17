//
//  PutNumberViewController.h
//  ChangFa
//
//  Created by dev on 2018/1/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFBaseNavigationViewController.h"

@protocol PutNumberViewControllerDelegate
- (void)bandMachineAccordingNumber:(NSString *)sender;
@end
@interface PutNumberViewController : CFBaseNavigationViewController
@property (nonatomic, weak)id delegate;
@end
