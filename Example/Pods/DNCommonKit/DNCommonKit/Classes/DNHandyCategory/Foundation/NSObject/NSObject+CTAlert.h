//
//  NSObject+ZZAlert.h
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (CTAlert)

/** 系统弹框 */
- (void)ct_showAlertWithTitle:(NSString *)title
                      message:(NSString *)message
              actionTitleList:(NSArray <NSString *> *)actionTitleList
                      handler:(void(^)(UIAlertAction * action, NSUInteger index))handler
                   completion:(void (^)(void))completion;

/** 系统弹框 */
- (void)ct_showAlertInputWithTitle:(NSString *)title
                           message:(NSString *)message
                   placeholderList:(NSArray <NSString *> *)placeholderList
                   actionTitleList:(NSArray <NSString *> *)actionTitleList
                           handler:(void(^)(UIAlertAction * action, UIAlertController * alertController, NSUInteger index))handler
                        completion:(void (^)(void))completion;

@end
