//
//  DNChannelTitleView.h
//  Donews
//
//  Created by Jamie on 2017/4/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "DNPageChannelStyle.h"

@interface DNChannelTitleView : UIView
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) UIColor *textColor;
@property (copy, nonatomic) UIFont *font;
@property (copy, nonatomic) UIFont *normalFont;
@property (copy, nonatomic) UIFont *selectedFont;

/** 标题切换后选中与未选中的标题文字为居中对齐 默认为Center */
@property (assign, nonatomic) DNPageChannelStyleChannelTextAlignment channelTextAlignment;

@property (assign, nonatomic) CGRect normalFrame;

//@property (assign, nonatomic) CGSize titleSize;

@property (assign, nonatomic) CGFloat currentTransformSx;
@property (assign, nonatomic, getter=isSelected) BOOL selected;

@property (strong, nonatomic, readonly) UILabel *label;

- (CGFloat)channleTitleViewWidth;

@end
