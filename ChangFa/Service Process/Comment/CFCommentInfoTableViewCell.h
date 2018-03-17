//
//  CFCommentInfoTableViewCell.h
//  ChangFa
//
//  Created by Developer on 2018/3/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFCommentModel.h"
@interface CFCommentInfoTableViewCell : UITableViewCell
@property (nonatomic, strong)CFCommentModel *commentModel;
@property (nonatomic, strong)UICollectionView *repairsPhotoCollection;
@property (nonatomic, strong)UILabel *lineLabel;
@end
