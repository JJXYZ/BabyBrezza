//
//  JJFunAlertView.m
//  BabyBrezza
//
//  Created by Jay on 16/5/31.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "JJFunAlertView.h"
@interface JJFunAlertView ()

@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation JJFunAlertView


#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutFunAlertViewUI];
    }
    return self;
}

#pragma mark - Private Methods

- (void)layoutFunAlertViewUI {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.alertLabel];
    [self autolayoutFunAlertViewUI];
}

- (void)autolayoutFunAlertViewUI {
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
}

#pragma mark - Property

- (UILabel *)alertLabel {
    if (_alertLabel) {
        return _alertLabel;
    }
    _alertLabel = [[UILabel alloc] init];
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    _alertLabel.backgroundColor = [UIColor clearColor];
    _alertLabel.textColor = [UIColor blackColor];
    _alertLabel.font = S_FONT(S_SCALE_W_4(25));
    _alertLabel.text = @"bottle is ready!";
    return _alertLabel;
}


@end
