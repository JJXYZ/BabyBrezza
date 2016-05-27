//
//  XJMessage.m
//  BabyBrezza
//
//  Created by Jay on 15/10/1.
//  Copyright © 2015年 XJ. All rights reserved.
//

#import "XJMessage.h"
#import "Config.h"
#import "KSCentralManager.h"

@implementation XJMessage


+ (void)sendData {
    
    NSLog(@"写数据");
    
    NSDate *_phoneDate = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"hh"];
    int hour = [[formatter stringFromDate:_phoneDate]intValue];
    
    [formatter setDateFormat:@"mm"];
    int minute = [[formatter stringFromDate:_phoneDate]intValue];
    
    [formatter setDateFormat:@"ss"];
    int second = [[formatter stringFromDate:_phoneDate]intValue];
    
    unsigned char send_bytes[16];
    
    send_bytes[GATT_HEAD_1] = 0xA5;
    send_bytes[GATT_HEAD_2] = 0xFF;
    send_bytes[GATT_COMMAND] = 3;
    
    send_bytes[GATT_HOUR] = hour;
    send_bytes[GATT_MINUTE] = minute;
    send_bytes[GATT_SECOND] = second;
    
    send_bytes[GATT_OZ] = 2;
    send_bytes[GATT_SPEED] = 1;
    send_bytes[GATT_WORK] = 1;
    
    send_bytes[GATT_TEMP] = 0;
    send_bytes[GATT_VAR] = 0;
    
    send_bytes[GATT_RESERVE_1] = 0;
    send_bytes[GATT_RESERVE_2] = 0;
    send_bytes[GATT_SYSTEM] = 0;
    
    int sum = 0;
    for (NSUInteger i = 1; i <= 13; i++) {
        sum += send_bytes[i];
    }
    
    send_bytes[GATT_FLAGL] = sum;

    
    NSLog(@"<GET DATA>");

    NSData *data = [NSData dataWithBytes:&send_bytes length:16];
    
    [CENTRAL_MANAGER writeCharacterisitic:CENTRAL_MANAGER.curPeripheral sUUID:SERVICE_UUID_STR cUUID:CHARACTERSITIC_UUID_STR data:data];
    
}


+ (void)receiveData:(NSData *)data
{
    NSLog(@"接收/读取数据成功:data = %@",data);
    
    if (data != nil)
    {
        int EventID = 0x00;
        int CategoryID = 0x00;
        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        switch (EventID) {
            case 0x90:
                switch (CategoryID - 0x80) {
                    case 0:
                        break;
                    case 1:
                        break;
                    case 2:
                        break;
                    case 3:
                        break;
                    default:
                        break;
                }
                
                break;
            case 0x91:
                if ( CategoryID == 0x01) {
                    
                }
                break;
            case 0x92:
            {
                [self replyBattLevel];
                
                int Battery_Vol = CategoryID * 20;
                if (Battery_Vol < 3500) {
                    [self closeCurPeripheral];
                }
                else if ( Battery_Vol <= 3600 && Battery_Vol >=3500) {
                    NSLog(@"BATTERY LOW");
                }

            }
            default:
                break;
        }
        [standardUserDefaults synchronize];
    }
}


//replyBatt设备
+ (void)replyBattLevel
{
    unsigned char send_bytes[16];

    [CENTRAL_MANAGER writeCharacterisitic:CENTRAL_MANAGER.curPeripheral sUUID:SERVICE_UUID_STR cUUID:CHARACTERSITIC_UUID_STR data:[NSData dataWithBytes:&send_bytes length:16]];
}

//关闭蓝牙设备
+ (void)closeCurPeripheral
{
    unsigned char send_bytes[16];
    
    [CENTRAL_MANAGER writeCharacterisitic:CENTRAL_MANAGER.curPeripheral sUUID:SERVICE_UUID_STR cUUID:CHARACTERSITIC_UUID_STR data:[NSData dataWithBytes:&send_bytes length:16]];
}


@end
