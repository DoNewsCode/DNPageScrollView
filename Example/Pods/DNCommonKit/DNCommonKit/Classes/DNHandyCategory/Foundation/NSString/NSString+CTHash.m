//
//  NSString+ZZHash.m
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import "NSString+CTHash.h"
#import "NSData+CTHash.h"

@implementation NSString (CTHash)

- (NSData *)ct_MD5
{
    NSData *inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [inputData ct_MD5];
}

- (NSString *)ct_MD5String
{
    NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [inputData ct_MD5String];
}

@end
