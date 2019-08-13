//
//  NSArray+CTGuard.m
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import "NSArray+CTGuard.h"

@implementation NSArray (CTGuard)

- (id)ct_objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

@end


@implementation NSMutableArray (CTGuard)

- (void)ct_addObject:(id)anObject {
    if (!anObject) { return;}
    [self addObject:anObject];
}

- (void)ct_addObjects:(NSArray *)objects {
    if (!objects) { return;}
    [self addObjectsFromArray:objects];
}

- (void)ct_removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

- (void)ct_removeLastObject {
    if (self.count) {
        [self removeObjectAtIndex:self.count - 1];
    }
}

- (id)ct_popFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self ct_removeFirstObject];
    }
    return obj;
}

- (id)ct_popLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self ct_removeLastObject];
    }
    return obj;
}

- (void)ct_prependObject:(id)anObject {
    if (anObject) {
        [self insertObject:anObject atIndex:0];
    }
}

- (void)ct_prependObjects:(NSArray *)objects {
    if (!objects) return;
    NSUInteger i = 0;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)ct_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject) {
        [self insertObject:anObject atIndex:index];
    }
}

- (void)ct_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for (id obj in objects) {
        [self ct_insertObject:obj atIndex:i++];
    }
}

- (void)ct_reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)ct_shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

/**
 移除数组元素
 */
- (void)ct_removeObject:(NSObject *)object{
    
    if (object) {
        
        [self removeObject:object];
        
    }
    
}


/**
 移除数组索引元素
 */
- (void)ct_removeObjectAtIndex:(NSUInteger)index{
    
    if (self.count>index) {
        
        [self removeObjectAtIndex:index];
        
    }
    
}




@end

