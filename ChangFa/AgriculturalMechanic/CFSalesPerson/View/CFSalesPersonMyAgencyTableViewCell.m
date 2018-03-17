//
//  CFSalesPersonMyAgencyTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/1/25.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFSalesPersonMyAgencyTableViewCell.h"

@interface CFSalesPersonMyAgencyTableViewCell ()
@property (nonatomic, strong)UILabel *agencyCompanyLabel;
@property (nonatomic, strong)UILabel *agencyAddressLabel;
@property (nonatomic, strong)UILabel *agencyTypeLabel;
@end
@implementation CFSalesPersonMyAgencyTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createMyAgencyCell];
    }
    return self;
}
- (void)createMyAgencyCell{
    _agencyCompanyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, [UIScreen mainScreen].bounds.size.width - 60 * screenWidth, 50 * screenHeight)];
    _agencyCompanyLabel.text = @"常州市常发集团公司";
    _agencyCompanyLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.contentView addSubview:_agencyCompanyLabel];
    
    _agencyAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_agencyCompanyLabel.frame.origin.x, _agencyCompanyLabel.frame.size.height + _agencyCompanyLabel.frame.origin.y + 20 * screenHeight, _agencyCompanyLabel.frame.size.width , _agencyCompanyLabel.frame.size.height)];
    _agencyAddressLabel.text = @"地址：";
    _agencyAddressLabel.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [self.contentView addSubview:_agencyAddressLabel];
    
    _agencyTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_agencyCompanyLabel.frame.origin.x, _agencyAddressLabel.frame.size.height + _agencyAddressLabel.frame.origin.y + 20 * screenHeight, _agencyCompanyLabel.frame.size.width , _agencyCompanyLabel.frame.size.height)];
    _agencyTypeLabel.text = @"经销类型";
    _agencyTypeLabel.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [self.contentView addSubview:_agencyTypeLabel];
}
- (void)setModel:(AgencyModel *)model{
    _model = model;
    _agencyCompanyLabel.text = [NSString stringWithFormat:@"%@", model.distributorsName];
    _agencyAddressLabel.text = [@"地址：" stringByAppendingString:[NSString stringWithFormat:@"%@", model.distributorsAddress]];
    if ([model.distributorsType integerValue] == 1) {
        _agencyTypeLabel.text = [@"经销类型：" stringByAppendingString:@"整机"];
    } else if ([model.distributorsType integerValue] == 2) {
        _agencyTypeLabel.text = [@"经销类型：" stringByAppendingString:@"动力"];
    }
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
