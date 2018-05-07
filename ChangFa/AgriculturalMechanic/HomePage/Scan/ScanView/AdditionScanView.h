//
//  AdditionScanView.h
//  ChangFa
//
//  Created by Developer on 2018/4/25.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MachineModel.h"
typedef NS_ENUM(NSInteger, AdditionStep) {
    AdditionStepScanIMEI,
    AdditionStepBindMachine,
    AdditionStepDone,
};
typedef void(^lightBlock)(BOOL selected);
typedef void(^additionStepsBlock)(NSInteger step, MachineModel *model);
typedef void(^stopSessionBlock)(BOOL isStop);
typedef void(^textNumberBlock)(NSString *text);
typedef void(^submitBlock)(void);
@interface AdditionScanView : UIView
@property (nonatomic, strong)UIView *scanView;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UILabel *lightLabel;
@property (nonatomic, strong)UIView *textView;
@property (nonatomic, strong)UIScrollView *additionScrollView;
@property (nonatomic, strong)UIButton *activeButton;

@property (nonatomic, copy)lightBlock lightBlock;
@property (nonatomic, copy)additionStepsBlock additionStepsBlock;
@property (nonatomic, copy)stopSessionBlock stopSessionBlock;
@property (nonatomic, copy)textNumberBlock textNumberBlock;
@property (nonatomic, copy)submitBlock submitBlock;
@end
