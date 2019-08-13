//
//  DNPageOneViewController.m
//  DNPageScrollView_Example
//
//  Created by 陈金铭 on 2019/8/13.
//  Copyright © 2019 418589912@qq.com. All rights reserved.
//

#import "DNPageOneViewController.h"

#import "DNPageScrollView.h"
#import "DNChildViewController.h"

@interface DNPageOneViewController () <DNPageScrollViewDelegate>

@property (nonatomic, copy) NSArray *channels;

@property (nonatomic, strong) DNPageScrollView *pageScrollView;
@property (nonatomic, strong) DNPageChannelStyle *pageStyle;

@end

@implementation DNPageOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.channels = @[@"首页",@"新鲜事",@"讨论",@"校友",@"相册",@"活动"];
    [self.view addSubview:self.pageScrollView];
}


#pragma mark - DNPageScrollViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.channels.count;
}

- (UIViewController<DNPageScrollViewChildViewControllerDelegate> *)childViewController:(UIViewController<DNPageScrollViewChildViewControllerDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    if(index == NSNotFound || index > self.channels.count - 1) {
        return nil;
    }
    if (reuseViewController == nil) {
        reuseViewController = [[DNChildViewController alloc] init];
    }
    if (index == 2) {
        reuseViewController.view.backgroundColor = [UIColor redColor];
    }
    return reuseViewController;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - Getters & Setters
- (DNPageScrollView *)pageScrollView {
    if (_pageScrollView == nil) {
        _pageScrollView = [[DNPageScrollView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 400) style:self.pageStyle channelNames:self.channels parentViewController:self delegate:self];
        _pageScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _pageScrollView;
}

- (DNPageChannelStyle *)pageStyle {
    if (_pageStyle == nil) {
        
        _pageStyle = [DNPageChannelStyle new];
        _pageStyle.scrollLineHeight = 5.;
        _pageStyle.scrollLineWidth = 5.;
        _pageStyle.contentCentered = YES;
        _pageStyle.scrollLineCornerRadius = 2.5;
        _pageStyle.contentBottomMargin = 7.;
        _pageStyle.titleMargin = 28.;
        _pageStyle.titleAboutMargin = 12.;
        _pageStyle.showLine = YES;
        _pageStyle.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15.];
        _pageStyle.selectedTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15.];
        _pageStyle.titleBigScale = 1.0;
        _pageStyle.channelTextAlignment = DNPageChannelStyleChannelTextAlignmentBottom;
        _pageStyle.normalTitleColor = [UIColor colorWithRed:51./255. green:51./255. blue:51./255. alpha:1.0];
        _pageStyle.selectedTitleColor = [UIColor redColor];
        _pageStyle.bottomLineHeight = 1;
//        _pageStyle.channelEdge = UIEdgeInsetsMake(17., 12, 24, 12);
//        _pageStyle.channelHeight = 28;
        _pageStyle.channleType = DNPageChannelStyleChannelTypeDefault;
    }
    return _pageStyle;
}

@end
