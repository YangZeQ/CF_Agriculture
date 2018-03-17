//
//  CFMisteViewButton.m
//  ChangFa
//
//  Created by dev on 2018/1/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFMisteViewButton.h"

@implementation CFMisteViewButton


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createButtonView];
    }
    return self;
}
- (void)createButtonView{

    _buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(30 * screenWidth, 30 * screenHeight, 60 * screenWidth, 60 * screenHeight)];
    _buttonImage.image = [UIImage imageNamed:_imageName];
    [self addSubview:_buttonImage];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_buttonImage.frame.size.width + _buttonImage.frame.origin.x + 30 * screenWidth, _buttonImage.frame.origin.y, self.frame.size.width - 120 * screenWidth, _buttonImage.frame.size.height)];
    _titleLabel.text = _titleName;
    [self addSubview:_titleLabel];
}
- (void)setImageName:(NSString *)imageName{
//    _imageName = imageName;
    _buttonImage.image = [UIImage imageNamed:imageName];
    
}
- (void)setTitleName:(NSString *)titleName{
//    _titleName = titleName;
    _titleLabel.text = titleName;
}
@end
