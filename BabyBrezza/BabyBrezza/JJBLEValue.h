//
//  JJBLEValue.h
//  BabyBrezza
//
//  Created by Jay on 16/6/4.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import <Foundation/Foundation.h>


#define BLE_VALUE [JJBLEValue sharedInstance]

@interface JJBLEValue : NSObject

/** 单例 */
+ (JJBLEValue *)sharedInstance;

@property (nonatomic, strong) NSString *head1;
@property (nonatomic, strong) NSString *head2;

@property (nonatomic, strong) NSString *command;

@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *minute;
@property (nonatomic, strong) NSString *second;

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *speed;
@property (nonatomic, strong) NSString *temp;
@property (nonatomic, strong) NSString *temperature;

@property (nonatomic, strong) NSString *var;

@property (nonatomic, strong) NSString *reserve_1;
@property (nonatomic, strong) NSString *reserve_2;

@property (nonatomic, strong) NSString *system;

/** 校验和 */
@property (nonatomic, strong) NSString *flagl;



/** 发送的校验和 */
@property (nonatomic, strong) NSString *startFlagl;


- (void)playNotiSound;

- (NSString *)getTime;
- (NSString *)getTimeWithNumber:(NSUInteger)number temp:(NSUInteger)temp speed:(NSUInteger)speed;

@end

