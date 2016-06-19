//
//  AppDelegate.m
//  BabyBrezza
//
//  Created by Jay on 15/9/30.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "AppDelegate.h"
#import "JJMainVC.h"
#import "JJRootNC.h"
#import "JJLocalNotificationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self appDidFinishLaunchingUI];
    
    /** 获取所有Central管理器对象的恢复标识: 
     NSArray *centralManagerIdentifiers = launchOptions[UIApplicationLaunchOptionsBluetoothCentralsKey];
     */
    
    [[JJLocalNotificationManager sharedInstance] registerLocalNotication];
    
    return YES;
}

#pragma mark - Private Methods
- (void)appDidFinishLaunchingUI {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[JJRootNC alloc] initWithRootViewController:MAIN_VC];
}

@end
