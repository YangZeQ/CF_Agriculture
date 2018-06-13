//
//  SystemNewsTableViewCell.h
//  ChangFa
//
//  Created by dev on 2018/1/3.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
@interface SystemNewsTableViewCell : UITableViewCell
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, assign)BOOL read;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIImageView *readNews;
@property (nonatomic, strong)NewsModel *model;

@end
