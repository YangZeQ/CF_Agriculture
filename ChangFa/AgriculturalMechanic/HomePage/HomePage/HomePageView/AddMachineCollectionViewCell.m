//
//  AddMachineCollectionViewCell.m
//  ChangFa
//
//  Created by dev on 2018/1/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "AddMachineCollectionViewCell.h"

@implementation AddMachineCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createCellView];
    }
    return self;
}
- (void)createCellView
{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    backImage.image = [UIImage imageNamed:@"juxing"];
    [self.contentView addSubview:backImage];
    
    self.addImageView = [[UIImageView alloc]initWithFrame:CGRectMake(67 * screenWidth, 107 * screenHeight, self.contentView.frame.size.width - 67 * 2 * screenWidth, self.contentView.frame.size.height - 107 * 2 * screenHeight)];
    self.addImageView.image = [UIImage imageNamed:@"addMachine"];
    [backImage addSubview:self.addImageView];
}
- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *addImageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    addImageView.image = [UIImage imageNamed:imageName];
    [self.contentView addSubview:addImageView];
}
@end
