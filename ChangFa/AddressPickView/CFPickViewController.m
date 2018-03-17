//
//  CFPickViewController.m
//  ChangFa
//
//  Created by Developer on 2018/1/28.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFPickViewController.h"
#import "CFAFNetWorkingMethod.h"
#import "ProvinceModel.h"

@interface CFPickViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *provinceTableView;
@property (nonatomic, strong)UITableView *cityTableView;
@property (nonatomic, strong)UITableView *districtTableView;
@property (nonatomic, strong)UITableView *otherTableView;

@property (nonatomic, strong) NSMutableArray *provinceArray;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *districtArray;
@property (nonatomic, strong) NSMutableArray *otherArrray;
@end

@implementation CFPickViewController
- (NSMutableArray *)provinceArray{
    if (_provinceArray == nil) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}
- (NSMutableArray *)cityArray{
    if (_cityArray == nil) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}
- (NSMutableArray *)districtArray{
    if (_districtArray == nil) {
        _districtArray = [NSMutableArray array];
    }
    return _districtArray;
}
- (instancetype)initWithType:(NSString *)type{
    if (self = [super init]) {
//        if ([type isEqualToString:@"address"]) {
            [self createProvincePickView];
//        } else {
//            [self createOtherPickView];
//        }
    }
    return self;
}
- (instancetype)initWithProvinceID:(NSString *)provinceID CityID:(NSString *)cityID districtID:(NSString *)districtID{
    if (self = [super init]) {
        self.provinceID = provinceID;
        self.cityID = cityID;
        self.districtID = districtID;
        [self createOtherPickView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)createProvincePickView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 530 * screenHeight, self.view.frame.size.width, 530 * screenHeight)];
    backView.backgroundColor = BackgroundColor;
    [self.view addSubview:backView];
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(0, 0, self.view.frame.size.width / 3, 88 * screenHeight);
    _cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30 * screenWidth, 0, 0);
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [backView addSubview:_cancelButton];
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(self.view.frame.size.width / 3 * 2, 0, _cancelButton.frame.size.width, _cancelButton.frame.size.height);
    _sureButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30 * screenWidth);
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [backView addSubview:_sureButton];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_cancelButton.frame.size.width, 0, _cancelButton.frame.size.width, _cancelButton.frame.size.height)];
    titleLabel.text = @"选择地区";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    self.provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _cancelButton.frame.size.height + 2 * screenHeight, self.view.frame.size.width / 3, 440 * screenHeight) style:UITableViewStylePlain];
    self.provinceTableView.delegate = self;
    self.provinceTableView.dataSource = self;
    self.provinceTableView.tag = 1001;
    [backView addSubview:self.provinceTableView];
    self.cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(_provinceTableView.frame.size.width, _cancelButton.frame.size.height + 2 * screenHeight, self.view.frame.size.width / 3, 440 * screenHeight) style:UITableViewStylePlain];
    self.cityTableView.delegate = self;
    self.cityTableView.dataSource = self;
    self.cityTableView.tag = 1002;
    [backView addSubview:self.cityTableView];
    self.districtTableView = [[UITableView alloc]initWithFrame:CGRectMake(_provinceTableView.frame.size.width * 2, _cancelButton.frame.size.height + 2 * screenHeight, self.view.frame.size.width / 3, 440 * screenHeight) style:UITableViewStylePlain];
    self.districtTableView.delegate = self;
    self.districtTableView.dataSource = self;
    self.districtTableView.tag = 1003;
    [backView addSubview:self.districtTableView];
    [self getProvinceInfo];
}
- (void)createOtherPickView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 530 * screenHeight, self.view.frame.size.width, 530 * screenHeight)];
    backView.backgroundColor = BackgroundColor;
    [self.view addSubview:backView];
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(0, 0, self.view.frame.size.width / 3, 88 * screenHeight);
    _cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30 * screenWidth, 0, 0);
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [backView addSubview:_cancelButton];
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(self.view.frame.size.width / 3 * 2, 0, _cancelButton.frame.size.width, _cancelButton.frame.size.height);
    _sureButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30 * screenWidth);
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [backView addSubview:_sureButton];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_cancelButton.frame.size.width, 0, _cancelButton.frame.size.width, _cancelButton.frame.size.height)];
    titleLabel.text = @"选择经销商";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    self.provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _cancelButton.frame.size.height + 2 * screenHeight, self.view.frame.size.width, 440 * screenHeight) style:UITableViewStylePlain];
    self.provinceTableView.delegate = self;
    self.provinceTableView.dataSource = self;
    self.provinceTableView.tag = 1004;
    [backView addSubview:self.provinceTableView];
    [self getAgencyInfo];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1001) {
        return self.provinceArray.count;
    } else if (tableView.tag == 1002) {
        return self.cityArray.count;
    } else if (tableView.tag == 1003) {
        return self.districtArray.count;
    } else {
        return self.provinceArray.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ProvinceModel *model = [[ProvinceModel alloc]init];
    if (tableView.tag == 1001) {
        model = self.provinceArray[indexPath.row];
        cell.textLabel.text = model.title;
    } else if (tableView.tag == 1002) {
        model = self.cityArray[indexPath.row];
        cell.textLabel.text = model.title;
    } else if (tableView.tag == 1003) {
        model = self.districtArray[indexPath.row];
        cell.textLabel.text = model.title;
    } else {
        AgencyModel *model = [[AgencyModel alloc]init];
        model = self.provinceArray[indexPath.row];
        cell.textLabel.text = model.distributorsName;
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1001) {
        ProvinceModel *model = self.provinceArray[indexPath.row];
        self.province = model.title;
        self.city = @"";
        self.district = @"";
        self.provinceID = [NSString stringWithFormat:@"%@", model.ID];
        self.cityID = @"";
        self.districtID = @"";
        [self getCityInfo:model.ID];
    } else if (tableView.tag == 1002) {
        ProvinceModel *model = self.cityArray[indexPath.row];
        self.city = model.title;
        self.district = @"";
        self.cityID = [NSString stringWithFormat:@"%@", model.ID];
        self.districtID = @"";
        [self getDistrictInfo:model.ID];
    } else if (tableView.tag == 1003) {
        ProvinceModel *model = self.districtArray[indexPath.row];
        self.district = model.title;
        self.districtID = [NSString stringWithFormat:@"%@", model.ID];
    } else {
        self.agencyModel = self.provinceArray[indexPath.row];
    }
}
- (void)getProvinceInfo{
    [CFAFNetWorkingMethod requestDataWithUrl:@"CodeArea/getProv" Params:nil Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            for (NSDictionary *dict in [[responseObject objectForKey:@"body"] objectForKey:@"areaList"]) {
                ProvinceModel *model = [ProvinceModel provinceModelWithDictionary:dict];
                [self.provinceArray addObject:model];
                [self.provinceTableView reloadData];
            }
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)getCityInfo:(NSString *)city{
    NSDictionary *dict = @{
                           @"id":city,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"CodeArea/getCity" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            [self.cityArray removeAllObjects];
            [self.districtArray removeAllObjects];
            [self.districtTableView reloadData];
            for (NSDictionary *dict in [[responseObject objectForKey:@"body"] objectForKey:@"areaList"]) {
                ProvinceModel *model = [ProvinceModel provinceModelWithDictionary:dict];
                [self.cityArray addObject:model];
                [self.cityTableView reloadData];
            }
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)getDistrictInfo:(NSString *)district{
    NSDictionary *dict = @{
                           @"id":district,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"CodeArea/getCountry" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            [self.districtArray removeAllObjects];
            for (NSDictionary *dict in [[responseObject objectForKey:@"body"] objectForKey:@"areaList"]) {
                ProvinceModel *model = [ProvinceModel provinceModelWithDictionary:dict];
                [self.districtArray addObject:model];
                [self.districtTableView reloadData];
            }
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)getAgencyInfo{
    NSDictionary *dict = @{
                           @"provinceID":self.provinceID,
                           @"cityID":self.cityID,
                           @"areaID":self.districtID,
                           };
    [CFAFNetWorkingMethod requestDataWithUrl:@"distributors/getDistributorsList" Params:dict Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", [responseObject objectForKey:@"body"]);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            [self.provinceArray removeAllObjects];
            for (NSDictionary *dict in [responseObject objectForKey:@"body"]) {
                AgencyModel *model = [AgencyModel agencyModelWithDictionary:dict];
                [self.provinceArray addObject:model];
                [self.provinceTableView reloadData];
            }
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
