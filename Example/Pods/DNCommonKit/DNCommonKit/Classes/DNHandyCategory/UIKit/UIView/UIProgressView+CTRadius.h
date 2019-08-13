//
//  UIProgressView+Radius.h
//  TGBus
//
//  Created by donews on 2018/8/28.
//  Copyright © 2018年 Jamie. All rights reserved.
//  UIProgressView 进度条圆角设置

#import <UIKit/UIKit.h>

@interface UIProgressView (CTRadius)

- (void)ct_setRadiusTrackColor:(UIColor *)trackColor ;
- (void)ct_setRadiusProgressColor:(UIColor *)progressColor;
- (void)ct_setRadiusTrackColor:(UIColor *)trackColor progressColor:(UIColor *)progressColor;

@end
