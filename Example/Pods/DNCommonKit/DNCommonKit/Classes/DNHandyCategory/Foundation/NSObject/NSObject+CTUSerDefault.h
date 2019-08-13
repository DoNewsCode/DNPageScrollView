//
//  NSObject+USerDefault.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/23.
//  Copyright © 2018年 donews. All rights reserved.
//  UserDefault 持久化的类

#import <Foundation/Foundation.h>

@interface NSObject (CTUSerDefault)

/** 根据key持久化数据到NSUserDefault */
+ (void)ct_saveUserDefaultForKey:(NSString *)key value:(id)value;
/** 根据key持久化自定义数据到NSUserDefault */
+ (void)ct_saveUserDefaultAndArchiveForKey:(NSString *)key value:(id)value;
/** 根据key获取NSUserDefault数据 */
+ (id)ct_getUserDefaultForKey:(NSString *)key;
/** 根据key获取NSUserDefault中的自定义数据 */
+ (id)ct_getUserDefaultAndUnarchiverForKey:(NSString *)key;
/** 根据key删除数据 */
+ (void)ct_removeUserDefaultForKey:(NSString *)key;

@end
