//
//  CFMapNavigationViewController.h
//  ChangFa
//
//  Created by Developer on 2018/3/20.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMapNavigationViewController : UIViewController
@property (nonatomic, assign)double stationLatitude;
@property (nonatomic, assign)double stationLongitude;
@property (nonatomic, copy)NSString *position;
@property (nonatomic, copy)NSString *machineType;
@end
