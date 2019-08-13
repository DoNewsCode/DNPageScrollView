//
//  UIProgressView+Radius.m
//  TGBus
//
//  Created by donews on 2018/8/28.
//  Copyright © 2018年 Jamie. All rights reserved.
//

#import "UIProgressView+CTRadius.h"

@implementation UIProgressView (CTRadius)

- (void)ct_setRadiusTrackColor:(UIColor *)trackColor
{
    UIImage *trackImage = [self imageWithColor:trackColor cornerRadius:self.frame.size.height/2.0];
    [self setTrackImage:trackImage];
}

- (void)ct_setRadiusProgressColor:(UIColor *)progressColor
{
    UIImage *progressImage = [self imageWithColor:progressColor cornerRadius:self.frame.size.height/2.0];
    [self setProgressImage:progressImage];
    
}

- (void)ct_setRadiusTrackColor:(UIColor *)trackColor
              progressColor:(UIColor *)progressColor
{
    
    [self ct_setRadiusTrackColor:trackColor];
    [self ct_setRadiusProgressColor:progressColor];
}


//最小尺寸---1px
static CGFloat edgeSizeWithRadius(CGFloat cornerRadius) {
    return cornerRadius * 2 + 1;
}

- (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius {
    CGFloat minEdgeSize = edgeSizeWithRadius(cornerRadius);
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}


@end
