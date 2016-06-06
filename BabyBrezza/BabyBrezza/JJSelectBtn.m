//
//  JJSelectBtn.m
//  BabyBrezza
//
//  Created by Jay on 16/6/7.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "JJSelectBtn.h"

@implementation JJSelectBtn


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isHigh = NO;
    }
    return self;
}

- (void)setIsHigh:(BOOL)isHigh {
    _isHigh = isHigh;
    if (isHigh) {
        [self setImage:[UIImage imageNamed:self.highImage] forState:UIControlStateNormal];
    }
    else {
        [self setImage:[UIImage imageNamed:self.normalImage] forState:UIControlStateNormal];
    }
}

@end
