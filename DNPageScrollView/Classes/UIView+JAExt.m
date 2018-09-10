//
//  UIView+JAExt.m
//  JAmieLottery
//
//  Created by Jamie on 15/12/18.
//  Copyright © 2015年 Jamie. All rights reserved.
//

#import "UIView+JAExt.h"

@implementation UIView (JAExt)
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
    
    if (width>=0.00) {
       
        CGRect rect = self.frame;
        rect.size.width = width;
        self.frame = rect;

    }
    
}
/** 控件的 高*/
-(CGFloat)height{
    
    CGRect rect = self.frame;
    return rect.size.height;
}
-(void)setHeight:(CGFloat)height{
    
    if (height>=0.00) {
       
        CGRect rect = self.frame;
        rect.size.height = height;
        self.frame = rect;
    }
   
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

- (void)mm_addRounderCornerWithRadius:(CGFloat)radius size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(cxt, [UIColor redColor].CGColor);
    CGContextSetStrokeColorWithColor(cxt, [UIColor redColor].CGColor);
    
    CGContextMoveToPoint(cxt, size.width, size.height-radius);
    CGContextAddArcToPoint(cxt, size.width, size.height, size.width-radius, size.height, radius);//右下角
    CGContextAddArcToPoint(cxt, 0, size.height, 0, size.height-radius, radius);//左下角
    CGContextAddArcToPoint(cxt, 0, 0, radius, 0, radius);//左上角
    CGContextAddArcToPoint(cxt, size.width, 0, size.width, radius, radius);//右上角
    CGContextClosePath(cxt);
    CGContextDrawPath(cxt, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [imageView setImage:image];
    [self insertSubview:imageView atIndex:0];
}
@end
