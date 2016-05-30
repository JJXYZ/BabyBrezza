//
//  JJFunTimeView.h
//  BabyBrezza
//
//  Created by Jay on 16/5/29.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJControllerBtn.h"

#define F_T_View_H (S_SCALE_H_4(160))
#define F_T_BTN_SIZE (S_SCALE_H_4(70))
#define F_T_BTN_Y (S_SCALE_H_4(10))

@protocol JJFunTimeViewDelegate <NSObject>

@optional
- (void)clickFunTimeStartBtn:(JJControllerBtn *)btn;
- (void)clickFunTimeCancleBtn:(JJControllerBtn *)btn;
- (void)clickFunTimeOKBtn:(JJControllerBtn *)btn;

@end


@interface JJFunTimeView : UIView

@property (nonatomic, weak) id <JJFunTimeViewDelegate> delegate;

@end
