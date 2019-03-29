//
//  DNChannelTitleView.m
//  Donews
//
//  Created by Jamie on 2017/4/19.
//  Copyright © 2017年 donews. All rights reserved.
//

#import "DNChannelTitleView.h"

@interface DNChannelTitleViewLabel : UILabel

@property (assign, nonatomic) DNPageChannelStyleChannelTextAlignment channelTextAlignment;
@property (nonatomic, assign) UIEdgeInsets textInsets; // 控制文字与控件边界的间距

@end

@implementation DNChannelTitleViewLabel

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    if (_channelTextAlignment == DNPageChannelStyleChannelTextAlignmentCenter) {
        [super drawTextInRect:rect];
    } else {
        [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
    }
}
@end

@interface DNChannelTitleView (){
    CGSize _titleSize;
    CGFloat _imageHeight;
    CGFloat _imageWidth;
    BOOL _isShowImage;
}
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) DNChannelTitleViewLabel *label;
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
    [UIView animateWithDuration:0.2 animations:^{
        if (self.channelTextAlignment == DNPageChannelStyleChannelTextAlignmentCenter) {
            
            self.transform = CGAffineTransformMakeScale(currentTransformSx, currentTransformSx);
        } else if (self.channelTextAlignment == DNPageChannelStyleChannelTextAlignmentBottom) {
            
            CGAffineTransform translation = CGAffineTransformMakeTranslation(0,-self.normalFrame.size.height * (currentTransformSx - 1.0) * 0.5);
            self.transform = CGAffineTransformScale(translation, currentTransformSx, currentTransformSx);
        }
        if (currentTransformSx > 1) {
            self.font = self.selectedFont;
        } else {
            self.font = self.normalFont;
        }
    }completion:^(BOOL finished) {
       
    }];
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

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGFloat margin = (frame.size.height - _titleSize.height) + (frame.size.height - _titleSize.height) * 0.5;
    _label.textInsets = UIEdgeInsetsMake(0.f, 0.f, -margin, 0.f);
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

- (DNChannelTitleViewLabel *)label {
    if (_label == nil) {
        _label = [[DNChannelTitleViewLabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (void)setChannelTextAlignment:(DNPageChannelStyleChannelTextAlignment)channelTextAlignment {
    _channelTextAlignment = channelTextAlignment;
    _label.channelTextAlignment = self.channelTextAlignment;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}


@end

