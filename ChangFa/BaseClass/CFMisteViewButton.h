//
//  CFMisteViewButton.h
//  ChangFa
//
//  Created by dev on 2018/1/2.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMisteViewButton : UIView
@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, copy)NSString *titleName;
@property (nonatomic, strong)UIImageView *buttonImage;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *misteViewButton;
@end
