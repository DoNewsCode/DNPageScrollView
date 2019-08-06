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

@end
