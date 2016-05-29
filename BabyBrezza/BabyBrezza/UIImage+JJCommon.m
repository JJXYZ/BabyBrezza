//
//  UIImage+JJCommon.m
//  BabyBrezza
//
//  Created by Jay on 16/5/29.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "UIImage+JJCommon.h"

@implementation UIImage (JJCommon)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    if (!color) {
        return nil;
    }
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
