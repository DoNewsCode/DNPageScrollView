//
//  DNPageOneViewController.m
//  DNPageScrollView_Example
//
//  Created by 陈金铭 on 2019/8/13.
//  Copyright © 2019 418589912@qq.com. All rights reserved.
//

#import "DNPageThreeViewController.h"

#import "DNPageScrollView.h"
#import "DNChildViewController.h"

@interface DNPageThreeViewController () <DNPageScrollViewDelegate>

@property (nonatomic, copy) NSArray *channels;

@property (nonatomic, strong) DNPageScrollView *pageScrollView;
@property (nonatomic, strong) DNPageChannelStyle *pageStyle;

@end

@implementation DNPageThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.channels = @[@"首页",@"新鲜事"];
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
        _pageScrollView.tabChannelView.backgroundColor = [UIColor yellowColor];
        _pageScrollView.tabChannelView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.07].CGColor;
        _pageScrollView.tabChannelView.layer.cornerRadius = _pageScrollView.tabChannelView.frame.size.height * 0.5;
        _pageScrollView.tabChannelView.layer.shadowOffset = CGSizeMake(0,10.5);
        _pageScrollView.tabChannelView.layer.shadowOpacity = 1;
        _pageScrollView.tabChannelView.layer.shadowRadius = 30.5 ;
        _pageScrollView.tabChannelView.selectedTip.backgroundColor = [UIColor grayColor];
    }
    return _pageScrollView;
}

- (DNPageChannelStyle *)pageStyle {
    if (_pageStyle == nil) {
        
        _pageStyle = [DNPageChannelStyle new];
        _pageStyle.scrollLineHeight = 34;
        _pageStyle.scrollLineWidth = 5.;
        _pageStyle.scrollLineCornerRadius = 2.5;
        _pageStyle.selectedTipCornerRadius = 17;
        _pageStyle.contentBottomMargin = 7.;
        _pageStyle.titleMargin = 28.;
        _pageStyle.titleAboutMargin = 12.;
        _pageStyle.showLine = YES;
        _pageStyle.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15.];
        _pageStyle.selectedTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15.];
        _pageStyle.titleBigScale = 1.0;
        _pageStyle.channelTextAlignment = DNPageChannelStyleChannelTextAlignmentBottom;
//        _pageStyle.channelBackgroundColor = [UIColor yellowColor];
        _pageStyle.normalTitleColor = [UIColor colorWithRed:51./255. green:51./255. blue:51./255. alpha:1.0];
        _pageStyle.selectedTitleColor = [UIColor redColor];
        _pageStyle.bottomLineHeight = 1;
        _pageStyle.channelEdge = UIEdgeInsetsMake(17., 12, 24, 12);
        _pageStyle.channelInnerEdge = UIEdgeInsetsMake(0, 12, 0, 12);
        _pageStyle.channelHeight = 46;
        _pageStyle.channleType = DNPageChannelStyleChannelTypeTab;
    }
    return _pageStyle;
}

@end
