//
//  CFRepairsPhotoCell.m
//  ChangFa
//
//  Created by Developer on 2018/3/1.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFRepairsPhotoCell.h"

@implementation CFRepairsPhotoCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createRepairsPhotoCell];
    }
    return self;
}

- (void)createRepairsPhotoCell{
    _repairsPhoto = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    _repairsPhoto.contentMode = UIViewContentModeScaleToFill;
    _repairsPhoto.userInteractionEnabled = YES;
//    _repairsPhoto.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _repairsPhoto.clipsToBounds = YES;
    [self.contentView addSubview:_repairsPhoto];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButton.frame = CGRectMake(_repairsPhoto.frame.size.width - 44 * screenWidth, 0, 44 * screenWidth, 44 * screenHeight);
    [_deleteButton setImage:[UIImage imageNamed:@"CF_Repairs_DeleteImage"] forState:UIControlStateNormal];
    _deleteButton.layer.cornerRadius = 22 * screenWidth;
    _deleteButton.clipsToBounds = YES;
    _deleteButton.hidden = YES;
    [_repairsPhoto addSubview:_deleteButton];
}

@end
