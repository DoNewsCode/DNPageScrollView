//
//  DNPageCollectionView.h
//  Donews
//
//  Created by Jamie on 2017/4/21.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNPageCollectionView : UICollectionView
typedef BOOL(^DNPageCollectionViewShouldBeginPanGestureHandler)(DNPageCollectionView *collectionView, UIPanGestureRecognizer *panGesture);

- (void)returnScrollViewShouldBeginPanGestureHandler:(DNPageCollectionViewShouldBeginPanGestureHandler)gestureBeginHandler;

@end
