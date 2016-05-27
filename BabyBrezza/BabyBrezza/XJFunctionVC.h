//
//  XJFunctionVC.h
//  BabyBrezza
//
//  Created by Jay on 15/10/1.
//  Copyright © 2015年 XJ. All rights reserved.
//

#import "XJBaseVC.h"

#define FUNC_VC [XJFunctionVC sharedInstance]

@interface XJFunctionVC : XJBaseVC

//单例
+ (XJFunctionVC *)sharedInstance;

@end
