//
//  BindAndOutput.h
//  ChangFa
//
//  Created by Developer on 2018/1/18.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineModel.h"
#import "AgencyModel.h"
typedef void(^relieveBlock)(NSString *imei, NSString *carbar);
@interface BindAndOutputView: UIView
@property (nonatomic, strong)AgencyModel *agencyModel;
@property (nonatomic, strong)MachineModel *model;
@property (nonatomic, strong)UIButton *completeButton;
@property (nonatomic, strong)UIButton *outputButton;
@property (nonatomic, strong)UIImageView *imageStatus;
@property (nonatomic, strong)relieveBlock relieveBlock;
- (instancetype)initWithFrame:(CGRect)frame
                    ViewStyle:(NSString *)style;
@end
