//
//  DNContentScrollView.h
//  Donews
//
//  Created by Jamie on 2017/4/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNPageScrollView.h"
#import "DNPageCollectionView.h"
@class DNChannelScrollView;
@interface DNContentScrollView : UIView
@property (nonatomic, weak) id<DNPageScrollViewDelegate> delegate;
// 用于处理重用和内容的显示
@property (nonatomic, strong) DNPageCollectionView *collectionView;
@property (nonatomic, assign) CGFloat currentHeight;
///初始化方法

- (instancetype)initWithFrame:(CGRect)frame channelScrollView:(DNChannelScrollView *)channelScrollView parentViewController:(UIViewController *)parentViewController delegate:(id<DNPageScrollViewDelegate>) delegate;
///给外界可以设置ContentOffSet的方法
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated;
///给外界 重新加载内容的方法
- (void)reload;

- (void)reloadTheme;
@end
