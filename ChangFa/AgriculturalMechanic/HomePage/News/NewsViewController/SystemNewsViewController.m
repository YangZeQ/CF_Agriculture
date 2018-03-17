//
//  SystemNewsViewController.m
//  ChangFa
//
//  Created by dev on 2018/1/3.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "SystemNewsViewController.h"
#import "SystemNewsTableViewCell.h"
#import "CFAFNetWorkingMethod.h"
@interface SystemNewsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UILabel *navigationLable;
@property (nonatomic, strong)UITableView *newsTableView;
@property (nonatomic, strong)NSMutableArray *newsArray;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIImageView *backImageView;
@property (nonatomic, strong)UIButton *refreshButton;
@end

@implementation SystemNewsViewController
- (NSMutableArray *)newsArray{
    if (!_newsArray) {
        _newsArray = [NSMutableArray array];
    }
    return _newsArray;
}
- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 256 * screenWidth) / 2, navHeight + 260 * screenHeight, 256 * screenWidth, 367 * screenHeight)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_backView];
        [_backView addSubview:_backImageView];
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshButton.frame = CGRectMake((self.view.frame.size.width - 240 * screenWidth) / 2, _backImageView.frame.size.height + _backImageView.frame.origin.y + 60 * screenHeight, 240 * screenWidth, 100 * screenHeight);
        [_refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
        [_refreshButton.layer setBorderColor:BackgroundColor.CGColor];
        [_refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_refreshButton.layer setBorderWidth:1];
        _refreshButton.layer.cornerRadius = 20 * screenWidth;
        [_refreshButton addTarget:self action:@selector(getNewsInfo) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_refreshButton];
    }
    return _backView;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = @"信息";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNewsInfo];
    [self createNewsView];
    // Do any additional setup after loading the view.
}

- (void)createNewsView{
    self.newsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.newsTableView.showsVerticalScrollIndicator = NO;
    self.newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.newsTableView.backgroundColor = BackgroundColor;
    self.newsTableView.delegate = self;
    self.newsTableView.dataSource = self;
    [self.view addSubview:self.newsTableView];
    self.newsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNewsInfo];
    }];
    self.newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getNewsInfo];
    }];
    [self.newsTableView.mj_header beginRefreshing];
//    [self.newsTableView.mj_footer beginRefreshing];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *registerID = @"news";
    SystemNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:registerID];
    if (cell == nil) {
        cell = [[SystemNewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:registerID];
    }
    cell.model = self.newsArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SystemNewsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self getDetailNewsInfo:cell.model];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 178 * screenHeight;
}
#pragma mark -获取系统消息
- (void)getNewsInfo{
    NSDictionary *dictPost = @{
                               @"page":@1,
                               @"pageSize":@10,
                               };

    [CFAFNetWorkingMethod requestDataWithUrl:@"notice/getNoticeList" Params:dictPost Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.newsTableView.mj_header endRefreshing];
        [self.newsTableView.mj_footer endRefreshing];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            _backView.hidden = YES;
            NSDictionary *dictBody = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"body"]];
            [self.newsArray removeAllObjects];
            for (NSDictionary *modelDic in [dictBody objectForKey:@"resultList"]) {
                NewsModel *model = [NewsModel newsModelWithDictionary:modelDic];
                [self.newsArray addObject:model];
            }
            [self.newsTableView reloadData];
        } else if ([[dict objectForKey:@"code"] integerValue] == 300) {
            self.backView.hidden = NO;
            self.backImageView.frame = CGRectMake((self.view.frame.size.width - 256 * screenWidth) / 2, navHeight + 260 * screenHeight, 256 * screenWidth, 367 * screenHeight);
            self.refreshButton.frame = CGRectMake((self.view.frame.size.width - 240 * screenWidth) / 2, _backImageView.frame.size.height + _backImageView.frame.origin.y + 60 * screenHeight, 240 * screenWidth, 100 * screenHeight);
            _backImageView.image = [UIImage imageNamed:@"CF_NoData"];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.newsTableView.mj_header endRefreshing];
        [self.newsTableView.mj_footer endRefreshing];
        if (error.code == -1009 || error.code == -1001) {
            self.backView.hidden = NO;
            self.backImageView.frame = CGRectMake((self.view.frame.size.width - 488 * screenWidth) / 2, navHeight + 260 * screenHeight, 488 * screenWidth, 373 * screenHeight);
            self.refreshButton.frame = CGRectMake((self.view.frame.size.width - 240 * screenWidth) / 2, _backImageView.frame.size.height + _backImageView.frame.origin.y + 60 * screenHeight, 240 * screenWidth, 100 * screenHeight);
            self.backImageView.image = [UIImage imageNamed:@"CF_NoNetwork"];
        }
    }];
}
#pragma mark -获取系统消息详情
- (void)getDetailNewsInfo:(NewsModel *)model{
    NSDictionary *dictPost = @{
                               @"id":model.ID,
                               };

    [CFAFNetWorkingMethod requestDataWithUrl:@"notice/getNoticeInfo" Params:dictPost Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"head"]];
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

    
    
}
- (void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
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
