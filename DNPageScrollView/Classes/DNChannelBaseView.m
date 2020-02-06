//
//  DNChannelBaseView.m
//  DNPageScrollView
//
//  Created by 陈金铭 on 2019/8/6.
//

#import "DNChannelBaseView.h"

@implementation DNChannelBaseView

- (instancetype)initWithFrame:(CGRect )frame channelStyle:(DNPageChannelStyle *)channelStyle channelNames:(NSArray<NSString *> *)channelNames channelDidClick:(DNChannelViewTitleClickBlock)channelDidClick
{
    self = [super initWithFrame:frame];
    if (self) {
        self.channelNameArray = channelNames.copy;
        self.channelStyle = channelStyle;
        self.channelButtonClickBlock = channelDidClick;
        _currentIndex = 0;
        _oldIndex = 0;
        _currentWidth = frame.size.width;
    }
    return self;
}

/** 切换下标的时候根据progress同步设置UI*/
- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex {}
/** 让选中的标题居中*/
- (void)adjustChannelOffSetToCurrentIndex:(NSInteger)currentIndex {}
/** 设置选中的下标*/
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {}
/** 重新刷新标题的内容*/
- (void)reloadTitlesWithNewTitles:(NSArray *)titles {}
- (void)reloadTitlesNameWithNewTitles:(NSArray *)titles selectIndex:(NSInteger)selectIndex {}
- (void)reloadTheme {}

- (void)returnSetUpTitleBlock:(DNChannelBaseViewSetUpTitleBlock)setUpTitleBlock {
    self.setUpTitleBlock = setUpTitleBlock;
}

- (void)returnChannelButtonClickBlock:(DNChannelViewTitleClickBlock)channelButtonClickBlock {
    self.channelButtonClickBlock = channelButtonClickBlock;
}

- (void)returnChannelClickBlock:(DNChannelViewTitleClickBlock)channelClickBlock {
    self.channelClickBlock = channelClickBlock;
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
