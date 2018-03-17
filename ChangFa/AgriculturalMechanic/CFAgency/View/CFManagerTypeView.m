//
//  CFManagerTypeVIew.m
//  ChangFa
//
//  Created by Developer on 2018/2/5.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFManagerTypeView.h"

@interface CFManagerTypeView()

@end

@implementation CFManagerTypeView
- (instancetype)initWithFrame:(CGRect)frame
                    ViewImage:(NSString *)viewImg
                        Title:(NSString *)title
                         Text:(NSString *)text{
    if (self = [super initWithFrame:frame]) {
//      self.layer.masksToBounds=YES;
        self.layer.cornerRadius = 20 * screenWidth;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(4 * screenWidth, 10 * screenWidth);
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius = 10 * screenWidth;
        [self createManagerTypeViewWithViewImage:viewImg Title:title Text:text];
    }
    return self;
}
- (void)createManagerTypeViewWithViewImage:(NSString *)viewImg
                                     Title:(NSString *)title
                                      Text:(NSString *)text{
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *viewImage = [[UIImageView alloc]initWithFrame:CGRectMake(60 * screenWidth, 60 * screenHeight, 100 * screenWidth, 100 * screenHeight)];
    viewImage.image = [UIImage imageNamed:viewImg];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewImage.frame.size.width + 60 * screenWidth, 50 * screenHeight, self.frame.size.width - viewImage.frame.size.width - 180 * screenWidth,  60 * screenHeight)];
    titleLabel.textColor = ChangfaColor;
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.text = title;
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.size.height + titleLabel.frame.origin.y, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    textLabel.text = text;
    textLabel.textColor = [UIColor grayColor];
    textLabel.textAlignment = NSTextAlignmentRight;
    textLabel.font = CFFONT14;
    UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width + 20 * screenWidth, 85 * screenHeight, 30 * screenWidth, 50 * screenHeight)];
    buttonImage.image = [UIImage imageNamed:@"xiugai"];
    self.viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.viewButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:viewImage];
    [self addSubview:titleLabel];
    [self addSubview:textLabel];
    [self addSubview:buttonImage];
    [self addSubview:self.viewButton];
}
@end
