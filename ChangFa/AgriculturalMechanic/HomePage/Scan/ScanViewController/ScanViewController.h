//
//  ScanViewController.h
//  ChangFa
//
//  Created by dev on 2018/1/4.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineModel.h"
@protocol scanViewControllerDelegate
- (void)scanGetInformation:(MachineModel *)model;
@end
@interface ScanViewController : UIViewController
@property (nonatomic, weak)id delegate;
@property (nonatomic, copy)NSString *scanType;
@property (nonatomic, copy)NSString *getInfoType;
@end
