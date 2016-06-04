//
//  JJCBCentralManagerDelegate.h
//  BabyBrezza
//
//  Created by Jay on 16/6/4.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JJCBCentralManager;

@protocol JJCBCentralManagerDelegate <NSObject>

@optional

/** 蓝牙不可用 */
- (void)JJCBCentralManagerStatePoweredOff;

/** 可以进行扫描 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central canScanForPeripherals:(BOOL)isScan;

/** 扫描到了设备 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central displayPeripheral:(CBPeripheral *)peripheral;

/** 已经连接了设备 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central didConnectPeripheral:(CBPeripheral *)JJPeripheral;

/** 连接失败 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)JJPeripheral;

/** 失去连接 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)JJPeripheral;

/** 订阅成功 可以收发数据 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central readyToSendDataForService:(CBService *)service withCharacteristic:(CBCharacteristic *)characteristic;

/** 接收/读取数据成功 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central didReceiveData:(NSData *)data;

/** 发送/写数据成功 */
- (void)JJCBCentralManager:(JJCBCentralManager *)central didWriteDataWithCharacteristic:(CBCharacteristic *)characteristic;

@end
