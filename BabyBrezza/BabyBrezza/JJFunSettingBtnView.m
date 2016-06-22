//
//  JJFunSettingBtnView.m
//  BabyBrezza
//
//  Created by Jay on 16/5/28.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJFunSettingBtnView.h"

@interface JJFunSettingBtnView ()

@property (nonatomic, strong) UIView *numberView;
@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) UIView *speedView;

@end

@implementation JJFunSettingBtnView
#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutFunSettingBtnViewUI];
    }
    return self;
}

#pragma mark - Private Methods

- (void)layoutFunSettingBtnViewUI {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.numberView];
    [self addSubview:self.tempView];
    [self addSubview:self.speedView];
    
    [self.numberView addSubview:self.numberUpBtn];
    [self.numberView addSubview:self.numberDownBtn];
    
    [self.tempView addSubview:self.tempUpBtn];
    [self.tempView addSubview:self.tempDownBtn];
    
    [self.speedView addSubview:self.speedUpBtn];
    [self.speedView addSubview:self.speedDownBtn];
    
    [self autolayoutFunSettingBtnViewUI];
}

- (void)autolayoutFunSettingBtnViewUI {
    
    [self.tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@((M_SCREEN_W - 20)/3));
    }];
    
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self.tempView.mas_left);
    }];
    
    [self.speedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self.tempView.mas_right);
    }];
    
    [self.numberUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberView.mas_top);
        make.bottom.equalTo(self.numberView.mas_bottom);
        make.right.equalTo(self.numberView.mas_centerX);
        make.width.equalTo(@(45));
    }];
    
    [self.numberDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberView.mas_top);
        make.bottom.equalTo(self.numberView.mas_bottom);
        make.left.equalTo(self.numberView.mas_centerX);
        make.width.equalTo(@(45));
    }];

    [self.tempUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tempView.mas_top);
        make.bottom.equalTo(self.tempView.mas_bottom);
        make.right.equalTo(self.tempView.mas_centerX);
        make.width.equalTo(@(45));
    }];
    
    [self.tempDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tempView.mas_top);
        make.bottom.equalTo(self.tempView.mas_bottom);
        make.left.equalTo(self.tempView.mas_centerX);
        make.width.equalTo(@(45));
    }];
    
    [self.speedUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speedView.mas_top);
        make.bottom.equalTo(self.speedView.mas_bottom);
        make.right.equalTo(self.speedView.mas_centerX);
        make.width.equalTo(@(45));
    }];
    
    [self.speedDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speedView.mas_top);
        make.bottom.equalTo(self.speedView.mas_bottom);
        make.left.equalTo(self.speedView.mas_centerX);
        make.width.equalTo(@(45));
    }];
    
}

#pragma mark - Public Method
- (void)hiddenTempSpeedBtn {
    self.tempView.hidden = YES;
    self.speedView.hidden = YES;
}

- (void)showTempSpeedBtn {
    self.tempView.hidden = NO;
    self.speedView.hidden = NO;
}


#pragma mark - Event

- (void)clickFunBtn:(JJFunSettingBtn *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(clickFunSettingBtnView:)]) {
        [_delegate clickFunSettingBtnView:btn];
    }
}

#pragma mark - Property

- (UIView *)numberView {
    if (_numberView) {
        return _numberView;
    }
    _numberView = [[UIView alloc] init];
    return _numberView;
}

- (UIView *)tempView {
    if (_tempView) {
        return _tempView;
    }
    _tempView = [[UIView alloc] init];
    return _tempView;
}

- (UIView *)speedView {
    if (_speedView) {
        return _speedView;
    }
    _speedView = [[UIView alloc] init];
    return _speedView;
}

- (JJFunSettingBtn *)numberUpBtn {
    if (_numberUpBtn) {
        return _numberUpBtn;
    }
    _numberUpBtn = [[JJFunSettingBtn alloc] init];
    _numberUpBtn.type = FunBtnType_NumUp;
    [_numberUpBtn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
    [_numberUpBtn addTarget:self action:@selector(clickFunBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _numberUpBtn;
}

- (JJFunSettingBtn *)numberDownBtn {
    if (_numberDownBtn) {
        return _numberDownBtn;
    }
    _numberDownBtn = [[JJFunSettingBtn alloc] init];
    _numberDownBtn.type = FunBtnType_NumDown;
    [_numberDownBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [_numberDownBtn addTarget:self action:@selector(clickFunBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _numberDownBtn;
}

- (JJFunSettingBtn *)speedUpBtn {
    if (_speedUpBtn) {
        return _speedUpBtn;
    }
    _speedUpBtn = [[JJFunSettingBtn alloc] init];
    _speedUpBtn.type = FunBtnType_SpeedUp;
    [_speedUpBtn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
    [_speedUpBtn addTarget:self action:@selector(clickFunBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _speedUpBtn;
}

- (JJFunSettingBtn *)speedDownBtn {
    if (_speedDownBtn) {
        return _speedDownBtn;
    }
    _speedDownBtn = [[JJFunSettingBtn alloc] init];
    _speedDownBtn.type = FunBtnType_SpeedDown;
    [_speedDownBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [_speedDownBtn addTarget:self action:@selector(clickFunBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _speedDownBtn;
}

- (JJFunSettingBtn *)tempUpBtn {
    if (_tempUpBtn) {
        return _tempUpBtn;
    }
    _tempUpBtn = [[JJFunSettingBtn alloc] init];
    _tempUpBtn.type = FunBtnType_TempUp;
    [_tempUpBtn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
    [_tempUpBtn addTarget:self action:@selector(clickFunBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _tempUpBtn;
}

- (JJFunSettingBtn *)tempDownBtn {
    if (_tempDownBtn) {
        return _tempDownBtn;
    }
    _tempDownBtn = [[JJFunSettingBtn alloc] init];
    _tempDownBtn.type = FunBtnType_TempDown;
    [_tempDownBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [_tempDownBtn addTarget:self action:@selector(clickFunBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _tempDownBtn;
}

@end
