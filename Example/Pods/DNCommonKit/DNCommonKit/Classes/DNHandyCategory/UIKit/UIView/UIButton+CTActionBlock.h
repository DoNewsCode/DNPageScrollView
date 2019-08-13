//
//  UIButton+CTActionBlock.h
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CTActionBlockBlock)(void);

@interface UIButton (CTActionBlock)

- (void)ct_handleControlEvent:(UIControlEvents)controlEvent withBlock:(CTActionBlockBlock)action;

@end

NS_ASSUME_NONNULL_END
