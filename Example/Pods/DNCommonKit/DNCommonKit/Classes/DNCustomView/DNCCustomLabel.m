//
//  TGCustomLabel.m
//  TGBus
//
//  Created by Madjensen on 2018/8/1.
//  Copyright © 2018 Jamie. All rights reserved.
//

#import "DNCCustomLabel.h"
#import "NSString+CTHeight.h"

@implementation DNCCustomLabel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.verticalAlignment = VerticalAlignmentTop;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentTop;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        //        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}
- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            //            NSLog(@"----%.2f",textRect.origin.y);
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    NSRange range = NSMakeRange(0, attributedText.length);
    NSDictionary *dic = [attributedText attributesAtIndex:0 effectiveRange:&range];
    NSMutableParagraphStyle *style = dic[NSParagraphStyleAttributeName];
    if ([attributedText.string ct_isSingleLineForLabel:self]) {
        style.lineSpacing = 0;
    }
    style.lineSpacing = 0;
    NSLog(@"%@",[style class]);
    [super setAttributedText:attributedText];
    
}
@end
