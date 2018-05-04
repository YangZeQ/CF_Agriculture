//
//  CFPersonalCenterTableViewCell.h
//  ChangFa
//
//  Created by Developer on 2018/4/28.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^imageFrameBlock)(CGRect imageFrame);
@interface CFPersonalCenterTableViewCell : UITableViewCell
@property (nonatomic, strong)UIImageView *cellImage;
@property (nonatomic, strong)UILabel *cellLabel;
@property (nonatomic, strong)UILabel *lineLabel;

@property (nonatomic, copy)imageFrameBlock imageFrameBlock;
@end
