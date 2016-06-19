//
//  NSString+JJSafe.h
//  JJSafeDemo
//
//  Created by Jay on 15/11/11.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JJSafe)

+ (id)safeStringWithString:(NSString *)string;

- (id)safeInitWithString:(NSString *)aString;

- (NSString *)safeSubstringFromIndex:(NSUInteger)from;

- (NSString *)safeSubstringToIndex:(NSUInteger)to;

- (NSString *)safeSubstringWithRange:(NSRange)range;

- (NSRange)safeRangeOfString:(NSString *)aString;

- (NSRange)safeRangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask;

- (NSString *)safeStringByAppendingString:(NSString *)aString;

@end
