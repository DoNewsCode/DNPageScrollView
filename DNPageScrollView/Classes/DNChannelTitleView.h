//
//  DNChannelTitleView.h
//  Donews
//
//  Created by Jamie on 2017/4/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNChannelTitleView : UIView
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) UIColor *textColor;
@property (copy, nonatomic) UIFont *font;

@property (assign, nonatomic) CGFloat currentTransformSx;
@property (assign, nonatomic, getter=isSelected) BOOL selected;

@property (strong, nonatomic, readonly) UILabel *label;

- (CGFloat)channleTitleViewWidth;
@end
