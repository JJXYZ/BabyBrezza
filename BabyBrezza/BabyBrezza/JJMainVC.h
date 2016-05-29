//
//  JJMainVC.h
//  BabyBrezza
//
//  Created by Jay on 15/9/30.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "JJRootVC.h"

#define MAIN_VC [JJMainVC sharedInstance]

@interface JJMainVC : JJRootVC

//单例 git test
+ (JJMainVC *)sharedInstance;

- (void)clickScanBtn:(id)sender;

@end
