//
//  DNChannelView.m
//  DNPageScrollView
//
//  Created by 陈金铭 on 2019/8/4.
//

#import "DNChannelView.h"

#import "DNChannelTitleView.h"

#import "UIView+CTLayout.h"

@interface DNChannelView ()
/** 缓存所有标题label */
@property (nonatomic, strong) NSMutableArray<DNChannelTitleView *> *channelViews;

@end
@implementation DNChannelView

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
    
    CGFloat deltaScale = self.channelStyle.titleBigScale - 1.0;
    
    oldChannelView.currentTransformSx = self.channelStyle.titleBigScale - deltaScale * progress;
    currentChannelView.currentTransformSx = 1.0 + deltaScale * progress;
}

/** 让选中的标题居中*/
- (void)adjustChannelOffSetToCurrentIndex:(NSInteger)currentIndex {
    self.selectedTipLayer.frame = self.channelViews[currentIndex].frame;
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
    [self.layer addSublayer:self.selectedTipLayer];
    CGFloat width = (self.frame.size.width - self.channelStyle.titleAboutMargin * 2 - self.channelStyle.titleMargin * (self.channelNameArray.count - 1)) / self.channelNameArray.count;
    CGFloat height = self.frame.size.height - self.channelStyle.titleSeesawMargin * 2;
    for (NSInteger i = 0; i < self.channelNameArray.count; i++) {
        NSString *name = self.channelNameArray[i];
        DNChannelTitleView *titleView = [DNChannelTitleView new];
        titleView.text = name;
        titleView.font = self.channelStyle.titleFont;
        titleView.textColor = self.channelStyle.normalTitleColor;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(channelViewClick:)];
        [titleView addGestureRecognizer:tapGesture];
        CGFloat titleViewX = self.channelStyle.titleAboutMargin + i * (width + self.channelStyle.titleMargin);
        titleView.frame = (CGRect){titleViewX,self.channelStyle.titleSeesawMargin,width,height};
        [self addSubview:titleView];
        [self.channelViews addObject:titleView];
        
    }
    self.selectedTipLayer.frame = self.channelViews.firstObject.frame;
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
        oldChannelView.currentTransformSx = 1.0;
        currentChannelView.selected = YES;
        currentChannelView.currentTransformSx = weakSelf.channelStyle.titleBigScale;
        
        weakSelf.selectedTipLayer.frame = currentChannelView.frame;
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

- (CALayer *)selectedTipLayer {
    if (!_selectedTipLayer) {
        CALayer *selectedTipLayer = [CALayer new];
        selectedTipLayer.backgroundColor = [UIColor grayColor].CGColor;
        _selectedTipLayer = selectedTipLayer;
    }
    return _selectedTipLayer;
}

- (NSMutableArray<DNChannelTitleView *> *)channelViews
{
    if (_channelViews == nil) {
        _channelViews = [NSMutableArray<DNChannelTitleView *> array];
    }
    return _channelViews;
}

- (NSArray *)deltaRGB {
    if (_deltaRGB == nil) {
        NSArray *normalColorRgb = self.normalColorRGB;
        NSArray *selectedColorRgb = self.selectedColorRGB;
        
        NSArray *delta;
        if (normalColorRgb && selectedColorRgb) {
            CGFloat deltaR = [normalColorRgb[0] floatValue] - [selectedColorRgb[0] floatValue];
            CGFloat deltaG = [normalColorRgb[1] floatValue] - [selectedColorRgb[1] floatValue];
            CGFloat deltaB = [normalColorRgb[2] floatValue] - [selectedColorRgb[2] floatValue];
            delta = [NSArray arrayWithObjects:@(deltaR), @(deltaG), @(deltaB), nil];
            _deltaRGB = delta;
            
        }
    }
    return _deltaRGB;
}

- (NSArray *)normalColorRGB {
    if (!_normalColorRGB) {
        NSArray *normalColorRgb = [self getColorRgb:self.channelStyle.normalTitleColor];
        NSAssert(normalColorRgb, @"设置普通状态的文字颜色时 请使用RGB空间的颜色值");
        _normalColorRGB = normalColorRgb;
        
    }
    return  _normalColorRGB;
}

- (NSArray *)selectedColorRGB {
    if (!_selectedColorRGB) {
        NSArray *selectedColorRgb = [self getColorRgb:self.channelStyle.selectedTitleColor];
        NSAssert(selectedColorRgb, @"设置选中状态的文字颜色时 请使用RGB空间的颜色值");
        _selectedColorRGB = selectedColorRgb;
        
    }
    return  _selectedColorRGB;
}

- (NSArray *)getColorRgb:(UIColor *)color {
    CGFloat numOfcomponents = CGColorGetNumberOfComponents(color.CGColor);
    NSArray *rgbComponents;
    if (numOfcomponents == 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        rgbComponents = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), nil];
    }
    return rgbComponents;
    
}

@end
