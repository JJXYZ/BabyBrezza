//
//  AppDelegate.m
//  BabyBrezza
//
//  Created by Jay on 15/9/30.
//  Copyright © 2015年 XJ. All rights reserved.
//

#import "AppDelegate.h"
#import "XJMainVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:MAIN_VC];
    
    return YES;
}


@end
