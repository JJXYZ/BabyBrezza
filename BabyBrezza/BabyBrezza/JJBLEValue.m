//
//  JJBLEValue.m
//  BabyBrezza
//
//  Created by Jay on 16/6/4.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "JJBLEValue.h"
#import "JJBLEConfig.h"

@implementation JJBLEValue

#pragma mark - Lifecycle

+ (JJBLEValue *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static JJBLEValue * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Public Methods

- (void)clearParam {
    self.head1 = nil;
    self.head2 = nil;
    
    self.command = nil;
    
    self.hour = nil;
    self.minute = nil;
    self.second = nil;
    
    self.number = nil;
    self.speed = nil;
    self.work = nil;
    self.temp = nil;
    
    self.var = nil;
    
    self.reserve_1 = nil;
    self.reserve_2 = nil;
    
    self.system = nil;
    
    self.flagl = nil;
}



@end
