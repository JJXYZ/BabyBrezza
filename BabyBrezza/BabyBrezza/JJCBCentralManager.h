//
//  JJCBCentralManager.h
//  BabyBrezza
//
//  Created by Jay on 16/6/4.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "JJCBCentralManagerDelegate.h"
#import "JJBLEConfig.h"

#define CENTRAL_MANAGER [JJCBCentralManager sharedInstance]

@interface JJCBCentralManager : NSObject

/** 单例 */
+ (JJCBCentralManager *)sharedInstance;

/** 代理 */
@property (nonatomic, weak) id <JJCBCentralManagerDelegate> delegate;

/** 中心类 */
@property (nonatomic, strong) CBCentralManager *centralManager;

/** 记录当前已经连上的设备 */
@property (nonatomic, strong) CBPeripheral *curPeripheral;

/** 是否允许自动重连 */
@property (nonatomic, assign) BOOL isAutoConnect;

/** 开始扫描 */
- (void)scan;

/** 停止扫描 */
- (void)stopScan;

/** 连接设备 */
- (void)connectToPeripherl:(CBPeripheral *)peripheral;

/** 移除重连定时器 */
- (void)removeRetrieveTimer;

/** 取消当前设备的连接 */
- (void)cancelPeripheralConnection;

/** 获取被操作系统连上的设备 元素为:CBPeripheral */
- (NSArray *)getConnectedSystemPeripherals;

/** 写数据 */
- (void)writeData:(NSData *)data;
- (void)writeCharacterisitic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data;

/** 读数据调用方法 */
- (void)readCharacterisitic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID;

/** 设置监听特征是否改变 */
- (void)setNotificationForCharacterisitic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID enable:(BOOL)enable;
@end
