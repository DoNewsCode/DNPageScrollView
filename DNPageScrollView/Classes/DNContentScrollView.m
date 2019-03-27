//
//  DNContentScrollView.m
//  Donews
//
//  Created by Jamie on 2017/4/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "DNContentScrollView.h"
//#import "DNDataManager.h"
//#import <SDWebImage/SDImageCache.h>
#import "DNChannelScrollView.h"
#import "UIViewController+DNPageController.h"
#import "DNPageCollectionViewFlowLayout.h"
#import "DNPageCollectionViewCell.h"
#import <DNCommonKit/UIView+Layout.h>

#define cellID @"DNPageContentCellid"

@interface DNContentScrollView ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    CGFloat _oldOffSetX;
    BOOL _isLoadFirstView;
    
}
// 父类 用于处理添加子控制器  使用weak避免循环引用
@property (weak, nonatomic) UIViewController *parentViewController;


// 当这个属性设置为YES的时候 就不用处理 scrollView滚动的计算
@property (assign, nonatomic) BOOL forbidTouchToAdjustPosition;

@property (assign, nonatomic) NSInteger itemsCount;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) NSInteger oldIndex;
@property (assign, nonatomic) BOOL changeAnimated;
@property (assign, nonatomic) BOOL needManageLifeCycle;

@property (weak, nonatomic) DNChannelScrollView *channelScrollView;
@property (nonatomic, strong) DNPageCollectionViewFlowLayout *collectionViewFlowLayout;

// 所有的子控制器
@property (strong, nonatomic) NSMutableDictionary<NSString *, UIViewController<DNPageScrollViewChildViewControllerDelegate> *> *childViewControllersDisctonary;
// 当前控制器
@property (strong, nonatomic) UIViewController<DNPageScrollViewChildViewControllerDelegate> *currentChildViewController;
@end
@implementation DNContentScrollView


///初始化方法
- (instancetype)initWithFrame:(CGRect)frame channelScrollView:(DNChannelScrollView *)channelScrollView parentViewController:(UIViewController *)parentViewController delegate:(id<DNPageScrollViewDelegate>) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.aut
        self.delegate = delegate;
        self.parentViewController = parentViewController;
        self.channelScrollView = channelScrollView;
        _needManageLifeCycle = ![parentViewController shouldAutomaticallyForwardAppearanceMethods];
        if (!_needManageLifeCycle) {
#if DEBUG
            NSLog(@"\n请注意: 如果你希望所有的子控制器的view的系统生命周期方法被正确的调用\n请重写%@的'shouldAutomaticallyForwardAppearanceMethods'方法 并且返回NO\n当然如果你不做这个操作, 子控制器的生命周期方法将不会被正确的调用\n如果你仍然想利用子控制器的生命周期方法, 请使用'DNPageScrollViewChildViewControllerDelegate'提供的代理方法\n或者'DNPageScrollViewDelegate'提供的代理方法", [parentViewController class]);
#endif
        }
        [self createContent];
        [self addNotification];
    }
    return self;
}

#pragma mark - Public

/** 给外界可以设置ContentOffSet的方法 */
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated
{
    self.forbidTouchToAdjustPosition = YES;
    NSInteger currentIndex = offset.x / self.collectionView.bounds.size.width;
    
    _oldIndex = _currentIndex;
    self.currentIndex = currentIndex;
    _changeAnimated = YES;
    if (animated) {
        CGFloat delta = offset.x - self.collectionView.contentOffset.x;
        NSInteger page = fabs(delta)/self.collectionView.bounds.size.width;
        if (page >= 2) { // 需要滚动两页以上的时候, 跳过中间页的动画
            _changeAnimated = NO;
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf.collectionView setContentOffset:offset animated:NO];
                }
            });
        }else{
            [self.collectionView setContentOffset:offset animated:animated];
        }
    }else{
        [self.collectionView setContentOffset:offset animated:animated];
    }
}
/** 给外界刷新视图的方法 */
-(void)reload
{
    [self.childViewControllersDisctonary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, UIViewController<DNPageScrollViewChildViewControllerDelegate> * _Nonnull childViewController, BOOL * _Nonnull stop) {
        [DNContentScrollView removeChildViewController:childViewController];
    }];
    self.childViewControllersDisctonary = nil;
    [self.collectionView reloadData];
    [self createContent];
}


#pragma mark - overRead
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.currentChildViewController) {
        self.currentChildViewController.view.frame = self.bounds;
    }
}

- (void)dealloc {
    self.parentViewController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)createContent
{
    _oldIndex = -1;
    _currentIndex = 0;
    _oldOffSetX = 0.0f;
    _forbidTouchToAdjustPosition = NO;
    _isLoadFirstView = YES;
    if ([_delegate respondsToSelector:@selector(numberOfChildViewControllers)]) {
        self.itemsCount = [_delegate numberOfChildViewControllers];
    }
    
    [self addSubview:self.collectionView];
    
    UINavigationController *navi = (UINavigationController *)self.parentViewController.parentViewController;
    
    if ([navi isKindOfClass:[UINavigationController class]]) {
        if (navi.viewControllers.count == 1) return;
        
        if (navi.interactivePopGestureRecognizer) {
            
            __weak typeof(self) weakSelf = self;
            [_collectionView returnScrollViewShouldBeginPanGestureHandler:^BOOL(DNPageCollectionView *collectionView, UIPanGestureRecognizer *panGesture) {
                CGFloat transionX = [panGesture translationInView:panGesture.view].x;
                if (collectionView.contentOffset.x == 0 && transionX > 0) {
                    navi.interactivePopGestureRecognizer.enabled = YES;
                }
                else {
                    navi.interactivePopGestureRecognizer.enabled = NO;
                
                }
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(scrollPageController:contentScrollView:shouldBeginPanGesture:)]) {
                    return [weakSelf.delegate scrollPageController:weakSelf.parentViewController contentScrollView:collectionView shouldBeginPanGesture:panGesture];
                }
                else return YES;
                
            }];
            
        }
    }
    
}
//监听内存警告
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWarningHander:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

//处理内存警告
- (void)receiveMemoryWarningHander:(NSNotificationCenter *)notificationCenter
{
    
    //清理图片缓存
//    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
//    [[SDImageCache sharedImageCache] clearMemory];
    
    __weak typeof(self) weakSelf = self;
    [_childViewControllersDisctonary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key,UIViewController<DNPageScrollViewChildViewControllerDelegate> * _Nonnull childViewController, BOOL * _Nonnull stop) {
        __strong typeof(self) stringSelf = weakSelf;
        if (stringSelf) {
            if (childViewController != stringSelf.currentChildViewController) {
                
                [stringSelf.childViewControllersDisctonary removeObjectForKey:key];
                [DNContentScrollView removeChildViewController:childViewController];
            }
        }
    }];
}
//移除控件中子控制器
+ (void)removeChildViewController:(UIViewController *)childViewController {
    
    [childViewController willMoveToParentViewController:nil];
    [childViewController.view removeFromSuperview];
    [childViewController removeFromParentViewController];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.forbidTouchToAdjustPosition || // 点击标题滚动
        scrollView.contentOffset.x <= 0 ||  // first or last
        scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.size.width) {
        return;
    }
    CGFloat tempProgress = scrollView.contentOffset.x / self.bounds.size.width;
    NSInteger tempIndex = tempProgress;
    
    CGFloat progress = tempProgress - floor(tempProgress);
    NSInteger deltaX = scrollView.contentOffset.x - _oldOffSetX;
    if (deltaX > 0) { //向右
        if (progress == 0.0) return;
        
        self.currentIndex = tempIndex + 1;
        self.oldIndex = tempIndex;
    }
    else if (deltaX < 0){
        progress = 1.0 - progress;
        self.oldIndex = tempIndex + 1;
        self.currentIndex = tempIndex;
        
    }
    else{
        return;
    }
    
    [self contentViewDidMoveFromIndex:_oldIndex toIndex:_currentIndex prigress:progress];
    
}

/** 滚动减速完成时再更新title的位置 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = (scrollView.contentOffset.x / self.bounds.size.width);
//    [self contentViewDidMoveFromIndex:currentIndex toIndex:currentIndex prigress:1.0];
    
    //    // 调整title
    [self adjustChannelTitleOffSetTicurrentIndex:currentIndex];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _oldIndex = scrollView.contentOffset.x / self.bounds.size.width;
    self.forbidTouchToAdjustPosition = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    UINavigationController *navigationController = (UINavigationController *)self.parentViewController.parentViewController;
    if ([navigationController isKindOfClass:[UINavigationController class]] &&
        navigationController.interactivePopGestureRecognizer) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    /** 停止拖拽时更新title位置 */
    NSInteger currentIndex = (scrollView.contentOffset.x / self.bounds.size.width);
    [self adjustChannelTitleOffSetTicurrentIndex:currentIndex];
}

#pragma mark - UICollectionViewDelegate --- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DNPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    // 移除subviews 避免重用内容显示错误
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self setupChildViewControllerForCell:cell atIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentIndex == indexPath.row) { //没有滚动完成
        
        if (_needManageLifeCycle) {
            UIViewController<DNPageScrollViewChildViewControllerDelegate> *currentViewcontroller = [self.childViewControllersDisctonary valueForKey:[NSString stringWithFormat:@"%ld",(long)_currentIndex]];
            //开始出现
            [currentViewcontroller beginAppearanceTransition:YES animated:NO];
            
            UIViewController<DNPageScrollViewChildViewControllerDelegate> *oldViewController = [self.childViewControllersDisctonary valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            //开始消失
            [oldViewController beginAppearanceTransition:YES animated:NO];
        }
        [self didApperaWithIndex:_currentIndex];
        [self didDisappearWithIndex:indexPath.row];
        
    }
    else{
        if (_oldIndex == indexPath.row) {
            //滚动完成
            if (self.forbidTouchToAdjustPosition && !_changeAnimated) {
                [self willDisappearWitnIndex:_oldIndex];
                [self didDisappearWithIndex:_oldIndex];
            }
            else{
                [self didApperaWithIndex:_currentIndex];
                [self didDisappearWithIndex:indexPath.row];
            }
        }
        else{
            //滚动没有完成又快速反向打开另一页
            if (_needManageLifeCycle) {
                UIViewController<DNPageScrollViewChildViewControllerDelegate> *currentViewController = [self.childViewControllersDisctonary valueForKey:[NSString stringWithFormat:@"%ld",(long)_oldIndex]];
                //开始出现
                [currentViewController beginAppearanceTransition:YES animated:NO];
                UIViewController<DNPageScrollViewChildViewControllerDelegate> *oldViewcontroller = [self.childViewControllersDisctonary valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                //开始消失
                [oldViewcontroller beginAppearanceTransition:NO animated:NO];
                //消失
            }
            [self didApperaWithIndex:_oldIndex];
            [self didDisappearWithIndex:indexPath.row];
        }
    }
}

- (void)setupChildViewControllerForCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    _currentChildViewController = [self.childViewControllersDisctonary valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    BOOL isFirstLoaded = _currentChildViewController == nil;
    if (_delegate &&[_delegate respondsToSelector:@selector(childViewController:forIndex:)]) {
        if (_currentChildViewController == nil) {
            _currentChildViewController = [_delegate childViewController:nil forIndex:indexPath.row];
            
            if (!_currentChildViewController ||
                ![_currentChildViewController conformsToProtocol:@protocol(DNPageScrollViewChildViewControllerDelegate)] ) {
                NSAssert(NO, @"子控制器必须遵守DNPageScrollViewChildViewControllerDelegate协议");
            }
            //设置当前下标
            _currentChildViewController.mm_currentIndex = indexPath.row;
            [self.childViewControllersDisctonary setValue:_currentChildViewController forKeyPath:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
        else{
            [_delegate childViewController:_currentChildViewController forIndex:indexPath.row];
        }
        
    }
    else {
        NSAssert(NO, @"必须设置代理和实现代理方法");
    }
    // 这里建立子控制器和父控制器的关系
    if ([_currentChildViewController isKindOfClass:[UINavigationController class]]) {
        NSAssert(NO, @"不要添加UINavigationController包装后的子控制器");
    }
    if (_currentChildViewController.mm_scrollViewController != self.parentViewController) {
        [self.parentViewController addChildViewController:_currentChildViewController];
    }
    _currentChildViewController.view.frame = self.bounds;
    [cell.contentView addSubview:_currentChildViewController.view];
    [_currentChildViewController didMoveToParentViewController:self.parentViewController];
    
    if (_isLoadFirstView) {
        
        if (self.forbidTouchToAdjustPosition && !_changeAnimated) {
            [self willAppearWithIndex:_currentIndex];
            if (isFirstLoaded) {
                if ([_currentChildViewController respondsToSelector:@selector(mm_viewDidLoadForIndex:)]) {
                    [_currentChildViewController mm_viewDidLoadForIndex:indexPath.row];
                }
            }
            [self didApperaWithIndex:_currentIndex];
        }
        else{
            [self willAppearWithIndex:indexPath.row];
            if (isFirstLoaded) {
                if ([_currentChildViewController respondsToSelector:@selector(mm_viewDidLoadForIndex:)]) {
                    [_currentChildViewController mm_viewDidLoadForIndex:indexPath.row];
                }
            }
            [self didApperaWithIndex:indexPath.row];
        }
        _isLoadFirstView = NO;
        
    }
    else{
        if (self.forbidTouchToAdjustPosition && !_changeAnimated) {
            [self willAppearWithIndex:_currentIndex];
            if (isFirstLoaded) {
                
                if ([_currentChildViewController respondsToSelector:@selector(mm_viewDidLoadForIndex:)]) {
                    [_currentChildViewController mm_viewDidLoadForIndex:indexPath.row];
                }
            }
            [self didApperaWithIndex:_currentIndex];
        }
        else{
            [self willAppearWithIndex:indexPath.row];
            if (isFirstLoaded) {
                if ([_currentChildViewController respondsToSelector:@selector(mm_viewDidLoadForIndex:)]) {
                    [_currentChildViewController mm_viewDidLoadForIndex:indexPath.row];
                }
            }
            [self willDisappearWitnIndex:_oldIndex];
        }
    }
}


#pragma mark - private

- (void)contentViewDidMoveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex prigress:(CGFloat)progress
{
    if (self.channelScrollView) {
        [self.channelScrollView adjustUIWithProgress:progress oldIndex:fromIndex currentIndex:toIndex];
    }
}

-(void)adjustChannelTitleOffSetTicurrentIndex:(NSInteger)index
{
    if (self.channelScrollView) {
        [self.channelScrollView adjustChannelOffSetToCurrentIndex:index];
    }
}

- (void)willAppearWithIndex:(NSInteger)index
{
    UIViewController<DNPageScrollViewChildViewControllerDelegate> *controller = [self.childViewControllersDisctonary valueForKey:[NSString stringWithFormat:@"%ld",(long)index]];
    if (controller) {
        if ([controller respondsToSelector:@selector(mm_viewWillAppearForIndex:)]) {
            [controller mm_viewWillAppearForIndex:index];
        }
        if (_needManageLifeCycle) {
            [controller beginAppearanceTransition:YES animated:NO];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(scrollPageController:childViewControllWillAppear:forIndex:)]) {
            [_delegate scrollPageController:self.parentViewController childViewControllWillAppear:controller forIndex:index];
        }
    }
}

- (void)didApperaWithIndex:(NSInteger)index
{
    UIViewController<DNPageScrollViewChildViewControllerDelegate> *controller = [self.childViewControllersDisctonary valueForKey:[NSString stringWithFormat:@"%ld",(long)index]];
    if (controller ) {
        if ([controller respondsToSelector:@selector(mm_viewDidAppearForIndex:)]) {
            [controller mm_viewDidAppearForIndex:index];
        }
        if (_needManageLifeCycle) {
            [controller endAppearanceTransition];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(scrollPageController:childViewControllDidAppear:forIndex:)]) {
            [_delegate scrollPageController:self.parentViewController childViewControllDidAppear:controller forIndex:index];
        }
    }
}
- (void)willDisappearWitnIndex:(NSInteger)index
{
    UIViewController<DNPageScrollViewChildViewControllerDelegate> *controller = [self.childViewControllersDisctonary valueForKey:[NSString stringWithFormat:@"%ld",(long)index]];
    if (controller) {
        if ([controller respondsToSelector:@selector(mm_viewWillDisappearForIndex:)]) {
            [controller mm_viewWillDisappearForIndex:index];
        }
        if (_needManageLifeCycle) {
            [controller beginAppearanceTransition:NO animated:NO];
            
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(scrollPageController:childViewControllWillDisappear:forIndex:)]) {
            [_delegate scrollPageController:self.parentViewController childViewControllWillDisappear:controller forIndex:index];
        }
    }
}

- (void) didDisappearWithIndex:(NSInteger)index
{
    UIViewController<DNPageScrollViewChildViewControllerDelegate> *controller = [self.childViewControllersDisctonary valueForKey:[NSString stringWithFormat:@"%ld",(long)index]];
    if (controller) {
        if ([controller respondsToSelector:@selector(mm_viewDidDisappearForIndex:)]) {
            [controller mm_viewDidDisappearForIndex:index];
        }
        if (_needManageLifeCycle) {
            [controller endAppearanceTransition];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(scrollPageController:childViewControllDidDisappear:forIndex:)]) {
            [_delegate scrollPageController:self.parentViewController childViewControllDidDisappear:controller forIndex:index];
        }
    }
}

-(void)setCurrentHeight:(CGFloat)currentHeight
{
    self.collectionViewFlowLayout.itemSize = CGSizeMake(self.collectionViewFlowLayout.itemSize.width, currentHeight);
    for (UIView *view in self.collectionView.subviews) {
        view.ct_y = 0;
    }
//    [self.collectionView ]
//    self.collectionView.bounds = self.bounds;
//    self.collectionView.y = 0;

}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    //    self.collectionView.frame = self.bounds;
    //    self.collectionViewFlowLayout.itemSize = self.bounds.size;
}

-(DNPageCollectionView *)collectionView
{
    if (!_collectionView) {
        DNPageCollectionView *collectionView = [[DNPageCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewFlowLayout];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.scrollsToTop = NO;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
        _collectionView = collectionView;
    }
    return _collectionView;
}

-(DNPageCollectionViewFlowLayout *)collectionViewFlowLayout
{
    if (!_collectionViewFlowLayout) {
        DNPageCollectionViewFlowLayout *layout = [[DNPageCollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionViewFlowLayout = layout;
    }
    return _collectionViewFlowLayout;
}

-(NSMutableDictionary<NSString *,UIViewController<DNPageScrollViewChildViewControllerDelegate> *> *)childViewControllersDisctonary
{
    if (!_childViewControllersDisctonary) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        _childViewControllersDisctonary = dict;
    }
    return _childViewControllersDisctonary;
}
@end

