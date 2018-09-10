//
//  UIViewController+DNPageController.h
//  Donews
//
//  Created by Jamie on 2017/4/24.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DNPageController)
/**
 *  所有子控制的父控制器, 方便在每个子控制页面直接获取到父控制器进行其他操作
 */
@property (nonatomic, weak, readonly) UIViewController *mm_scrollViewController;

@property (nonatomic, assign) NSInteger mm_currentIndex;

@end
