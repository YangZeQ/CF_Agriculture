//
//  CFManagerTypeVIew.h
//  ChangFa
//
//  Created by Developer on 2018/2/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFManagerTypeView : UIView
@property (nonatomic, strong)UIButton *viewButton;
- (instancetype)initWithFrame:(CGRect)frame
                    ViewImage:(NSString *)viewImg
                        Title:(NSString *)title
                         Text:(NSString *)text;
@end
