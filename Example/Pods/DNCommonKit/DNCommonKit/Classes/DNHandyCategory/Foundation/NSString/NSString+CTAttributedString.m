//
//  NSString+CTAttributedString.m
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import "NSString+CTAttributedString.h"

@implementation NSString (CTAttributedString)

- (NSMutableAttributedString *)ct_attributedStringWithFont:(UIFont *)font range:(NSRange)range {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self];
    [attributedString addAttribute:NSFontAttributeName value:font range:range];
    
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    ////    [paragraphStyle setLineSpacing:0.5];//调整行间距
    //    paragraphStyle.paragraphSpacing = 1;
    //
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.length)];
    
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(-10) range:range];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.lineSpacing = 5;       //字间距5
    //    paragraphStyle.paragraphSpacing = 20;       //行间距是20
    paragraphStyle.alignment = NSTextAlignmentLeft;   //对齐方式为居中对齐
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    return attributedString;
}

@end
