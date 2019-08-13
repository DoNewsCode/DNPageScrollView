//
//  NSObject+USerDefault.m
//  ZZHandyCategory
//
//  Created by donews on 2018/7/23.
//  Copyright © 2018年 donews. All rights reserved.
//

#import "NSObject+CTUSerDefault.h"

@implementation NSObject (CTUSerDefault)

+ (void)ct_saveUserDefaultForKey:(NSString *)key value:(id)value {
    if (!value) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)ct_saveUserDefaultAndArchiveForKey:(NSString *)key value:(id)value {
    if (!value) {
        return;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    if (!data) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)ct_getUserDefaultForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (id)ct_getUserDefaultAndUnarchiverForKey:(NSString *)key {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!data) {
        return nil;
    }
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return obj;
}

+ (void)ct_removeUserDefaultForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
