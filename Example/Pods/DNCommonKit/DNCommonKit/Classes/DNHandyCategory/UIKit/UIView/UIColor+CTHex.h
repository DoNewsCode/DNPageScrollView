//
//  UIColor+CTHex.h
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CTHex)

// 透明度固定为1，以0x开头的十六进制转换成的颜色
+ (UIColor *)ct_colorWithHex:(long)hexColor;

// 0x开头的十六进制转换成的颜色,透明度可调整
+ (UIColor *)ct_colorWithHex:(long)hexColor alpha:(float)opacity;

// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
+ (UIColor *)ct_colorWithHexString: (NSString *)color;


@end

NS_ASSUME_NONNULL_END
