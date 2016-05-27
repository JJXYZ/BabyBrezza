//
//  UIColor+XJColor.m
//  BabyBrezza
//
//  Created by Jay on 15/10/1.
//  Copyright © 2015年 XJ. All rights reserved.
//

#import "UIColor+XJColor.h"

@implementation UIColor (XJColor)


+ (UIColor *)homeBG
{
    return [UIColor r:204 g:204 b:204 a:1];
}


+ (UIColor*)r:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}


@end
