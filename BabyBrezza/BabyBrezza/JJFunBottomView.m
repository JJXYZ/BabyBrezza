//
//  JJFunBottomView.m
//  BabyBrezza
//
//  Created by Jay on 16/5/29.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJFunBottomView.h"

@interface JJFunBottomView ()

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UIImageView *stateImageView;

@end

@implementation JJFunBottomView
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
    [self addSubview:self.stateLabel];
    [self addSubview:self.stateImageView];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    [self.stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(30));
        make.width.equalTo(@(25));
        make.right.equalTo(self.stateLabel.mas_left);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - Public Methods

- (void)setConnectText {
    self.stateLabel.text = [BBUtils languageStrType:JJLanguageStrTypeConnect];
}

- (void)setDisconnectText {
    self.stateLabel.text = [BBUtils languageStrType:JJLanguageStrTypeDisconnect];
}

#pragma mark - Property

- (UILabel *)stateLabel {
    if (_stateLabel) {
        return _stateLabel;
    }
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.backgroundColor = [UIColor clearColor];
    _stateLabel.textColor = [UIColor blackColor];
    _stateLabel.font = VAGRounded_FONT(14);
    _stateLabel.text = [BBUtils languageStrType:JJLanguageStrTypeConnect];
    return _stateLabel;
}

- (UIImageView *)stateImageView {
    if (_stateImageView) {
        return _stateImageView;
    }
    _stateImageView = [[UIImageView alloc] init];
    _stateImageView.image = [UIImage imageNamed:@"lt_bt_icon"];
    return _stateImageView;
}

@end
