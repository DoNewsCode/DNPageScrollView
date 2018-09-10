//
//  DNViewController.m
//  DNPageScrollView
//
//  Created by 540563689@qq.com on 09/10/2018.
//  Copyright (c) 2018 540563689@qq.com. All rights reserved.
//

#import "DNViewController.h"
#import <DNPageScrollView/DNPageScrollView.h>
#import "DNChildViewController.h"

@interface DNViewController () <DNPageScrollViewDelegate>

@property (nonatomic, strong) DNPageScrollView *pageScrollView;
@property (nonatomic, strong) DNPageChannelStyle *pageStyle;
@property (nonatomic, copy) NSArray *channels;

@end

@implementation DNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    return [[DNChildViewController alloc] init];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - Getters & Setters
- (DNPageScrollView *)pageScrollView {
    if (_pageScrollView == nil) {
        _pageScrollView = [[DNPageScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 400) style:self.pageStyle channelNames:self.channels parentViewController:self delegate:self];
        _pageScrollView.contentView.backgroundColor = [UIColor whiteColor];
        _pageScrollView.channelView.backgroundColor = [UIColor whiteColor];
    }
    return _pageScrollView;
}

- (DNPageChannelStyle *)pageStyle {
    if (_pageStyle == nil) {
        _pageStyle = [DNPageChannelStyle new];
        _pageStyle.showLine = YES;
        _pageStyle.scrollLineHeight = 4;
        _pageStyle.scrollLineWidth = 19;
        _pageStyle.scrollLinecornerRadius = 2.5;
        _pageStyle.titleMargin = 20;
        _pageStyle.scrollLineColor = [UIColor orangeColor];
        _pageStyle.titleFont = [UIFont systemFontOfSize:16];
        _pageStyle.normalTitleColor = [UIColor darkGrayColor];
        _pageStyle.selectedTitleColor = [UIColor orangeColor];
        _pageStyle.shadowCover = YES;
//        _pageStyle.shadowCoverImageName = @"icon_pagescroll";
        //        _pageStyle.showBottomLine = YES;
        //        _pageStyle.bottomLineHeight = 1;
        //        _pageStyle.bottomLineBackgroundColor = [TGColorManager sharedInstance].colorLineView;
    }
    return _pageStyle;
}

- (NSArray *)channels {
    return @[@"推荐",@"关注",@"测试",@"视频",@"推荐",@"关注",@"测试",@"视频"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
