//
//  JJCBCentralManager.m
//  BabyBrezza
//
//  Created by Jay on 16/6/4.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "JJCBCentralManager.h"

@interface JJCBCentralManager () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) NSTimer *retrieveTimer;

@end

@implementation JJCBCentralManager

#pragma mark - Lifecycle

+ (JJCBCentralManager *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static JJCBCentralManager * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:nil];
    }
    return self;
}

#pragma mark - NSTimer

- (void)creatRetrieveTimer {
    [self removeRetrieveTimer];
    NSLog(@"创建重连定时器");
    _retrieveTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(retrieveConnect) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_retrieveTimer forMode:NSDefaultRunLoopMode];
}

- (void)removeRetrieveTimer {
    if (_retrieveTimer) {
        NSLog(@"移除重连定时器");
        [_retrieveTimer invalidate];
        _retrieveTimer = nil;
    }
}

#pragma mark - Private Methods
/** 记录当前的设备 */
- (void)saveCurPeripheral {
    [[NSUserDefaults standardUserDefaults] setObject:self.curPeripheral.identifier.UUIDString forKey:UD_KEY_CUR_PERIPHERAL_UUID];
    [[NSUserDefaults standardUserDefaults] setObject:self.curPeripheral.name forKey:UD_KEY_CUR_PERIPHERAL_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 如果失败 清除数据 */
- (void)clearUp {
    
    if (self.curPeripheral.state != CBPeripheralStateConnected) {
        return;
    }
    
    for (CBService *s in self.curPeripheral.services) {
        for (CBCharacteristic *c in s.characteristics) {
            if ([c.UUID.UUIDString isEqualToString:C_NOTIFY_UUID]) {
                if (c.isNotifying) {
                    /** 如果订阅了,取消订阅 */
                    [self.curPeripheral setNotifyValue:NO forCharacteristic:c];
                    return;
                }
            }
        }
    }
    /** 如果我们连接了，但是没有订阅，就断开连接即可 */
    [self.centralManager cancelPeripheralConnection:self.curPeripheral];
}

- (void)retrieveConnect
{
    NSLog(@"开始重连设备...");
    
    /**
     *  iOS6方法 有回调
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        [self.centralManager retrieveConnectedPeripherals];
        NSString *UUIDString = [[NSUserDefaults standardUserDefaults] valueForKey:UD_KEY_CUR_PERIPHERAL];
        NSUUID *UUID = [[NSUUID alloc] initWithUUIDString:UUIDString];
        [self.centralManager retrievePeripherals:@[UUID]];
     */
    
    /** 系统已经连接的设备 */
    NSArray *peripheralsArr = [self getConnectedSystemPeripherals];
    
    if(!peripheralsArr.count){
        NSLog(@"无系统连接的设备");
    }
    
    for (CBPeripheral *p in peripheralsArr) {
        NSLog(@"系统已经连接的设备:%@",p.name);
        /**
         *  NSDictionary *optonsDic = [NSDictionary dictionaryWithObjectsAndKeys:@YES,CBConnectPeripheralOptionNotifyOnConnectionKey, nil];
         */
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        self.curPeripheral = p;
        
        /**
         *  [self.centralManager retrievePeripheralsWithIdentifiers:@[p.identifier]];
         */
        [self.centralManager connectPeripheral:p options:nil];
    }
}

#pragma mark - Public Methods
/** 开始扫描 */
- (void)scan
{
    NSLog(@"停止扫描");
    [self.centralManager stopScan];
    
    NSLog(@"开始扫描...");
    /**
     *  options中的意思是否允许中央设备多次收到曾经监听到的设备的消息，这样来监听外围设备联接的信号强度，以决定是否增大广播强度，为YES时会多耗电
        [self.centralManager scanForPeripheralsWithServices:@[SERVICE_CBUUID] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
     */
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

/** 停止扫描 */
- (void)stopScan
{
    NSLog(@"停止扫描");
    [self.centralManager stopScan];
}

/** 连接设备 */
- (void)connectToPeripherl:(CBPeripheral *)peripheral {
    
    NSLog(@"停止扫描");
    [self.centralManager stopScan];
    
    NSLog(@"开始连接设备... %@", peripheral.name);
    /**
     *  NSDictionary *optonsDic = [NSDictionary dictionaryWithObjectsAndKeys:@YES,CBConnectPeripheralOptionNotifyOnConnectionKey, nil];
     */
    [self.centralManager connectPeripheral:peripheral options:nil];
}

/** 取消当前设备的连接 */
- (void)cancelPeripheralConnection
{
    /** 如果已经连接上了 就断开 */
    if (self.curPeripheral.state == CBPeripheralStateConnected) {
        NSLog(@"开始取消连接...");
        [self.centralManager cancelPeripheralConnection:self.curPeripheral];
    }
}

/** 获取被操作系统连上的设备 元素为:CBPeripheral */
- (NSArray *)getConnectedSystemPeripherals {
    NSArray *serviceUUIDs = [[NSArray alloc] initWithObjects:S_UUID, nil];
    NSArray *peripheralArr = [self.centralManager retrieveConnectedPeripheralsWithServices:serviceUUIDs];
    return peripheralArr;
}

/** 写数据调用方法 */
- (void)writeData:(NSData *)data {
    
    NSLog(@"发送 %@ 到 %@", data, self.curPeripheral.name);
    for (CBService *s in self.curPeripheral.services) {
        for (CBCharacteristic *c in s.characteristics) {
            if ([c.UUID.UUIDString isEqualToString:C_WRITE_UUID]) {
                NSLog(@"找到服务中的特征 开始写数据 %@", c);
                [self.curPeripheral writeValue:data forCharacteristic:c type:CBCharacteristicWriteWithResponse];
            }
        }
    }
}

- (void)writeCharacterisitic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data {
    
    NSLog(@"发送 %@ 到 %@", data, peripheral.name);
    for (CBService *s in peripheral.services) {
        if ([s.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for (CBCharacteristic *c in s.characteristics) {
                if ([c.UUID isEqual:[CBUUID UUIDWithString:cUUID]]) {
                    NSLog(@"找到服务中的特征 开始写数据 %@", c);
                    [peripheral writeValue:data forCharacteristic:c type:CBCharacteristicWriteWithResponse];
                }
            }
        }
    }
}

/** 读数据调用方法 */
- (void)readCharacterisitic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID {
    
    NSLog(@"读 %@ 的数据", peripheral.name);
    for (CBService *s in peripheral.services) {
        if ([s.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for (CBCharacteristic *characteristic  in s.characteristics) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]]) {
                    NSLog(@"找到服务中的特征 开始读数据 %@", characteristic);
                    [peripheral readValueForCharacteristic:characteristic];
                }
            }
        }
    }
}

/** 设置监听特征值是否改变 */
- (void)setNotificationForCharacterisitic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID enable:(BOOL)enable {
    
    NSLog(@"设置监听特征值 %d", enable);
    
    for (CBService *s in peripheral.services) {
        if ([s.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for (CBCharacteristic *c in s.characteristics) {
                if ([c.UUID isEqual:[CBUUID UUIDWithString:cUUID]]) {
                    NSLog(@"找到服务中的特征 设置监听特征值 %@ %d", c, enable);
                    [peripheral setNotifyValue:enable forCharacteristic:c];
                }
            }
        }
    }
}


#pragma mark - CBCentralManagerDelegate
/** 检测中央设备状态 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            self.curPeripheral = nil;
            if (_delegate && [_delegate respondsToSelector:@selector(JJCBCentralManagerStatePoweredOff)]) {
                [_delegate JJCBCentralManagerStatePoweredOff];
            }
        }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            /** 这里表示蓝牙已经开启 可以进行扫描 */
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
            if (_delegate && [_delegate respondsToSelector:@selector(JJCBCentralManager:canScanForPeripherals:)]) {
                [_delegate JJCBCentralManager:self canScanForPeripherals:YES];
            }
        }
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CoreBluetooth BLE hardware is resetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE hardware is unauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CoreBluetooth BLE hardware is unknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
            break;
        default:
            break;
    }
}

/** 后台完成一些蓝牙相关的任务，同步你的应用程序的状态 */
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    NSLog(@"centralManager:willRestoreState:");
}

/** 当外围设备广播同样的UUID信号被发现时，这个代理函数被调用。这时我们要监测RSSI即Received Signal Strength Indication接收的信号强度指示，确保足够近，我们才连接它 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"发现了:%@ RSSI:%@", peripheral.name, RSSI);
    if (_delegate && [_delegate respondsToSelector:@selector(JJCBCentralManager:displayPeripheral:)]) {
        [_delegate JJCBCentralManager:self displayPeripheral:peripheral];
    }
}


/**
 *  已经连上了设备
    连接上外围设备后我们就要找到外围设备的服务特性
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"已经连上了设备 %@",peripheral.name);
    /** 连接完成后，就停止检测 */
    [self.centralManager stopScan];
    /** 设置为当前的设备 */
    self.curPeripheral = peripheral;
    self.curPeripheral.delegate = self;
    /** 记录当前的设备 */
    [self saveCurPeripheral];
    
    if (_delegate && [_delegate respondsToSelector:@selector(JJCBCentralManager:didConnectPeripheral:)]) {
        [_delegate JJCBCentralManager:self didConnectPeripheral:peripheral];
    }
    
    /** 让外围设备找到与我们发送的UUID所匹配的服务 例:@[SERVICE_CBUUID] */
    NSLog(@"%@ 查找服务...", peripheral.name);
    [self.curPeripheral discoverServices:nil];
}

/** 连接失败 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"连接失败: peripheral:%@", peripheral.name);
    if ([self.curPeripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
        self.curPeripheral = nil;
    }
}

/** 设备失去连接 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"失去连接: peripheral:%@", peripheral.name);
    
    if ([self.curPeripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
        self.curPeripheral = nil;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(JJCBCentralManager:didDisconnectPeripheral:)]) {
        [_delegate JJCBCentralManager:self didDisconnectPeripheral:peripheral];
    }
}

#pragma mark - CBPeripheralDelegate

/** 相当于对方的账号 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    if (error) {
        NSLog(@"Wrong Discover Services:%@",error.localizedDescription);
        return;
    }
    
    NSLog(@"发现了服务");
    
    /** 遍历外围设备 */
    for (CBService *s in peripheral.services) {
        NSLog(@"查找服务中的特性... %@", s);
        /** @[CHARACTERSITIC_CBUUID] */
        [peripheral discoverCharacteristics:nil forService:s];
    }
}


/** 当发现传送服务特性后我们要订阅他 来告诉外围设备我们想要这个特性所持有的数据 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"Wrong Discover Characteristics %@",[error localizedDescription]);
        return;
    }
    
    NSLog(@"发现了服务中的特性 %@", service);
    
    /** 遍历特性 */
    for (CBCharacteristic *c in service.characteristics) {
        /** 判断是否是特性 [c.UUID isEqual:CHARACTERSITIC_CBUUID] */
        /** 有来自外围的特性，找到了，就订阅他
            1.如果第一个参数是YES的话，就是允许代理方法peripheral:didUpdateValueForCharacteristic:error: 来监听
            2.第二个参数 特性值是否发生变化
            NSLog(@"订阅特性...");
            [peripheral setNotifyValue:YES forCharacteristic:c];
         
            获取特征对应的描述
            [peripheral discoverDescriptorsForCharacteristic:c];
         
             NSLog(@"读取特性的值 %@", c);
             [peripheral readValueForCharacteristic:c];
         */

        if ([c.UUID.UUIDString isEqualToString:C_NOTIFY_UUID]) {
            NSLog(@"订阅特性... %@ %@", service, c);
            [peripheral setNotifyValue:YES forCharacteristic:c];
            
            if (_delegate && [_delegate respondsToSelector:@selector(JJCBCentralManager:readyToSendDataForService:withCharacteristic:)]) {
                [_delegate JJCBCentralManager:self readyToSendDataForService:service withCharacteristic:c];
            }
        }
    }
}

/** 从Characteristic(特征)发现Descriptors(描述符) */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"从描述符发现特征");
}

/** 这个函数类似网络请求时候只需收到数据的那个函数 
    从Characteristic(特征)更新Value  收到数据/读取数据成功调用
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Wrong Did Update Value Characteristic %@ %@", characteristic.UUID.UUIDString, error.localizedDescription);
        return;
    }
    
    NSLog(@"特征 接收到了数据 %@", characteristic);

    if (_delegate && [_delegate respondsToSelector:@selector(JJCBCentralManager:didReceiveData:)]) {
        /** characteristic.value 是特性中所包含的数据 */
        [_delegate JJCBCentralManager:self didReceiveData:characteristic.value];
    }
}

/** 从Descriptor(描述符)更新 Value  收到数据/读取数据成功调用 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    NSLog(@"描述符 接收到了数据");
}


/** 从Characteristic(特征)写Value  写数据成功调用 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"特征 写数据失败!! : %@",error);
        return;
    }
    
    NSLog(@"特征 写数据成功!! %@", characteristic);
    if (_delegate && [_delegate respondsToSelector:@selector(JJCBCentralManager:didWriteDataWithCharacteristic:)]) {
        [_delegate JJCBCentralManager:self didWriteDataWithCharacteristic:characteristic];
    }
}

/** 从Descriptor(描述符)写Value  写数据成功调用 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    if (error) {
        NSLog(@"描述符 写数据失败!! : %@",error);
    }
    else {
        NSLog(@"描述符 写数据失败!!");
    }
}

/** 外围设备让我们知道，我们订阅和取消订阅是否发生 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"外围特性通知 %@ %@", characteristic, error.localizedDescription);
        return;
    }
    
    /** 是否是我们要的特性
        [characteristic.UUID isEqual:CHARACTERSITIC_CBUUID]
     */
    
    if (characteristic.isNotifying) {
        NSLog(@"外围特性通知开始 %@", characteristic);
    }else{
        NSLog(@"外围设备特性通知结束，也就是用户要下线或者离开 %@",characteristic);
        /** 断开连接 */
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

@end
