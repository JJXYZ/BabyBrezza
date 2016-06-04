//
//  BBUtils.m
//  BabyBrezza
//
//  Created by Jay on 16/5/30.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "BBUtils.h"

@implementation BBUtils


+ (id)getI4:(id)i4 i5:(id)i5 i6:(id)i6 i6p:(id)i6p{
    id i = IS_IPHONE5 ? i5 : (IS_IPHONE6 ? i6 : (IS_IPHONE6_PLUS ? i6p : i4));
    return i;
}

+ (CGFloat)getFloatI4:(CGFloat)i4 i5:(CGFloat)i5 i6:(CGFloat)i6 i6p:(CGFloat)i6p {
    CGFloat i = IS_IPHONE5 ? i5 : (IS_IPHONE6 ? i6 : (IS_IPHONE6_PLUS ? i6p : i4));
    return i;
}


+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

@end
