//
//  NSData+CTHash.h
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (CTHash)

/// 将NSData进行MD5加密返回NSData
- (NSData *)ct_MD5;
/// 将NSData进行MD5加密返回NSString
- (NSString *)ct_MD5String;

@end

NS_ASSUME_NONNULL_END
