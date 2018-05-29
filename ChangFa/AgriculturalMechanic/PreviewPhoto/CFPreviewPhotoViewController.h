//
//  CFPreviewPhotoViewController.h
//  ChangFa
//
//  Created by Developer on 2018/4/12.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFPreviewPhotoViewController : UIViewController
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, assign)NSInteger headerHeight;
@end
