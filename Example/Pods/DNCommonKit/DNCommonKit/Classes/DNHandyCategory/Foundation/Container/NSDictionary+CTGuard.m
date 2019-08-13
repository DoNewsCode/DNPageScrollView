//
//  NSDictionary+CTGuard.m
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import "NSDictionary+CTGuard.h"

@implementation NSDictionary (CTGuard)
- (BOOL)ct_containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

@end

@implementation NSMutableDictionary (CTGuard)

- (void)ct_addObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject) { return;}
    [self setObject:anObject forKey:aKey];
}

- (void)ct_removeObjectForKey:(id)aKey {
    if ([self ct_containsObjectForKey:aKey]) {
        [self removeObjectForKey:aKey];
    }
}

@end
