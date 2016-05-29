//
//  KSCentralManager.m
//  BluetoothDevice
//
//  Created by Jay on 14-12-21.
//  Copyright (c) 2014年 JJ. All rights reserved.
//

#import "KSCentralManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "Config.h"
#import "KSCBPeripheral.h"


@interface KSCentralManager () <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    KSCBPeripheral *_curPeripheral;
}

@property (nonatomic, strong) NSTimer *retrieveTimer;

@end

@implementation KSCentralManager
@synthesize curPeripheral = _curPeripheral;

#pragma mark - Init

//单例
+ (KSCentralManager *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static KSCentralManager * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.central = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:nil];
    }
    return self;
}


#pragma mark - Private Methods

//如果失败 清除数据
- (void)clearUp
{
    
    if (!(self.curPeripheral.peripheral.state == CBPeripheralStateConnected)) {
        return;
    }
    
    if (self.curPeripheral.peripheral.services != nil) {
        for (CBService *s in self.curPeripheral.peripheral.services) {
            
            if (s.characteristics != nil) {
                for (CBCharacteristic *c in s.characteristics) {
                    
                    if ([c.UUID isEqual:CHARACTERSITIC_UUID_STR]) {
                        
                        //查看是否订阅了
                        if (c.isNotifying) {
                            //如果订阅了。取消订阅
                            [self.curPeripheral.peripheral setNotifyValue:NO forCharacteristic:c];
                            return;
                        }
                        
                    }
                    
                }
            }
        }
    }
    //如果我们连接了，但是没有订阅，就断开连接即可
    [self.central cancelPeripheralConnection:self.curPeripheral.peripheral];
    
}

- (void)retrieveConnect
{
    NSLog(@"开始重连设备");
    
    //iOS6方法 有回调
    //    [self.central scanForPeripheralsWithServices:nil options:nil];
    //    [self.central retrieveConnectedPeripherals];
    
    
    //    NSString *UUIDString = [[NSUserDefaults standardUserDefaults] valueForKey:UD_KEY_CUR_PERIPHERAL];
    //    NSUUID *UUID = [[NSUUID alloc] initWithUUIDString:UUIDString];
    //    [self.central retrievePeripherals:@[UUID]];
    
    //系统已经连接的设备
    
    NSArray *peripheralsArr = [self.central retrieveConnectedPeripheralsWithServices:[NSArray arrayWithObject:SERVICE_CBUUID]];
    
    
    
    
    
    for (CBPeripheral *p in peripheralsArr) {
        NSLog(@"系统已经连接的设备:%@",p.name);
        
        //         [self connectToPeripherl:p];
        //        NSDictionary *optonsDic = [NSDictionary dictionaryWithObjectsAndKeys:@YES,CBConnectPeripheralOptionNotifyOnConnectionKey, nil];
        [self.central scanForPeripheralsWithServices:nil options:nil];
        
        self.curPeripheral.peripheral = p;
        
        [self.central connectPeripheral:p options:nil];
        
        //        [self.central retrievePeripheralsWithIdentifiers:@[p.identifier]];
        
    }
    
    if(!peripheralsArr.count){
        NSLog(@"无连接的设备");
    }
    
    
}

#pragma mark - Public Methods
//开始扫描
- (void)scanForPeripherals
{
    NSLog(@"停止扫描");
    [self.central stopScan];
    
    NSLog(@"开始扫描...");
    
    //options中的意思是否允许中央设备多次收到曾经监听到的设备的消息，这样来监听外围设备联接的信号强度，以决定是否增大广播强度，为YES时会多耗电
//    [self.central scanForPeripheralsWithServices:@[SERVICE_CBUUID] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    [self.central scanForPeripheralsWithServices:nil options:nil];
}

//停止扫描
- (void)stopScanForPeripherals
{
    NSLog(@"停止扫描");
    [self.central stopScan];
}


//连接设备
- (void)connectToPeripherl:(KSCBPeripheral *)ksp
{
    CBPeripheral *p = ksp.peripheral;
    
    NSLog(@"停止扫描");
    [self.central stopScan];
    
    NSLog(@"开始连接设备... %@", p.name);
//    NSDictionary *optonsDic = [NSDictionary dictionaryWithObjectsAndKeys:@YES,CBConnectPeripheralOptionNotifyOnConnectionKey, nil];
    [self.central connectPeripheral:p options:nil];
}

//取消当前设备的连接
- (void)cancelPeripheralConnection
{
    //如果已经连接上了 就断开
    if (self.curPeripheral.peripheral.state == CBPeripheralStateConnected){
        NSLog(@"开始取消连接...");
        [self.central cancelPeripheralConnection:self.curPeripheral.peripheral];
        
    }
}

//获取被操作系统连上的设备 元素为:KSCBPeripheral
- (NSArray *)getConnectedSystemPeripherals
{
    
    NSArray *arr = [[NSArray alloc] initWithObjects:SERVICE_CBUUID, nil];
    
    NSArray *connectedArr = [self.central retrieveConnectedPeripheralsWithServices:arr];
    
    
    NSMutableArray *ksPeripheralArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (CBPeripheral *p in connectedArr) {
        KSCBPeripheral *ksP = [[KSCBPeripheral alloc] init];
        ksP.peripheral = p;
        ksP.isSystemConnected = YES;
        
        [ksPeripheralArr addObject:ksP];
    }
    
    return ksPeripheralArr;
    

}



//写数据调用方法
- (void)writeCharacterisitic:(KSCBPeripheral *)ksPeripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data
{
    CBPeripheral *peripheral = ksPeripheral.peripheral;
    
    NSLog(@"发送 %@ 到 %@",data, peripheral.name);
    
    for (CBService *service in peripheral.services)
    {
//        NSLog(@"Service %@",service.UUID);
//        NSLog(@"sUUID %@",[CBUUID UUIDWithString:sUUID]);
        if ([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]])
        {
            for (CBCharacteristic *characteristic in service.characteristics)
            {
                NSLog(@"Characteristic %@",characteristic.UUID);
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]])
                {
                    NSLog(@"找到服务中的特征 开始写数据");
                    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                }
            }
        }
    }
}

//读数据调用方法
- (void)readCharacterisitic:(KSCBPeripheral *)ksPeripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID
{
    CBPeripheral *peripheral = ksPeripheral.peripheral;
    
    NSLog(@"读 %@ 的数据", peripheral.name);
    
    for (CBService *service in peripheral.services)
    {
        //        NSLog(@"Service %@",service.UUID);
        if ([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]])
        {
            for (CBCharacteristic *charateristic  in service.characteristics)
            {
                //                NSLog(@"Charateristic %@",charateristic.UUID);
                if ([charateristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]])
                {
                    NSLog(@"找到服务中的特征 开始读数据");
                    [peripheral readValueForCharacteristic:charateristic];
                }
            }
        }
    }
}

//设置监听特征值是否改变
- (void)setNotificationForCharacterisitic:(KSCBPeripheral *)ksPeripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID enable:(BOOL)enable
{
    CBPeripheral *peripheral = ksPeripheral.peripheral;
    
    NSLog(@"%s : %@", __func__, enable?@"Enable":@"Disable");
    
    for (CBService *service in peripheral.services)
    {
        //        NSLog(@"Service %@",service.UUID);
        if ([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]])
        {
            for (CBCharacteristic *charateristic in service.characteristics)
            {
                //                NSLog(@"Characteristic %@",charateristic.UUID);
                if ([charateristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]])
                {
                    //                    NSLog(@"Found Service,Charatistic,setting notification state:%@",enable?@"Enable":@"Disable");
                    [peripheral setNotifyValue:enable forCharacteristic:charateristic];
                }
            }
        }
    }
}



#pragma mark - NSTimer


//断线重连定时器
- (void)creatRetrieveTimer
{
    NSLog(@"创建重连定时器");
    _retrieveTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(retrieveConnect) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_retrieveTimer forMode:NSDefaultRunLoopMode];
}

- (void)removeRetrieveTimer
{
    NSLog(@"移除重连定时器");
    [_retrieveTimer invalidate];
    _retrieveTimer = nil;
}





#pragma mark - CBCentralManagerDelegate
//检测中央设备状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            
            self.curPeripheral = nil;
            
            //代理
            if (_delegate && [_delegate respondsToSelector:@selector(ksCentralManagerStatePoweredOff)])
            {
                [_delegate ksCentralManagerStatePoweredOff];
            }
        }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            //这里表示蓝牙已经开启 可以进行扫描
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
            
            //代理
            if (_delegate && [_delegate respondsToSelector:@selector(ksCentralManager:canScanForPeripherals:)])
            {
                [_delegate ksCentralManager:self canScanForPeripherals:YES];
            }
            
//            [self performSelector:@selector(retrieveConnect) withObject:nil afterDelay:10];
//            [self creatRetrieveTimer];
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


//当外围设备广播同样的UUID信号被发现时，这个代理函数被调用。这时我们要监测RSSI即Received Signal Strength Indication接收的信号强度指示，确保足够近，我们才连接它
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //peripheral.name: Discovered Kisai Link.TST
    NSLog(@"发现了:%@ RSSI:%@", peripheral.name, RSSI);
    
    //代理
    if (_delegate && [_delegate respondsToSelector:@selector(ksCentralManager:displayPeripheral:)])
    {
        KSCBPeripheral *ksPeripheral = [[KSCBPeripheral alloc] initWithPeripheral:peripheral];
        [_delegate ksCentralManager:self displayPeripheral:ksPeripheral];
    }
}

//已经连上了设备
//连接上外围设备后我们就要找到外围设备的服务特性
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"已经连上了设备 %@",peripheral.name);
        
    //连接完成后，就停止检测
    [self.central stopScan];
    
    //设置为当前的设备
    self.curPeripheral.peripheral = peripheral;
    self.curPeripheral.peripheral.delegate = self;
    
    NSLog(@"设置%@为当前的设备", peripheral.name);
    
    //让外围设备找到与我们发送的UUID所匹配的服务
    //@[SERVICE_CBUUID]
    [self.curPeripheral.peripheral discoverServices:nil];
    
    //记录当前的设备
    [[NSUserDefaults standardUserDefaults] setObject:self.curPeripheral.peripheral.identifier.UUIDString forKey:UD_KEY_CUR_PERIPHERAL_UUID];
    [[NSUserDefaults standardUserDefaults] setObject:self.curPeripheral.peripheral.name forKey:UD_KEY_CUR_PERIPHERAL_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //代理
    if (_delegate && [_delegate respondsToSelector:@selector(ksCentralManager:didConnectPeripheral:)])
    {
        KSCBPeripheral *ksPeripheral = [[KSCBPeripheral alloc] initWithPeripheral:peripheral];
        ksPeripheral.isAppConnected = YES;
        
        [_delegate ksCentralManager:self didConnectPeripheral:ksPeripheral];
    }
    
}

//连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接失败: peripheral:%@", peripheral.name);
    
    if ([self.curPeripheral.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
        self.curPeripheral.peripheral = nil;
    }
}



//设备失去连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    NSLog(@"失去连接: peripheral:%@", peripheral.name);
    
    if ([self.curPeripheral.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
        self.curPeripheral.peripheral = nil;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(ksCentralManager:didDisconnectPeripheral:)]) {
        
        KSCBPeripheral *ksPeripheral = [[KSCBPeripheral alloc] initWithPeripheral:peripheral];
        
        [_delegate ksCentralManager:self didDisconnectPeripheral:ksPeripheral];
    }
    
}


//要恢复的设备
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"恢复设备");

    for (CBPeripheral *peripheral in peripherals)
    {
//        NSDictionary *connectOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey];
        
        [central connectPeripheral:peripheral options:nil];
        NSLog(@"恢复设备 :%@",peripheral.name);
    }
}

//已经恢复设备
- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"已经恢复设备");

    for (CBPeripheral *peripheral in peripherals)
    {
        
        //连接
//        NSDictionary *connectOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey];
        [central connectPeripheral:peripheral options:nil];
        NSLog(@"恢复已连接设备 :%@",peripheral.name);
    }

    
}


#pragma mark - CBPeripheralDelegate

//相当于对方的账号
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    if (error) {
        NSLog(@"错误 发现了服务:%@",error.localizedDescription);
        [self clearUp];
        return;
    }
    
    NSLog(@"发现了服务");
    
    //遍历外围设备
    for (CBService *s in peripheral.services) {
        //找到我们想要的特性
        [peripheral discoverCharacteristics:@[CHARACTERSITIC_CBUUID] forService:s];
    }
    
}


//当发现传送服务特性后我们要订阅他 来告诉外围设备我们想要这个特性所持有的数据
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"发现了特性");
    
    if (error) {
        NSLog(@"错误 发现了特性 %@",[error localizedDescription]);
        [self clearUp];
        return;
    }
    
    //检查特性
    for (CBCharacteristic *c in service.characteristics) {
        if ([c.UUID isEqual:CHARACTERSITIC_CBUUID]) {
            //有来自外围的特性，找到了，就订阅他
            // 如果第一个参数是YES的话，就是允许代理方法peripheral:didUpdateValueForCharacteristic:error: 来监听
            //第二个参数 特性值是否发生变化
            [peripheral setNotifyValue:YES forCharacteristic:c];
            //完成后，等待数据传进来
            NSLog(@"订阅成功");
            
            
            //代理
            if (_delegate && [_delegate respondsToSelector:@selector(ksCentralManager:readyToSendDataForService:withCharacteristic:)])
            {
                [_delegate ksCentralManager:self readyToSendDataForService:service withCharacteristic:c];
            }
            
        }
    }
    
}

//从Characteristic(特征)发现Descriptors(描述符)
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"从描述符发现特征");
}


//这个函数类似网络请求时候只需收到数据的那个函数
//从Characteristic(特征)更新Value  收到数据/读取数据成功调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"错误 接收到了数据 %@",error.localizedDescription);
        [self clearUp];
        return;
    }
    
    NSLog(@"特征 接收到了数据");    
    
    //代理
    if (_delegate && [_delegate respondsToSelector:@selector(ksCentralManager:didReceiveData:)])
    {
        //characteristic.value 是特性中所包含的数据
        [_delegate ksCentralManager:self didReceiveData:characteristic.value];
    }
    
}

//从Descriptor(描述符)更新 Value  收到数据/读取数据成功调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"描述符 接收到了数据");
}


//从Characteristic(特征)写Value  写数据成功调用
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if (!error) {
        NSLog(@"特征 写数据成功!!");
        
        //代理
        if (_delegate && [_delegate respondsToSelector:@selector(ksCentralManager:didWriteDataWithCharacteristic:)])
        {
            [_delegate ksCentralManager:self didWriteDataWithCharacteristic:characteristic];
        }
    }
    else{
        NSLog(@"特征 写数据失败!! : %@",error);
    }
}

//从Descriptor(描述符)写Value  写数据成功调用
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    if (!error) {
        NSLog(@"描述符 写数据失败!!");
    }
    else{
        NSLog(@"描述符 写数据失败!! : %@",error);
    }
    
}



//外围设备让我们知道，我们订阅和取消订阅是否发生
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"外围特性通知 = %@",error.localizedDescription);
//        [self clearUp];
        return;
    }
    
    //如果不是我们要特性就退出
    if (![characteristic.UUID isEqual:CHARACTERSITIC_CBUUID]) {
        return;
    }
    
    if (characteristic.isNotifying) {
        NSLog(@"外围特性通知开始");
    }else{
        NSLog(@"外围设备特性通知结束，也就是用户要下线或者离开%@",characteristic);
        //断开连接
        [self.central cancelPeripheralConnection:peripheral];
        
    }
}




#pragma mark - Property

- (void)setCurPeripheral:(KSCBPeripheral *)curPeripheral
{
    _curPeripheral = curPeripheral;
    
    //确保我们收到的外围设备连接后的回调代理函数
    _curPeripheral.peripheral.delegate = self;
}




@end






















