//
//  BBUtils.m
//  BabyBrezza
//
//  Created by Jay on 16/5/30.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "BBUtils.h"
#import "JJBLEManager.h"

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

+ (NSString *)languageStrType:(JJLanguageStrType)strType {
    switch (strType) {
        case JJLanguageStrTypeENFR: {
            return [self languageEN:kEN FR:kFR];
        }
        case JJLanguageStrTypeSBW: {
            return [self languageEN:kStartBottleWarmer_EN FR:kStartBottleWarmer_FR];
        }
        case JJLanguageStrTypeSFYBW: {
            return [self languageEN:kScanForYourBottleWarmer_EN FR:kScanForYourBottleWarmer_FR];
        }
        case JJLanguageStrTypeBWC: {
            return [self languageEN:kBottleWarmerConnected_EN FR:kBottleWarmerConnected_FR];
        }
        case JJLanguageStrTypeSetGuide: {
            return [self languageEN:kSettingGuide_EN FR:kSettingGuide_FR];
        }
        case JJLanguageStrTypeSetting: {
            return [self languageEN:kSetting_EN FR:kSetting_FR];
        }
        case JJLanguageStrTypeSpeed: {
            return [self languageEN:kSpeed_EN FR:kSpeed_FR];
        }
        case JJLanguageStrTypeStartTemp: {
            return [self languageEN:kStartTemp_EN FR:kStartTemp_FR];
        }
        case JJLanguageStrTypeRoom: {
            return [self languageEN:kRoom_EN FR:kRoom_FR];
        }
        case JJLanguageStrTypeCode: {
            return [self languageEN:kCode_EN FR:kCode_FR];
        }
        case JJLanguageStrTypeSteedy: {
            return [self languageEN:kSteady_EN FR:kSteady_FR];
        }
        case JJLanguageStrTypeQuick: {
            return [self languageEN:kQuick_EN FR:kQuick_FR];
        }
        case JJLanguageStrTypeStart: {
            return [self languageEN:kStart_EN FR:kStart_FR];
        }
        case JJLanguageStrTypeConnect: {
            return [self languageEN:kConnect_EN FR:kConnect_FR];
        }
        case JJLanguageStrTypeDisconnect: {
            return [self languageEN:kDisconnect_EN FR:kDisconnect_FR];
        }
        case JJLanguageStrTypeCancel: {
            return [self languageEN:kCancel_EN FR:kCancel_FR];
        }
        case JJLanguageStrTypeBIR: {
            return [self languageEN:kBottleIsReady_EN FR:kBottleIsReady_FR];
        }
        case JJLanguageStrTypeError: {
            return [self languageEN:kError_EN FR:kError_FR];
        }
        case JJLanguageStrTypePST: {
            return [self languageEN:kPleaseSeeTrouble_EN FR:kPleaseSeeTrouble_FR];
        }
    }
    return nil;
}

+ (NSString *)languageEN:(NSString *)EN FR:(NSString *)FR {
    NSNumber *languageType = [JJBLEManager sharedInstance].languageType;
    switch (languageType.integerValue) {
        case JJLanguageTypeEN: {
            return EN;
        }
        case JJLanguageTypeFR: {
            return FR;
        }
    }
    return nil;
}

/** 语言 */
+ (void)saveLanguageType:(JJLanguageType)type {
    [JJBLEManager sharedInstance].languageType = @(type);
    
    [[NSUserDefaults standardUserDefaults] setObject:@(type) forKey:UD_KEY_LANGUAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSNumber *)getLanguageNum {
    NSNumber *languageNum = [[NSUserDefaults standardUserDefaults] objectForKey:UD_KEY_LANGUAGE];
    return languageNum;
}

@end
