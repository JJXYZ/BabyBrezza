//
//  JJLocalNotificationManager.m
//  BabyBrezza
//
//  Created by Jay on 16/6/19.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "JJLocalNotificationManager.h"

@implementation JJLocalNotificationManager

#pragma mark - Lifecycle

+ (JJLocalNotificationManager *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static JJLocalNotificationManager * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark - Private Methods

/** 注册APNS类型 */
- (void)settingNofitication {
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

#pragma mark - Public Methods

/** 注册本地通知 */
- (void)registerLocalNotication {
    [self settingNofitication];
    self.localNotification = [[UILocalNotification alloc] init];
}

/** 删除本地通知 */
- (void)removeLocalNotification {
    NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (int i=0; i<array.count; i++) {
        /** 取出所有通知 */
        UILocalNotification *localNotification = [array objectAtIndex:i];
        if ([[[localNotification userInfo] objectForKey:@"localNotificationKey"] isEqualToString:@"localNotificationObject"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
}

/** 添加本地通知 */
- (void)addLocalNotification {
    /** 系统默认提醒声音 */
    self.localNotification.soundName = UILocalNotificationDefaultSoundName;
    self.localNotification.alertBody = @"Brezza Success!";
    self.localNotification.timeZone = [NSTimeZone defaultTimeZone];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    [userInfo setObject:@"localNotificationObject" forKey:@"localNotificationKey"];
    self.localNotification.userInfo = userInfo;
    [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
}


@end
