//
//  CFAgencySendingViewController.h
//  ChangFa
//
//  Created by Developer on 2018/1/23.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFAgencySendingViewControllerDelegate
- (void)changeSendingTableViewStatus;
@end
@interface CFAgencySendingViewController : UIViewController
@property (nonatomic, assign)float height;
@property (nonatomic, copy)NSString *cellType;
//@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic, strong)UITableView *sendingTableView;
@property (nonatomic, copy)NSString *distributorsID;
@property (nonatomic, weak)id delegate;
@property (nonatomic, copy)NSString *refresh;
@end
