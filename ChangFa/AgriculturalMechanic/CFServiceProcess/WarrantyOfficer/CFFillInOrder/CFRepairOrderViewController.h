//
//  CFRepairOrderViewController.h
//  ChangFa
//
//  Created by yang on 2018/6/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFRepairOrderViewController : UIViewController
@property (nonatomic, copy)NSString *dispatchId;
@property (nonatomic, copy)NSString *repairId;
@property (nonatomic, copy)NSString *disId;
@property (nonatomic, copy)NSString *disNum;
@property (nonatomic, assign)BOOL isCheck;
@end
