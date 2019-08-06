//
//  DNChannelScrollView.h
//  Donews
//
//  Created by Jamie on 2017/4/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DNChannelBaseView.h"

typedef void(^DNChannelScrollViewExtraBtnOnClick)(UIButton *extraBtn);

@interface DNChannelScrollView : DNChannelBaseView

// 滚动scrollView
@property (strong, nonatomic,readonly) UIScrollView *scrollView;
/** channelCenterY */
@property (nonatomic, assign,readonly) CGFloat channelCenterY;

@property (copy, nonatomic) DNChannelScrollViewExtraBtnOnClick extraButtonClickBlock;



@end
