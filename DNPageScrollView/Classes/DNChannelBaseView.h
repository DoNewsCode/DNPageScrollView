//
//  DNChannelBaseView.h
//  DNPageScrollView
//
//  Created by 陈金铭 on 2019/8/6.
//

#import <UIKit/UIKit.h>

#import "DNChannelTitleView.h"
#import "DNPageChannelStyle.h"



typedef void(^DNChannelViewTitleClickBlock)(NSInteger index);

typedef void(^DNChannelBaseViewSetUpTitleBlock)(UIView *titleView, NSInteger index);

@interface DNChannelBaseView : UIView

@property (nonatomic, copy ) NSArray *channelNameArray;
/** 必须设置代理并且实现相应的方法*/
//@property(weak, nonatomic) id<DNPageScrollViewDelegate> delegate;

@property (nonatomic, strong) DNPageChannelStyle *channelStyle;

// 响应标题点击
@property (copy, nonatomic) DNChannelViewTitleClickBlock channelButtonClickBlock;
// 响应标题点击
@property (copy, nonatomic) DNChannelBaseViewSetUpTitleBlock setUpTitleBlock;

@property(nonatomic, assign) CGFloat currentWidth;
@property(nonatomic, assign) CGFloat currentIndex;
@property(nonatomic, assign) CGFloat oldIndex;

// 用于懒加载计算文字的rgb差值, 用于颜色渐变的时候设置
@property (strong, nonatomic) NSArray *deltaRGB;
@property (strong, nonatomic) NSArray *selectedColorRGB;
@property (strong, nonatomic) NSArray *normalColorRGB;

- (NSArray *)getColorRgb:(UIColor *)color;

- (instancetype)initWithFrame:(CGRect )frame channelStyle:(DNPageChannelStyle *)channelStyle channelNames:(NSArray<NSString *> *)channelNames channelDidClick:(DNChannelViewTitleClickBlock)channelDidClick;

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

- (void)returnSetUpTitleBlock:(DNChannelBaseViewSetUpTitleBlock)setUpTitleBlock;
- (void)returnChannelButtonClickBlock:(DNChannelViewTitleClickBlock)channelButtonClickBlock;

@end


