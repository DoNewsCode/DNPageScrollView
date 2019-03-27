//
//  DNChannelScrollView.m
//  Donews
//
//  Created by Jamie on 2017/4/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "DNChannelScrollView.h"
#import "DNChannelTitleView.h"
#import <DNCommonKit/UIView+Layout.h>
//#import "TGConst.h"
//#import "UIImage+ZZAdd.h"

@interface DNChannelScrollView ()<UIScrollViewDelegate>{
    CGFloat _currentWidth;
    NSUInteger _currentIndex;
    NSUInteger _oldIndex;
}

// 滚动scrollView
@property (strong, nonatomic) UIScrollView *scrollView;
/** channelCenterY */
@property (nonatomic, assign) CGFloat channelCenterY;
// 背景ImageView
@property (strong, nonatomic) UIImageView *backgroundImageView;
// 附加的按钮
@property (strong, nonatomic) UIButton *extraButton;
@property (nonatomic, strong) UIImageView *shadowCover;
@property (nonatomic, strong) UIImageView *scrollLine;
@property (nonatomic, strong) UIView *bottomLine;

/** 缓存所有标题label */
@property (nonatomic, strong) NSMutableArray *channelViews;
// 缓存计算出来的每个标题的宽度
@property (nonatomic, strong) NSMutableArray *channelWidths;

// 用于懒加载计算文字的rgb差值, 用于颜色渐变的时候设置
@property (strong, nonatomic) NSArray *deltaRGB;
@property (strong, nonatomic) NSArray *selectedColorRGB;
@property (strong, nonatomic) NSArray *normalColorRGB;
@property (nonatomic, strong) NSBundle *resourceBundle;

// 响应标题点击
@property (copy, nonatomic) DNChannelScrollViewTitleBtnOnClickBlock channelButtonClickBlock;
@end
@implementation DNChannelScrollView

static CGFloat const xGap = 5.0;
static CGFloat const wGap = 2*xGap;
static CGFloat const contentSizeXOff = 20.0;
static CGFloat const shadowCoverWidth = 30;

- (NSBundle *)resourceBundle {
    if (_resourceBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.ct_x和0.ct_x
        _resourceBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"DNPageScrollView" ofType:@"bundle"]];
    }
    return _resourceBundle;
}

- (instancetype)initWithFrame:(CGRect )frame channelStyle:(DNPageChannelStyle *)channelStyle delegate:(id<DNPageScrollViewDelegate>)delegate channelNames:(NSArray<NSString *> *)channelNames channelDidClick:(DNChannelScrollViewTitleBtnOnClickBlock)channelDidClick
{
    self = [super initWithFrame:frame];
    if (self) {
        self.channelNameArray = channelNames.copy;
        self.delegate = delegate;
        self.channelStyle = channelStyle;
        self.channelButtonClickBlock = channelDidClick;
        _currentIndex = 0;
        _oldIndex = 0;
        _currentWidth = frame.size.width;
        if (channelStyle.isShowChannelShadow) {
            self.layer.shadowColor = [[UIColor colorWithRed:0. green:0. blue:0. alpha:1.] CGColor];
            self.layer.shadowOpacity = 0.1;//设置阴影的透明度
            self.layer.shadowOffset = CGSizeMake(0, 1);//设置阴影的偏移量
        }
        [self createContent];
    }
    return self;
}

- (void)createContent
{
    [self addSubview:self.scrollView];
    [self setupChannelTitles];
    [self setupUI];
}

-(void)reloadTheme
{
    for (DNChannelTitleView *channelView in self.channelViews) {
        channelView.textColor = self.channelStyle.normalTitleColor;
    }
    if(self.channelViews.count>_currentIndex){
    DNChannelTitleView *channelView  =  self.channelViews[_currentIndex];
    channelView.textColor = self.channelStyle.selectedTitleColor;
    }
    self.scrollLine.backgroundColor = self.channelStyle.scrollLineColor;
    if (self.channelStyle.scrollLineImageName) {
        self.scrollLine.image = [UIImage imageNamed:self.channelStyle.scrollLineImageName];
    }
    self.bottomLine.backgroundColor = self.channelStyle.bottomLineBackgroundColor;
    
    [self.extraButton setImage:[UIImage imageNamed:self.channelStyle.extraButtonImageName] forState:UIControlStateNormal];
    self.extraButton.backgroundColor = self.channelStyle.extraButtonBackgroundColor;
    
//    self.shadowCover.image = [UIImage zz_imageName:self.channelStyle.shadowCoverImageName inBundle:TGBundleHome];
    
   self.shadowCover.image = [[UIImage imageWithContentsOfFile:[self.resourceBundle pathForResource:@"icon_pagescroll" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)setupChannelTitles
{
    if (self.channelNameArray.count == 0) return;
    NSInteger index = 0;
    for (NSString *channelName in self.channelNameArray) {
        DNChannelTitleView *channelView = [[DNChannelTitleView alloc] initWithFrame:CGRectZero];
        channelView.tag = index;
        channelView.font = self.channelStyle.titleFont;
        channelView.text = channelName;
        channelView.textColor = self.channelStyle.normalTitleColor;
        channelView.channelTextAlignment = self.channelStyle.channelTextAlignment;
        channelView.normalFont = self.channelStyle.titleFont;
        channelView.selectedFont = self.channelStyle.selectedTitleFont;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(setUpTitleView:forIndex:)]) {
            [self.delegate setUpTitleView:channelView forIndex:index];
        }
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(channelViewClick:)];
        [channelView addGestureRecognizer:tapGesture];
        CGFloat channelViewWidth = [channelView channleTitleViewWidth];
        
        [self.channelWidths addObject:@(channelViewWidth)];
        [self.channelViews addObject:channelView];
        [self.scrollView addSubview:channelView];
        
        index++;
    }
}

-(void)setupUI
{
    if (self.channelNameArray.count == 0) return;
    
    [self setupChannelViewsPosition];
    [self setupScrollViewAndExtraButton];
    [self setupBottomLine];
    [self setupScrollLine];
    //设置滚动区域
    DNChannelTitleView *lastChannelView = (DNChannelTitleView *)self.channelViews.lastObject;
    if (lastChannelView) {
        self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastChannelView.frame) + contentSizeXOff, 0.0f);
    }
    
}

-(void)setupScrollLine{
    DNChannelTitleView *firstLabel = (DNChannelTitleView *)self.channelViews.firstObject;
    CGFloat lineW = self.channelStyle.scrollLineWidth > 0 ? self.channelStyle.scrollLineWidth : firstLabel.ct_width;
    CGFloat lineX = self.channelStyle.scrollLineWidth > 0 ? (firstLabel.ct_x + (firstLabel.ct_width - lineW) * 0.5) : firstLabel.ct_x;
    CGFloat lineH = self.channelStyle.scrollLineHeight;
    CGFloat lineY = self.ct_height - lineH - self.channelStyle.contentBottomMargin;
    
    if (self.scrollLine) {
        if (self.channelStyle.isScrollTitle) {
            self.scrollLine.frame = CGRectMake(lineX, lineY, lineW, lineH);
        }
    }
    if (self.channelStyle.isShowLine) {
        [self.scrollView addSubview:self.scrollLine];
    }
}
- (void)setupBottomLine
{
    if (self.channelStyle.isShowBottomLine) {
        [self insertSubview:self.bottomLine atIndex:0];
    }
    if (self.bottomLine) {
        CGFloat lineW = self.ct_width;
        CGFloat lineH = self.channelStyle.bottomLineHeight;
        CGFloat lineX = 0.0;
        CGFloat lineY = self.ct_height - lineH;
        self.bottomLine.frame = CGRectMake(lineX, lineY, lineW, lineH);
    }
}
- (void)setupScrollViewAndExtraButton {
    CGFloat extraBtnW = 44.0;
    CGFloat extraBtnY = 5.0;
     CGFloat scrollH = self.frame.size.height - self.channelStyle.contentBottomMargin;
    CGFloat scrollW = self.extraButton ? _currentWidth - extraBtnW : _currentWidth;
    if (self.channelStyle.contentCentered) {
        scrollW = CGRectGetMaxX(self.scrollView.subviews.lastObject.frame);
    }
    self.scrollView.frame = CGRectMake(0., 0., scrollW, scrollH);
    if (self.channelStyle.contentCentered) {
        self.scrollView.ct_centerX = self.ct_centerX;
    }
    if (self.channelStyle.isShowExtraButton) {
        [self addSubview:self.extraButton];
    }
    
    if (self.channelStyle.isShadowCover) {
        [self addSubview:self.shadowCover];
    }
    if (self.extraButton) {
        ///>标注 频道栏 + 按钮 frame
        self.extraButton.frame = CGRectMake(CGRectGetMaxX(self.scrollView.frame) , extraBtnY+1, extraBtnW, self.frame.size.height - 2 * extraBtnY);
    }
    
    if (self.shadowCover) {
        self.shadowCover.frame = CGRectMake(CGRectGetMaxX(self.scrollView.frame) - shadowCoverWidth, extraBtnY, shadowCoverWidth, self.frame.size.height - 2 * extraBtnY);
    }
}

- (void)setupChannelViewsPosition
{
    CGFloat channelX = 0.0f;
    CGFloat channelY = 5.0f;
    CGFloat channelW = 0.0f;
//<<<<<<< HEAD
//    CGFloat channelH = self.ct_height - self.channelStyle.scrollLineHeight - self.channelStyle.bottomLineHeight - channelY;
//
//=======
    CGFloat channelH = self.ct_height - self.channelStyle.scrollLineHeight - self.channelStyle.bottomLineHeight - channelY - self.channelStyle.contentBottomMargin;
    _channelCenterY = 5. + channelH * 0.5;
//>>>>>>> 278496b9cb41cb065f62b3f52bb357b8ed666ab8
    NSInteger index = 0;
    float lastChannelLabelMaxX = self.channelStyle.titleAboutMargin;
    float addedMargon = 0.0f;
    
    for (DNChannelTitleView *channelView in self.channelViews) {
        channelW = [self.channelWidths[index] floatValue];
        channelX = lastChannelLabelMaxX + addedMargon * 0.5;
        lastChannelLabelMaxX += (channelW + addedMargon + self.channelStyle.titleMargin);
        channelView.frame = CGRectMake(channelX, channelY, channelW, channelH);
        channelView.normalFrame = channelView.frame;
        index++;
    }
    //初始选中状态样式
    DNChannelTitleView *currentChannelView = (DNChannelTitleView *)self.channelViews[_currentIndex];
    currentChannelView.currentTransformSx = 1.0;
    if (currentChannelView) {
        // 缩放, 设置初始的label的transform
        currentChannelView.currentTransformSx = self.channelStyle.titleBigScale;
        currentChannelView.textColor = self.channelStyle.selectedTitleColor;
    }
}

- (UIButton *)addChannelButtonWithchannelName:(NSString *)channelName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:channelName forState:UIControlStateNormal];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    return button;
}

///附加按钮点击方法
- (void)extraButtonClick:(UIButton *)button
{
    if (self.extraButtonClickBlock) {
        self.extraButtonClickBlock(button);
    }
}

-(void)channelViewClick:(UITapGestureRecognizer *)tapGesture
{
    DNChannelTitleView * currentChannelView = (DNChannelTitleView *)tapGesture.view;
    if (!currentChannelView) return;
    
    _currentIndex = currentChannelView.tag;
    
    [self adjustUIWhenBtttonClickWithAnimate:YES taped:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.channelStyle.notificationChannelClickName object:[NSString stringWithFormat:@"%zd",_currentIndex]];
    
}

- (void)adjustUIWhenBtttonClickWithAnimate:(BOOL)animated taped:(BOOL)taped
{
    if (_currentIndex == _oldIndex && taped) return;
    
    DNChannelTitleView *oldChannelView = self.channelViews[_oldIndex];
    DNChannelTitleView *currentChannelView = self.channelViews[_currentIndex];
    
    CGFloat animatedTime = animated ? 0.25 : 0;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:animatedTime animations:^{
        
        oldChannelView.textColor = weakSelf.channelStyle.normalTitleColor;
        currentChannelView.textColor = weakSelf.channelStyle.selectedTitleColor;
        
        oldChannelView.selected = NO;
        oldChannelView.currentTransformSx = 1.0;
        currentChannelView.selected = YES;
        currentChannelView.currentTransformSx = weakSelf.channelStyle.titleBigScale;
        
        if (weakSelf.scrollLine) {
            if (weakSelf.channelStyle.isScrollTitle) {
                weakSelf.scrollLine.ct_width = self.channelStyle.scrollLineWidth > 0 ? self.channelStyle.scrollLineWidth : currentChannelView.ct_width;
                weakSelf.scrollLine.ct_x =  self.channelStyle.scrollLineWidth > 0 ? (currentChannelView.ct_x + (currentChannelView.ct_width - self.channelStyle.scrollLineWidth) * 0.5) : currentChannelView.ct_x;
            }
            else{
                if (self.channelStyle.isAdjustCoverOrLineWidth) {
                    CGFloat scrollLineW = [weakSelf.channelWidths[self->_currentIndex] floatValue] + wGap;
                    CGFloat scrollLineX = currentChannelView.ct_x + (currentChannelView.ct_width - scrollLineW) * 0.5;
                    weakSelf.scrollLine.ct_x = scrollLineX;
                    weakSelf.scrollLine.ct_width = scrollLineW;
                }
                else{
                    weakSelf.scrollLine.ct_x = self.channelStyle.scrollLineWidth > 0 ? (currentChannelView.ct_x + (currentChannelView.ct_width - self.channelStyle.scrollLineWidth) * 0.5) : currentChannelView.ct_x;
                    weakSelf.scrollLine.ct_width = self.channelStyle.scrollLineWidth > 0 ? self.channelStyle.scrollLineWidth : currentChannelView.ct_width;
                }
            }
        }
        
    } completion:^(BOOL finished) {
        [weakSelf adjustChannelOffSetToCurrentIndex:self->_currentIndex];
    }];
    _oldIndex = _currentIndex;
    
    //点击标题执行的Block
    if (self.channelButtonClickBlock) {
        self.channelButtonClickBlock(currentChannelView, _currentIndex);
    }
}

- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex
{
    if (oldIndex < 0 ||
        oldIndex >= self.channelNameArray.count ||
        currentIndex < 0 ||
        currentIndex >= self.channelNameArray.count) return;
    
    _oldIndex = currentIndex;
    
    DNChannelTitleView *oldChannelView = self.channelViews[oldIndex];
    DNChannelTitleView *currentChannelView = self.channelViews[currentIndex];
    
    CGFloat xDistance = currentChannelView.ct_centerX - oldChannelView.ct_centerX;
    CGFloat wDistance = currentChannelView.ct_width - oldChannelView.ct_width;
    //下标
    if (self.scrollLine) {
        if (self.channelStyle.isScrollTitle) {
            self.scrollLine.ct_centerX = oldChannelView.ct_centerX + xDistance * progress;
            self.scrollLine.ct_width = self.channelStyle.scrollLineWidth > 0 ? self.channelStyle.scrollLineWidth : (oldChannelView.ct_width + wDistance * progress);
        }
    }
    
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

- (void)adjustChannelOffSetToCurrentIndex:(NSInteger)currentIndex
{
    _oldIndex = currentIndex;
    
    NSInteger index = 0;
    for (DNChannelTitleView *channelView in _channelViews) {
        if (index != currentIndex) {
            channelView.textColor = self.channelStyle.normalTitleColor;
            channelView.currentTransformSx = 1.0;
            channelView.selected = NO;
        }
        else{
            channelView.textColor = self.channelStyle.selectedTitleColor;
            channelView.selected = YES;
        }
        
        index++;
    }
    
    if (self.scrollView.contentSize.width != self.scrollView.bounds.size.width + contentSizeXOff) {//需要滚动
        DNChannelTitleView *currentChannelView = (DNChannelTitleView *)_channelViews[currentIndex];
        CGFloat offSetX = currentChannelView.center.x - _currentWidth * 0.5;
        
        if (offSetX < 0) offSetX = 0;
        
        CGFloat extraButtonW = self.extraButton ? self.extraButton.frame.size.width : 0.0f;
        CGFloat maxOffSetX = self.scrollView.contentSize.width - (_currentWidth - extraButtonW);
        
        if (maxOffSetX < 0) maxOffSetX = 0;
        if (offSetX > maxOffSetX) offSetX = maxOffSetX;
        
        [self.scrollView setContentOffset:CGPointMake(offSetX, 0.0f) animated:YES];
    }
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    NSAssert(index >= 0 && index < self.channelNameArray.count, @"设置的下标不合法!");
    
    if (index < 0 || index >= self.channelNameArray.count) return;
    
    _currentIndex = index;
    [self adjustUIWhenBtttonClickWithAnimate:animated taped:NO];
}

- (void)reloadTitlesWithNewTitles:(NSArray *)titles
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _currentIndex = 0;
    _oldIndex = 0;
    self.channelWidths = nil;
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
- (void)reloadTitlesNameWithNewTitles:(NSArray *)titles selectIndex:(NSInteger)selectIndex
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _currentIndex = 0;
    _oldIndex = 0;
    self.channelWidths = nil;
    self.channelViews = nil;
    self.channelNameArray = nil;
    self.channelNameArray = titles;
    if (self.channelNameArray.count == 0) return;
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self createContent];
    [self setSelectedIndex:selectIndex animated:YES];
}

#pragma mark - Getter and Setter
-(void)setChannelNameArray:(NSArray *)channelNameArray
{
    _channelNameArray = channelNameArray;
    
}

- (NSMutableArray *)channelViews
{
    if (_channelViews == nil) {
        _channelViews = [NSMutableArray array];
    }
    return _channelViews;
}

- (NSMutableArray *)channelWidths
{
    if (_channelWidths == nil) {
        _channelWidths = [NSMutableArray array];
    }
    return _channelWidths;
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
        scrollView.delegate = self;
        scrollView.scrollEnabled = !_channelStyle.contentCentered;
        _scrollView = scrollView;
    }
    return _scrollView;
}

-(UIImageView *)scrollLine
{
    if (!self.channelStyle.isShowLine) return nil;
    if (!_scrollLine) {
        UIImageView *lineView = [UIImageView new];
        lineView.backgroundColor = self.channelStyle.scrollLineColor;
        lineView.contentMode = UIViewContentModeScaleAspectFill;
        if (self.channelStyle.scrollLineImageName) {
            lineView.image = [UIImage imageNamed:self.channelStyle.scrollLineImageName];
        }
        if (self.channelStyle.scrollLinecornerRadius > 0) {
            lineView.layer.cornerRadius  = self.channelStyle.scrollLinecornerRadius;
            lineView.clipsToBounds = YES;
        }
        _scrollLine = lineView;
    }
    return _scrollLine;
}

-(UIView *)bottomLine
{
    if (!self.channelStyle.isShowBottomLine) return nil;
    if (!_bottomLine) {
        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = self.channelStyle.bottomLineBackgroundColor;
        _bottomLine = bottomLine;
    }
    return _bottomLine;
}

- (UIButton *)extraButton
{
    if (!self.channelStyle.isShowExtraButton) return nil;
    if (!_extraButton) {
        UIButton *button = [UIButton new];
        [button addTarget:self action:@selector(extraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageName = self.channelStyle.extraButtonImageName ? self.channelStyle.extraButtonImageName : @"";
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        button.backgroundColor = self.channelStyle.extraButtonBackgroundColor;
        // 设置边缘的阴影效果
        //        button.layer.shadowColor = [UIColor whiteColor].CGColor;
        //        button.layer.shadowOffset = CGSizeMake(-5, 0);
        //        button.layer.shadowOpacity = 1;
        _extraButton = button;
    }
    return _extraButton;
}

-(UIImageView *)shadowCover
{
    if (!_shadowCover) {
        UIImageView *shadowCover = [UIImageView new];
        NSString *imageName = self.channelStyle.shadowCoverImageName ? self.channelStyle.shadowCoverImageName : @"";
           shadowCover.image = [[UIImage imageWithContentsOfFile:[self.resourceBundle pathForResource:imageName ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        shadowCover.image = [UIImage zz_imageName:imageName inBundle:TGBundleHome];
        _shadowCover = shadowCover;
    }
    return _shadowCover;
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
