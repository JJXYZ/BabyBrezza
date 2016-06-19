//
//  NSString+JJSafe.m
//  JJSafeDemo
//
//  Created by Jay on 15/11/11.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "NSString+JJSafe.h"

@implementation NSString (JJSafe)

+ (id)safeStringWithString:(NSString *)string
{
    if (string) {
        return [self stringWithString:string];
    }
    else {
        return [self stringWithString:@""];
    }
}

- (id)safeInitWithString:(NSString *)aString
{
    if (aString) {
        return [self initWithString:aString];
    }
    else {
        return [self initWithString:@""];
    }
}


- (NSString *)safeSubstringFromIndex:(NSUInteger)from
{
    if (from > self.length) {
        return nil;
    }
    else {
        return [self substringFromIndex:from];
    }
}

- (NSString *)safeSubstringToIndex:(NSUInteger)to
{
    if (to > self.length) {
        return nil;
    }
    else {
        return [self substringToIndex:to];
    }
}

- (NSString *)safeSubstringWithRange:(NSRange)range
{
    if (range.location + range.length > self.length) {
        return nil;
    }
    else {
        return [self substringWithRange:range];
    }
}

- (NSRange)safeRangeOfString:(NSString *)aString
{
    if (aString) {
        return [self rangeOfString:aString];
    }
    else {
        return NSMakeRange(NSNotFound, 0);
    }
}

- (NSRange)safeRangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask
{
    if (aString) {
        return [self rangeOfString:aString options:mask];
    }
    else {
        return NSMakeRange(NSNotFound, 0);
    }
}

- (NSString *)safeStringByAppendingString:(NSString *)aString
{
    if (aString) {
        return [self stringByAppendingString:aString];
    }
    else {
        return [self stringByAppendingString:@""];
    }
}



@end
