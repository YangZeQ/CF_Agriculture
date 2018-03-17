//
//  CFSalesPersonAgencyInfoViewController.h
//  ChangFa
//
//  Created by Developer on 2018/1/26.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgencyModel.h"
@protocol CFSalesPersonAgencyInfoViewControllerDelegate
- (void)changeTableViewStatus;
@end
@interface CFSalesPersonAgencyInfoViewController : UIViewController
@property (nonatomic, weak)id delegate;
@property (nonatomic, strong)AgencyModel *agencyModel;
@end
