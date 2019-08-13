//
//  NSString+ZZURL.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CTURL)

- (NSDictionary *)ct_URLQueryParams;
/*
 HTML中有些图片并不能自适应大小
 如果出现这种<img style ="width = ;height= px" 这种的话 我们就没办法进行控制了
 所以我们需要把img 标签里面的style样式给替换掉
 */
+ (NSString *)ct_autoWebAutoImageSize:(NSString *)html;
@end
