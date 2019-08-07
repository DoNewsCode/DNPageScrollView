//
//  DNSymmetryItemView.m
//  DNPageScrollView
//
//  Created by 陈金铭 on 2019/8/6.
//

#import "DNSymmetryItemView.h"

#import "UIView+CTLayout.h"

@implementation DNSymmetryItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel *titleLabel = [UILabel new];
//        titleLabel.backgroundColor = [UIColor redColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
//        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
}


@end
