//
//  UIAlertController+EndEditong.m
//  ChangFa
//
//  Created by Developer on 2018/2/24.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "UIAlertController+EndEditing.h"

@implementation UIAlertController (EndEditing)
- (void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
}
@end
