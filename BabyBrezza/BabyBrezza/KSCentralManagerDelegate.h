//
//  KSCentralManagerDelegate.h
//  BluetoothDevice
//
//  Created by Jay on 14-12-22.
//  Copyright (c) 2014年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSCentralManager;
@class KSCBPeripheral;

@protocol KSCentralManagerDelegate <NSObject>


@optional

/** 蓝牙不可用 */
- (void)ksCentralManagerStatePoweredOff;

/** 可以进行扫描 */
- (void)ksCentralManager:(KSCentralManager *)central canScanForPeripherals:(BOOL)isScan;

/** 扫描到了设备 */
- (void)ksCentralManager:(KSCentralManager *)central displayPeripheral:(KSCBPeripheral *)peripheral;

/** 已经连接了设备 */
- (void)ksCentralManager:(KSCentralManager *)central didConnectPeripheral:(KSCBPeripheral *)ksPeripheral;

/** 连接失败 */
- (void)ksCentralManager:(KSCentralManager *)central didFailToConnectPeripheral:(KSCBPeripheral *)ksPeripheral;

/** 失去连接 */
- (void)ksCentralManager:(KSCentralManager *)central didDisconnectPeripheral:(KSCBPeripheral *)ksPeripheral;

/** 订阅成功 可以收发数据 */
- (void)ksCentralManager:(KSCentralManager *)central readyToSendDataForService:(CBService *)service withCharacteristic:(CBCharacteristic *)characteristic;

/** 接收/读取数据成功 */
- (void)ksCentralManager:(KSCentralManager *)central didReceiveData:(NSData *)data;

/** 发送/写数据成功 */
- (void)ksCentralManager:(KSCentralManager *)central didWriteDataWithCharacteristic:(CBCharacteristic *)characteristic;

@end
