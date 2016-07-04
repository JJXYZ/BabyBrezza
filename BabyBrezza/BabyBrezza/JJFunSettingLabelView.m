//
//  JJFunSettingLabelView.m
//  BabyBrezza
//
//  Created by Jay on 16/5/28.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJFunSettingLabelView.h"
@interface JJFunSettingLabelView ()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *tempLabel;

@end

@implementation JJFunSettingLabelView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutFunSettingLabelViewUI];
    }
    return self;
}

#pragma mark - Private Methods

- (void)layoutFunSettingLabelViewUI {
    [self addSubview:self.numberLabel];
    [self addSubview:self.tempLabel];
    [self addSubview:self.speedLabel];
    
    [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@((M_SCREEN_W - 20)/3));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self.tempLabel.mas_left);
    }];
    
    [self.speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self.tempLabel.mas_right);
    }];

}

#pragma mark - Property

- (UILabel *)numberLabel {
    if (_numberLabel) {
        return _numberLabel;
    }
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.textColor = [UIColor blackColor];
    _numberLabel.font = VAGRounded_FONT(S_SCALE_W_4(16));
    _numberLabel.text = @"setting";
    return _numberLabel;
}

- (UILabel *)speedLabel {
    if (_speedLabel) {
        return _speedLabel;
    }
    _speedLabel = [[UILabel alloc] init];
    _speedLabel.textAlignment = NSTextAlignmentCenter;
    _speedLabel.backgroundColor = [UIColor clearColor];
    _speedLabel.textColor = [UIColor blackColor];
    _speedLabel.font = VAGRounded_FONT(S_SCALE_W_4(16));
    _speedLabel.text = @"speed";
    return _speedLabel;
}


- (UILabel *)tempLabel {
    if (_tempLabel) {
        return _tempLabel;
    }
    _tempLabel = [[UILabel alloc] init];
    _tempLabel.textAlignment = NSTextAlignmentCenter;
    _tempLabel.backgroundColor = [UIColor clearColor];
    _tempLabel.textColor = [UIColor blackColor];
    _tempLabel.font = VAGRounded_FONT(S_SCALE_W_4(16));
    _tempLabel.text = @"start temp";
    return _tempLabel;
}




@end
