//
//  NSDictionary+CTGuard.h
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (CTGuard)
/**
 判断字典里对应key的值是否存在
 
 @param key The key.
 */
- (BOOL)ct_containsObjectForKey:(id)key;

@end


@interface NSMutableDictionary (CTGuard)

/**
 向字典插入元素
 
 @param anObject 要插入数组的value
 @param aKey 对应的key
 如果anObject为nil 则不执行插入
 */
- (void)ct_addObject:(id)anObject forKey:(id<NSCopying>)aKey;

/**
 删除字典中key对应的value
 
 @param aKey The key
 如果key对应的vlaue不存在 则不执行删除操作
 */
- (void)ct_removeObjectForKey:(id)aKey;

@end

NS_ASSUME_NONNULL_END
