//
//  DNBaseMacro.h
//  Pods
//
//  Created by donews on 2018/9/10.
//  项目里一些基本的宏

#ifndef DNBaseMacro_h
#define DNBaseMacro_h


#define YYAssertNil(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)
#define YYCAssertNil(condition, description, ...) NSCAssert(!(condition), (description), ##__VA_ARGS__)

#define YYAssertNotNil(condition, description, ...) NSAssert((condition), (description), ##__VA_ARGS__)
#define YYCAssertNotNil(condition, description, ...) NSCAssert((condition), (description), ##__VA_ARGS__)

#define YYAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
#define YYCAssertMainThread() NSCAssert([NSThread isMainThread], @"This method must be called on the main thread")


//----------------
//   Base Setting
//----------------
#define UIColorRandom ([UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1])

#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)

#define kHPercentage(a) (SCREEN_HEIGHT*((a)/667.00))
#define kWPercentage(a) (SCREEN_WIDTH *((a)/375.00))


//-------------
//   基本适配
//-------------

//判断机型
#define iphone4                         [UIScreen mainScreen].bounds.size.height==480
#define iphone5                         [UIScreen mainScreen].bounds.size.height==568
#define iphone6                         [UIScreen mainScreen].bounds.size.height==667
#define iphone6p                        [UIScreen mainScreen].bounds.size.height==736
#define iphonePlush                     [UIScreen mainScreen].bounds.size.width==414
//#define iPhoneX                         [UIScreen mainScreen].bounds.size.height==812
// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告
#define iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


// 适配iOS 11 & iPhoneX
#define DNStatuBarHeight  (iPhoneX ? 44.00 : 20.00)
#define DNNavHeight       (DNStatuBarHeight + 44)
#define DNTabbarHeight    (iPhoneX ? 83 : 49)
#define DNPageScrollHeight  44.0
#define DNStatuBarH [UIApplication sharedApplication].statusBarFrame.size.height

//顶导航+状态栏高度
#define kNAVSTATE_H (self.navigationController.navigationBar.height + [UIApplication sharedApplication].statusBarFrame.size.height)


// 适配 iOS 11 重写 adjustsScrollViewInsets
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)


///-----------------------
///  常用宏定义、预编译指令
///-----------------------

/// 判断一个对象是否为nil或null 返回YES说明对象为nil
#define DNIsNil(_ref)  (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
/// 判断字符串是否为空 返回YES说明为空
#define DNIsEmptyStr(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length]< 1 ? YES : NO )
/// 判断数组是否为空 返回YES说明为空
#define DNIsEmptyArray(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
/// 判断字典是否为空 返回YES说明为空
#define DNIsEmptyDict(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)


/// NSLog 的宏定义
#ifdef DEBUG
# define DNLog(fmt, ...) NSLog((@"\n#####%s-》%s [line %d]\n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);

#else
# define DLog(...);
# define DNLogError(...);
#endif

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

//----------
//  线程操作
//----------

//线程执行方法
#define Foreground_Begin  dispatch_async(dispatch_get_main_queue(), ^{
#define Foreground_End    });

#define Background_Begin  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{\
@autoreleasepool {
#define Background_End          }\
});


#endif /* DNBaseMacro_h */


