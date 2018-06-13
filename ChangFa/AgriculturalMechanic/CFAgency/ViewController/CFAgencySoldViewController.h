//
//  CFAgencySoldViewController.h
//  ChangFa
//
//  Created by Developer on 2018/1/23.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CFAgencySoldViewControllerDelegate
- (void)changeSoldTableViewStatus;
- (void)changeTableViewInfo;
@end
@interface CFAgencySoldViewController : UIViewController
@property (nonatomic, assign)float height;
@property (nonatomic, strong)UITableView *soldTableView;
@property (nonatomic, copy)NSString *distributorsID;
@property (nonatomic, weak)id delegate;
@property (nonatomic, copy)NSString *refresh;
@end
