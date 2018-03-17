//
//  CFRepairsStationViewController.h
//  ChangFa
//
//  Created by Developer on 2018/3/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFRepairsStationModel.h"
typedef void(^repairsStationBlock)(CFRepairsStationModel *model);
@interface CFRepairsStationViewController : UIViewController
@property (nonatomic, strong)NSMutableArray *stationArray;
@property (nonatomic, strong)repairsStationBlock stationBlock;
@end
