//
//  NSMutableArray+JJSafe.m
//  JJSafeDemo
//
//  Created by Jay on 15/11/10.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "NSMutableArray+JJSafe.h"

@implementation NSMutableArray (JJSafe)

- (void)safeAddObject:(id)object {
    if (object) {
        [self addObject:object];
    }
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return ;
    }
    else {
        [self removeObjectAtIndex:index];
    }
}

- (void)safeInsertObject:(id)object atIndex:(NSUInteger)index
{
    if (object == nil) {
        return ;
    }
    else if (index > self.count) {
        return ;
    }
    else {
        [self insertObject:object atIndex:index];
    }
}

- (void)safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs
{
    if (indexs == nil) {
        return ;
    }
    else if (indexs.count != objects.count ||
             indexs.firstIndex >= objects.count ||
             indexs.lastIndex >= objects.count) {
        return ;
    }
    else {
        [self insertObjects:objects atIndexes:indexs];
    }
}



@end
