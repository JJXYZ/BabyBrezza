//
//  JJControllerBtn.m
//  BabyBrezza
//
//  Created by Jay on 16/5/29.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJFunSettingControlBtn.h"

@implementation JJFunSettingControlBtn


+ (JJFunSettingControlBtn *)createTitle:(NSString *)title frame:(CGRect)frame color:(UIColor *)color {
    JJFunSettingControlBtn *btn = [[JJFunSettingControlBtn alloc] initWithFrame:frame];
    btn.backgroundColor = color;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = frame.size.width/2;
    return btn;
}


#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutControllerBtnUI];
    }
    return self;
}

#pragma mark - Private Methods

- (void)layoutControllerBtnUI {
    if (IS_IPHONE4) {
        self.titleLabel.font = S_FONT(22);
    }
    else {
        self.titleLabel.font = S_FONT(24);
    }
    
}

@end
