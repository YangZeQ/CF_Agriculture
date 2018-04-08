//
//  CFRepairsRecordInfoViewController.h
//  ChangFa
//
//  Created by Developer on 2018/3/3.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFRepairsRecordModel.h"
@interface CFRepairsRecordInfoViewController : UIViewController
@property (nonatomic, strong)CFRepairsRecordModel *recordModel;
@property (nonatomic, assign)BOOL setTitle;
@end
