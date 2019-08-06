//
//  DNPageScrollView.h
//  Donews
//
//  Created by Jamie on 2017/4/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DNPageScrollViewDelegate.h"

#import "DNChannelView.h"
#import "DNChannelScrollView.h"
#import "DNContentScrollView.h"

@class DNContentScrollView,DNHomeSearchBar,DNChannelScrollView,DNPageChannelStyle,DNChannelView;

typedef void(^DNPageScrollViewExtraButtonClickBlock)(UIButton *extraBtn);

@interface DNPageScrollView : UIView
/** 必须设置代理并且实现相应的方法*/
@property(nonatomic,weak )id<DNPageScrollViewDelegate> delegate;
@property (copy, nonatomic) DNPageScrollViewExtraButtonClickBlock extraButtonClickBlock;
@property (nonatomic, strong) DNChannelView *symmetryChannelView;
@property (nonatomic, strong) DNChannelScrollView *channelView;

@property (nonatomic, strong) DNChannelBaseView *channelBaseView;
@property (nonatomic, strong) DNContentScrollView *contentView;
//@property (nonatomic, strong) DNHomeSearchBar *searchBar;
@property (nonatomic, assign) CGFloat currentHeight;


- (instancetype)initWithFrame:(CGRect)frame style:(DNPageChannelStyle *)style channelNames:(NSArray<NSString *> *)channelNames parentViewController:(UIViewController *)parentViewController delegate:(id<DNPageScrollViewDelegate>) delegate;

/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

/**  给外界重新设置的标题的方法(同时会重新加载页面的内容) */
- (void)reloadWithNewTitles:(NSArray<NSString *> *)newTitles;
/**  只刷新频道名字 并load 地方频道数据 */
- (void)reloadChannelNameWithNewTitles:(NSArray<NSString *> *)newTitles selectIndex:(NSInteger)selectIndex;

- (void)returnExtraButtonClickBlock:(DNPageScrollViewExtraButtonClickBlock )block;

- (void)reloadTheme;


@end
