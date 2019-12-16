//
//  DNPageOneViewController.m
//  DNPageScrollView_Example
//
//  Created by 陈金铭 on 2019/8/13.
//  Copyright © 2019 418589912@qq.com. All rights reserved.
//

#import "DNPageTwoViewController.h"

#import "DNPageScrollView.h"
#import "DNChildViewController.h"

@interface DNPageTwoViewController () <DNPageScrollViewDelegate>

@property (nonatomic, copy) NSArray *channels;

@property (nonatomic, strong) DNPageScrollView *pageScrollView;
@property (nonatomic, strong) DNPageChannelStyle *pageStyle;

@end

@implementation DNPageTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.channels = @[@"新鲜事",@"推荐"];
    [self.view addSubview:self.pageScrollView];
    UIButton *button = [UIButton new];
    button.frame = (CGRect){0.,100.,50.,50.};
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(eventButtonEventTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)eventButtonEventTouchUpInside:(UIButton *)button {
    [self.pageScrollView setSelectedIndex:0 animated:YES];
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
        _pageScrollView.tabChannelView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.07].CGColor;
        _pageScrollView.tabChannelView.layer.cornerRadius = _pageScrollView.channelView.frame.size.height * 0.5;
        _pageScrollView.tabChannelView.layer.shadowOffset = CGSizeMake(0,10.5);
        _pageScrollView.tabChannelView.layer.shadowOpacity = 1;
        _pageScrollView.tabChannelView.layer.shadowRadius = 30.5 ;
        _pageScrollView.tabChannelView.selectedTip.layer.cornerRadius = (_pageScrollView.tabChannelView.frame.size.height - _pageStyle.titleSeesawMargin * 2) * 0.5;
        
    }
    return _pageScrollView;
}

- (DNPageChannelStyle *)pageStyle {
    if (_pageStyle == nil) {
        
        _pageStyle = [DNPageChannelStyle new];
        _pageStyle.scrollLineHeight = 5.;
        _pageStyle.scrollLineWidth = 5.;
        _pageStyle.scrollLineCornerRadius = 2.5;
        _pageStyle.contentBottomMargin = 7.;
        _pageStyle.titleMargin = 37.;
        _pageStyle.titleAboutMargin = 12;
        _pageStyle.showLine = YES;
        _pageStyle.channelTextAlignment = DNPageChannelStyleChannelTextAlignmentBottom;
        _pageStyle.normalTitleColor = [UIColor colorWithRed:50/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _pageStyle.selectedTitleColor = [UIColor colorWithRed:50/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _pageStyle.channelEdge = UIEdgeInsetsMake(17., 12, 24, 12);
        _pageStyle.titleSeesawMargin = 16;
        _pageStyle.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        _pageStyle.channelFrame = (CGRect){0.,0,144,37};
        _pageStyle.titleBigScale = 1.411765;
        _pageStyle.channelBackgroundColor = [UIColor whiteColor];
        _pageStyle.scrollLineColor = [UIColor blackColor];
        _pageStyle.channleType = DNPageChannelStyleChannelTypeSymmetry;
    }
    return _pageStyle;
}

@end
