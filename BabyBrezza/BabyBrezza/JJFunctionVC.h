//
//  JJFunctionVC.h
//  BabyBrezza
//
//  Created by Jay on 15/10/1.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "JJRootVC.h"

#define FUNC_VC [JJFunctionVC sharedInstance]

@interface JJFunctionVC : JJRootVC

//单例
+ (JJFunctionVC *)sharedInstance;

@end
