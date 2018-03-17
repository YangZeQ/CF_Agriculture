//
//  CFCommentInfoViewController.m
//  ChangFa
//
//  Created by Developer on 2018/3/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFCommentInfoViewController.h"
#import "CFCommentInfoTableViewCell.h"
@interface CFCommentInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *commentInfoTableView;
@property (nonatomic, strong)NSMutableArray *commentArray;
@end

@implementation CFCommentInfoViewController
- (NSMutableArray *)commentArray
{
    if (_commentArray == nil) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.title = @"评论";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    [self createCommentInfoView];
    [self getCommentInfo];
    // Do any additional setup after loading the view.
}
- (void)createCommentInfoView {
    _commentInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _commentInfoTableView.backgroundColor = BackgroundColor;
    _commentInfoTableView.delegate = self;
    _commentInfoTableView.dataSource = self;
    _commentInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
    [self.view addSubview:_commentInfoTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    CFCommentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFCommentInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
//    [_commentInfoTableView setSeparatorInset:UIEdgeInsetsMake(0, 30 * screenWidth, 0, 30 * screenWidth)];
    cell.separatorInset = UIEdgeInsetsMake(0, 30 * screenWidth, 0, 30 * screenWidth);
    cell.commentModel = self.commentArray[indexPath.row];
    if (indexPath.row == self.commentArray.count - 1) {
        cell.lineLabel.hidden = YES;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *commentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 88 * screenHeight)];
    commentView.backgroundColor = [UIColor whiteColor];
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 4 * screenHeight, self.view.frame.size.width - 60 * screenWidth, 80 * screenHeight)];
    commentLabel.text = @"评论";
    [commentView addSubview:commentLabel];
    
    for (int i = 0; i < [self.commentLevel integerValue]; i++) {
        UIImageView *commentLevelImage = [[UIImageView alloc]initWithFrame:CGRectMake(110 * screenWidth + 50 * i * screenWidth, 20 * screenHeight, 40 * screenWidth, 40 * screenHeight)];
        commentLevelImage.image = [UIImage imageNamed:@"CF_Comment_Star_Full"];
        [commentView addSubview:commentLevelImage];
        if (i == [self.commentLevel integerValue] - 1) {
            UILabel *commentLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(commentLevelImage.frame.size.width + commentLevelImage.frame.origin.x + 20 * screenWidth, 0, 80 * screenWidth, commentView.frame.size.height)];
            if ([[NSString stringWithFormat:@"%@", self.commentLevel] length] == 1) {
                commentLevelLabel.text = [NSString stringWithFormat:@"%@.0", _commentLevel];
            } else {
                commentLevelLabel.text = [NSString stringWithFormat:@"%@", _commentLevel];
            }
            [commentView addSubview:commentLevelLabel];
        }
    }
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, commentView.frame.size.height - 2 * screenHeight, self.view.frame.size.width, 2 * screenHeight)];
    lineLabel.backgroundColor = BackgroundColor;
    [commentView addSubview:lineLabel];
    return commentView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据内容计算高度
//    CGRect rect = [_contentArray[indexPath.row] boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-120, MAXFLOAT)
//                                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    CFCommentModel *commentModel = self.commentArray[indexPath.row];
    if (commentModel.filePath.count > 0) {
        return 496 * screenHeight;
    }
    return 226 * screenHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 88 * screenHeight;
}
- (void)getCommentInfo
{
    NSDictionary *params = @{
                             @"serviceId":self.serviceId,
                             };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"serviceInfo/getServiceComment" Loading:1 Params:params Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
            for (NSDictionary *dict in [[[responseObject objectForKey:@"body"] objectForKey:@"result"] objectForKey:@"resultList"]) {
                CFCommentModel *commentModel = [CFCommentModel commentModelWithDictionary:dict];
                [self.commentArray addObject:commentModel];
                [self.commentInfoTableView reloadData];
            }
        } else {
            
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)leftButtonClick {
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
