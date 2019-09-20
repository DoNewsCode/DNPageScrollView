//
//  DNChannelSymmetryView.m
//  DNPageScrollView
//
//  Created by 陈金铭 on 2019/8/6.
//

#import "DNChannelSymmetryView.h"

#import "DNSymmetryItemView.h"


@interface DNChannelSymmetryView ()

/** 缓存所有标题label */
@property (nonatomic, strong) NSMutableArray<DNSymmetryItemView *> *channelViews;

@end

@implementation DNChannelSymmetryView

- (instancetype)initWithFrame:(CGRect )frame channelStyle:(DNPageChannelStyle *)channelStyle channelNames:(NSArray<NSString *> *)channelNames channelDidClick:(DNChannelViewTitleClickBlock)channelDidClick
{
    self = [super initWithFrame:frame channelStyle:channelStyle channelNames:channelNames channelDidClick:channelDidClick];
    if (self) {
        //        self.backgroundColor = [UIColor redColor];
        [self createContent];
    }
    return self;
}

- (void)createContent {
    self.clipsToBounds = YES;
    CGFloat height = self.frame.size.height - self.channelStyle.titleSeesawMargin * 2;
    CGFloat lastChannelLabelMaxX = self.channelStyle.titleAboutMargin;
    for (NSInteger i = 0; i < self.channelNameArray.count; i++) {
        NSString *name = self.channelNameArray[i];
        
//        UIView * clickView = [UIView new];
        DNSymmetryItemView *titleView = [DNSymmetryItemView new];
        titleView.titleLabel.font = self.channelStyle.titleFont;
        if (i == 0) {
            titleView.titleLabel.textColor = self.channelStyle.selectedTitleColor;
            titleView.layer.anchorPoint = CGPointMake(0, 1);
        }  else if (i == self.channelNameArray.count - 1) {
            
            titleView.titleLabel.textColor = self.channelStyle.normalTitleColor;
            titleView.layer.anchorPoint = CGPointMake(1, 1);
        } else {
            titleView.layer.anchorPoint = CGPointMake(0.5, 1);
            titleView.titleLabel.textColor = self.channelStyle.normalTitleColor;
        }
        titleView.titleLabel.text = name;
        CGSize titleSize =  [titleView.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : titleView.titleLabel.font} context:nil].size;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(channelViewClick:)];
        [titleView addGestureRecognizer:tapGesture];
        CGFloat titleViewX = lastChannelLabelMaxX;
        titleView.frame = (CGRect){titleViewX,self.channelStyle.titleSeesawMargin,titleSize.width,titleSize.height};
        titleView.titleLabel.frame = titleView.bounds;
//        titleView.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        lastChannelLabelMaxX += (titleView.ct_width + self.channelStyle.titleMargin);
        if (i == 0) {
            
            titleView.transform = CGAffineTransformMakeScale(self.channelStyle.titleBigScale, self.channelStyle.titleBigScale);
        }
        
        [self addSubview:titleView];
        [self.channelViews addObject:titleView];
        
        
    }
    if (self.channelStyle.showLine == YES) {
        self.selectedTip.backgroundColor = self.channelStyle.scrollLineColor;
        NSInteger currentIndex = self.currentIndex;
        DNSymmetryItemView *itemView = self.channelViews[currentIndex];
        self.selectedTip.ct_y = CGRectGetMaxY(self.channelViews.firstObject.frame) + self.channelStyle.titleSelectedTipMargin;
        self.selectedTip.ct_size = CGSizeMake(self.channelStyle.scrollLineWidth, self.channelStyle.scrollLineHeight);
        self.selectedTip.layer.cornerRadius = self.channelStyle.scrollLineCornerRadius;
        CGFloat centerX = itemView.ct_centerX;
        //        self.selectedTip.cen
        if (itemView.layer.anchorPoint.x == 0) {
            centerX += (itemView.ct_width * 0.5);
        } else if (itemView.layer.anchorPoint.x == 1) {
            centerX -= (itemView.ct_width * 0.5);
            
        }
        self.selectedTip.ct_centerX = centerX;
        [self addSubview:self.selectedTip];
    }
    self.channelViews.firstObject.titleLabel.textColor = self.channelStyle.selectedTitleColor;
}

- (void)createItemTitleLableFrameWithItem:(DNSymmetryItemView *)item index:(NSInteger)index {
    CGSize titleSize =  [item.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : item.titleLabel.font} context:nil].size;
    CGPoint titlePoint = CGPointZero;
    if (index == 0) {//首个
        titlePoint = CGPointMake(0, item.ct_height - titleSize.height);
    } else if (index == (self.channelNameArray.count - 1)) {//最后一个
        titlePoint = CGPointMake(item.ct_width - titleSize.width, item.ct_height - titleSize.height);
    } else {
        titlePoint = CGPointMake((item.ct_width - titleSize.width) * 0.5, item.ct_height - titleSize.height);
    }
    
    item.titleLabel.frame = (CGRect){titlePoint,titleSize};
}

- (void)channelViewClick:(UITapGestureRecognizer *)tapGesture {
    DNSymmetryItemView *titleView = (DNSymmetryItemView *)tapGesture.view;
    NSInteger index = [self.channelViews indexOfObject:titleView];
    self.currentIndex = index;
    [self adjustUIWhenBtttonClickWithAnimate:YES taped:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:self.channelStyle.notificationChannelClickName object:[NSString stringWithFormat:@"%zd",index]];
}

/** 让选中的标题居中*/
- (void)adjustChannelOffSetToCurrentIndex:(NSInteger)currentIndex {
    DNSymmetryItemView *titleView = self.channelViews[currentIndex];
    CGFloat oldChannelViewCenterX = titleView.ct_centerX;
    //        self.selectedTip.cen
    if (titleView.layer.anchorPoint.x == 0) {
        oldChannelViewCenterX += (titleView.ct_width * 0.5);
    } else if (titleView.layer.anchorPoint.x == 1) {
        oldChannelViewCenterX -= (titleView.ct_width * 0.5);
    }
    self.selectedTip.ct_centerX = oldChannelViewCenterX;
}

/** 切换下标的时候根据progress同步设置UI*/
- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex {
    if (oldIndex < 0 ||
        oldIndex >= self.channelNameArray.count ||
        currentIndex < 0 ||
        currentIndex >= self.channelNameArray.count) return;
    
    self.oldIndex = currentIndex;
    
    DNSymmetryItemView *oldChannelView = self.channelViews[oldIndex];
    DNSymmetryItemView *currentChannelView = self.channelViews[currentIndex];
    
    
    //颜色渐变
    oldChannelView.titleLabel.textColor = [UIColor colorWithRed:[self.selectedColorRGB[0] floatValue] + [self.deltaRGB[0] floatValue] * progress
                                                          green:[self.selectedColorRGB[1] floatValue] + [self.deltaRGB[1] floatValue] * progress
                                                           blue:[self.selectedColorRGB[2] floatValue] + [self.deltaRGB[2] floatValue] * progress
                                                          alpha:1.0];
    currentChannelView.titleLabel.textColor = [UIColor colorWithRed:[self.normalColorRGB[0] floatValue] - [self.deltaRGB[0] floatValue] * progress
                                                              green:[self.normalColorRGB[1] floatValue] - [self.deltaRGB[1] floatValue] * progress
                                                               blue:[self.normalColorRGB[2] floatValue] - [self.deltaRGB[2] floatValue] * progress
                                                              alpha:1.0];
    
    CGFloat oldScale = self.channelStyle.titleBigScale - (self.channelStyle.titleBigScale - 1.0) * progress;
    CGFloat currentScale = 1.0 + (self.channelStyle.titleBigScale - 1.0) * progress;
    oldChannelView.transform = CGAffineTransformMakeScale(oldScale, oldScale);
    currentChannelView.transform = CGAffineTransformMakeScale(currentScale, currentScale);
    //    CGFloat margin = ((currentChannelView.ct_x) - (oldChannelView.ct_x));
    //    CGFloat centerX = oldChannelView.ct_centerX + margin * progress;
    //
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
    self.selectedTip.ct_width = self.channelStyle.scrollLineWidth > 0 ? self.channelStyle.scrollLineWidth : (oldChannelView.ct_width + wDistance * progress);
}

- (void)adjustUIWhenBtttonClickWithAnimate:(BOOL)animated taped:(BOOL)taped
{
    if (self.currentIndex == self.oldIndex && taped) return;
    NSInteger oldIndex = self.oldIndex;
    NSInteger currentIndex = self.currentIndex;
    DNSymmetryItemView *oldChannelView = self.channelViews[oldIndex];
    DNSymmetryItemView *currentChannelView = self.channelViews[currentIndex];
    
    CGFloat animatedTime = animated ? 0.25 : 0;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateKeyframesWithDuration:animatedTime delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        oldChannelView.titleLabel.textColor = weakSelf.channelStyle.normalTitleColor;
        currentChannelView.titleLabel.textColor = weakSelf.channelStyle.selectedTitleColor;
        
        oldChannelView.transform = CGAffineTransformIdentity;
        currentChannelView.transform = CGAffineTransformMakeScale(self.channelStyle.titleBigScale, self.channelStyle.titleBigScale);;
        
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

-(UIView *)selectedTip {
    if (!_selectedTip) {
        UIView *selectedTip = [UIView new];
        //        selectedTip.backgroundColor = [UIColor grayColor];
        _selectedTip = selectedTip;
    }
    return _selectedTip;
}

- (NSMutableArray<DNSymmetryItemView *> *)channelViews
{
    if (_channelViews == nil) {
        _channelViews = [NSMutableArray<DNSymmetryItemView *> array];
    }
    return _channelViews;
}

@end
