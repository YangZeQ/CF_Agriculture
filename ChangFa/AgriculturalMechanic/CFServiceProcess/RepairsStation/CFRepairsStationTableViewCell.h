//
//  CFRepairsStationTableViewCell.h
//  ChangFa
//
//  Created by Developer on 2018/3/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFRepairsStationModel.h"
@interface CFRepairsStationTableViewCell : UITableViewCell
@property (nonatomic, strong)UIButton *stationInfoButton;
@property (nonatomic, strong)CFRepairsStationModel *model;
@end
