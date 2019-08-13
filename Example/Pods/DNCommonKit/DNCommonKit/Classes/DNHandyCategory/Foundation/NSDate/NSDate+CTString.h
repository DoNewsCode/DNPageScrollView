//
//  NSDate+ZZString.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CTString)


/// 将日期按照yyyy_MM_dd_HH_mm_ss字符串显示
- (NSString *)ct_stringWithyyyy_MM_dd_HH_mm_ss;
- (NSString *)ct_stringWithyyyy_MM_dd;
- (NSDate *)ct_dateWithyyyy_MM_dd;

/** 是否为今年 */
- (BOOL)ct_isThisYear;
/** 是否为明天 */
- (BOOL)ct_isTomorrow;
/** 是否为后天 */
- (BOOL)ct_isDayAfterTomorrow;
/** 是否为3-30天后 */
- (BOOL)ct_isThreeToThirtyDay;
/** 是否为今天 */
- (BOOL)ct_isToday;
/** 是否为昨天 */
- (BOOL)ct_isYesterday;
/** 是否为前天 */
- (BOOL)ct_isBeforeYesterday;
/** 是否为3-9天内 */
- (BOOL)ct_isThreeToNineDay;
/** 距离现在一个小时以内 */
- (BOOL)ct_isInAnHour;
/** 距今日的时间天数 */
- (NSInteger)ct_daysBeforToday;
/** 同一年中距本月的月份差 */
- (NSInteger)ct_mouthBeforMouth;
/** 获得与当前时间的差距*/
- (NSDateComponents *)ct_deltaWithNow;

@end
