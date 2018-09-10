//
//  UIViewController+DNPageController.m
//  Donews
//
//  Created by Jamie on 2017/4/24.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "UIViewController+DNPageController.h"
#import "DNPageScrollViewDelegate.h"
#import <objc/runtime.h>
char MMIndexKey;
@implementation UIViewController (DNPageController)
-(UIViewController *)mm_scrollViewController
{
    UIViewController *controller = self;
    while (controller) {
        if ([controller conformsToProtocol:@protocol(DNPageScrollViewDelegate)]) {
            break;
        }
        controller = controller.parentViewController;
    }
    return controller;
}

-(void)setMm_currentIndex:(NSInteger)mm_currentIndex
{
    objc_setAssociatedObject(self, &MMIndexKey, [NSNumber numberWithInteger:mm_currentIndex], OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)mm_currentIndex
{
    return [objc_getAssociatedObject(self, &MMIndexKey) integerValue];
}
@end
