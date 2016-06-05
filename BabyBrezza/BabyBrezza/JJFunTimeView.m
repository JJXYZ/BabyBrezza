//
//  JJFunTimeView.m
//  BabyBrezza
//
//  Created by Jay on 16/5/29.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJFunTimeView.h"
#import "JJFunSettingControlBtn.h"

@interface JJFunTimeView ()

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) JJFunSettingControlBtn *startBtn;

@property (nonatomic, strong) JJFunSettingControlBtn *cancleBtn;

@property (nonatomic, strong) JJFunSettingControlBtn *okBtn;

@end


@implementation JJFunTimeView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutFunTimeViewUI];
    }
    return self;
}

#pragma mark - Private Methods

- (void)layoutFunTimeViewUI {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.timeLabel];
    [self addSubview:self.startBtn];
    [self addSubview:self.cancleBtn];
    [self addSubview:self.okBtn];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.height.equalTo(@(S_SCALE_H_4(80)));
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(F_T_BTN_Y);
        make.centerX.equalTo(self);
        make.width.equalTo(@(F_T_BTN_SIZE));
        make.height.equalTo(@(F_T_BTN_SIZE));
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(F_T_BTN_Y);
        make.centerX.equalTo(self);
        make.width.equalTo(@(F_T_BTN_SIZE));
        make.height.equalTo(@(F_T_BTN_SIZE));
    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(F_T_BTN_Y);
        make.centerX.equalTo(self);
        make.width.equalTo(@(F_T_BTN_SIZE));
        make.height.equalTo(@(F_T_BTN_SIZE));
    }];
}


- (void)setTimeText:(NSString *)time {
    self.timeLabel.text = time;
}


#pragma mark - Event

- (void)clickStartBtn:(JJFunSettingControlBtn *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(clickFunTimeStartBtn:)]) {
        [_delegate clickFunTimeStartBtn:btn];
    }
}

- (void)clickCancleBtn:(JJFunSettingControlBtn *)btn {
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickFunTimeCancleBtn:)]) {
        [_delegate clickFunTimeCancleBtn:btn];
    }
}

- (void)clickOKBtn:(JJFunSettingControlBtn *)btn {
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickFunTimeOKBtn:)]) {
        [_delegate clickFunTimeOKBtn:btn];
    }
}

#pragma mark - Public Methods
- (void)showStartBtn {
    self.startBtn.hidden = NO;
    self.cancleBtn.hidden = YES;
    self.okBtn.hidden = YES;
}

- (void)showCancleBtn {
    self.startBtn.hidden = YES;
    self.cancleBtn.hidden = NO;
    self.okBtn.hidden = YES;
}

- (void)showOKBtn {
    self.startBtn.hidden = YES;
    self.cancleBtn.hidden = YES;
    self.okBtn.hidden = NO;
}

#pragma mark - Property

- (UILabel *)timeLabel {
    if (_timeLabel) {
        return _timeLabel;
    }
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.font = S_FONT(50);
    _timeLabel.text = @"00:00";
    return _timeLabel;
}

- (JJFunSettingControlBtn *)startBtn {
    if (_startBtn) {
        return _startBtn;
    }
    _startBtn = [[JJFunSettingControlBtn alloc] init];
    [_startBtn setTitle:@"start" forState:UIControlStateNormal];
    _startBtn.frame = CGRectMake(0, 0, F_T_BTN_SIZE, F_T_BTN_SIZE);
    _startBtn.backgroundColor = [UIColor funControlBtnGreenColor];
    _startBtn.layer.cornerRadius = F_T_BTN_SIZE/2;
    [_startBtn addTarget:self action:@selector(clickStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    _startBtn.hidden = NO;
    return _startBtn;
}

- (JJFunSettingControlBtn *)cancleBtn {
    if (_cancleBtn) {
        return _cancleBtn;
    }
    _cancleBtn = [[JJFunSettingControlBtn alloc] init];
    [_cancleBtn setTitle:@"cancle" forState:UIControlStateNormal];
    _cancleBtn.frame = CGRectMake(0, 0, F_T_BTN_SIZE, F_T_BTN_SIZE);
    _cancleBtn.backgroundColor = [UIColor funControlBtnOrangeColor];
    _cancleBtn.layer.cornerRadius = F_T_BTN_SIZE/2;
    [_cancleBtn addTarget:self action:@selector(clickCancleBtn:) forControlEvents:UIControlEventTouchUpInside];
    _cancleBtn.hidden = YES;
    return _cancleBtn;
}


- (JJFunSettingControlBtn *)okBtn {
    if (_okBtn) {
        return _okBtn;
    }
    _okBtn = [[JJFunSettingControlBtn alloc] init];
    [_okBtn setTitle:@"ok" forState:UIControlStateNormal];
    _okBtn.frame = CGRectMake(0, 0, F_T_BTN_SIZE, F_T_BTN_SIZE);
    _okBtn.backgroundColor = [UIColor funControlBtnGreenColor];
    _okBtn.layer.cornerRadius = F_T_BTN_SIZE/2;
    [_okBtn addTarget:self action:@selector(clickOKBtn:) forControlEvents:UIControlEventTouchUpInside];
    _okBtn.hidden = YES;
    return _okBtn;
}



@end
