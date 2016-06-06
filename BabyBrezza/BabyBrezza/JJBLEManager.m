//
//  JJBLEManager.m
//  BabyBrezza
//
//  Created by Jay on 16/6/4.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "JJBLEManager.h"
#import "JJMessage.h"

/** 扫描定时器时间 */
#define SCAN_TIME 30

@interface JJBLEManager () <JJCBCentralManagerDelegate>

/** 扫描定时器 */
@property (nonatomic, strong) NSTimer *scanTimer;

@end

@implementation JJBLEManager

#pragma mark - Lifecycle

+ (JJBLEManager *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static JJBLEManager * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CENTRAL_MANAGER.delegate = self;
    }
    return self;
}

#pragma mark - NSTimer

- (void)createScanTimer {
    
    [self removeScanTimer];
    
    NSLog(@"创建扫描定时器 %lu秒", (unsigned long)SCAN_TIME);
    
    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:SCAN_TIME target:self selector:@selector(timerStopScan) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.scanTimer forMode:NSDefaultRunLoopMode];
    
    [CENTRAL_MANAGER scan];
}

- (void)removeScanTimer {
    if (self.scanTimer) {
        NSLog(@"移除扫描定时器 %lu秒", (unsigned long)SCAN_TIME);
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }
}

- (void)timerStopScan {
    [self stopScan];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TimerStopScan object:nil];
}

- (void)stopScan {
    [CENTRAL_MANAGER stopScan];
    [self removeScanTimer];
}

#pragma mark - JJCBCentralManagerDelegate

/** 蓝牙不可用 */
- (void)JJCBCentralManagerStatePoweredOff {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_StatePoweredOff object:nil];
}

/** 可以进行扫描 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central canScanForPeripherals:(BOOL)isScan {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CanScanForPeripherals object:nil];
}

/** 扫描到了设备 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central displayPeripheral:(CBPeripheral *)peripheral {
    
    NSRange range = [peripheral.name rangeOfString:@"Brezza"];
    if (range.location != NSNotFound) {
        self.curDisplayPeripheral = peripheral;
        /** 取消当前设备的连接 */
        [CENTRAL_MANAGER cancelPeripheralConnection];
        /** 连接设备 */
        [CENTRAL_MANAGER connectToPeripherl:peripheral];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DisplayPeripheral object:nil];
    }
}

/** 已经连接了设备 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    [self removeScanTimer];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DidConnectPeripheral object:nil];
}

/** 连接失败 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DidFailToConnectPeripheral object:nil];
}

/** 失去连接 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DidDisconnectPeripheral object:nil];
}

/** 订阅成功 可以收发数据 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central readyToSendDataForService:(CBService *)service withCharacteristic:(CBCharacteristic *)characteristic {
    
    //订阅成功 会写一次数据   确保手机和设备数据同步
//    [JJMessage sendData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ReadyToSendData object:nil];
}

/** 接收/读取数据成功 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central didReceiveData:(NSData *)data {
    [JJMessage receiveData:data];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DidReceiveData object:nil];
}

/** 发送/写数据成功 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central didWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DidWriteData object:nil];
}

@end
