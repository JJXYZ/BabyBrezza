//
//  JJFunTimeView.h
//  BabyBrezza
//
//  Created by Jay on 16/5/29.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJFunSettingControlBtn.h"

#define F_T_View_H (S_SCALE_H_4(160))
#define F_T_BTN_SIZE (S_SCALE_H_4(70))
#define F_T_BTN_Y (S_SCALE_H_4(10))


typedef NS_ENUM(NSUInteger, FunStatusType) {
    FunStatusType_Normal = 0,
    FunStatusType_Start,
    FunStatusType_Finish,
};

@protocol JJFunTimeViewDelegate <NSObject>

@optional
- (void)clickFunTimeStartBtn:(JJFunSettingControlBtn *)btn;
- (void)clickFunTimecancelBtn:(JJFunSettingControlBtn *)btn;
- (void)clickFunTimeOKBtn:(JJFunSettingControlBtn *)btn;

@end


@interface JJFunTimeView : UIView

@property (nonatomic, weak) id <JJFunTimeViewDelegate> delegate;

- (void)showTimeLabel;

- (void)hideTimeLabel;

- (void)animationTimeLabel;

- (void)showTextLabel;

- (void)setTimeText:(NSString *)time;

- (void)showStartBtn;

- (void)showcancelBtn;

- (void)showOKBtn;

@end
