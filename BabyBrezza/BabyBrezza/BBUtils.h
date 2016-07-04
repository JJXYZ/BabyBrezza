//
//  BBUtils.h
//  BabyBrezza
//
//  Created by Jay on 16/5/30.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>


#define VAGRounded_FONT(FONTSIZE)    [UIFont fontWithName:@"VAGRounded-Light" size:FONTSIZE]

@interface BBUtils : NSObject

+ (id)getI4:(id)i4 i5:(id)i5 i6:(id)i6 i6p:(id)i6p;

+ (CGFloat)getFloatI4:(CGFloat)i4 i5:(CGFloat)i5 i6:(CGFloat)i6 i6p:(CGFloat)i6p;

+ (NSString *)convertDataToHexStr:(NSData *)data;

@end
