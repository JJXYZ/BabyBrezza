//
//  JJMessage.m
//  BabyBrezza
//
//  Created by Jay on 15/10/1.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "JJMessage.h"
#import "JJBLEConfig.h"
#import "JJCBCentralManager.h"
#import "JJBLEValue.h"

@interface JJMessage ()

@property (nonatomic, strong) NSTimer *delayTimer;

@property (nonatomic, assign) int command;

@property (nonatomic, assign) int system;

@property (nonatomic, assign) BOOL isBusying;

@end

@implementation JJMessage

#pragma mark - Lifecycle

+ (JJMessage *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static JJMessage * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark - Private Methods

- (void)delaySendDataCommand:(int)command system:(int)system {
    self.isBusying = YES;
    self.command = command;
    self.system = system;
    [self createDelayTimer];
}

- (void)delaySendData {
    self.isBusying = NO;
    [JJMessage sendDataCommand:self.command system:self.system];
}


#pragma mark - NSTimer

- (void)createDelayTimer {
    [self removeDelayTimer];
    self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(delaySendData) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.delayTimer forMode:NSDefaultRunLoopMode];
}

- (void)removeDelayTimer {
    if (self.delayTimer) {
        [self.delayTimer invalidate];
        self.delayTimer = nil;
    }
}


#pragma mark - Public Methods


+ (void)sendSettingData {
    [[JJMessage sharedInstance] delaySendDataCommand:0x03 system:0x02];
}

+ (void)sendStartData {
    [JJMessage sendDataCommand:0x03 system:0x03];
}

+ (void)sendCancelData {
    [JJMessage sendDataCommand:0x02 system:0x02];
}


+ (void)sendDataCommand:(int)command system:(int)system {
    
    unsigned char send_bytes[15];
    send_bytes[GATT_HEAD_1] = 0xA5;
    send_bytes[GATT_HEAD_2] = 0xFF;
    
    send_bytes[GATT_COMMAND] = command;
    
    send_bytes[GATT_HOUR] = 0x00;
    send_bytes[GATT_MINUTE] = BLE_VALUE.minute.intValue;
    send_bytes[GATT_SECOND] = BLE_VALUE.second.intValue;
    
    send_bytes[GATT_OZ] = BLE_VALUE.number.intValue;
    send_bytes[GATT_SPEED] = BLE_VALUE.speed.intValue;
    send_bytes[GATT_WORK] = BLE_VALUE.temp.intValue;
    send_bytes[GATT_TEMP] = 0x00;
    
    send_bytes[GATT_VAR] = 0x02;
    send_bytes[GATT_RESERVE_1] = 0x00;
    send_bytes[GATT_RESERVE_2] = 0x00;
    send_bytes[GATT_SYSTEM] = system;
    
    int sum = 0;
    for (NSUInteger i = 0; i < 14; i++) {
        sum += send_bytes[i];
    }
    
    send_bytes[GATT_FLAGL] = sum;

    NSData *data = [NSData dataWithBytes:&send_bytes length:15];
        
    [CENTRAL_MANAGER writeData:data];
}

- (BOOL)receiveData:(NSData *)data {
    if (self.isBusying) {
        return NO;
    }
    
    __block BOOL isValidData = NO;
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        
        if (byteRange.length != 15) {
            return ;
        }
        
        unsigned char *dataBytes = (unsigned char *)bytes;
        
        if((dataBytes[0]!=0xa5) || (dataBytes[1]!=0xff)) {
            return ;
        }
        
        unsigned char sum = 0;
        for (NSInteger i = 0; i < byteRange.length-1; i++) {
            sum += dataBytes[i];
        }
        if (sum != dataBytes[14]) {
            return ;
        }
        
        unsigned char head1 = dataBytes[0];
        unsigned char head2 = dataBytes[1];
        unsigned char command = dataBytes[2];
        
        unsigned char hour = dataBytes[3];
        unsigned char minute = dataBytes[4];
        unsigned char second = dataBytes[5];
        
        unsigned char number = dataBytes[6];
        unsigned char speed = dataBytes[7];
        unsigned char temp = dataBytes[8];
        
        unsigned char temperature = dataBytes[9];
        unsigned char var = dataBytes[10];
        unsigned char reserve_1 = dataBytes[11];
        unsigned char reserve_2 = dataBytes[12];
        
        unsigned char system = dataBytes[13];
        unsigned char flagl = dataBytes[14];
        
        if (command == 5) {
            if (system == 2) {
                if((number == 0) && (speed == 0) && (temp == 0)) {
                    isValidData = NO;
                }
                else {
                    isValidData = YES;
                }
            }
            else if (system == 3) {
                isValidData = YES;
            }
        }
        
        if (isValidData) {
            BLE_VALUE.head1 = [NSString stringWithFormat:@"%x", head1 & 0xff];
            BLE_VALUE.head2 = [NSString stringWithFormat:@"%x", head2 & 0xff];
            BLE_VALUE.command = [NSString stringWithFormat:@"%02d", command & 0xff];
            BLE_VALUE.hour = [NSString stringWithFormat:@"%02d", hour & 0xff];
            BLE_VALUE.minute = [NSString stringWithFormat:@"%02d", minute & 0xff];
            BLE_VALUE.second = [NSString stringWithFormat:@"%02d", second & 0xff];
            BLE_VALUE.number = [NSString stringWithFormat:@"%02d", number & 0xff];
            BLE_VALUE.speed = [NSString stringWithFormat:@"%02d", speed & 0xff];
            BLE_VALUE.temp = [NSString stringWithFormat:@"%02d", temp & 0xff];
            BLE_VALUE.temperature = [NSString stringWithFormat:@"%02d", temperature & 0xff];
            BLE_VALUE.var = [NSString stringWithFormat:@"%02d", var & 0xff];
            BLE_VALUE.reserve_1 = [NSString stringWithFormat:@"%02d", reserve_1 & 0xff];
            BLE_VALUE.reserve_2 = [NSString stringWithFormat:@"%02d", reserve_2 & 0xff];
            BLE_VALUE.system = [NSString stringWithFormat:@"%02d", system & 0xff];
            BLE_VALUE.flagl = [NSString stringWithFormat:@"%02d", flagl & 0xff];
        }
    }];
    
    return isValidData;
}

+ (BOOL)receiveData:(NSData *)data {
    return [[JJMessage sharedInstance] receiveData:data];
}


//replyBatt设备
+ (void)replyBattLevel
{
    unsigned char send_bytes[16];

    [CENTRAL_MANAGER writeCharacterisitic:CENTRAL_MANAGER.curPeripheral sUUID:S_UUID cUUID:C_WRITE_UUID data:[NSData dataWithBytes:&send_bytes length:16]];
}

//关闭蓝牙设备
+ (void)closeCurPeripheral
{
    unsigned char send_bytes[16];
    
    [CENTRAL_MANAGER writeCharacterisitic:CENTRAL_MANAGER.curPeripheral sUUID:S_UUID cUUID:C_WRITE_UUID data:[NSData dataWithBytes:&send_bytes length:16]];
}




@end
