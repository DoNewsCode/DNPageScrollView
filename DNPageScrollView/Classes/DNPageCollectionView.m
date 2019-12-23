//
//  DNPageCollectionView.m
//  Donews
//
//  Created by Jamie on 2017/4/21.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "DNPageCollectionView.h"

@interface DNPageCollectionView ()
@property (copy, nonatomic) DNPageCollectionViewShouldBeginPanGestureHandler gestureBeginHandler;
@end
@implementation DNPageCollectionView

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (_gestureBeginHandler && gestureRecognizer == self.panGestureRecognizer) {
        return _gestureBeginHandler(self, (UIPanGestureRecognizer *)gestureRecognizer);
    }
    else {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
}
-(void)returnScrollViewShouldBeginPanGestureHandler:(DNPageCollectionViewShouldBeginPanGestureHandler)gestureBeginHandler
{
    _gestureBeginHandler = [gestureBeginHandler copy];
}

/// 12.23 新增，解决与右滑返回手势的冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}

@end
