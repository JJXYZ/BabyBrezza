//
//  KSCBPeripheral.h
//  BluetoothDevice
//
//  Created by Jay on 15-1-10.
//  Copyright (c) 2015年 XJ. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface KSCBPeripheral : NSObject


@property (nonatomic, strong) CBPeripheral *peripheral;

//被系统连接上的
@property (nonatomic, assign) BOOL isSystemConnected;

//被App连接上的
@property (nonatomic, assign) BOOL isAppConnected;


- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

@end
