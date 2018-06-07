//
//  CFRepairOrderView.h
//  ChangFa
//
//  Created by yang on 2018/6/6.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FillViewStylePhoto,// 合影
    FillViewStyleInfo,// 农机信息
    FillViewStyleReason,//说明
    FillViewStyleParts,//零件
} FillViewStyle;

typedef void(^chooseTypeBlock)(void);
@interface CFRepairOrderView : UIView
@property (nonatomic, assign)BOOL isSelected;
@property (nonatomic, strong)UIImageView *signImage;
@property (nonatomic, strong)UIImageView *starImage;
@property (nonatomic, strong)UIImageView *statusImage;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *statuslabel;
@property (nonatomic, strong)UIButton *selectedButton;
@property (nonatomic, strong)UIView *partTypeView;

@property (nonatomic, copy)chooseTypeBlock chooseTypeBlock;

- (instancetype)initWithViewStyle:(FillViewStyle)viewStyle;
@end
