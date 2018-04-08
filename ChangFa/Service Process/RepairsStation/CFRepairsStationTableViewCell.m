//
//  CFRepairsStationTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/3/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsStationTableViewCell.h"

@interface CFRepairsStationTableViewCell()
@property (nonatomic, strong)UIImageView *stationImageView;
@property (nonatomic, strong)UILabel *stationTitle;
@property (nonatomic, strong)UILabel *stationType;
@property (nonatomic, strong)UILabel *stationRecommend;
@property (nonatomic, strong)UILabel *stationStarLabel;
@property (nonatomic, strong)UIImageView *stationStar;
@property (nonatomic, strong)UILabel *stationAddress;
@property (nonatomic, strong)UILabel *stationDistance;
@end
@implementation CFRepairsStationTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createRepairsStationTableViewCell];
    }
    return self;
}
- (void)createRepairsStationTableViewCell{
    //图片
    _stationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 20 * screenHeight, 146 * screenWidth, 146 * screenHeight)];
    _stationImageView.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_stationImageView];
    //名称
    _stationTitle = [[UILabel alloc]initWithFrame:CGRectMake(_stationImageView.frame.size.width + _stationImageView.frame.origin.x + 20 * screenWidth, _stationImageView.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 176 * screenWidth, 40 * screenHeight)];
    [_stationTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    _stationTitle.text = @"";
    [self.contentView addSubview:_stationTitle];
    //类型
    _stationType = [[UILabel alloc]initWithFrame:CGRectMake(_stationTitle.frame.origin.x, _stationTitle.frame.size.height + _stationTitle.frame.origin.y + 13 * screenHeight, _stationTitle.frame.size.width, _stationTitle.frame.size.height)];
    _stationType.text = @"维修站类型：";
    _stationType.font = CFFONT15;
    [self.contentView addSubview:_stationType];
    //星级
    _stationStarLabel = [[UILabel alloc]initWithFrame:CGRectMake(_stationTitle.frame.origin.x, _stationType.frame.size.height + _stationType.frame.origin.y + 13 * screenHeight, _stationTitle.frame.size.width, _stationTitle.frame.size.height)];
    _stationStarLabel.text = @"服务星级：";
    _stationStarLabel.font = CFFONT15;
    [self.contentView addSubview:_stationStarLabel];
    _stationStar = [[UIImageView alloc]initWithFrame:CGRectMake(_stationTitle.frame.origin.x, _stationType.frame.size.height + _stationType.frame.origin.y + 10 * screenHeight, _stationTitle.frame.size.width, _stationTitle.frame.size.height)];
    _stationStar.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_stationStar];
    //推荐
    _stationRecommend = [[UILabel alloc]initWithFrame:CGRectMake(CF_WIDTH - 230 * screenWidth, _stationStarLabel.frame.origin.y, 200 * screenWidth, _stationStarLabel.frame.size.height)];
    _stationRecommend.textAlignment = NSTextAlignmentRight;
    _stationRecommend.textColor = [UIColor redColor];
    _stationRecommend.text = @"";
    _stationRecommend.font = CFFONT14;
    [self.contentView addSubview:_stationRecommend];
    //地址
    _stationAddress = [[UILabel alloc]initWithFrame:CGRectMake(_stationImageView.frame.origin.x, _stationImageView.frame.origin.y + _stationImageView.frame.size.height + 15 * screenHeight, [UIScreen mainScreen].bounds.size.width - 60 * screenWidth, 50 * screenHeight)];
    _stationAddress.text = @"地址：";
    _stationAddress.font = CFFONT14;
    _stationAddress.textColor = [UIColor grayColor];
    [self.contentView addSubview:_stationAddress];
    //距离
    _stationDistance = [[UILabel alloc]initWithFrame:CGRectMake(_stationImageView.frame.origin.x, _stationAddress.frame.origin.y + _stationAddress.frame.size.height, _stationAddress.frame.size.width, _stationAddress.frame.size.height)];
    _stationDistance.text = @"距离：";
    _stationDistance.font = CFFONT14;
    _stationDistance.userInteractionEnabled = YES;
    _stationDistance.textColor = [UIColor grayColor];
    [self.contentView addSubview:_stationDistance];
    //详情
    _stationInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _stationInfoButton.frame = CGRectMake(_stationRecommend.frame.origin.x, _stationDistance.frame.origin.y - 10 * screenHeight, _stationRecommend.frame.size.width, _stationDistance.frame.size.height);
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(_stationInfoButton.frame.origin.x + _stationInfoButton.frame.size.width - 160 * screenWidth, _stationInfoButton.frame.origin.y, 130 * screenWidth, _stationInfoButton.frame.size.height)];
    infoLabel.text = @"查看详情";
    infoLabel.font = CFFONT15;
    infoLabel.textColor = [UIColor grayColor];
    infoLabel.userInteractionEnabled = YES;
    UIImageView *infoImage = [[UIImageView alloc]initWithFrame:CGRectMake(infoLabel.frame.origin.x + infoLabel.frame.size.width, infoLabel.frame.origin.y + 10 * screenHeight, 30 * screenWidth, 30 * screenHeight)];
    infoImage.image = [UIImage imageNamed:@"CF_Station_Info"];
    infoImage.userInteractionEnabled = YES;
    [self.contentView addSubview:infoLabel];
    [self.contentView addSubview:infoImage];
    [self.contentView addSubview:_stationInfoButton];
    
}
- (void)setModel:(CFRepairsStationModel *)model{
    _model = model;
    if ([model.companyType integerValue] == 1) {
        _stationImageView.image = [UIImage imageNamed:@"CF_Station_Maintenance"];
        _stationType.text = [@"维修站类型：" stringByAppendingString:@"维修站"];
    } else {
        _stationImageView.image = [UIImage imageNamed:@"CF_Station_Agency"];
        _stationType.text = [@"维修站类型：" stringByAppendingString:@"经销商"];
    }
    if ([model.type integerValue] == 0) {
        _stationRecommend.text = @"上次使用";
    } else if ([model.type integerValue] == 1) {
        _stationRecommend.text = @"离我最近";
    }
    _stationTitle.text = [@"" stringByAppendingString:model.serviceCompany];
    _stationAddress.text = [[[_stationAddress.text stringByAppendingString:model.province] stringByAppendingString:model.city] stringByAppendingString:model.county];
    NSString *distance = [[[[NSString stringWithFormat:@"%ld", [model.distance integerValue] / 1000] stringByAppendingString:@"."] stringByAppendingString:[NSString stringWithFormat:@"%ld", [model.distance integerValue] % 1000]] stringByAppendingString:@"Km"];
    _stationDistance.text = [_stationDistance.text stringByAppendingString:distance];
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
