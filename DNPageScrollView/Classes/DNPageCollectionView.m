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


@end
