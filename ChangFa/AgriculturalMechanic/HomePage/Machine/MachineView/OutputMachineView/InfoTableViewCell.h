//
//  InfoTableViewCell.h
//  ChangFa
//
//  Created by Developer on 2018/1/17.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"
@interface InfoTableViewCell : UITableViewCell
@property (nonatomic, strong)PersonModel *model;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *titleLabel;
@end
