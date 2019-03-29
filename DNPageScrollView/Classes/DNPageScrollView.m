//
//  DNPageScrollView.m
//  Donews
//
//  Created by Jamie on 2017/4/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "DNPageScrollView.h"
#import "DNPageChannelStyle.h"
#import "DNChannelTitleView.h"
#import "UIView+Layout.h"

@interface DNPageScrollView ()

@property (nonatomic, strong) DNPageChannelStyle *style;
@property (nonatomic, weak) UIViewController *parentViewController;

@property (strong, nonatomic) NSArray *childViewControllers;
@property (strong, nonatomic) NSArray *channelNameArray;
@end

@implementation DNPageScrollView

- (instancetype)initWithFrame:(CGRect)frame style:(DNPageChannelStyle *)style channelNames:(NSArray<NSString *> *)channelNames parentViewController:(UIViewController *)parentViewController delegate:(id<DNPageScrollViewDelegate>) delegate {
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.style = style;
        self.parentViewController = parentViewController;
        self.channelNameArray = channelNames.copy;
        self.backgroundColor = style.pageViewBackgroundColor;
        [self createContent];
    }
    return self;
}

- (void)createContent {
    self.contentView.backgroundColor = self.style.pageViewBackgroundColor;
    self.channelView.backgroundColor = self.style.channelBackgroundColor;
    
}

/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    [self.channelView setSelectedIndex:selectedIndex animated:animated];
}

/**  给外界重新设置视图内容的标题的方法 */
- (void)reloadWithNewTitles:(NSArray<NSString *> *)newTitles {
    
    self.channelNameArray = nil;
    self.channelNameArray = newTitles.copy;
    
    [self.channelView reloadTitlesWithNewTitles:self.channelNameArray];
    [self.contentView reload];
}

/**  只刷新频道名字 并load 地方频道数据 */
- (void)reloadChannelNameWithNewTitles:(NSArray<NSString *> *)newTitles selectIndex:(NSInteger)selectIndex{
    self.channelNameArray = nil;
    self.channelNameArray = newTitles.copy;
    
    [self.channelView reloadTitlesNameWithNewTitles:self.channelNameArray selectIndex:selectIndex];
    [self.contentView reload];
}

- (void)reloadTheme {
    [self.channelView reloadTheme];
//    [self.contentView reload];
    self.backgroundColor = self.style.pageViewBackgroundColor;
    self.contentView.backgroundColor = self.style.channelBackgroundColor;
    self.channelView.backgroundColor = self.style.channelBackgroundColor;
}

-(void)returnExtraButtonClickBlock:(DNPageScrollViewExtraButtonClickBlock)block {
    self.extraButtonClickBlock = block;
}

//<<<<<<< HEAD
//-(void)setCurrentHeight:(CGFloat)currentHeight
//{
//    self.ct_height = currentHeight;
////  self.contentView.height = self.height - (CGRectGetMaxY(self.channelView.frame) + 1);
////    self.contentView.currentHeight = self.height - (CGRectGetMaxY(self.channelView.frame));
////    self.contentView.bounds = CGRectMake(0., 0., self.width, self.height - (CGRectGetMaxY(self.channelView.frame)));
//=======
-(void)setCurrentHeight:(CGFloat)currentHeight {
    self.ct_height = currentHeight;
//>>>>>>> 278496b9cb41cb065f62b3f52bb357b8ed666ab8
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];

}

- (DNChannelScrollView *)channelView {
    if (!_channelView) {
        __weak typeof (self) weakSelf = self;
        CGFloat stateBarHeight = 0;//iPhoneX ? 44 : 20;
        CGFloat height = (self.style.isShowSearchBar ? 44. : 0.);
        
        DNChannelScrollView *channelScrollView = [[DNChannelScrollView alloc]
                                                  initWithFrame:CGRectMake(0.0f, stateBarHeight + height, self.bounds.size.width, self.style.channelHeight)
                                                  channelStyle:self.style
                                                  delegate:self.delegate
                                                  channelNames:self.channelNameArray
                                                  channelDidClick:^(DNChannelTitleView *titleView, NSInteger index) {
                                                      [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
                                                  }];
        [self addSubview:channelScrollView];
        _channelView = channelScrollView;
    }
    return _channelView;
}

- (DNContentScrollView *)contentView {
    if (!_contentView) {
        DNContentScrollView *content = [[DNContentScrollView alloc]
                                        initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.channelView.frame) , self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(self.channelView.frame))
                                        channelScrollView:self.channelView
                                        parentViewController:self.parentViewController
                                        delegate:self.delegate];
        [self insertSubview:content atIndex:0];
        _contentView = content;
    }
    return _contentView;
}

- (NSArray *)channelNameArray {
    if (!_channelNameArray) {
        _channelNameArray = [NSArray array];
    }
    return _channelNameArray;
}

- (NSArray *)childViewControllers {
    if (!_channelNameArray) {
        _channelNameArray = [NSArray array];
    }
    return _childViewControllers;
}

- (void)setExtraButtonClickBlock:(DNPageScrollViewExtraButtonClickBlock)extraButtonClickBlock {
    _extraButtonClickBlock = extraButtonClickBlock;
    self.channelView.extraButtonClickBlock = extraButtonClickBlock;
}

@end
