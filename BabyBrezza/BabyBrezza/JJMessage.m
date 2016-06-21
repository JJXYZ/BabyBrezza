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


@implementation JJMessage

#pragma mark - Private Methods

#pragma mark - Public Methods


+ (void)sendSettingData {
    [self sendDataCommand:0x03 system:0x02];
}

+ (void)sendStartData {
    [self sendDataCommand:0x03 system:0x03];
}

+ (void)sendcancelData {
    [self sendDataCommand:0x02 system:0x02];
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


+ (void)receiveData:(NSData *)data {
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%02d", (dataBytes[i]) & 0xff];
            
            if (i == 0  || i == 1) {
                hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
                if (![hexStr isEqualToString:@"a5"] &&
                    ![hexStr isEqualToString:@"ff"]) {
                    *stop = YES;
                }
            }
            
            [self setValueIndex:i String:hexStr];
        }
    }];
}

+ (void)setValueIndex:(NSInteger)index String:(NSString *)hexStr {
    switch (index) {
        case 0:
            BLE_VALUE.head1 = hexStr;
            break;
        case 1:
            BLE_VALUE.head2 = hexStr;
            break;
        case 2:
            BLE_VALUE.command = hexStr;
            break;
        case 3:
            BLE_VALUE.hour = hexStr;
            break;
        case 4:
            BLE_VALUE.minute = hexStr;
            break;
        case 5:
            BLE_VALUE.second = hexStr;
            break;
        case 6:
            BLE_VALUE.number = hexStr;
            break;
        case 7:
            BLE_VALUE.speed = hexStr;
            break;
        case 8:
            BLE_VALUE.temp = hexStr;
            break;
        case 9:
            BLE_VALUE.temperature = hexStr;
            break;
        case 10:
            BLE_VALUE.var = hexStr;
            break;
        case 11:
            BLE_VALUE.reserve_1 = hexStr;
            break;
        case 12:
            BLE_VALUE.reserve_2 = hexStr;
            break;
        case 13:
            BLE_VALUE.system = hexStr;
            break;
        case 14:
            BLE_VALUE.flagl = hexStr;
            break;
        default:
            break;
    }
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
