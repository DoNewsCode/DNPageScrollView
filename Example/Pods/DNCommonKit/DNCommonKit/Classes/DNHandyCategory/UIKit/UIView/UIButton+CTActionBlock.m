//
//  UIButton+CTActionBlock.m
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import "UIButton+CTActionBlock.h"

#import <objc/runtime.h>

static char overviewKey;

@implementation UIButton (CTActionBlock)

- (void)ct_handleControlEvent:(UIControlEvents)event withBlock:(CTActionBlockBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(__callActionBlock:) forControlEvents:event];
}


- (void)__callActionBlock:(id)sender {
    CTActionBlockBlock block = (CTActionBlockBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}

@end
