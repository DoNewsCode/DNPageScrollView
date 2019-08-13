//
//  NSObject+ZZAlert.m
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import "NSObject+CTAlert.h"
#import "NSObject+CTUIViewController.h"

@implementation NSObject (CTAlert)

- (void)ct_showAlertWithTitle:(NSString *)title
                      message:(NSString *)message
              actionTitleList:(NSArray<NSString *> *)actionTitleList
                      handler:(void (^)(UIAlertAction *, NSUInteger))handler
                   completion:(void (^)(void))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [actionTitleList enumerateObjectsUsingBlock:^(NSString * _Nonnull actionTitle, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:actionTitle
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                if (handler) {
                                                                    handler(action, idx);
                                                                }
                                                            }];
        alertAction.accessibilityLabel = actionTitle;
        [alertController addAction:alertAction];
    }];
    
    [self ct_presentViewController:alertController animated:YES completion:completion];
}

- (void)ct_showAlertInputWithTitle:(NSString *)title
                           message:(NSString *)message
                   placeholderList:(NSArray<NSString *> *)placeholderList
                   actionTitleList:(NSArray <NSString *> *)actionTitleList
                           handler:(void (^)(UIAlertAction *, UIAlertController *, NSUInteger))handler
                        completion:(void (^)(void))completion
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // add text field
    [placeholderList enumerateObjectsUsingBlock:^(NSString * _Nonnull placeholder, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeholder;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
    }];
    
    // add action
    [actionTitleList enumerateObjectsUsingBlock:^(NSString * _Nonnull actionTitle, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           if (handler) {
                                                               handler(action, alertController, idx);
                                                           }
                                                       }];
        action.accessibilityLabel = actionTitle;
        [alertController addAction:action];
    }];
    
    [self ct_presentViewController:alertController animated:YES completion:completion];
}

@end
