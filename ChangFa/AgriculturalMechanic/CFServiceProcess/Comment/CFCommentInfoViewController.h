//
//  CFCommentInfoViewController.h
//  ChangFa
//
//  Created by Developer on 2018/3/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFCommentInfoViewController : UIViewController
@property (nonatomic, assign)NSInteger pushType;  // completeorder push:2
@property (nonatomic, copy)NSString *serviceId;
@property (nonatomic, copy)NSString *commentLevel;
@end
