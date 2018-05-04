//
//  CFPickView.m
//  ChangFa
//
//  Created by Developer on 2018/2/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFPickView.h"
#import "ProvinceModel.h"
#import "City.h"
#import "Province.h"
#import "MachineModel.h"
#import "CFPickMachineView.h"
@interface CFPickView ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong)UIPickerView *pickView;
@property (nonatomic ,strong) NSDictionary   * dataDict;/**< 省市区数据源字典*/
@property (nonatomic ,strong) NSDictionary   * citysDict;/**< 所有城市的字典*/
@property (nonatomic ,strong) NSDictionary   * areasDict;/**< 所有地区的字典*/

@end
@implementation CFPickView

- (UIPickerView *)pickView
{
    if (_pickView == nil) {
        _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 80 * screenHeight, [UIScreen mainScreen].bounds.size.width, self.frame.size.height - 80 * screenHeight)];
        _provinceSign = 0;
        _agencySign = 0;
        _pickView.delegate = self;
        _pickView.dataSource = self;
        [self addSubview:_pickView];
    }
    return _pickView;
}
- (NSMutableArray *)provinceArray
{
    if (_provinceArray == nil) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}
- (NSMutableArray *)cityArray
{
    if (_cityArray == nil) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}
- (NSMutableArray *)areaArray
{
    if (_areaArray == nil) {
        _areaArray = [NSMutableArray array];
    }
    return _areaArray;
}
- (NSMutableDictionary *)params
{
    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createPickView];
    }
    return self;
}
- (void)setNumberOfComponents:(int)numberOfComponents{
    _numberOfComponents = numberOfComponents;
    [self.pickView reloadAllComponents];
    if (_numberOfComponents == 2 && _provinceSign == 0) {
        [self getProvinceInfo];
//    } else if (_numberOfComponents == 1 && _agencySign == 0 && _style == 2) {
    } else if (_numberOfComponents == 1 && _style == 2) {
        [self getAgencyInfo];
    } else if (_numberOfComponents == 1 && _style == 3) {
        [self pickerView:_pickView didSelectRow:0 inComponent:0];
    } else if (_numberOfComponents == 3) {
        [self loadAddressData];
    }
}
- (void)setSourceArray:(NSArray *)sourceArray{
    _sourceArray = [NSArray arrayWithArray:sourceArray];
    [self.pickView reloadAllComponents];
}
- (void)createPickView{
    self.backgroundColor = [UIColor whiteColor];
    self.pickView.showsSelectionIndicator = YES;
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(0, 0, self.frame.size.width / 3, 88 * screenHeight);
    _cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30 * screenWidth, 0, 0);
    _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = CFFONT16;
    [self addSubview:_cancelButton];
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(self.frame.size.width / 3 * 2, 0, _cancelButton.frame.size.width, _cancelButton.frame.size.height);
    _sureButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30 * screenWidth);
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _sureButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _sureButton.titleLabel.font = CFFONT16;
    [self addSubview:_sureButton];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_cancelButton.frame.size.width, 0, _cancelButton.frame.size.width, _cancelButton.frame.size.height)];
    titleLabel.text = @"请选择";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return _numberOfComponents;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_numberOfComponents == 2) {
        if (component == 0) {
            return self.provinceArray.count;
        } else if (component == 1) {
            return self.cityArray.count;
        } else {
            return self.areaArray.count;
        }
    } else if (self.numberOfComponents == 3) {
        if (0 == component) {
            return _areaArray.count;
        }
        else if (1 == component){
            NSInteger selectProvince = [pickerView selectedRowInComponent:0];
            Province  * p            = _areaArray[selectProvince];
            return p.cities.count;
        }
        else if (2 == component){
            NSInteger selectProvince = [pickerView selectedRowInComponent:0];
            NSInteger selectCity     = [pickerView selectedRowInComponent:1];
            Province  * p            = _areaArray[selectProvince];
            if (selectCity > p.cityModels.count - 1) {
                return 0;
            }
            City * c = p.cityModels[selectCity];
            return c.areas.count;
        }
    } else {
        if (_style == 3) {// 农机model
            return self.areaArray.count;
        }
        if (_agencySign == 1) {
            return self.provinceArray.count;
        } else {
            return self.sourceArray.count;
        }
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
    label.backgroundColor = [UIColor clearColor];
    if (_numberOfComponents == 2) {//选择地址（网络）
        ProvinceModel *model = [[ProvinceModel alloc] init];
        if (component == 0) {
            model = self.provinceArray[row];
            label.text = model.title;
        } else if (component == 1) {
            model = self.cityArray[row];
            label.text = model.title;
        } else {
            model = self.areaArray[row];
            label.text = model.title;
        }
    } else if (_numberOfComponents == 3) {//选择地址（本地）
        if (0 == component) {
            Province * p = _areaArray[row];
            label.text = p.name;
            self.province = p.name;
        }
        else if (1 == component) {
            Province * selectP = _areaArray[[pickerView selectedRowInComponent:0]];
            if (row > selectP.cities.count - 1) {
                return nil;
            }
            label.text = selectP.cities[row];
            self.city = selectP.cities[row];
        }
        else if (2 == component) {
            NSInteger selectProvince = [pickerView selectedRowInComponent:0];
            NSInteger selectCity     = [pickerView selectedRowInComponent:1];
            Province  * p            = _areaArray[selectProvince];
            if (selectCity > p.cityModels.count - 1) {
                return nil;
            }
            City * c = p.cityModels[selectCity];
            if (row > c.areas.count -1 ) {
                return nil;
            }
            label.text = c.areas[row];
            self.area = c.areas[row];
        }
    } else {
#pragma mark - 未解决自定义resumeview
        if (_style == 3) {
            MachineModel *model = self.areaArray[row];
            CFPickMachineView *machineView = [[CFPickMachineView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, 120 * screenHeight)];
            machineView.name = model.productName;
            machineView.type = model.productModel;
            return machineView;
        }
        //选择性别等单一component
        if (_agencySign == 1) {
            AgencyModel *model = self.provinceArray[row];
            label.text = model.distributorsName;
        } else {
            label.text = self.sourceArray[row];
        }
    }
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    if (_style == 3) {
        return 120 * screenHeight;
    }
    return 100 * screenHeight;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_numberOfComponents == 2) {
         ProvinceModel *model = [[ProvinceModel alloc] init];
        if (component == 0) {
            model = self.provinceArray[row];
            self.province = model.title;
            self.provinceID = model.ID;
            [self getCityInfo:model.ID];
        } else if (component == 1) {
            model = self.cityArray[row];
            self.city = model.title;
            self.cityID = model.ID;
            self.selectedInfo = [[self.province stringByAppendingString:@"-"]stringByAppendingString:self.city];
//            [self getDistrictInfo:model.ID];
        } else {
            model = self.areaArray[row];
            self.area = model.title;
            self.areaID = model.ID;
            self.selectedInfo = [[self.province stringByAppendingString:self.city] stringByAppendingString:self.area];
        }
    } else if (_numberOfComponents == 3) {
        self.selectedInfo = @"";
        if (component == 0) {
            [self.pickView reloadComponent:1];
            [self.pickView reloadComponent:2];
        } else if (component == 1) {
            [self.pickView reloadComponent:2];
        } else {
            
        }
        NSInteger selectProvince = [self.pickView selectedRowInComponent:0];
        NSInteger selectCity     = [self.pickView selectedRowInComponent:1];
        NSInteger selectArea     = [self.pickView selectedRowInComponent:2];
        
        Province * p = _areaArray[selectProvince];
        //解决省市同时滑动未结束时点击完成按钮的数组越界问题
        if (selectCity > p.cityModels.count - 1) {
            selectCity = p.cityModels.count - 1;
        }
        City * c = p.cityModels[selectCity];
        if (selectProvince < 4) {
            self.selectedInfo = [c.cityName stringByAppendingString:c.areas[selectArea]];
            return;
        }
        self.selectedInfo = [[p.name stringByAppendingString:c.cityName] stringByAppendingString:c.areas[selectArea]];
    } else {
        if (_style == 3) {
            self.machineModel = self.areaArray[row];
        }
        if (_agencySign == 1) {
            _agencyModel = self.provinceArray[row];
            self.selectedInfo = _agencyModel.distributorsName;
        } else {
            self.selectedInfo = self.sourceArray[row];
        }
    }

}
#pragma mark - 获取省数据
- (void)getProvinceInfo{
    [CFAFNetWorkingMethod requestDataWithUrl:@"CodeArea/getProv" Loading:0 Params:nil Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            _provinceSign = 1;
            for (NSDictionary *dict in [[responseObject objectForKey:@"body"] objectForKey:@"areaList"]) {
                ProvinceModel *model = [ProvinceModel provinceModelWithDictionary:dict];
                [self.provinceArray addObject:model];
                [self.pickView reloadComponent:0];
//                [_pickView selectRow:0 inComponent:0 animated:YES];
                [self pickerView:_pickView didSelectRow:0 inComponent:0];
            }
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark - 获取市数据
- (void)getCityInfo:(NSString *)city{
    NSDictionary *dict = @{
                           @"id":city,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"CodeArea/getCity" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            [self.cityArray removeAllObjects];
            [self.areaArray removeAllObjects];
//            [self.pickView reloadComponent:2];
            for (NSDictionary *dict in [[responseObject objectForKey:@"body"] objectForKey:@"areaList"]) {
                ProvinceModel *model = [ProvinceModel provinceModelWithDictionary:dict];
                [self.cityArray addObject:model];
                [self.pickView reloadComponent:1];
//                [_pickView selectRow:0 inComponent:1 animated:YES];
                [self pickerView:_pickView didSelectRow:0 inComponent:1];
            }
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark - 获取区数据
- (void)getDistrictInfo:(NSString *)district{
    NSDictionary *dict = @{
                           @"id":district,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"CodeArea/getCountry" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            [self.areaArray removeAllObjects];
            for (NSDictionary *dict in [[responseObject objectForKey:@"body"] objectForKey:@"areaList"]) {
                ProvinceModel *model = [ProvinceModel provinceModelWithDictionary:dict];
                [self.areaArray addObject:model];
                [self.pickView reloadComponent:2];
//                [_pickView selectRow:0 inComponent:2 animated:YES];
                [self pickerView:_pickView didSelectRow:0 inComponent:2];
            }
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark - 获取经销商数据
- (void)getAgencyInfo{
    NSDictionary *dict = @{
                           @"provinceID":self.provinceID,
                           @"cityID":self.cityID,
                           @"areaID":@"",
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"distributors/getDistributorsList" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", [responseObject objectForKey:@"body"]);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            _agencySign = 1;
            [self.provinceArray removeAllObjects];
            for (NSDictionary *dict in [responseObject objectForKey:@"body"]) {
                AgencyModel *model = [AgencyModel agencyModelWithDictionary:dict];
                [self.provinceArray addObject:model];
                [self.pickView reloadAllComponents];
                [self pickerView:_pickView didSelectRow:0 inComponent:0];
            }
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
}

#pragma mark - 本地解析json获取省市区数据
- (void)loadAddressData{
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"address"
                                                          ofType:@"txt"];
    
    NSError  * error;
    NSString * pathStr = [NSString stringWithContentsOfFile:filePath
                                                 encoding:NSUTF8StringEncoding
                                                    error:&error];
    
    if (error) {
        return;
    }
    
    _dataDict = [self dictionaryWithJsonString:pathStr];
    
    if (!_dataDict) {
        return;
    }
    
    _provinceArray = [_dataDict objectForKey:@"p"];
    _citysDict = [_dataDict objectForKey:@"c"];
    _areasDict = [_dataDict objectForKey:@"a"];
    NSLog(@"%@", [_citysDict objectForKey:_provinceArray[2]]);
    NSLog(@"%@", _provinceArray[2]);
    _areaArray = [NSMutableArray array];
    
    //省份模型数组加载各个省份模型
    for (int i = 0 ;i < _provinceArray.count; i++) {
        NSArray  *citys = [_citysDict objectForKey:_provinceArray[i]];
        Province *p = [Province provinceWithName:_provinceArray[i]
                                               cities:citys];
        
        [_areaArray addObject:p];
    }

    //各个省份模型加载各自的所有城市模型
    for (Province * p in _areaArray) {
        NSMutableArray * areasArr = [[NSMutableArray alloc]init];
        for (NSString * cityName in p.cities) {
            NSString * cityKey = [NSString stringWithFormat:@"%@-%@",p.name,cityName];
            NSArray  * cityArr = [_areasDict objectForKey:cityKey];
            City     * city    = [City cityWithName:cityName areas:cityArr];
            [areasArr addObject:city];
        }
        p.cityModels = areasArr;
    }
    [self pickerView:_pickView didSelectRow:0 inComponent:0];
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData  * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * err;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
}

@end
