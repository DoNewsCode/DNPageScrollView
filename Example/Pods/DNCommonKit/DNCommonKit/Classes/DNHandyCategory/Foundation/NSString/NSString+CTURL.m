//
//  NSString+ZZURL.m
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import "NSString+CTURL.h"

@implementation NSString (CTURL)

- (NSDictionary *)ct_URLQueryParams
{
    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *components = [self componentsSeparatedByString:@"&"];
    [components enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSArray *param = [obj componentsSeparatedByString:@"="];
            if ([param count] == 2) {
                NSString *key = param[0];
                NSString *encodedValue = param[1];
                
                NSString *decodeString = [encodedValue stringByRemovingPercentEncoding];
                resultDictionary[key] = decodeString;
            }
        }
    }];
    return resultDictionary;
}


// 自适应尺寸大小
+ (NSString *)ct_autoWebAutoImageSize:(NSString *)html
{
    NSString * regExpStr = @"<img\\s+.*?\\s+(style\\s*=\\s*.+?\")";
    NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:regExpStr options:NSRegularExpressionCaseInsensitive error:nil];

    NSArray *matches=[regex matchesInString:html
                                    options:0
                                      range:NSMakeRange(0, [html length])];


    NSMutableArray * mutArray = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSString* group1 = [html substringWithRange:[match rangeAtIndex:1]];
        [mutArray addObject: group1];
    }

    NSUInteger len = [mutArray count];
    for (int i = 0; i < len; ++ i) {
        html = [html stringByReplacingOccurrencesOfString:mutArray[i] withString: @"style=\"width:100%; height:auto;\""];
    }

    return html;
}

@end
