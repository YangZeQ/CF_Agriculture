//
//  PickView.m
//  test
//
//  Created by dev on 2018/1/9.
//  Copyright © 2018年 dev. All rights reserved.
//
#define SCREEN_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT               [[UIScreen mainScreen] bounds].size.height
#define PICKERVIEW_HEIGHT           205
#import "PickView.h"

@interface PickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger selectRow;
}
@property (retain, nonatomic) UIView *baseView;
@end
@implementation PickView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-PICKERVIEW_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT)];
        _baseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_baseView];
        
        UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 0, 40, 40)];
        [btnOK setTitle:@"确定" forState:UIControlStateNormal];
        [btnOK setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnOK addTarget:self action:@selector(pickerViewBtnOK:) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:btnOK];
        
        UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(pickerViewBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:btnCancel];
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, PICKERVIEW_HEIGHT-40)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [_baseView addSubview:_pickerView];
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPickerView)];
//        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

#pragma mark - UIPickerViewDataSource

//返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

//每列对应多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _arrPickerData.count;
}

//每行显示的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _arrPickerData[row];
}


#pragma mark - UIPickerViewDelegate

//选中pickerView的某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectRow = row;
    
//    [pickerLabel setTextAlignment:NSTextAlignmentCenter];
//    [pickerLabel setBackgroundColor:[UIColor clearColor]];
//    [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
}

#pragma mark - Private Menthods

//弹出pickerView
- (void)popPickerView
{
//    [UIView animateWithDuration:0.5
//                     animations:^{
                         self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//                     }];
    
}

//取消pickerView
- (void)dismissPickerView
{
//    [UIView animateWithDuration:0.5
//                     animations:^{
                         self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH , SCREEN_HEIGHT);
//                     }];
}

//确定
- (void)pickerViewBtnOK:(id)sender
{
    if (self.selectBlock) {
        self.selectBlock(_arrPickerData[selectRow]);
    }
    [self.delegate transformText:_arrPickerData[selectRow]];
    [self dismissPickerView];
}

//取消
- (void)pickerViewBtnCancel:(id)sender
{
    if (self.selectBlock) {
        self.selectBlock(nil);
    }
    
    [self dismissPickerView];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
