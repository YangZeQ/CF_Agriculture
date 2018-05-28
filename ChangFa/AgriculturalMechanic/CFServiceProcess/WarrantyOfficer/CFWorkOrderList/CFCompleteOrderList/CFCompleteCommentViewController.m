//
//  CFCompleteCommentViewController.m
//  ChangFa
//
//  Created by Developer on 2018/4/10.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFCompleteCommentViewController.h"
#import "CFPreviewPhotoViewController.h"
#import "CFRepairsPhotoCell.h"
#import "CFCommentModel.h"
@interface CFCompleteCommentViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UILabel *phoneLabel;
@property (nonatomic, strong)UILabel *commentContentLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIView *commentBackVgroundView;
@property (nonatomic, strong)CFRepairsPhotoCell *repairsPhotoCell;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)CFCommentModel *commentModel;
@property (nonatomic, strong)UICollectionView *repairsPhotoCollection;
@end

@implementation CFCompleteCommentViewController
- (NSMutableArray *)photoArray
{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.navigationItem.title = @"用户评论";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"fanhuiwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick)];
    [self getCommentInfo];
    [self createCommentInfoView];
    // Do any additional setup after loading the view.
}

- (void)createCommentInfoView{
    _commentBackVgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 30 * screenHeight, CF_WIDTH, 230 * screenHeight)];
    _commentBackVgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_commentBackVgroundView];
    
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 0, CF_WIDTH - 60 * screenWidth, 80 * screenHeight)];
    commentLabel.text = @"用户评价";
    commentLabel.font = CFFONT15;
    [_commentBackVgroundView addSubview:commentLabel];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, commentLabel.frame.size.height - screenHeight, commentLabel.frame.size.width, screenHeight)];
    lineLabel.backgroundColor = [UIColor grayColor];
    [commentLabel addSubview:lineLabel];
    
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, commentLabel.frame.size.height + commentLabel.frame.origin.y + 20 * screenHeight, [UIScreen mainScreen].bounds.size.width - 60 * screenWidth, 50 * screenHeight)];
    _phoneLabel.font = CFFONT14;
    _phoneLabel.text =  _contactMobile;
    _phoneLabel.textColor = [UIColor grayColor];
    
    _commentContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_phoneLabel.frame.origin.x, _phoneLabel.frame.size.height + _phoneLabel.frame.origin.y + 20 * screenHeight, _phoneLabel.frame.size.width, _phoneLabel.frame.size.height)];
    _commentContentLabel.font = CFFONT14;
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _repairsPhotoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(_phoneLabel.frame.origin.x, _commentContentLabel.frame.size.height + _commentContentLabel.frame.origin.y + 20 * screenHeight, CF_WIDTH, 250 * screenHeight) collectionViewLayout:layout];
    _repairsPhotoCollection.backgroundColor = [UIColor whiteColor];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(250 * screenWidth, 250 * screenHeight);
    layout.minimumLineSpacing = 20 * screenWidth;
    layout.minimumInteritemSpacing = 0 * screenHeight;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _repairsPhotoCollection.showsHorizontalScrollIndicator = NO;
    _repairsPhotoCollection.delegate = self;
    _repairsPhotoCollection.dataSource = self;
    _repairsPhotoCollection.hidden = YES;
    [_repairsPhotoCollection registerClass:[CFRepairsPhotoCell class] forCellWithReuseIdentifier:@"repairsPhotoCellId"];

    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_phoneLabel.frame.origin.x, _commentContentLabel.frame.size.height + _commentContentLabel.frame.origin.y + 20 * screenHeight, _phoneLabel.frame.size.width, _phoneLabel.frame.size.height)];
    _timeLabel.font = CFFONT13;
    _timeLabel.textColor = [UIColor grayColor];
    
    [_commentBackVgroundView addSubview:_phoneLabel];
    [_commentBackVgroundView addSubview:_commentContentLabel];
    [_commentBackVgroundView addSubview:_repairsPhotoCollection];
    [_commentBackVgroundView addSubview:_timeLabel];
    
}
- (void)setCommentModel:(CFCommentModel *)commentModel
{
    _commentModel = commentModel;
    _commentContentLabel.text = commentModel.content;
    _timeLabel.text = commentModel.createTime;
    if (commentModel.filePath.count > 0) {
        _commentBackVgroundView.frame = CGRectMake(0, navHeight, CF_WIDTH, 560 * screenHeight);
        _repairsPhotoCollection.hidden = NO;
        _repairsPhotoCollection.frame = CGRectMake(_commentContentLabel.frame.origin.x, _commentContentLabel.frame.size.height + _commentContentLabel.frame.origin.y + 20 * screenHeight, _commentContentLabel.frame.size.width, 250 * screenHeight);
        _repairsPhotoCollection.backgroundColor = [UIColor whiteColor];
        _timeLabel.frame = CGRectMake(_phoneLabel.frame.origin.x, _repairsPhotoCollection.frame.size.height + _repairsPhotoCollection.frame.origin.y + 20 * screenHeight, _phoneLabel.frame.size.width, _phoneLabel.frame.size.height);
        self.photoArray = commentModel.filePath;
        [_repairsPhotoCollection reloadData];
    }
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_phoneLabel.frame.size.width - 50 * screenWidth, 0, 50 * screenWidth, _phoneLabel.frame.size.height)];
    commentLabel.textAlignment = NSTextAlignmentRight;
    commentLabel.font = CFFONT15;
    if ([[NSString stringWithFormat:@"%@", commentModel.level] length] > 1) {
        commentLabel.text = [NSString stringWithFormat:@"%@", commentModel.level];
    } else {
        commentLabel.text = [NSString stringWithFormat:@"%@.0", commentModel.level];
    }
    [_phoneLabel addSubview:commentLabel];

    for (int i = 0; i < [commentModel.level integerValue]; i++) {
        UIImageView *commentLevelImage = [[UIImageView alloc]initWithFrame:CGRectMake(_phoneLabel.frame.size.width - 110 * screenWidth - 50 * i * screenWidth, 8 * screenHeight, 25 * screenWidth, 25 * screenHeight)];
        commentLevelImage.image = [UIImage imageNamed:@"CF_Comment_Star_Full"];
        [_phoneLabel addSubview:commentLevelImage];
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    _repairsPhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"repairsPhotoCellId" forIndexPath:indexPath];
    [_repairsPhotoCell.repairsPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.photoArray[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"CF_RepairImage"]];
    return _repairsPhotoCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CFPreviewPhotoViewController *preview = [[CFPreviewPhotoViewController alloc]init];
    preview.photoArray = self.photoArray;
    preview.selectedIndex = indexPath.row;
    preview.headerHeight = navHeight;
    [self presentViewController:preview animated:YES completion:^{
        
    }];
}
- (void)getCommentInfo
{
    NSDictionary *params = @{
                             @"commentId":self.commentId,
                             };
    [CFAFNetWorkingMethod requestDataWithJavaUrl:@"reportComment/selectById" Loading:1 Params:params Method:@"get" Image:nil Success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[[responseObject objectForKey:@"head"] objectForKey:@"code"] integerValue] == 200) {
                self.commentModel = [CFCommentModel commentModelWithDictionary:[[responseObject objectForKey:@"body"] objectForKey:@"result"]];
//                self.photoArray = commentModel.filePath;
//                [self.repairsPhotoCollection reloadData];
//                _commentLabel.text = commentModel.content;
//                _timeLabel.text = commentModel.createTime;
        } else {
            
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
