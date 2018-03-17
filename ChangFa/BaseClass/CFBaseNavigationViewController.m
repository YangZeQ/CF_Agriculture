//
//  CFBaseNavigationViewController.m
//  ChangFa
//
//  Created by dev on 2018/1/3.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFBaseNavigationViewController.h"

@interface CFBaseNavigationViewController ()

@end

@implementation CFBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    NSLog(@"%f", self.view.frame.size.width);
    _navigationView.backgroundColor = ChangfaColor;
    [self.view addSubview:_navigationView];
    _navigationLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, _navigationView.frame.size.width, 44)];
//    _navigationLable.text = @"常发农装";
    _navigationLable.userInteractionEnabled = YES;
    _navigationLable.font = [UIFont systemFontOfSize:[self autoScaleW:20]];
    _navigationLable.textAlignment = NSTextAlignmentCenter;
    _navigationLable.textColor = [UIColor whiteColor];
    [_navigationView addSubview:_navigationLable];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
//    [_leftButton setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
//    [_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationLable addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(_navigationView.frame.size.width - 44, _leftButton.frame.origin.y, _leftButton.frame.size.width, _leftButton.frame.size.height);
//    [_rightButton setImage:[UIImage imageNamed:@"xinxi"] forState:UIControlStateNormal];
//    [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_navigationLable addSubview:_rightButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
