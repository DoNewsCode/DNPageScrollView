//
//  NSString+ZZDate.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CTDate)

/** RFC3339时间格式创建NSDate */
- (NSDate *)ct_dateFromRFC3339;
/**字符串时间戳转date*/
-(NSDate *)ct_dateFromTimeInterval;
/** 将时间戳转换成具体的时间描述 */
- (NSString *)ct_fromTimeStampToDetailDesc;
/** 将未来时间戳转换成具体的时间描述 */
- (NSString *)ct_fromTimeStampToFutureDetailDesc;


//-------------
// Class Method
//-------------
/** 获取当前时间的时间戳 */
+ (NSString *)ct_timeStampForNow ;
/** 传入秒数返回 HH:mm:ss 格式字符串 */
+ (NSString *)ct_stringHMSWithSecond:(NSUInteger)second;
/** 传入秒数返回 mm:ss 格式字符串 */
+ (NSString *)ct_stringMSWithSecond:(NSUInteger)second;
/// 传入时间戳字符串 返回 yyyy-MM-dd
+ (NSString *)ct_getDateStringWithTimeInterval:(NSString *)timeInterStr;

@end
