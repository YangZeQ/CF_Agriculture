//
//  PickView.h
//  test
//
//  Created by dev on 2018/1/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MyBasicBlock)(id result);

@protocol textDelegate
- (void)transformText:(NSString *)text;
@end
@interface PickView : UIView

@property (retain, nonatomic) NSArray *arrPickerData;
@property (retain, nonatomic) UIPickerView *pickerView;
@property (nonatomic, weak)id  delegate;
@property (nonatomic, copy) MyBasicBlock selectBlock;

- (void)popPickerView;
- (void)dismissPickerView;
@end
