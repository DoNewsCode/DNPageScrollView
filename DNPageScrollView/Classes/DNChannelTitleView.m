//
//  DNChannelTitleView.m
//  Donews
//
//  Created by Jamie on 2017/4/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "DNChannelTitleView.h"

@interface DNChannelTitleView (){
    CGSize _titleSize;
    CGFloat _imageHeight;
    CGFloat _imageWidth;
    BOOL _isShowImage;
}
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *contentView;

@end
@implementation DNChannelTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentTransformSx = 1.0;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = self.bounds;
}


- (CGFloat)channleTitleViewWidth {
    CGFloat width = 0.0f;
            width = _titleSize.width;
    return width;
}

- (void)setCurrentTransformSx:(CGFloat)currentTransformSx {
    _currentTransformSx = currentTransformSx;
    self.transform = CGAffineTransformMakeScale(currentTransformSx, currentTransformSx);
}

-(void)setFont:(UIFont *)font
{
    _font = font;
    self.label.font = font;
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.label.textColor = textColor;
}

-(void)setText:(NSString *)text
{
    _text = text;
    self.label.text = text;
    CGRect bounds = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.label.font} context:nil];
    _titleSize = bounds.size;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}


@end
