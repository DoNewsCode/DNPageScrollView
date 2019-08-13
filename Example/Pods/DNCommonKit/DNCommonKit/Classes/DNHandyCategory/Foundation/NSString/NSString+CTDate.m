//
//  NSString+ZZDate.m
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import "NSString+CTDate.h"
#import "NSDate+CTString.h"

@implementation NSString (CTDate)


- (NSDate *)ct_dateFromRFC3339 {
    NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    rfc3339DateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS";
    //    rfc3339DateFormatter.timeZone = [NSTimeZone systemTimeZone];
    //    rfc3339DateFormatter.locale = [NSLocale currentLocale];
    NSDate *result = [rfc3339DateFormatter dateFromString:self];
    return result;
}

/**字符串时间戳转date*/
-(NSDate *)ct_dateFromTimeInterval{
    
    NSTimeInterval interval = [self doubleValue]; // 把时间戳转化成时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
    
}



- (NSString *)ct_fromTimeStampToDetailDesc {
    
    if (!self || [self length] == 0 ) { // 字符串为空判断
        return @"";
    }
    NSTimeInterval interval;
    if (self.length == 13) {
        interval = [self doubleValue] / 1000.0;
    }else{
        interval = [self doubleValue]; // 把时间戳转化成时间
    }
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    
    NSDateFormatter *dFM = [[NSDateFormatter alloc] init];
    dFM.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    NSDate *createDate = [dFM dateFromString:timeStr];// 获取具体时间
    if (createDate.ct_isThisYear) {//是今年
        if (createDate.ct_isToday) {//是今天
            NSDateComponents *components = [createDate ct_deltaWithNow];
            
            if (components.hour > 1) {//至少是一小时前发的
                return [NSString stringWithFormat:@"%zd小时前 ",components.hour];
            } else if (components.minute >= 1){//1~59分钟之前发的
                return [NSString stringWithFormat:@"%zd分钟前 ",components.minute];
            } else{//1分钟内发的
                return @"刚刚";
            }
        } else if (createDate.ct_isYesterday) {//z昨天
            dFM.dateFormat = @"昨天 HH:mm";
            return [dFM stringFromDate:createDate];
            
        } else if (createDate.ct_isBeforeYesterday) {//前天
            dFM.dateFormat = @"前天 HH:mm";
            return [dFM stringFromDate:createDate];
        } else if (createDate.ct_isThreeToNineDay) {//三至九天内
            
            return [NSString stringWithFormat:@"%zd天前",createDate.ct_daysBeforToday];
        } else {//十天前
            dFM.dateFormat = @"MM月dd日";
            return [dFM stringFromDate:createDate];
        }
    } else {//非今年
        dFM.dateFormat = @"yyyy年MM月dd日";
        return [dFM stringFromDate:createDate];
    }
}

/*
 使用倒计时方式
 三天以内的用 今天、明天、后天
 3-30天的用 3天后……30天后
 30天以上的用 1个月后，2个月后
 次年的用 20XX年
 */
- (NSString *)ct_fromTimeStampToFutureDetailDesc {
    
    if (!self || [self length] == 0 ) { // 字符串为空判断
        return @"";
    }
    
    NSTimeInterval interval;
    if (self.length == 13) {
        interval = [self doubleValue] / 1000.0;
    }else{
        interval = [self doubleValue]; // 把时间戳转化成时间
    }
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    
    NSDateFormatter *dFM = [[NSDateFormatter alloc] init];
    dFM.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    NSDate *createDate = [dFM dateFromString:timeStr];// 获取具体时间
    
    if (createDate.ct_isThisYear) {//是今年
        if (createDate.ct_isToday) {//是今天
            return @"今天";
        } else if (createDate.ct_isTomorrow) {//明天
            return @"明天";
        } else if (createDate.ct_isDayAfterTomorrow) {
            return @"后天";
        } else if (createDate.ct_isThreeToThirtyDay) {
            return [NSString stringWithFormat:@"%zd天后",-createDate.ct_daysBeforToday];
        } else {
            return [NSString stringWithFormat:@"%zd个月后",-createDate.ct_mouthBeforMouth];
        }
    } else {//非今年
        dFM.dateFormat = @"yyyy年";
        return [dFM stringFromDate:createDate];
    }
}

//-------------
// Class Method
//-------------
+ (NSString *)ct_getDateStringWithTimeInterval:(NSString *)timeInterStr
{
    
    NSDate *dates = [NSDate dateWithTimeIntervalSince1970:[timeInterStr doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone =[NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSString *loctime=[formatter stringFromDate:dates];
    return  loctime;
}


+ (NSString *)ct_stringHMSWithSecond:(NSUInteger)second {
    
    NSString *str_hour = [NSString stringWithFormat:@"%02ld", second / 3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (second % 3600) / 60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld", second % 60];
    return [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute, str_second];
}

+ (NSString *)ct_stringMSWithSecond:(NSUInteger)second {
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", second / 60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld", second % 60];
    return [NSString stringWithFormat:@"%@:%@", str_minute, str_second];
}


+ (NSString *)ct_timeStampForNow {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];
    return timeString;
}

@end
