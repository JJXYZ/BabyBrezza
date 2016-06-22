//
//  JJFunSettingBtnView.h
//  BabyBrezza
//
//  Created by Jay on 16/5/28.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJFunSettingBtn.h"

#define F_S_BTN_View_H (45)

@protocol JJFunSettingBtnViewDelegate <NSObject>

@optional
- (void)clickFunSettingBtnView:(JJFunSettingBtn *)btn;

@end

@interface JJFunSettingBtnView : UIView

@property (nonatomic, weak) id <JJFunSettingBtnViewDelegate> delegate;

@property (nonatomic, strong) JJFunSettingBtn *numberUpBtn;
@property (nonatomic, strong) JJFunSettingBtn *numberDownBtn;

@property (nonatomic, strong) JJFunSettingBtn *tempUpBtn;
@property (nonatomic, strong) JJFunSettingBtn *tempDownBtn;

@property (nonatomic, strong) JJFunSettingBtn *speedUpBtn;
@property (nonatomic, strong) JJFunSettingBtn *speedDownBtn;

- (void)hiddenTempSpeedBtn;

- (void)showTempSpeedBtn;

@end
