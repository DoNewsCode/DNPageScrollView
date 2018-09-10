//
//  DNChannelScrollView.h
//  Donews
//
//  Created by Jamie on 2017/4/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNPageChannelStyle.h"
#import "DNChannelTitleView.h"
#import "DNPageScrollView.h"
typedef void(^DNChannelScrollViewTitleBtnOnClickBlock)(DNChannelTitleView *titleView, NSInteger index);
typedef void(^DNChannelScrollViewExtraBtnOnClick)(UIButton *extraBtn);

@interface DNChannelScrollView : UIView
@property (nonatomic, copy ) NSArray *channelNameArray;
/** 必须设置代理并且实现相应的方法*/
@property(weak, nonatomic) id<DNPageScrollViewDelegate> delegate;
@property (copy, nonatomic) DNChannelScrollViewExtraBtnOnClick extraButtonClickBlock;

@property (nonatomic, strong) DNPageChannelStyle *channelStyle;


- (instancetype)initWithFrame:(CGRect )frame channelStyle:(DNPageChannelStyle *)channelStyle delegate:(id<DNPageScrollViewDelegate>)delegate channelNames:(NSArray<NSString *> *)channelNames  channelDidClick:(DNChannelScrollViewTitleBtnOnClickBlock)channelDidClick;


/** 切换下标的时候根据progress同步设置UI*/
- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex;
/** 让选中的标题居中*/
- (void)adjustChannelOffSetToCurrentIndex:(NSInteger)currentIndex;
/** 设置选中的下标*/
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;
/** 重新刷新标题的内容*/
- (void)reloadTitlesWithNewTitles:(NSArray *)titles;
- (void)reloadTitlesNameWithNewTitles:(NSArray *)titles selectIndex:(NSInteger)selectIndex;
- (void)reloadTheme;
@end
