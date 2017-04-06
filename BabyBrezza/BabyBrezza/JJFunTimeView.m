//
//  JJFunTimeView.m
//  BabyBrezza
//
//  Created by Jay on 16/5/29.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJFunTimeView.h"
#import "JJFunSettingControlBtn.h"
#import "UIButton+JJCommon.h"
//LLY @0702
#import "JJBLEManager.h"
#import "JJCBCentralManager.h"

@interface JJFunTimeView ()

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *errorLabel;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) JJFunSettingControlBtn *startBtn;

@property (nonatomic, strong) JJFunSettingControlBtn *cancelBtn;

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
    [self addSubview:self.errorLabel];
    [self addSubview:self.textLabel];
    [self addSubview:self.startBtn];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.okBtn];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.height.equalTo(@(S_SCALE_H_4(80)));
    }];
    
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.height.equalTo(@(S_SCALE_H_4(30)));
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.errorLabel.mas_bottom);
        make.right.equalTo(self);
        make.left.equalTo(self);
        make.height.equalTo(@(S_SCALE_H_4(50)));
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(F_T_BTN_Y);
        make.centerX.equalTo(self);
        make.width.equalTo(@(F_T_BTN_SIZE));
        make.height.equalTo(@(F_T_BTN_SIZE));
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = 5;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];///没有的话是均匀的动画。
    return animation;
}



#pragma mark - Event

- (void)clickStartBtn:(JJFunSettingControlBtn *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(clickFunTimeStartBtn:)]) {
        [_delegate clickFunTimeStartBtn:btn];
    }
}

- (void)clickcancelBtn:(JJFunSettingControlBtn *)btn {
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickFunTimecancelBtn:)]) {
        [_delegate clickFunTimecancelBtn:btn];
    }
}

- (void)clickOKBtn:(JJFunSettingControlBtn *)btn {
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickFunTimeOKBtn:)]) {
        [_delegate clickFunTimeOKBtn:btn];
        
        //LLY @0701
        CENTRAL_MANAGER.curPeripheral    = nil;
    }
}

#pragma mark - Public Methods

- (void)showTimeLabel {
    self.timeLabel.hidden = NO;
    self.errorLabel.hidden = YES;
    self.textLabel.hidden = YES;
}

- (void)hideTimeLabel {
    self.timeLabel.hidden = YES;
    self.errorLabel.hidden = YES;
    self.textLabel.hidden = YES;
}

- (void)animationTimeLabel {
    [self.timeLabel.layer addAnimation:[self opacityForever_Animation:0.5] forKey:nil];
}


- (void)showTextLabel {
    self.timeLabel.hidden = YES;
    self.errorLabel.hidden = NO;
    self.textLabel.hidden = NO;
}


- (void)showStartBtn {
    self.startBtn.hidden = NO;
    self.cancelBtn.hidden = YES;
    self.okBtn.hidden = YES;
}

- (void)showCancelBtn {
    self.startBtn.hidden = YES;
    self.cancelBtn.hidden = NO;
    self.okBtn.hidden = YES;
}

- (void)showOKBtn {
    self.startBtn.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.okBtn.hidden = NO;
}

- (void)hideStartCancleBtn {
    self.startBtn.hidden = YES;
    self.cancelBtn.hidden = YES;
}

#pragma mark - Property

- (UILabel *)timeLabel {
    if (_timeLabel) {
        return _timeLabel;
    }
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.hidden = NO;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.font = VAGRounded_FONT(50);
    _timeLabel.text = @"00:00";
    return _timeLabel;
}




- (UILabel *)errorLabel {
    if (_errorLabel) {
        return _errorLabel;
    }
    _errorLabel = [[UILabel alloc] init];
    _errorLabel.hidden = YES;
    _errorLabel.numberOfLines = 0;
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.backgroundColor = [UIColor clearColor];
    _errorLabel.textColor = [UIColor blackColor];
    _errorLabel.font = VAGRounded_FONT(24); //LLY modified 30 to 24
    _errorLabel.text = [BBUtils languageStrType:JJLanguageStrTypeError];
    return _errorLabel;
}

- (UILabel *)textLabel {
    if (_textLabel) {
        return _textLabel;
    }
    _textLabel = [[UILabel alloc] init];
    _textLabel.hidden = YES;
    _textLabel.numberOfLines = 0;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.font = VAGRounded_FONT(16);//LLY modified 20 to 16
    _textLabel.text = [BBUtils languageStrType:JJLanguageStrTypePST];
    return _textLabel;
}


- (JJFunSettingControlBtn *)startBtn {
    if (_startBtn) {
        return _startBtn;
    }
    _startBtn = [[JJFunSettingControlBtn alloc] init];
    _startBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_startBtn setTitle:[BBUtils languageStrType:JJLanguageStrTypeStart] forState:UIControlStateNormal];
    _startBtn.frame = CGRectMake(0, 0, F_T_BTN_SIZE, F_T_BTN_SIZE);
    _startBtn.layer.cornerRadius = F_T_BTN_SIZE/2;
    [_startBtn setBackgroundColor:[UIColor funControlBtnGreenColor] forState:UIControlStateNormal];
    [_startBtn setBackgroundColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _startBtn.layer.masksToBounds = YES;
    [_startBtn addTarget:self action:@selector(clickStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    _startBtn.hidden = NO;
    return _startBtn;
}

- (JJFunSettingControlBtn *)cancelBtn {
    if (_cancelBtn) {
        return _cancelBtn;
    }
    _cancelBtn = [[JJFunSettingControlBtn alloc] init];
    _cancelBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_cancelBtn setTitle:[BBUtils languageStrType:JJLanguageStrTypeCancel] forState:UIControlStateNormal];
    _cancelBtn.frame = CGRectMake(0, 0, F_T_BTN_SIZE, F_T_BTN_SIZE);
    _cancelBtn.backgroundColor = [UIColor funControlBtnOrangeColor];
    _cancelBtn.layer.cornerRadius = F_T_BTN_SIZE/2;
    [_cancelBtn setBackgroundColor:[UIColor funControlBtnOrangeColor] forState:UIControlStateNormal];
    [_cancelBtn setBackgroundColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _cancelBtn.layer.masksToBounds = YES;
    [_cancelBtn addTarget:self action:@selector(clickcancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.hidden = YES;
    return _cancelBtn;
}


- (JJFunSettingControlBtn *)okBtn {
    if (_okBtn) {
        return _okBtn;
    }
    _okBtn = [[JJFunSettingControlBtn alloc] init];
    [_okBtn setTitle:@"ok" forState:UIControlStateNormal];
    _okBtn.frame = CGRectMake(0, 0, F_T_BTN_SIZE, F_T_BTN_SIZE);
    [_okBtn setBackgroundColor:[UIColor funControlBtnGreenColor] forState:UIControlStateNormal];
    [_okBtn setBackgroundColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _okBtn.layer.masksToBounds = YES;
    _okBtn.layer.cornerRadius = F_T_BTN_SIZE/2;
    [_okBtn addTarget:self action:@selector(clickOKBtn:) forControlEvents:UIControlEventTouchUpInside];
    _okBtn.hidden = YES;
    return _okBtn;
}



@end
