//
//  UIView+CTTargetAction.h
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CTTargetActionCallBackBlock)(void);

@interface UIView (CTTargetAction)

@property (nonatomic, copy) CTTargetActionCallBackBlock callBackBlock;

///  Block 形式给UIView视图添加点击手势
- (void)ct_addActionWithblock:(CTTargetActionCallBackBlock)block;
///  Target-Action 形式给UIView视图添加点击手势
- (void)ct_addTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
