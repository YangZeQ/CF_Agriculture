//
//  CFPickViewController.h
//  ChangFa
//
//  Created by Developer on 2018/1/28.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgencyModel.h"
@interface CFPickViewController : UIViewController
@property (nonatomic, copy)NSString *type;
@property (nonatomic, strong)UIButton *cancelButton;
@property (nonatomic, strong)UIButton *sureButton;
@property (nonatomic, copy)NSString *province;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *district;
@property (nonatomic, copy)NSString *provinceID;
@property (nonatomic, copy)NSString *cityID;
@property (nonatomic, copy)NSString *districtID;
@property (nonatomic, strong)AgencyModel *agencyModel;
- (instancetype)initWithType:(NSString *)type;
- (instancetype)initWithProvinceID:(NSString *)provinceID
                            CityID:(NSString *)cityID
                        districtID:(NSString *)districtID;
@end
