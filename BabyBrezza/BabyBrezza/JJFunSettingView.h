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
- (void)didSelectRowNumber:(NSString *)number temp:(NSString *)temp speed:(NSString *)speed;

@end

@interface JJFunSettingView : UIView

@property (nonatomic, weak) id <JJFunSettingViewDelegate> delegate;

- (NSUInteger)getPickViewNumber;

- (void)setPickViewNumber:(NSString *)number;

- (NSUInteger)getPickViewTemp;

- (void)setPickViewTemp:(NSString *)temp;

- (NSUInteger)getPickViewSpeed;

- (void)setPickViewSpeed:(NSString *)speed;

- (void)enable;

- (void)disable;

@end
