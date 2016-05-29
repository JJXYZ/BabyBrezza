//
//  JJFunSettingBtn.h
//  BabyBrezza
//
//  Created by Jay on 16/5/29.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JJFunBtnType) {
    FunBtnType_NumUp,
    FunBtnType_NumDown,
    FunBtnType_TempUp,
    FunBtnType_TempDown,
    FunBtnType_SpeedUp,
    FunBtnType_SpeedDown,
};

@interface JJFunSettingBtn : UIButton

@property (nonatomic, assign) JJFunBtnType type;

@end
