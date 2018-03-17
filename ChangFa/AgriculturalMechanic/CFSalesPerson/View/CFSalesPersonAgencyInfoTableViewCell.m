//
//  CFSalesPersonAgencyInfoTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/1/26.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFSalesPersonAgencyInfoTableViewCell.h"

@interface CFSalesPersonAgencyInfoTableViewCell ()
@property (nonatomic, strong)UILabel *agencyCompanyLabel;
@property (nonatomic, strong)UILabel *agencyTypeLabel;
@property (nonatomic, strong)UILabel *agencyProductLabel;
@property (nonatomic, strong)UILabel *agencyAddressLabel;
@property (nonatomic, strong)UILabel *agencyNameLabel;
@property (nonatomic, strong)UILabel *agencyPhoneLabel;
@property (nonatomic, strong)UIButton *agencyPhoneButton;
@end
@implementation CFSalesPersonAgencyInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createAgencyInfoCell];
    }
    return self;
}
- (void)createAgencyInfoCell{
    _agencyCompanyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 * screenWidth, 20 * screenHeight, self.frame.size.width - 60 * screenWidth, 50 * screenHeight)];
    _agencyCompanyLabel.text = @"常州市常发集团公司";
    _agencyCompanyLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [self.contentView addSubview:_agencyCompanyLabel];
    
    _agencyAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(_agencyCompanyLabel.frame.origin.x, _agencyCompanyLabel.frame.size.height + _agencyCompanyLabel.frame.origin.y + 20 * screenHeight, _agencyCompanyLabel.frame.size.width, _agencyCompanyLabel.frame.size.height)];
    _agencyAddressLabel.text = @"地址：";
    _agencyAddressLabel.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [self.contentView addSubview:_agencyAddressLabel];
    
    _agencyTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_agencyCompanyLabel.frame.origin.x, _agencyAddressLabel.frame.size.height + _agencyAddressLabel.frame.origin.y + 20 * screenHeight, _agencyCompanyLabel.frame.size.width, _agencyCompanyLabel.frame.size.height)];
    _agencyTypeLabel.text = @"经销类型：";
    _agencyTypeLabel.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [self.contentView addSubview:_agencyTypeLabel];
    
    _agencyProductLabel = [[UILabel alloc]initWithFrame:CGRectMake(_agencyCompanyLabel.frame.origin.x, _agencyTypeLabel.frame.size.height + _agencyTypeLabel.frame.origin.y + 20 * screenHeight, _agencyCompanyLabel.frame.size.width, _agencyCompanyLabel.frame.size.height * 2)];
    _agencyProductLabel.text = @"经销产品：";
    _agencyProductLabel.numberOfLines = 2;
    _agencyProductLabel.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [self.contentView addSubview:_agencyProductLabel];
    
    _agencyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_agencyCompanyLabel.frame.origin.x, _agencyProductLabel.frame.size.height + _agencyProductLabel.frame.origin.y + 40 * screenHeight, _agencyCompanyLabel.frame.size.width - 50 * screenWidth, _agencyCompanyLabel.frame.size.height)];
    _agencyNameLabel.text = @"负责人：";
    _agencyNameLabel.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [self.contentView addSubview:_agencyNameLabel];
    
    _agencyPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(_agencyCompanyLabel.frame.origin.x, _agencyNameLabel.frame.size.height + _agencyNameLabel.frame.origin.y + 20 * screenHeight, _agencyNameLabel.frame.size.width, _agencyCompanyLabel.frame.size.height)];
    _agencyPhoneLabel.text = @"联系电话：";
    _agencyPhoneLabel.font = [UIFont systemFontOfSize:[self autoScaleW:15]];
    [self.contentView addSubview:_agencyPhoneLabel];
    
    _agencyPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _agencyPhoneButton.frame = CGRectMake(_agencyNameLabel.frame.size.width + _agencyNameLabel.frame.origin.x, self.frame.size.height - 95 * screenHeight, 50 * screenWidth, 50 * screenHeight);
    [_agencyPhoneButton setBackgroundImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];
    [_agencyPhoneButton addTarget:self action:@selector(callAgencyPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_agencyPhoneButton];
}
- (void)setFrame:(CGRect)frame{
     _agencyPhoneButton.frame = CGRectMake(_agencyNameLabel.frame.size.width + _agencyNameLabel.frame.origin.x, self.frame.size.height - 95 * screenHeight, 50 * screenWidth, 50 * screenHeight);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)callAgencyPhone{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@", _model.tel];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
