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
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)UIButton *cancelButton;
@property (nonatomic, strong)UIButton *sureButton;
@property (nonatomic, strong)NSString *province;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *district;
@property (nonatomic, strong)NSString *provinceID;
@property (nonatomic, strong)NSString *cityID;
@property (nonatomic, strong)NSString *districtID;
@property (nonatomic, strong)AgencyModel *agencyModel;
- (instancetype)initWithType:(NSString *)type;
- (instancetype)initWithProvinceID:(NSString *)provinceID
                            CityID:(NSString *)cityID
                        districtID:(NSString *)districtID;
@end
