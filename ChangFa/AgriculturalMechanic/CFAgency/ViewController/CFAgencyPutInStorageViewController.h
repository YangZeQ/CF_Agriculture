//
//  CFAgencyPutInStorageViewController.h
//  ChangFa
//
//  Created by Developer on 2018/1/23.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CFAgencyPutInViewControllerDelegate
- (void)changePutInTableViewStatus;
- (void)changeTableViewInfo;
@end
@interface CFAgencyPutInStorageViewController : UIViewController
@property (nonatomic, assign)float height;
@property (nonatomic, strong)UITableView *putinTableView;
@property (nonatomic, copy)NSString *distributorsID;
@property (nonatomic, weak)id delegate;
@property (nonatomic, copy)NSString *refresh;
@end
