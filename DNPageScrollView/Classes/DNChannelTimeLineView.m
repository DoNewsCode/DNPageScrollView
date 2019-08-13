//
//  DNChannelTimeLineView.m
//  DNPageScrollView
//
//  Created by 陈金铭 on 2019/8/13.
//

#import "DNChannelTimeLineView.h"


@interface DNChannelTimeLineView ()<UIScrollViewDelegate>

/** 缓存所有标题label */
@property (nonatomic, strong) NSMutableArray<DNChannelTitleView *> *channelViews;

// 滚动scrollView
@property (strong, nonatomic) UIScrollView *scrollView;

@property(nonatomic, assign) CGFloat offSetX;

@end

@implementation DNChannelTimeLineView

- (instancetype)initWithFrame:(CGRect )frame channelStyle:(DNPageChannelStyle *)channelStyle channelNames:(NSArray<NSString *> *)channelNames channelDidClick:(DNChannelViewTitleClickBlock)channelDidClick
{
    self = [super initWithFrame:frame channelStyle:channelStyle channelNames:channelNames channelDidClick:channelDidClick];
    if (self) {
        
        [self createContent];
    }
    return self;
}

- (void)createContent {
    [self addSubview:self.selectedTip];
    [self addSubview:self.scrollView];
    self.scrollView.frame = self.bounds;
    
    if (self.channelNameArray.count == 0) return;
    NSInteger index = 0;
    CGFloat titleMaxX = self.channelStyle.titleAboutMargin;
    for (NSString *channelName in self.channelNameArray) {
        DNChannelTitleView *channelView = [[DNChannelTitleView alloc] initWithFrame:CGRectZero];
        channelView.tag = index;
        channelView.font = self.channelStyle.titleFont;
        channelView.text = channelName;
        channelView.textColor = self.channelStyle.normalTitleColor;
        channelView.channelTextAlignment = self.channelStyle.channelTextAlignment;
        channelView.normalFont = self.channelStyle.titleFont;
        channelView.selectedFont = self.channelStyle.selectedTitleFont;
        
        if (self.setUpTitleBlock) {
            self.setUpTitleBlock(channelView, index);
        }
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(channelViewClick:)];
        [channelView addGestureRecognizer:tapGesture];

        channelView.ct_width = [channelView channleTitleViewWidth];
        channelView.ct_x = titleMaxX + index * self.channelStyle.titleMargin;
        titleMaxX += channelView.ct_width;
        channelView.ct_height = self.scrollView.ct_height;
//        channelView.ct
        [self.channelViews addObject:channelView];
        [self.scrollView addSubview:channelView];
        
        index++;
    }
    
    //初始选中状态样式
    NSInteger currentIndex = self.currentIndex;
    DNChannelTitleView *currentChannelView = (DNChannelTitleView *)self.channelViews[currentIndex];
    currentChannelView.currentTransformSx = 1.0;
    if (currentChannelView) {
        // 缩放, 设置初始的label的transform
        currentChannelView.currentTransformSx = self.channelStyle.titleBigScale;
        currentChannelView.textColor = self.channelStyle.selectedTitleColor;
    }
    
    if (self.channelStyle.showLine == YES) {
        self.selectedTip.backgroundColor = self.channelStyle.scrollLineColor;
        NSInteger currentIndex = self.currentIndex;
        DNChannelTitleView *itemView = self.channelViews[currentIndex];
        self.selectedTip.ct_size = CGSizeMake(itemView.ct_width + self.channelStyle.titleAboutMargin * 2, self.selectedTip.ct_height > 0 ? self.selectedTip.ct_height : self.channelStyle.scrollLineHeight);
        self.selectedTip.layer.cornerRadius = self.channelStyle.scrollLineCornerRadius;
        self.selectedTip.ct_centerX = self.ct_centerX + self.channelStyle.centerOffset;
        self.selectedTip.ct_centerY = itemView.ct_centerY;
        
        [self insertSubview:self.selectedTip atIndex:0];
        
        self.offSetX = -(self.selectedTip.ct_centerX - self.selectedTip.ct_width * 0.5);
        [self.scrollView setContentOffset:CGPointMake(self.offSetX, 0.0f) animated:YES];
    }
    self.channelViews.firstObject.textColor = self.channelStyle.selectedTitleColor;
}

- (void)channelViewClick:(UITapGestureRecognizer *)tapGesture {
    DNChannelTitleView *titleView = (DNChannelTitleView *)tapGesture.view;
    NSInteger index = [self.channelViews indexOfObject:titleView];
    self.currentIndex = index;
    [self adjustUIWhenBtttonClickWithAnimate:YES taped:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:self.channelStyle.notificationChannelClickName object:[NSString stringWithFormat:@"%zd",index]];
}

- (void)adjustUIWhenBtttonClickWithAnimate:(BOOL)animated taped:(BOOL)taped
{
    if (self.currentIndex == self.oldIndex && taped) return;
    NSInteger oldIndex = self.oldIndex;
    NSInteger currentIndex = self.currentIndex;
    DNChannelTitleView *oldChannelView = self.channelViews[oldIndex];
    DNChannelTitleView *currentChannelView = self.channelViews[currentIndex];
    
    CGFloat animatedTime = animated ? 0.25 : 0;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateKeyframesWithDuration:animatedTime delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        oldChannelView.textColor = weakSelf.channelStyle.normalTitleColor;
        currentChannelView.textColor = weakSelf.channelStyle.selectedTitleColor;
        
        oldChannelView.selected = NO;
        //        oldChannelView.currentTransformSx = 1.0;
        currentChannelView.selected = YES;
        //        currentChannelView.currentTransformSx = weakSelf.channelStyle.titleBigScale;
        
        CGFloat offSetX = self.offSetX + currentChannelView.ct_x - self.channelStyle.titleAboutMargin;
        [self.scrollView setContentOffset:CGPointMake(offSetX, 0.0f) animated:YES];
        weakSelf.selectedTip.center = currentChannelView.center;
        weakSelf.selectedTip.ct_width = (currentChannelView.ct_width + self.channelStyle.titleAboutMargin * 2);
    } completion:^(BOOL finished) {
        [weakSelf adjustChannelOffSetToCurrentIndex:self.currentIndex];
    }];
    
    self.oldIndex = self.currentIndex;
    
    //点击标题执行的Block
    if (self.channelButtonClickBlock) {
        NSInteger currentIndex = self.currentIndex;
        self.channelButtonClickBlock(currentIndex);
    }
}

/** 切换下标的时候根据progress同步设置UI*/
- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex {
    if (oldIndex < 0 ||
        oldIndex >= self.channelNameArray.count ||
        currentIndex < 0 ||
        currentIndex >= self.channelNameArray.count) return;
    
    self.oldIndex = currentIndex;
    
    DNChannelTitleView *oldChannelView = self.channelViews[oldIndex];
    DNChannelTitleView *currentChannelView = self.channelViews[currentIndex];
    
    
    //颜色渐变
    oldChannelView.textColor = [UIColor colorWithRed:[self.selectedColorRGB[0] floatValue] + [self.deltaRGB[0] floatValue] * progress
                                               green:[self.selectedColorRGB[1] floatValue] + [self.deltaRGB[1] floatValue] * progress
                                                blue:[self.selectedColorRGB[2] floatValue] + [self.deltaRGB[2] floatValue] * progress
                                               alpha:1.0];
    currentChannelView.textColor = [UIColor colorWithRed:[self.normalColorRGB[0] floatValue] - [self.deltaRGB[0] floatValue] * progress
                                                   green:[self.normalColorRGB[1] floatValue] - [self.deltaRGB[1] floatValue] * progress
                                                    blue:[self.normalColorRGB[2] floatValue] - [self.deltaRGB[2] floatValue] * progress
                                                   alpha:1.0];
    
    CGFloat currentChannelViewCenterX = currentChannelView.ct_centerX;
    CGFloat oldChannelViewCenterX = oldChannelView.ct_centerX;
    //        self.selectedTip.cen
    if (currentChannelView.layer.anchorPoint.x == 0) {
        currentChannelViewCenterX += (currentChannelView.ct_width * 0.5);
    } else if (currentChannelView.layer.anchorPoint.x == 1) {
        currentChannelViewCenterX -= (currentChannelView.ct_width * 0.5);
        
    }
    if (oldChannelView.layer.anchorPoint.x == 0) {
        oldChannelViewCenterX += (oldChannelView.ct_width * 0.5);
    } else if (oldChannelView.layer.anchorPoint.x == 1) {
        oldChannelViewCenterX -= (oldChannelView.ct_width * 0.5);
        
    }
    
    CGFloat xDistance = currentChannelView.ct_centerX - oldChannelView.ct_centerX;
    CGFloat wDistance = currentChannelView.ct_width - oldChannelView.ct_width;
    self.selectedTip.ct_width = ((oldChannelView.ct_width + self.channelStyle.titleAboutMargin * 2) + wDistance * progress);
    CGFloat offSetX = self.offSetX + oldChannelView.ct_x - self.channelStyle.titleAboutMargin;
    NSLog(@"\noffSetX = %f\npro = %f",offSetX,(offSetX + xDistance * progress));
    self.scrollView.contentOffset = CGPointMake(offSetX + xDistance * progress, 0.0f);
//    [self.scrollView setContentOffset:CGPointMake(offSetX + xDistance * progress, 0.0f) animated:NO];
}

/** 让选中的标题居中*/
- (void)adjustChannelOffSetToCurrentIndex:(NSInteger)currentIndex {
    self.selectedTip.ct_width = (self.channelViews[currentIndex].ct_width + self.channelStyle.titleAboutMargin * 2);
    DNChannelTitleView *currentChannelView = self.channelViews[currentIndex];
    CGFloat offSetX = self.offSetX + currentChannelView.ct_x - self.channelStyle.titleAboutMargin;
    [self.scrollView setContentOffset:CGPointMake(offSetX, 0.0f) animated:YES];
}

/** 设置选中的下标*/
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    NSAssert(index >= 0 && index < self.channelNameArray.count, @"设置的下标不合法!");
    
    if (index < 0 || index >= self.channelNameArray.count) return;
    
    self.currentIndex = index;
    
    [self adjustUIWhenBtttonClickWithAnimate:animated taped:NO];
}

/** 重新刷新标题的内容*/
- (void)reloadTitlesWithNewTitles:(NSArray *)titles {
    self.currentIndex = 0;
    self.oldIndex = 0;
    //    self.channelWidths = nil;
    self.channelViews = nil;
    self.channelNameArray = nil;
    self.channelNameArray = titles;
    if (self.channelNameArray.count == 0) return;
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self createContent];
    [self setSelectedIndex:0 animated:YES];
}

- (void)reloadTitlesNameWithNewTitles:(NSArray *)titles selectIndex:(NSInteger)selectIndex {
    
}

- (void)reloadTheme {
    
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView * scrollView = [UIScrollView new];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.bounces = YES;
        scrollView.pagingEnabled = NO;
        scrollView.clipsToBounds = NO;
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIView *)selectedTip {
    if (!_selectedTip) {
        UIView *selectedTip = [UIView new];
        selectedTip.clipsToBounds = YES;
        _selectedTip = selectedTip;
    }
    return _selectedTip;
}

- (NSMutableArray<DNChannelTitleView *> *)channelViews
{
    if (_channelViews == nil) {
        _channelViews = [NSMutableArray<DNChannelTitleView *> array];
    }
    return _channelViews;
}

@end
