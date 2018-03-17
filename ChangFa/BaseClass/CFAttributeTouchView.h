//
//  CFAttributeTouchView.h
//  ChangFa
//
//  Created by Developer on 2018/3/9.
//  Copyright © 2018年 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol CFAttributeTouchViewDelegate
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange;
//@end
typedef void(^CFTouchEventBlock)(NSAttributedString *str);
@interface CFAttributeTouchView : UIView
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)CFTouchEventBlock eventBlock;
@end
