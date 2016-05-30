//
//  JJFunSettingView.h
//  BabyBrezza
//
//  Created by Jay on 16/5/28.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJFunSettingBtn.h"

#define F_S_View_H (S_SCALE_H_4(140))

@protocol JJFunSettingViewDelegate <NSObject>

@optional
- (void)clickFunSettingView:(JJFunSettingBtn *)btn;

@end

@interface JJFunSettingView : UIView

@property (nonatomic, weak) id <JJFunSettingViewDelegate> delegate;


@end
