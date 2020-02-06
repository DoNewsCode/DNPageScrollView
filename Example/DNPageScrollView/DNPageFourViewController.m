//
//  DNPageOneViewController.m
//  DNPageScrollView_Example
//
//  Created by 陈金铭 on 2019/8/13.
//  Copyright © 2019 418589912@qq.com. All rights reserved.
//

#import "DNPageFourViewController.h"

#import "DNPageScrollView.h"
#import "DNChildViewController.h"

@interface DNPageFourViewController () <DNPageScrollViewDelegate>

@property (nonatomic, copy) NSArray *channels;

@property (nonatomic, strong) DNPageScrollView *pageScrollView;
@property (nonatomic, strong) DNPageChannelStyle *pageStyle;

@end

@implementation DNPageFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.channels = @[@"2019",@"2018",@"2017",@"2016",@"2015",@"2014",@"2013",@"2012",@"2011",@"2010",@"2009",@"2008",@"2007"];
    [self.view addSubview:self.pageScrollView];
}


#pragma mark - DNPageScrollViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.channels.count;
}

- (void)pageScrollow:(DNPageScrollView *)pageScrollow channelDidClickWithIndex:(NSUInteger)channelIndex {
    
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
        _pageStyle.scrollLineHeight = 35;
        _pageStyle.scrollLineCornerRadius = 17.5;
        _pageStyle.contentBottomMargin = 7.;
        _pageStyle.titleMargin = 30.;
        _pageStyle.titleAboutMargin = 17.;
        _pageStyle.showLine = YES;
        _pageStyle.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:19.];
        _pageStyle.selectedTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15.];
        _pageStyle.titleBigScale = 1.0;
        _pageStyle.channelTextAlignment = DNPageChannelStyleChannelTextAlignmentBottom;
        _pageStyle.normalTitleColor = [UIColor colorWithRed:51./255. green:51./255. blue:51./255. alpha:1.0];
        _pageStyle.selectedTitleColor = [UIColor redColor];
        _pageStyle.bottomLineHeight = 1;
        _pageStyle.channelEdge = UIEdgeInsetsMake(17., 12, 24, 12);
        _pageStyle.channelHeight = 28;
        _pageStyle.channleType = DNPageChannelStyleChannelTypeTimeLine;
        _pageStyle.centerOffset = 10;
        
    }
    return _pageStyle;
}

@end
