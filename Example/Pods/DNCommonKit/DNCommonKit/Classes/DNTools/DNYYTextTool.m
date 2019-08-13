//
//  DNYYTextTool.m
//  Gravity
//
//  Created by donews on 2018/12/13.
//  Copyright © 2018年 DoNews. All rights reserved.
//

#import "DNYYTextTool.h"
#import <YYText/YYText.h>

@implementation DNYYTextTool

+ (NSMutableAttributedString *)attrWithString:(NSString *)string label:(YYLabel *)label {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    attr.yy_alignment = NSTextAlignmentLeft;
    attr.yy_font = label.font;
    attr.yy_color = label.textColor;
    return attr;
}

+ (void)attr:(NSMutableAttributedString *)attr range:(NSRange)range font:(UIFont *)font color:(UIColor *)color {
    [attr yy_setFont:font range:range];
    [attr yy_setColor:color range:range];
}

+ (CGFloat)attrWidth:(NSMutableAttributedString *)attr height:(CGFloat)height {
    CGSize size = CGSizeMake(CGFLOAT_MAX, height);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attr];
    return layout.textBoundingSize.width;
}

@end
