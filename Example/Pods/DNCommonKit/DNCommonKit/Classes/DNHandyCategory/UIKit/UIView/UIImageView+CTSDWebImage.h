//
//  UIImageView+CTSDWebImage.h
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import <UIKit/UIKit.h>

#if __has_include( <SDWebImage/UIImageView+WebCache.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#else
#import "UIImageView+WebCache.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (CTSDWebImage)

- (void)ct_setImageWithURL:(NSURL *)url;
- (void)ct_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;
- (void)ct_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)options;
- (void)ct_setImageWithURL:(NSURL *)url completed:(void (^)(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL))completed;
- (void)ct_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage*)placeholderImage completed:(void (^)(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL))completed;
- (void)ct_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)options completed:(void (^)(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL))completed;

@end

NS_ASSUME_NONNULL_END
