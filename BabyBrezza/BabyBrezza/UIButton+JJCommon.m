//
//  UIButton+JJCommon.m
//  BabyBrezza
//
//  Created by Jay on 16/5/29.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "UIButton+JJCommon.h"
#import "UIImage+JJCommon.h"

@implementation UIButton (JJCommon)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor] forState:state];
}

@end
