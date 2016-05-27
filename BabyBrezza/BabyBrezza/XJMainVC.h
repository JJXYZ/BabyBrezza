//
//  XJMainVC.h
//  BabyBrezza
//
//  Created by Jay on 15/9/30.
//  Copyright © 2015年 XJ. All rights reserved.
//

#import "XJBaseVC.h"

#define MAIN_VC [XJMainVC sharedInstance]

@interface XJMainVC : XJBaseVC

//单例 git test
+ (XJMainVC *)sharedInstance;

- (IBAction)clickScanBtn:(id)sender;

@end
