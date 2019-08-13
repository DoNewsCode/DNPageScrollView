//
//  NSString+CTAdd.m
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import "NSString+CTAdd.h"

@implementation NSString (CTAdd)

+ (instancetype)ct_commentCountStringWithCount:(NSUInteger)count {
    float temp = count / 1000.0;
    if (temp >= 1) {
        return [NSString stringWithFormat:@"%.1fk",temp];
    }
    return [NSString stringWithFormat:@"%lu",(unsigned long)count];
}

- (instancetype)ct_substringWithRange:(NSRange)range{
#ifdef DEBUG
    if (self.length >=(range.location + range.length)) {
        
        return [self substringWithRange:range];
        
    }
    return nil;
#elif
    return [self substringWithRange:range];
#endif
    return nil;
}

@end
