//
//  UIView+CTTargetAction.m
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import "UIView+CTTargetAction.h"

#import <objc/runtime.h>

NSString const *BlockTapKey = @"BlockTapKey";
NSString const *BlockKey = @"BlockKey";

@implementation UIView (CTTargetAction)

- (void)ct_addActionWithblock:(CTTargetActionCallBackBlock)block
{
    self.touchCallBackBlock = block;
    
    self.userInteractionEnabled = YES;
    
    /**
     *  添加相同事件方法，，先将原来的事件移除，避免重复调用
     */
    NSMutableArray *taps = [self allUIViewBlockTaps];
    [taps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)obj;
        [self removeGestureRecognizer:tap];
    }];
    [taps removeAllObjects];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(invoke:)];
    [self addGestureRecognizer:tap];
    [taps addObject:tap];
}

- (void)invoke:(id)sender
{
    if(self.touchCallBackBlock) {
        self.touchCallBackBlock();
    }
}

- (void)setTouchCallBackBlock:(CTTargetActionCallBackBlock)touchCallBackBlock
{
    objc_setAssociatedObject(self, &BlockKey, touchCallBackBlock, OBJC_ASSOCIATION_COPY);
}

- (CTTargetActionCallBackBlock)touchCallBackBlock
{
    return objc_getAssociatedObject(self, &BlockKey);
}

- (void)ct_addTarget:(id)target action:(SEL)action
{
    self.userInteractionEnabled = YES;
    
    /**
     *  添加相同事件方法，，先将原来的事件移除，避免重复调用
     */
    NSMutableArray *taps = [self allUIViewBlockTaps];
    [taps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)obj;
        [self removeGestureRecognizer:tap];
    }];
    [taps removeAllObjects];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    [taps addObject:tap];
}

- (NSMutableArray *)allUIViewBlockTaps
{
    NSMutableArray *taps = objc_getAssociatedObject(self, &BlockTapKey);
    if (!taps) {
        taps = [NSMutableArray array];
        objc_setAssociatedObject(self, &BlockTapKey, taps, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return taps;
}
@end
