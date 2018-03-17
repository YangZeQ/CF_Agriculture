//
//  MapPinView.m
//  ChangFa
//
//  Created by Developer on 2018/1/11.
//  Copyright © 2018年 dev. All rights reserved.
//

#import "MapPinView.h"

@implementation MapPinView

- (instancetype)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        CGRect  myFrame = self.frame;
        myFrame.size.width = 100;
        myFrame.size.height = 100;
        self.frame = myFrame;
//        self.positionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _positionButton.frame = CGRectMake(0, 0, 100, 100);
//        [self addSubview:_positionButton];
//        [_positionButton setImage:[UIImage imageNamed:@"nongjiweizhi"] forState:UIControlStateNormal];
//        self.backgroundColor = [UIColor cyanColor];
        // The opaque property is YES by default. Setting it to
//        // NO allows map content to show through any unrendered parts of your view.
//        self.opaque = NO;
//        self.canShowCallout = NO;
//        self.image = [UIImage imageNamed:@"nongjiweizhi"];
    }
    return self;
}
- (void)setImage:(UIImage *)image{
    
}
- (void)createPinView{
    self.backgroundColor = [UIColor redColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
