//
//  NSString+ZZHeight.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (CTHeight)


/**
 指定宽度 计算文字高度

 @param font 字体
 @param width 宽度
 @return 高度
 */
- (CGFloat)ct_heightWithFont:(UIFont *)font width:(CGFloat)width;


/**
 指定宽度 计算文字高度 & 设置最大值

 @param font 字体
 @param width 宽度
 @param maxHeight 最大高度
 @return 高度
 */
- (CGFloat)ct_heightWithFont:(UIFont *)font width:(CGFloat)width maxHeight:(CGFloat)maxHeight;

    
/**
 根据高度计算文字宽度 20的高
     
 @param font 字体
 @return 宽度
*/
- (CGFloat)ct_widthWithFont:(UIFont *)font;

/**
 指定高度 计算文字宽度

 @param font 字体
 @param height 高度
 @return 宽度
 */
- (CGFloat)ct_widthWith:(UIFont *)font height:(CGFloat)height;
    
- (BOOL)ct_isSingleLineForLabel:(UILabel *)label;

@end
