//
//  UIImage+CTAdd.h
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CTAdd)

/** 从bundle中获取图片 */
+ (instancetype)ct_imageName:(NSString *)imageName inBundle:(NSString *)bundle;
/** 当图片被压缩拉伸时裁切图片 */
+ (instancetype)ct_imageClip:(UIImage *)image;
/** 单一的颜色生成图片 */
+ (instancetype)ct_imageWithColor:(UIColor*)color;
/** 返回特定尺寸的UImag/image参数为原图片，size为要设定的图片大小 */
+ (UIImage*)ct_resizeImageToSize:(CGSize)size
                     sizeOfImage:(UIImage*)image;

@end

NS_ASSUME_NONNULL_END
