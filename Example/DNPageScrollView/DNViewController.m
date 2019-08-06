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
        _pageScrollView = [[DNPageScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 400) style:self.pageStyle channelNames:self.channels parentViewController:self delegate:self];
        _pageScrollView.backgroundColor = [UIColor whiteColor];
        _pageScrollView.symmetryChannelView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.07].CGColor;
        _pageScrollView.symmetryChannelView.layer.cornerRadius = _pageScrollView.channelView.frame.size.height * 0.5;
        _pageScrollView.symmetryChannelView.layer.shadowOffset = CGSizeMake(0,10.5);
        _pageScrollView.symmetryChannelView.layer.shadowOpacity = 1;
        _pageScrollView.symmetryChannelView.layer.shadowRadius = 30.5 ;
        _pageScrollView.symmetryChannelView.selectedTipLayer.cornerRadius = (_pageScrollView.symmetryChannelView.frame.size.height - _pageStyle.titleSeesawMargin * 2) * 0.5;
        
//        _pageScrollView.channelView.backgroundColor = [UIColor whiteColor];
//        _pageScrollView.
    }
    return _pageScrollView;
}

- (DNPageChannelStyle *)pageStyle {
    if (_pageStyle == nil) {
        
        _pageStyle = [DNPageChannelStyle new];
//        _pageStyle.contentCentered = YES;
//        _pageStyle.showChannelShadow = YES;
//        _pageStyle.showLine = YES;
//        _pageStyle.scrollTitle = YES;
        _pageStyle.scrollLineHeight = 5.;
        _pageStyle.scrollLineWidth = 5.;
        _pageStyle.scrollLinecornerRadius = 2.5;
        _pageStyle.contentBottomMargin = 7.;
        _pageStyle.titleMargin = 28.;
        _pageStyle.titleAboutMargin = 12.;
        _pageStyle.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15.];
        _pageStyle.selectedTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15.];
        _pageStyle.titleBigScale = 1.0;
        _pageStyle.channelTextAlignment = DNPageChannelStyleChannelTextAlignmentBottom;
//        _pageStyle.channleType = DNPageChannelStyleChannelTypeSymmetry;
//        _pageStyle.scrollLineColor = [UIColor orangeColor];
        _pageStyle.normalTitleColor = [UIColor colorWithRed:51./255. green:51./255. blue:51./255. alpha:1.0];
        _pageStyle.selectedTitleColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1.0];
        _pageStyle.bottomLineHeight = 1;
        _pageStyle.channelEdge = UIEdgeInsetsMake(17., 12, 24, 12);
        _pageStyle.channelHeight = 46;
        _pageStyle.channleType = DNPageChannelStyleChannelTypeSymmetry;
    }
    return _pageStyle;
}

- (NSArray *)channels {
    //,@"视频",@"推荐",@"关注",@"测试"
    return @[@"推荐",@"关注",@"测试",@"视频"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
