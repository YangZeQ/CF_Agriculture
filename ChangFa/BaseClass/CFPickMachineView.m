//
//  CFPickMachineView.m
//  ChangFa
//
//  Created by Developer on 2018/3/7.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFPickMachineView.h"

@interface CFPickMachineView()
@property (nonatomic, strong)UILabel *machineNameLabel;
@property (nonatomic, strong)UILabel *noteLabel;
@end
@implementation CFPickMachineView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createPickMachineView];
    }
    return self;
}
- (void)createPickMachineView
{
    UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _machineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, labelView.frame.size.width, labelView.frame.size.height / 2)];
    _machineNameLabel.textAlignment = NSTextAlignmentCenter;
    [labelView addSubview:_machineNameLabel];
    
    _noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _machineNameLabel.frame.size.height, _machineNameLabel.frame.size.width, labelView.frame.size.height / 2)];
    _noteLabel.textAlignment = NSTextAlignmentCenter;
    _noteLabel.font = CFFONT15;
    _noteLabel.textColor = [UIColor grayColor];
    [labelView addSubview:_noteLabel];
    [self addSubview:labelView];
}
- (void)setName:(NSString *)name
{
    _machineNameLabel.text = name;
}
- (void)setType:(NSString *)type
{
    _noteLabel.text = [@"备注：" stringByAppendingString:type];
}
@end
