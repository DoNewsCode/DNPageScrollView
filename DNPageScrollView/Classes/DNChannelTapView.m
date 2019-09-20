//
//  DNChannelTapView.m
//  DNPageScrollView
//
//  Created by 陈金铭 on 2019/8/7.
//

#import "DNChannelTapView.h"

#import "DNChannelTitleView.h"

@interface DNChannelTapView ()
/** 缓存所有标题label */
@property (nonatomic, strong) NSMutableArray<DNChannelTitleView *> *channelViews;

@end
@implementation DNChannelTapView

- (instancetype)initWithFrame:(CGRect )frame channelStyle:(DNPageChannelStyle *)channelStyle channelNames:(NSArray<NSString *> *)channelNames channelDidClick:(DNChannelViewTitleClickBlock)channelDidClick
{
    self = [super initWithFrame:frame channelStyle:channelStyle channelNames:channelNames channelDidClick:channelDidClick];
    if (self) {
        
        [self createContent];
    }
    return self;
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
    
    CGFloat xDistance = currentChannelViewCenterX - oldChannelViewCenterX;
    CGFloat wDistance = currentChannelView.ct_width - oldChannelView.ct_width;
    //下标
    self.selectedTip.ct_centerX = oldChannelViewCenterX + xDistance * progress;
    self.selectedTip.ct_width = ((oldChannelView.ct_width) + wDistance * progress);
    
}

/** 让选中的标题居中*/
- (void)adjustChannelOffSetToCurrentIndex:(NSInteger)currentIndex {
//    self.selectedTip.center = self.channelViews[currentIndex].center;
//    self.selectedTip.ct_width = (self.channelViews[currentIndex].ct_width + self.channelStyle.titleAboutMargin * 2);
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



- (void)createContent {
    [self addSubview:self.selectedTip];
    CGFloat height = self.frame.size.height - self.channelStyle.titleSeesawMargin * 2;
    
    CGFloat totalWidth = 0;
    for (NSInteger i = 0; i < self.channelNameArray.count; i++) {
        NSString *name = self.channelNameArray[i];
        DNChannelTitleView *titleView = [DNChannelTitleView new];
        titleView.font = self.channelStyle.titleFont;
        titleView.textColor = self.channelStyle.normalTitleColor;
        titleView.text = name;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(channelViewClick:)];
        [titleView addGestureRecognizer:tapGesture];
        CGFloat titleViewX = self.channelStyle.channelInnerEdge.left + i * (titleView.channleTitleViewWidth);
        titleView.frame = (CGRect){titleViewX,self.channelStyle.titleSeesawMargin,titleView.channleTitleViewWidth + self.channelStyle.titleAboutMargin * 2,height};
        totalWidth += titleView.ct_width;
        [self addSubview:titleView];
        [self.channelViews addObject:titleView];
        
    }
    CGFloat margin = (self.frame.size.width - self.channelStyle.channelInnerEdge.left - self.channelStyle.channelInnerEdge.right - totalWidth) / (self.channelViews.count - 1);
    if (self.channelViews.count == 2) {
        DNChannelTitleView *titleView = self.channelViews.lastObject;
        titleView.ct_x = self.ct_width - self.channelStyle.channelInnerEdge.right - titleView.ct_width;
    } else {
        for (NSInteger i = 0; i < self.channelViews.count; i++) {
            if (i > 0) {
                DNChannelTitleView *titleView = self.channelViews[i];
                titleView.ct_x = CGRectGetMaxX(self.channelViews[i - 1].frame) + margin;
            }
        }
    }
    
    
    if (self.channelStyle.showLine == YES) {
        self.selectedTip.backgroundColor = self.channelStyle.scrollLineColor;
        NSInteger currentIndex = self.currentIndex;
        DNChannelTitleView *itemView = self.channelViews[currentIndex];
        self.selectedTip.ct_size = CGSizeMake(itemView.ct_width, self.selectedTip.ct_height > 0 ? self.selectedTip.ct_height : self.channelStyle.scrollLineHeight);
        self.selectedTip.layer.cornerRadius = self.channelStyle.scrollLineCornerRadius;
        self.selectedTip.ct_centerX = itemView.ct_centerX;
        self.selectedTip.ct_centerY = itemView.ct_centerY;
        self.selectedTip.layer.cornerRadius = self.channelStyle.selectedTipCornerRadius;
        
        [self insertSubview:self.selectedTip atIndex:0];
    }
    self.channelViews.firstObject.textColor = self.channelStyle.selectedTitleColor;
}

-(void)channelViewClick:(UITapGestureRecognizer *)tapGesture {
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
        currentChannelView.selected = YES;
        
        weakSelf.selectedTip.ct_width = (currentChannelView.ct_width);
        weakSelf.selectedTip.center = currentChannelView.center;
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
