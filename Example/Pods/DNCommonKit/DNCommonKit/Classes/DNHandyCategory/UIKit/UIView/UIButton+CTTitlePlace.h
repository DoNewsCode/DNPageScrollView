//
//  UIButton+CTTitlePlace.h
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 图片方向选择
typedef NS_ENUM(NSUInteger, CTButtonEdgeInsetsStyle) {
    CTButtonEdgeInsetsStyleTop, // image在上，label在下
    CTButtonEdgeInsetsStyleLeft, // image在左，label在右
    CTButtonEdgeInsetsStyleBottom, // image在下，label在上
    CTButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (CTTitlePlace)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)ct_layoutButtonWithEdgeInsetsStyle:(CTButtonEdgeInsetsStyle)style
                           imageTitleSpace:(CGFloat)space;


/**
 设置按钮扩大响应区域的范围
 
 @param size size大小
 */
- (void)ct_setEnlargeEdge:(CGFloat)size;


/**
 * @brief 详细设置按钮扩大响应区域的范围
 * @param top         按钮上方扩展的范围
 * @param right       按钮右方扩展的范围
 * @param bottom      按钮下方扩展的范围
 * @param left        按钮左方扩展的范围
 */
- (void)ct_setEnlargeEdgeWithTop:(CGFloat)top
                           right:(CGFloat)right
                          bottom:(CGFloat)bottom
                            left:(CGFloat)left;

@end

NS_ASSUME_NONNULL_END
