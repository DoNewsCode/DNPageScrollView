//
//  TGCustomLabel.h
//  TGBus
//
//  Created by Madjensen on 2018/8/1.
//  Copyright © 2018 Jamie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface DNCCustomLabel : UILabel

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
