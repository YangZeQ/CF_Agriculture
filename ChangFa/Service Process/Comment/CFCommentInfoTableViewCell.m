//
//  CFCommentInfoTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/3/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFCommentInfoTableViewCell.h"
#import "CFRepairsPhotoCell.h"
@interface CFCommentInfoTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UILabel *phoneLabel;
@property (nonatomic, strong)UILabel *commentLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIView *photoView;
@property (nonatomic, strong)UICollectionViewCell *cellll;
@property (nonatomic, strong)CFRepairsPhotoCell *repairsPhotoCell;
@property (nonatomic, strong)NSMutableArray *photoArray;
@end
@implementation CFCommentInfoTableViewCell

- (NSMutableArray *)photoArray
{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCommentInfoCell];
    }
    return self;
}
- (void)createCommentInfoCell{
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, [UIScreen mainScreen].bounds.size.width - 60 * screenWidth, 50 * screenHeight)];
    _phoneLabel.font = CFFONT14;
    _phoneLabel.textColor = [UIColor grayColor];
    
    _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_phoneLabel.frame.origin.x, _phoneLabel.frame.size.height + _phoneLabel.frame.origin.y + 20 * screenHeight, _phoneLabel.frame.size.width, _phoneLabel.frame.size.height)];
    _commentLabel.font = CFFONT14;
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_phoneLabel.frame.origin.x, _commentLabel.frame.size.height + _commentLabel.frame.origin.y + 20 * screenHeight, _phoneLabel.frame.size.width, _phoneLabel.frame.size.height)];
    _timeLabel.font = CFFONT13;
    _timeLabel.textColor = [UIColor grayColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _repairsPhotoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 25 * screenHeight, self.contentView.frame.size.width, 250 * screenHeight) collectionViewLayout:layout];
    layout.sectionInset = UIEdgeInsetsMake(0, 25 * screenWidth, 0, 25 * screenWidth);
    layout.itemSize = CGSizeMake(250 * screenWidth, 250 * screenHeight);
    layout.minimumLineSpacing = 10 * screenWidth;
    layout.minimumInteritemSpacing = 0 * screenHeight;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _repairsPhotoCollection.showsHorizontalScrollIndicator = NO;
    _repairsPhotoCollection.delegate = self;
    _repairsPhotoCollection.dataSource = self;
    [_repairsPhotoCollection registerClass:[CFRepairsPhotoCell class] forCellWithReuseIdentifier:@"repairsPhotoCellId"];
    [_repairsPhotoCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellll"];
    [self.contentView addSubview:_repairsPhotoCollection];
    _repairsPhotoCollection.hidden = YES;
    
    [self.contentView addSubview:_phoneLabel];
    [self.contentView addSubview:_commentLabel];
    [self.contentView addSubview:_timeLabel];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _timeLabel.frame.size.height - screenHeight, _phoneLabel.frame.size.width, screenHeight)];
    _lineLabel.backgroundColor = [UIColor grayColor];
    [_timeLabel addSubview:_lineLabel];
}
- (void)setCommentModel:(CFCommentModel *)commentModel
{
    _commentModel = commentModel;
    _phoneLabel.text = commentModel.mobile;
    _commentLabel.text = commentModel.content;
    _timeLabel.text = commentModel.commentTime;
    if (commentModel.filePath.count > 0) {
        _repairsPhotoCollection.hidden = NO;
        _repairsPhotoCollection.frame = CGRectMake(_commentLabel.frame.origin.x, _commentLabel.frame.size.height + _commentLabel.frame.origin.y + 20 * screenHeight, _commentLabel.frame.size.width, 250 * screenHeight);
        _repairsPhotoCollection.backgroundColor = [UIColor whiteColor];
        _timeLabel.frame = CGRectMake(_phoneLabel.frame.origin.x, _repairsPhotoCollection.frame.size.height + _repairsPhotoCollection.frame.origin.y + 20 * screenHeight, _phoneLabel.frame.size.width, _phoneLabel.frame.size.height);
        self.photoArray = commentModel.filePath;
        [_repairsPhotoCollection reloadData];
    }
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_phoneLabel.frame.size.width - 50 * screenWidth, 0, 50 * screenWidth, _phoneLabel.frame.size.height)];
    commentLabel.textAlignment = NSTextAlignmentRight;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
