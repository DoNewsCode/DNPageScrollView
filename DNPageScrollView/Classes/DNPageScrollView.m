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
#import "UIView+CTLayout.h"
#import "DNChannelView.h"

@interface DNPageScrollView ()

@property (nonatomic, strong) DNPageChannelStyle *style;
@property (nonatomic, weak) UIViewController *parentViewController;

@property (strong, nonatomic) NSArray *childViewControllers;
@property (strong, nonatomic) NSArray *channelNameArray;

@property(nonatomic, assign) CGFloat contentY;


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
    if (self.style.channleType == DNPageChannelStyleChannelTypeDefault) {
        self.channelBaseView = self.channelView;
        self.channelView.backgroundColor = self.style.channelBackgroundColor;
        self.contentY = CGRectGetMaxY(self.channelView.frame) + self.style.channelEdge.bottom;
        self.contentView.backgroundColor = self.style.pageViewBackgroundColor;
        [self addSubview:self.channelView];
        [self insertSubview:self.contentView atIndex:0];
    } else if (self.style.channleType == DNPageChannelStyleChannelTypeTab) {
        self.channelBaseView = self.tabChannelView;
        self.tabChannelView.backgroundColor = self.style.channelBackgroundColor;
        
        self.contentY = CGRectGetMaxY(self.tabChannelView.frame) + self.style.channelEdge.bottom;
        self.contentView.backgroundColor = self.style.pageViewBackgroundColor;
        [self addSubview:self.tabChannelView];
        [self insertSubview:self.contentView atIndex:0];
    } else if (self.style.channleType == DNPageChannelStyleChannelTypeSymmetry){
        self.channelBaseView = self.symmetryChannelView;
        self.symmetryChannelView.backgroundColor = self.style.channelBackgroundColor;
        
        self.contentY = CGRectGetMaxY(self.symmetryChannelView.frame) + self.style.channelEdge.bottom;
        self.contentView.backgroundColor = self.style.pageViewBackgroundColor;
        [self addSubview:self.symmetryChannelView];
        [self insertSubview:self.contentView atIndex:0];
    } else if (self.style.channleType == DNPageChannelStyleChannelTypeTimeLine){
        self.channelBaseView = self.timeLineChannelView;
        self.timeLineChannelView.backgroundColor = self.style.channelBackgroundColor;
        
        self.contentY = CGRectGetMaxY(self.timeLineChannelView.frame) + self.style.channelEdge.bottom;
        self.contentView.backgroundColor = self.style.pageViewBackgroundColor;
        [self addSubview:self.timeLineChannelView];
        [self insertSubview:self.contentView atIndex:0];
    }
    
    
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
    self.backgroundColor = self.style.pageViewBackgroundColor;
    self.contentView.backgroundColor = self.style.channelBackgroundColor;
    self.channelView.backgroundColor = self.style.channelBackgroundColor;
}

- (void)returnExtraButtonClickBlock:(DNPageScrollViewExtraButtonClickBlock)block {
    self.extraButtonClickBlock = block;
}

- (void)setCurrentHeight:(CGFloat)currentHeight {
    self.ct_height = currentHeight;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
}

- (DNChannelScrollView *)channelView {
    if (!_channelView) {
        __weak typeof (self) weakSelf = self;
        CGRect symmetryChannelViewFrame = CGRectZero;
        if (self.style.channelFrame.size.width > 0) {
            symmetryChannelViewFrame = self.style.channelFrame;
        } else {
            CGFloat startHeight = self.style.channelEdge.top;//iPhoneX ? 44 : 20;
            CGFloat height = (self.style.isShowSearchBar ? 44. : 0.);
            startHeight += height;
            
            CGFloat width = self.bounds.size.width - self.style.channelEdge.left - self.style.channelEdge.right;
            symmetryChannelViewFrame = CGRectMake(self.style.channelEdge.left, startHeight, width, self.style.channelHeight);
        }
        DNChannelScrollView *channelScrollView = [[DNChannelScrollView alloc]
                                                  initWithFrame:symmetryChannelViewFrame
                                                  channelStyle:self.style
                                                  channelNames:self.channelNameArray
                                                  channelDidClick:^(NSInteger index) {
                                                      [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
                                                  }];
        
        [channelScrollView returnSetUpTitleBlock:^(UIView *titleView, NSInteger index) {
            if (weakSelf.delegate && [weakSelf respondsToSelector:@selector(setUpTitleView:forIndex:)]) {
                [weakSelf.delegate setUpTitleView:titleView forIndex:index];
            }
        }];
        
        _channelView = channelScrollView;
    }
    return _channelView;
}

- (DNChannelTapView *)tabChannelView {
    if (!_tabChannelView) {
        __weak typeof (self) weakSelf = self;
        CGRect symmetryChannelViewFrame = CGRectZero;
        if (self.style.channelFrame.size.width > 0) {
            symmetryChannelViewFrame = self.style.channelFrame;
        } else {
            CGFloat startHeight = self.style.channelEdge.top;//iPhoneX ? 44 : 20;
            CGFloat height = (self.style.isShowSearchBar ? 44. : 0.);
            startHeight += height;
            
            CGFloat width = self.bounds.size.width - self.style.channelEdge.left - self.style.channelEdge.right;
            symmetryChannelViewFrame = CGRectMake(self.style.channelEdge.left, startHeight, width, self.style.channelHeight);
        }
        
        DNChannelTapView *tabChannelView = [[DNChannelTapView alloc]
                                            initWithFrame:symmetryChannelViewFrame
                                            channelStyle:self.style
                                            channelNames:self.channelNameArray
                                            channelDidClick:^(NSInteger index) {
                                                [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
                                            }];
        [tabChannelView returnSetUpTitleBlock:^(UIView *titleView, NSInteger index) {
            if (weakSelf.delegate && [weakSelf respondsToSelector:@selector(setUpTitleView:forIndex:)]) {
                [weakSelf.delegate setUpTitleView:titleView forIndex:index];
            }
        }];
        _tabChannelView = tabChannelView;
    }
    return _tabChannelView;
}

- (DNChannelSymmetryView *)symmetryChannelView {
    if (!_symmetryChannelView) {
        __weak typeof (self) weakSelf = self;
        CGRect symmetryChannelViewFrame = CGRectZero;
        if (self.style.channelFrame.size.width > 0) {
            symmetryChannelViewFrame = self.style.channelFrame;
        } else {
            CGFloat startHeight = self.style.channelEdge.top;//iPhoneX ? 44 : 20;
            CGFloat height = (self.style.isShowSearchBar ? 44. : 0.);
            startHeight += height;
            
            CGFloat width = self.bounds.size.width - self.style.channelEdge.left - self.style.channelEdge.right;
            symmetryChannelViewFrame = CGRectMake(self.style.channelEdge.left, startHeight, width, self.style.channelHeight);
        }
        
        DNChannelSymmetryView *symmetryChannelView = [[DNChannelSymmetryView alloc]
                                                      initWithFrame:symmetryChannelViewFrame
                                                      channelStyle:self.style
                                                      channelNames:self.channelNameArray
                                                      channelDidClick:^(NSInteger index) {
                                                          [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
                                                      }];
        [symmetryChannelView returnSetUpTitleBlock:^(UIView *titleView, NSInteger index) {
            if (weakSelf.delegate && [weakSelf respondsToSelector:@selector(setUpTitleView:forIndex:)]) {
                [weakSelf.delegate setUpTitleView:titleView forIndex:index];
            }
        }];
        _symmetryChannelView = symmetryChannelView;
    }
    return _symmetryChannelView;
}

- (DNChannelTimeLineView *)timeLineChannelView {
    if (!_timeLineChannelView) {
        __weak typeof (self) weakSelf = self;
        CGRect symmetryChannelViewFrame = CGRectZero;
        if (self.style.channelFrame.size.width > 0) {
            symmetryChannelViewFrame = self.style.channelFrame;
        } else {
            CGFloat startHeight = self.style.channelEdge.top;//iPhoneX ? 44 : 20;
            CGFloat height = (self.style.isShowSearchBar ? 44. : 0.);
            startHeight += height;
            
            CGFloat width = self.bounds.size.width - self.style.channelEdge.left - self.style.channelEdge.right;
            symmetryChannelViewFrame = CGRectMake(self.style.channelEdge.left, startHeight, width, self.style.channelHeight);
        }
        
        DNChannelTimeLineView *timeLineChannelView = [[DNChannelTimeLineView alloc]
                                                      initWithFrame:symmetryChannelViewFrame
                                                      channelStyle:self.style
                                                      channelNames:self.channelNameArray
                                                      channelDidClick:^(NSInteger index) {
                                                          [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
                                                      }];
        [timeLineChannelView returnSetUpTitleBlock:^(UIView *titleView, NSInteger index) {
            if (weakSelf.delegate && [weakSelf respondsToSelector:@selector(setUpTitleView:forIndex:)]) {
                [weakSelf.delegate setUpTitleView:titleView forIndex:index];
            }
        }];
        _timeLineChannelView = timeLineChannelView;
    }
    return _timeLineChannelView;
}


- (DNContentScrollView *)contentView {
    if (!_contentView) {
        DNContentScrollView *content = [[DNContentScrollView alloc]
                                        initWithFrame:CGRectMake(0.0, self.contentY, self.bounds.size.width, self.bounds.size.height - self.contentY)
                                        channelScrollView:self.channelBaseView
                                        parentViewController:self.parentViewController
                                        delegate:self.delegate];
        
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
