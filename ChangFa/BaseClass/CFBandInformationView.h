//
//  CFBandInformationView.h
//  ChangFa
//
//  Created by dev on 2018/1/4.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFBandInformationView : UIView
@property (nonatomic, copy)NSString *bandinfo;
@property (nonatomic, strong)UITextField *bandTextField;
//@property (nonatomic, strong)UITextField *nameTextField;
//@property (nonatomic, strong)UITextField *phoneTextField;
//@property (nonatomic, strong)UITextField *remarkTextField;
- (instancetype)initWithFrame:(CGRect)frame
                     LabelStr:(NSString *)labelStr
               PlaceHolderStr:(NSString *)placeHolderStr;
@end
