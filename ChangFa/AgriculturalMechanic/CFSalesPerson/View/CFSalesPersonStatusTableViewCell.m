//
//  CFSalesPersonStatusTableViewCell.m
//  ChangFa
//
//  Created by Developer on 2018/1/26.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFSalesPersonStatusTableViewCell.h"
#import "CFAgencySendingViewController.h"
#import "CFAgencyPutInStorageViewController.h"
#import "CFAgencySoldViewController.h"
#import "CFAgencyPutInStorageTableViewCell.h"
@interface CFSalesPersonStatusTableViewCell ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *statusTableView;
@end
@implementation CFSalesPersonStatusTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createStatusCell];
    }
    return self;
}
- (void)createStatusCell{
    self.statusTableView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
    self.statusTableView.delegate = self;
    self.statusTableView.dataSource = self;
    self.statusTableView.bounces = NO;
    [self.contentView addSubview:self.statusTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    CFAgencyPutInStorageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CFAgencyPutInStorageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240 * screenHeight;
}
- (void)setFrame:(CGRect)frame{
    self.statusTableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
//- (void)createStatusCell{
//    CFAgencySendingViewController *sending = [[CFAgencySendingViewController alloc]init];
////    sending.height = navHeight + 88 * screenHeight + 100 * screenHeight;
//    CFAgencyPutInStorageViewController *putin = [[CFAgencyPutInStorageViewController alloc]init];
//    CFAgencySoldViewController *sold = [[CFAgencySoldViewController alloc]init];
//    [self addChildViewController:sending];
//    [self addChildViewController:putin];
//    [self addChildViewController:sold];
//
////    _buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, _agencyCompanyView.frame.size.height + _agencyCompanyView.frame.origin.y + 30 * screenHeight, self.view.frame.size.width, 88 * screenHeight)];
////    _buttonView.backgroundColor = [UIColor cyanColor];
////    [self.agencyScrollView addSubview:_buttonView];
//
////    NSArray *statusButtonTitle = @[@"发往中", @"库存", @"售出"];
////    for (int i = 0; i < 3; i++) {
////        UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
////        statusButton.frame = CGRectMake(250 * screenWidth * i, self.agencyCompanyView.frame.size.height + self.agencyCompanyView.frame.origin.y + 30 * screenHeight, 250 * screenWidth, 88 * screenHeight);
////        statusButton.tag = 1000 + i;
////        [statusButton setTitle:statusButtonTitle[i] forState:UIControlStateNormal];
////        [statusButton addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
////        [statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////        [self.agencyScrollView addSubview:statusButton];
////    }
//    self.statusScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
//    self.statusScrollView.showsVerticalScrollIndicator = YES;
//    self.statusScrollView.showsHorizontalScrollIndicator = YES;
//    self.statusScrollView.pagingEnabled = YES;
//    self.statusScrollView.bounces = NO;
//    self.statusScrollView.contentSize = CGSizeMake(self.contentView.frame.size.width * 3, self.contentView.frame.size.height);
//    [self.contentView addSubview:self.statusScrollView];
//
//    for (int i = 0; i < 3; i++) {
//        UIView *childView = [[UIView alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.statusScrollView.frame.size.height)];
//        [childView addSubview:self.childViewControllers[i].view];
//        [self.statusScrollView addSubview:childView];
//    }
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
