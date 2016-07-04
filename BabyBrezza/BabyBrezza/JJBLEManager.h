//
//  JJBLEManager.h
//  BabyBrezza
//
//  Created by Jay on 16/6/4.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJCBCentralManager.h"
#import "JJBLENotifyName.h"

#define BLE_MANAGER [JJBLEManager sharedInstance]

@interface JJBLEManager : NSObject

/** 单例 */
+ (JJBLEManager *)sharedInstance;

/** 持有peripheral代理 */
@property (nonatomic, strong) CBPeripheral *curDisplayPeripheral;

/** 初始化数据 */
- (void)initData;

/** 停止扫描 */
- (void)stopScan;

/** 开始扫描 */
- (void)createScanTimer;

@end
