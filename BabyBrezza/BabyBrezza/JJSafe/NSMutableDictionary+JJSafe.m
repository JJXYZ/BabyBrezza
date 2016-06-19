//
//  NSMutableDictionary+JJSafe.m
//  JJSafeDemo
//
//  Created by Jay on 15/11/10.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "NSMutableDictionary+JJSafe.h"

@implementation NSMutableDictionary (JJSafe)

+ (instancetype)safeDictionaryWithDictionary:(NSDictionary *)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return [self dictionaryWithDictionary:dic];
    }
    else {
        return nil;
    }
}

- (void)safeSetObject:(id)aObj forKey:(id<NSCopying>)aKey
{
    if (aObj && aKey && ![aObj isKindOfClass:[NSNull class]]) {
        [self setObject:aObj forKey:aKey];
    }
}

- (void)safeRemoveObjectForKey:(id<NSCopying>)aKey {
    if (aKey) {
        [self removeObjectForKey:aKey];
    }
}


@end
