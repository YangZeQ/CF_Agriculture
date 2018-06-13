//
//  CFPickView.h
//  ChangFa
//
//  Created by Developer on 2018/2/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgencyModel.h"
#import "MachineModel.h"
//@protocol CFPickViewDelegate
//@optional
//- (void)getProvinceInfo;
//- (void)getCityInfo:(NSString *)province;
//- (void)getAreaInfo:(NSString *)city;
//@end
@interface CFPickView : UIView
@property (nonatomic, weak)id delegate;
@property (nonatomic, strong)UIButton *cancelButton;
@property (nonatomic, strong)UIButton *sureButton;
@property (nonatomic, copy)NSString *selectedInfo;
@property (nonatomic, strong)NSArray *sourceArray;
@property (nonatomic, strong)NSMutableArray *provinceArray;
@property (nonatomic, strong)NSMutableArray *cityArray;
@property (nonatomic, strong)NSMutableArray *areaArray;
@property (nonatomic, assign)int numberOfComponents;
@property (nonatomic, copy)NSString *provinceID;
@property (nonatomic, copy)NSString *cityID;
@property (nonatomic, copy)NSString *areaID;

@property (nonatomic, copy)NSString *province;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *area;

@property (nonatomic, strong)AgencyModel *agencyModel;
@property (nonatomic, strong)MachineModel *machineModel;
@property (nonatomic, assign)NSInteger style;// 0:初始状态 2:agency，经销商 3:农机
@property (nonatomic, assign)NSInteger provinceSign; // 防止重复请求省级数据
@property (nonatomic, assign)NSInteger agencySign; // 防止重复请求经销商数据

@property (nonatomic, strong)NSMutableDictionary *params;
//-(instancetype)initWithFrame:(CGRect)frame
//          NumberOfComponents:(int)numberOfComponents
//                 SourceArray:(NSArray *)sourceArray;
@end
