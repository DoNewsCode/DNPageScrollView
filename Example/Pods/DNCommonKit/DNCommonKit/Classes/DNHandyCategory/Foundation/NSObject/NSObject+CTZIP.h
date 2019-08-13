//
//  NSObject+ZZIP.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CTZIP)

/** 返回IP地址字符串 */
- (NSString *)ct_ipAddressWithShouldPreferIPv4:(BOOL)preferIPv4;

@end
