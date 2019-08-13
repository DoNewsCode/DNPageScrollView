//
//  NSString+CTAttributedString.h
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CTAttributedString)

/// 只改变字体
- (NSMutableAttributedString *)ct_attributedStringWithFont:(UIFont *)font range:(NSRange)range;


@end

NS_ASSUME_NONNULL_END
