//
//  CFFillInOrderViewTableViewCell.h
//  ChangFa
//
//  Created by Developer on 2018/3/21.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFRepairsPhotoCell.h"
#import "CFReasonTextView.h"
#import "CFRegisterTextFieldView.h"
typedef void(^itemBlock)(void);
typedef void(^textInfoBlock)(NSString *textInfo, NSInteger index);
typedef void(^textEditBlock)(NSInteger status);
typedef void(^deleteImageBlock)(NSInteger sender);
typedef void(^clickImageBlock)(NSInteger sender);
@interface CFFillInOrderViewTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *orderInfoLabel;
@property (nonatomic, strong)UIButton *editButton;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UILabel *textNumberLabel;
@property (nonatomic, strong)UIImageView *starImage;
@property (nonatomic, assign)NSInteger styleStatus;  // 0:收起cell  1:添加图片  2：文字说明
@property (nonatomic, copy)NSString *reasonPlaceholder;
@property (nonatomic, assign)NSInteger cellIndex;
@property (nonatomic, assign)BOOL cellSelected;
@property (nonatomic, assign)NSInteger cellType;
@property (nonatomic, assign)NSInteger infoType;
@property (nonatomic, assign)NSInteger cellStyle;
@property (nonatomic, assign)double originX;

@property (nonatomic, strong)UICollectionView *photoColleectionView;
@property (nonatomic, strong)CFReasonTextView *reasonView;
@property (nonatomic, strong)CFRepairsPhotoCell *photoCell;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *reloadPhotoArray;

@property (nonatomic, strong)CFRegisterTextFieldView *hourTextField;
@property (nonatomic, strong)CFRegisterTextFieldView *mileageTextField;

@property (nonatomic, copy)itemBlock itemBlock;
@property (nonatomic, copy)textInfoBlock textInfoBlock;
@property (nonatomic, copy)textEditBlock textEditBlock;
@property (nonatomic, copy)deleteImageBlock deleteImageBlock;
@property (nonatomic, copy)clickImageBlock clickImageBlock;

@end

