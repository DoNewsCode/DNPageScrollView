//
//  DNYYTextTool.h
//  Gravity
//
//  Created by donews on 2018/12/13.
//  Copyright © 2018年 DoNews. All rights reserved.
//  操作YYText、YYLabel的工具类

#import <Foundation/Foundation.h>
#import <YYText/YYLabel.h>

@interface DNYYTextTool : NSObject

/// 生成一个NSMutableAttributedString (操作YYLabel)
+ (NSMutableAttributedString *)attrWithString:(NSString *)string label:(YYLabel *)label;
/// 设置富文本的文字大小、颜色等 (操作YYLabel)
+ (void)attr:(NSMutableAttributedString *)attr range:(NSRange)range font:(UIFont *)font color:(UIColor *)color;
/// 获取文字宽度
+ (CGFloat)attrWidth:(NSMutableAttributedString *)attr height:(CGFloat)height;

@end
