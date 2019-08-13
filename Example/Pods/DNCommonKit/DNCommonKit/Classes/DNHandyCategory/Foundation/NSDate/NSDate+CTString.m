//
//  NSDate+String.m
//  Gravity
//
//  Created by Ming on 2018/9/4.
//  Copyright © 2018 DoNews. All rights reserved.
//

#import "NSDate+CTString.h"

@implementation NSDate (String)


- (NSString *)ct_stringWithyyyy_MM_dd_HH_mm_ss {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:self];
}

- (NSString *)ct_stringWithyyyy_MM_dd {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:self];
}

- (NSDate *)ct_dateWithyyyy_MM_dd {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *string = [self ct_stringWithyyyy_MM_dd];
    return [dateFormatter dateFromString:string];
}


- (BOOL)ct_isThisYear {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return nowCmps.year == selfCmps.year;
}

- (BOOL)ct_isToday{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];// 获得当前时间的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];// 获得self的年月日
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

- (BOOL)ct_isYesterday {
    return  ([self ct_daysBeforToday] == 1);
}

- (BOOL)ct_isBeforeYesterday {
    return  ([self ct_daysBeforToday] == 2);
}

- (BOOL)ct_isThreeToNineDay {
    
    NSUInteger day = [self ct_daysBeforToday];
    return (day <= 9 && day >= 3);
}

- (BOOL)ct_isInAnHour {
    
    NSTimeInterval lasttimeInterval = [self timeIntervalSince1970];
    NSTimeInterval NowtimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval DistanceTime = NowtimeInterval -lasttimeInterval;
    
    if (DistanceTime < 60.0 * 60.0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)ct_daysBeforToday {
    
    NSDate *nowDate = [[NSDate date] ct_dateWithyyyy_MM_dd];  // 例如 2014-05-01
    NSDate *selfDate = [self ct_dateWithyyyy_MM_dd]; // 例如 2014-04-30
    NSCalendar *calendar = [NSCalendar currentCalendar];// 获得差距
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day;
}


- (NSInteger)ct_mouthBeforMouth {
    
    NSDate *nowDate = [[NSDate date] ct_dateWithyyyy_MM_dd];  // 例如 2014-05-01
    NSDate *selfDate = [self ct_dateWithyyyy_MM_dd]; // 例如 2014-04-30
    NSCalendar *calendar = [NSCalendar currentCalendar];// 获得差距
    NSDateComponents *cmps = [calendar components:NSCalendarUnitMonth fromDate:selfDate toDate:nowDate options:0];
    return cmps.month;
}

- (BOOL)ct_isTomorrow {
    return ([self ct_daysBeforToday] == -1);
}

- (BOOL)ct_isDayAfterTomorrow {
    return ([self ct_daysBeforToday] == -2);
}

- (BOOL)ct_isThreeToThirtyDay {
    NSUInteger day = [self ct_daysBeforToday];
    return (day <= -3 && day >= -30);
}

- (NSDateComponents *)ct_deltaWithNow {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

@end
