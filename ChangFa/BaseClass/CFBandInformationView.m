//
//  CFBandInformationView.m
//  ChangFa
//
//  Created by dev on 2018/1/4.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "CFBandInformationView.h"

@implementation CFBandInformationView
- (instancetype)initWithFrame:(CGRect)frame
                     LabelStr:(NSString *)labelStr
               PlaceHolderStr:(NSString *)placeHolderStr{
    if (self = [super initWithFrame:frame]) {
        [self createCFBandInformationViewLabelStr:labelStr PlaceHolderStr:placeHolderStr];
    }
    return self;
}
- (void)createCFBandInformationViewLabelStr:(NSString *)labelStr
                           PlaceHolderStr:(NSString *)placeGHolderStr{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *bandLabel = [[UILabel alloc]initWithFrame:CGRectMake(60 * screenWidth, 37 * screenHeight, 200 * screenWidth, 46 * screenHeight)];
    bandLabel.text = labelStr;
    bandLabel.font = CFFONT16;
    [self addSubview:bandLabel];
    
    self.bandTextField = [[UITextField alloc]initWithFrame:CGRectMake(bandLabel.frame.size.width + bandLabel.frame.origin.x, bandLabel.frame.origin.y, 430 * screenWidth, bandLabel.frame.size.height)];
    self.bandTextField.placeholder = placeGHolderStr;
    self.bandTextField.font = CFFONT16;
    [self addSubview:self.bandTextField];
}
- (void)setBandinfo:(NSString *)bandinfo{
    _bandTextField.text = bandinfo;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
