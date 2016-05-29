//
//  KSCentralManager.h
//  BluetoothDevice
//
//  Created by Jay on 14-12-21.
//  Copyright (c) 2014年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "KSCentralManagerDelegate.h"

#define CENTRAL_MANAGER [KSCentralManager sharedInstance]

@class KSCBPeripheral;

//中心管理类
@interface KSCentralManager : NSObject

//单例
+ (KSCentralManager *)sharedInstance;

//代理
@property (nonatomic, weak) id <KSCentralManagerDelegate> delegate;

//中心类
@property (nonatomic, strong) CBCentralManager *central;

//记录当前已经连上的设备
@property (nonatomic, strong) KSCBPeripheral *curPeripheral;


//开始扫描
- (void)scanForPeripherals;

//停止扫描
- (void)stopScanForPeripherals;

//连接设备
- (void)connectToPeripherl:(KSCBPeripheral *)ksPeripheral;

//取消当前设备的连接
- (void)cancelPeripheralConnection;

//获取被操作系统连上的设备 元素为:KSCBPeripheral
- (NSArray *)getConnectedSystemPeripherals;

//写数据调用方法
- (void)writeCharacterisitic:(KSCBPeripheral *)ksPeripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data;

//读数据调用方法
- (void)readCharacterisitic:(KSCBPeripheral *)ksPeripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID;

//设置监听特征是否改变
- (void)setNotificationForCharacterisitic:(KSCBPeripheral *)ksPeripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID enable:(BOOL)enable;

@end
