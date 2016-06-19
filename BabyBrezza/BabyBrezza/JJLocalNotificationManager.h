//
//  JJLocalNotificationManager.h
//  BabyBrezza
//
//  Created by Jay on 16/6/19.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJLocalNotificationManager : NSObject

@property (nonatomic, strong) UILocalNotification *localNotification;

/** 单例 */
+ (JJLocalNotificationManager *)sharedInstance;

/** 注册本地通知 */
- (void)registerLocalNotication;

/** 添加本地通知 */
- (void)addLocalNotification;

/** 删除本地通知 */
- (void)removeLocalNotification;


@end
