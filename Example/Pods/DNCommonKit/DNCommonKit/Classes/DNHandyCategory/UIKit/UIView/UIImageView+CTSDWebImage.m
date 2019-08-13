//
//  UIImageView+CTSDWebImage.m
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import "UIImageView+CTSDWebImage.h"
#import "UIImage+CTAdd.h"

@implementation UIImageView (CTSDWebImage)

- (void)ct_setImageWithURL:(NSURL *)url {
    [self ct_setImageWithURL:url completed:nil];
}

- (void)ct_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    [self ct_setImageWithURL:url placeholderImage:placeholderImage completed:nil];
}

- (void)ct_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)options {
    [self ct_setImageWithURL:url placeholderImage:placeholderImage options:options completed:nil];
}

- (void)ct_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)options width:(CGFloat)width {
    
    [self ct_setImageWithURL:url placeholderImage:placeholderImage options:options completed:^(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL) {
        
        if (options == SDWebImageAvoidAutoSetImage) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                UIImage *tempImage = [UIImage ct_imageClip:image];//[UIImage zz_imageClip:image]; // 后台线程剪裁图片
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = tempImage;
                    [self setNeedsLayout];
                });
            });
        }
    }];
}

- (void)ct_setImageWithURL:(NSURL *)url completed:(void (^)(UIImage * _Nullable, NSError * _Nullable, NSURL * _Nullable))completed {
    
    [self sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (completed) {
            completed(image, error, imageURL);
        }
    }];
    
}

- (void)ct_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage completed:(void (^)(UIImage * _Nullable, NSError * _Nullable, NSURL * _Nullable))completed {
    
    [self ct_setImageWithURL:url placeholderImage:placeholderImage options:(SDWebImageRetryFailed) completed:completed];
}

- (void)ct_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage options:(SDWebImageOptions)options completed:(void (^)(UIImage * _Nullable, NSError * _Nullable, NSURL * _Nullable))completed {
    
    [self sd_setImageWithURL:url placeholderImage:placeholderImage options:options completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (options == SDWebImageAvoidAutoSetImage) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                UIImage *tempImage = [UIImage ct_imageClip:image]; // 后台线程剪裁图片
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = tempImage;
                    [self setNeedsLayout];
                });
            });
        }
        
        if (completed) {
            completed(image, error, imageURL);
        }
    }];
}

@end
