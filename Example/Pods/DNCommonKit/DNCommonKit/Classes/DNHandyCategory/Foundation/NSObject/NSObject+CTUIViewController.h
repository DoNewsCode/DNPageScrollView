//
//  NSObject+UIViewController.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (CTUIViewController)

/** 获取Window当前显示的VC */
- (UIViewController * _Nullable)ct_currentTopViewController;
/** 获取Window当前显示的VC的根视图 */
- (UIView * _Nullable)ct_currentRootView;
/** Push */
- (void)ct_pushViewController:(UIViewController * _Nonnull)viewController animated:(BOOL)animated;
/** Present */
- (void)ct_presentViewController:(UIViewController * _Nonnull)viewControllerToPresent animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

@end
