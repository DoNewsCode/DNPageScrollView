//
//  DNChannelView.h
//  DNPageScrollView
//
//  Created by 陈金铭 on 2019/8/4.
//

#import <UIKit/UIKit.h>

#import "DNChannelBaseView.h"


@interface DNChannelView : DNChannelBaseView

@property(nonatomic, strong) CALayer *selectedTipLayer;

// 用于懒加载计算文字的rgb差值, 用于颜色渐变的时候设置
@property (strong, nonatomic) NSArray *deltaRGB;
@property (strong, nonatomic) NSArray *selectedColorRGB;
@property (strong, nonatomic) NSArray *normalColorRGB;

@end

