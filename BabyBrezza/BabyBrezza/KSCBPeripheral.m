//
//  KSCBPeripheral.m
//  BluetoothDevice
//
//  Created by Jay on 15-1-10.
//  Copyright (c) 2015年 JJ. All rights reserved.
//

#import "KSCBPeripheral.h"

@implementation KSCBPeripheral

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral
{
    self = [super init];
    if (self) {
        self.isSystemConnected = NO;
        self.isAppConnected = NO;
        self.peripheral = peripheral;
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isSystemConnected = NO;
        self.isAppConnected = NO;
    }
    
    return self;
}

@end
