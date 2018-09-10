//
//  UIView+JAExt.m
//  JAmieLottery
//
//  Created by Jamie on 15/12/18.
//  Copyright © 2015年 Jamie. All rights reserved.
//

#import "UIView+JAExtForPageScroll.h"

@implementation UIView (JAExtForPageScroll)
/** 控件的 X*/
-(CGFloat)x{
    CGRect rect = self.frame;
    return rect.origin.x;
}
-(void)setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
/** 控件的 Y*/
-(CGFloat)y{
    CGRect rect = self.frame;
    return rect.origin.y;
}
-(void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
/** 控件的 宽*/
-(CGFloat)width{
    CGRect rect = self.frame;
    return rect.size.width;
}
-(void)setWidth:(CGFloat)width{
    
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
/** 控件的 高*/
-(CGFloat)height{
    CGRect rect = self.frame;
    return rect.size.height;
}
-(void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
/** 控件的 尺寸*/
-(CGSize)size{
    return self.frame.size;
}
-(void)setSize:(CGSize)size{
    self.width = size.width;
    self.height = size.height;
}
-(void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
/** 控件的 中心点坐标 X*/
-(CGFloat)centerX{
    return self.center.x;
}
-(void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
/** 控件的 中心点坐标 Y*/

-(CGFloat)centerY{
    return self.center.y;
}
- (CGFloat)left {
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

@end
