//
//  NSArray+CTGuard.h
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (CTGuard)

/**
 返回下标index对应的元素 当下标越界时返回nil
 功能和系统的`objectAtIndex:`一样 但是下标越界时不会崩溃
 
 @param index 元素下标
 */
- (nullable id)ct_objectOrNilAtIndex:(NSUInteger)index;

@end


/**
 `NSMutableArray` 替代提供的一些方法
 */
@interface NSMutableArray (CTGuard)

/**
 插入对象
 当插入的对象为nil时直接返回 （Release模式下）
 @param anObject 元素
 */
- (void)ct_addObject:(id)anObject;


/**
 以数组的形式插入一组对象
 当objects为nil时直接返回
 @param objects 对象数组
 
 */
- (void)ct_addObjects:(NSArray *)objects;


/**
 移除数组的第一个元素 如果元素为nil 没有任何响应
 */
- (void)ct_removeFirstObject;

/**
 移除数组最后一个元素 如果元素为nil 没有任何响应
 */
- (void)ct_removeLastObject;

/**
 移除数组的第一个元素 冰返回该元素 如果移除的元素为nil 则返会nil
 */
- (nullable id)ct_popFirstObject;

/**
 移除数组的最后一个元素 冰返回该元素 如果移除的元素为nil 则返会nil
 */
- (nullable id)ct_popLastObject;



/**
 插入元素在数组的开头位置
 
 @param anObject 要插入的元素
 如果插入的元素为nil 则没有响应
 */
- (void)ct_prependObject:(id)anObject;



/**
 插入一组元素从数组的开头位置
 
 @param objects 要插入的对象数组
 如果对象数组为nil 则没有响应
 */
- (void)ct_prependObjects:(NSArray *)objects;

- (void)ct_insertObject:(id)anObject atIndex:(NSUInteger)index;

/**
 在index的位置插入一组元素
 
 @param objects 要插入的对象数组
 content. If the objects is empty or nil, this method has no effect.
 
 @param index 下标
 如果对象数组为nil 则没有响应
 */
- (void)ct_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;

/**
 翻转数组里的元素的位置
 Example: Before @[ @1, @2, @3 ], After @[ @3, @2, @1 ].
 */
- (void)ct_reverse;

/**
 随机排序数组
 */
- (void)ct_shuffle;

/**
 移除数组元素
 */
- (void)ct_removeObject:(NSObject *)object;


/**
 移除数组索引元素
 */
- (void)ct_removeObjectAtIndex:(NSUInteger)index;

@end


NS_ASSUME_NONNULL_END
