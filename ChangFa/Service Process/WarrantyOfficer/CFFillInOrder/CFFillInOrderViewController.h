//
//  CFFillInOrderViewController.h
//  ChangFa
//
//  Created by Developer on 2018/3/21.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^uploadImageBlock)(BOOL changeStatus);
@interface CFFillInOrderViewController : UIViewController
@property (nonatomic, strong)NSString *repairId;
@property (nonatomic, strong)NSString *disId;
@property (nonatomic, strong)NSString *disNum;
@property (nonatomic, copy)uploadImageBlock uploadImageBlock;
@end
