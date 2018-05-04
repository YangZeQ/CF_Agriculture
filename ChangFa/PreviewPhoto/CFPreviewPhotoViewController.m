//
//  CFPreviewPhotoViewController.m
//  ChangFa
//
//  Created by Developer on 2018/4/12.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFPreviewPhotoViewController.h"

@interface CFPreviewPhotoViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong)UIScrollView *photoScrollView;

@property (nonatomic, strong)UIView *headerView;
//@property (nonatomic, strong)UIScrollView *photoScrollView;
//@property (nonatomic, strong)UIScrollView *photoScrollView;
@property (nonatomic, assign)BOOL tapStatus;
@end

@implementation CFPreviewPhotoViewController

-(NSMutableArray *)photoArray
{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPreviewPhotoView];
    // Do any additional setup after loading the view.
}
- (void)createPreviewPhotoView
{
    self.view.backgroundColor = [UIColor blackColor];
    _tapStatus = YES;
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, _headerHeight)];
    _headerView.backgroundColor = ChangfaColor;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(20 * screenWidth, (_headerHeight - 44 * screenHeight) / 2 + 10 * screenHeight, 44 * screenWidth, 44 * screenHeight);
    [leftButton setImage:[UIImage imageNamed:@"fanhuiwhite"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:leftButton];
    
    _photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CF_WIDTH, CF_HEIGHT)];
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.contentSize = CGSizeMake(CF_WIDTH * self.photoArray.count, CF_HEIGHT);
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_photoScrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollView)];
    [_photoScrollView addGestureRecognizer:tapGesture];
    for (int i = 0; i < _photoArray.count; i++) {
        NSLog(@"%@   %@", [_photoArray[i] class], [UIImage class]);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CF_WIDTH * i, 0, CF_WIDTH, CF_HEIGHT)];
        if ([[NSString stringWithFormat:@"%@", [_photoArray[i] class]] isEqualToString:[NSString stringWithFormat:@"%@", [UIImage class]]]) {
            NSLog(@"image");
            imageView.image = _photoArray[i];
        } else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.photoArray[i]]] placeholderImage:[UIImage imageNamed:@"CF_RepairImage"]];
        }
        imageView.tag = 1000 + i;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_photoScrollView addSubview:imageView];
    }

    [self.view addSubview:_headerView];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:1.0 animations:^{
//            _headerView.frame = CGRectMake(0, -_headerHeight, CF_WIDTH, _headerHeight);
//            _tapStatus = NO;
//        }];
//    });
    _photoScrollView.contentOffset = CGPointMake(CF_WIDTH * _selectedIndex, 0);
}
- (void)tapScrollView
{
    if (_tapStatus) {
        _headerView.frame = CGRectMake(0, -_headerHeight, CF_WIDTH, _headerHeight);
    } else {
        _headerView.frame = CGRectMake(0, 0, CF_WIDTH, _headerHeight);
    }
    _tapStatus = !_tapStatus;
}
- (void)leftButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
