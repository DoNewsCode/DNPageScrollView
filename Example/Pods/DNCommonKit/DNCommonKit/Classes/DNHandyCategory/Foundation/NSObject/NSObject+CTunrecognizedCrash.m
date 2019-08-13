//
//  NSObject+unrecognizedCrash.m
//  崩溃组件
//
//  Created by 耿森森 on 2018/6/19.
//  Copyright © 2018年 耿森森. All rights reserved.
//

#import "NSObject+CTunrecognizedCrash.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@implementation NSObject (CTunrecognizedCrash)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

// 重写消息转发方法
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    // 做一次类的判断
    if (
        [self isKindOfClass: [NSNull class]]||
        [self isKindOfClass: [NSString class]]||
        [self isKindOfClass: [NSDictionary class]]||
        [self isKindOfClass: [NSArray class]]||
        [self isKindOfClass: [NSSet class]]||
        [self isKindOfClass:[NSData class]]||
        [self isKindOfClass:[NSAttributedString class]]||
        [self isKindOfClass:[UIImage class]]||
        [self isKindOfClass:[NSCache class]]||
        [self isKindOfClass:[CALayer class]]||
        [self isKindOfClass:[NSValue class]]
        )
    {
        // 动态添加桩类 将消息转发给桩类实例
        Class class = objc_allocateClassPair(NSClassFromString(@"NSObject"),"AvoidCrashTarget",0);
        class_addMethod(class, aSelector, class_getMethodImplementation([self class], @selector(avoidCrashAction)), "@:");
        id tempObject = [[class alloc] init];
        
        return tempObject;
    }
    else
    {
        return nil;
    }
}

// 重新绑定的IMP
- (NSInteger)avoidCrashAction {
    return 0;
}

#pragma clang diagnostic pop

@end

