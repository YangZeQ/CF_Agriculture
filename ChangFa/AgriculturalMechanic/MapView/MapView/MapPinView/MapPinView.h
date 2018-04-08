//
//  MapPinView.h
//  ChangFa
//
//  Created by Developer on 2018/1/11.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
//#import <MAPinAnnotationView.h>
#import "MachineModel.h"
@interface MapPinView :MAAnnotationView
@property (nonatomic, strong)MachineModel *model;
@end
