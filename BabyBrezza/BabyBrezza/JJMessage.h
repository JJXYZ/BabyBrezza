//
//  JJMessage.h
//  BabyBrezza
//
//  Created by Jay on 15/10/1.
//  Copyright © 2015年 XJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJMessage : NSObject

+ (void)sendData;

+ (void)receiveData:(NSData *)data;

//replyBatt设备
+ (void)replyBattLevel;

//关闭蓝牙设备
+ (void)closeCurPeripheral;

@end
