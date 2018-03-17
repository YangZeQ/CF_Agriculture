//
//  CFAgencyApplicationRecordTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/2/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFAgencyApplicationRecordTableViewCell.h"

@interface CFAgencyApplicationRecordTableViewCell ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *typeLabel;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UILabel *timeLabel;

@end
@implementation CFAgencyApplicationRecordTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createApplicationRecordCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)createApplicationRecordCell{
    self.contentView.backgroundColor = BackgroundColor;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(30 * screenWidth, 0, [UIScreen mainScreen].bounds.size.width - 60 * screenWidth, 195 * screenHeight)];
    backView.layer.cornerRadius = 20 * screenWidth;
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 20 * screenHeight, 200 * screenWidth, 45 * screenHeight)];
    _titleLabel.font = CFFONT16;
    [backView addSubview:_titleLabel];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.size.height + _titleLabel.frame.origin.y + 15 * screenHeight, backView.frame.size.width - 60 * screenWidth, 40 * screenHeight)];
    _nameLabel.font = CFFONT14;
    _nameLabel.text = @"名称：";
    _nameLabel.textColor = [UIColor lightGrayColor];
    [backView addSubview:_nameLabel];
    
    _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 15 * screenHeight, backView.frame.size.width / 2 + 20 * screenWidth, _nameLabel.frame.size.height)];
    _typeLabel.font = CFFONT14;
    _typeLabel.text = @"型号：";
    _typeLabel.textColor = [UIColor lightGrayColor];
    [backView addSubview:_typeLabel];
    
    _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(backView.frame.size.width - 230 * screenWidth, _titleLabel.frame.origin.y, 200 * screenWidth, _titleLabel.frame.size.height)];
    _statusLabel.font = CFFONT18;
    _statusLabel.textColor = ChangfaColor;
    _statusLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:_statusLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(backView.frame.size.width / 2 + 50 * screenWidth, _typeLabel.frame.origin.y, backView.frame.size.width / 2 - 80 * screenWidth, _nameLabel.frame.size.height)];
    _timeLabel.font = CFFONT13;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:_timeLabel];
}
- (void)setModel:(MachineModel *)model{
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"%@", model.apply_type];
    _nameLabel.text = [_nameLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", model.productName]];
    _typeLabel.text = [_typeLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@", model.productModel]];
    switch ([model.apply_state integerValue]) {
        case 0:
            _statusLabel.text = @"审核中";
            break;
        case 1:
            _statusLabel.text = @"通过";
            break;
        case 2:
            _statusLabel.text = @"不通过";
            _statusLabel.textColor = [UIColor redColor];
            break;
        default:
            break;
    }
    _timeLabel.text = [[model.apply_time substringWithRange:NSMakeRange(0, 16)] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
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
