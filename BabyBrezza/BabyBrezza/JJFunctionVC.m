//
//  JJFunctionVC.m
//  BabyBrezza
//
//  Created by Jay on 15/10/1.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "JJFunctionVC.h"
#import "JJFunSettingView.h"
#import "JJFunTimeView.h"
#import "JJFunBottomView.h"
#import "JJSettingGuideVC.h"

@interface JJFunctionVC ()

@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *settingGuideBtn;

@property (nonatomic, strong) JJFunSettingView *funSettingView;

@property (nonatomic, strong) JJFunTimeView *funTimeView;

@property (nonatomic, strong) JJFunBottomView *funBottomView;

@property (nonatomic, strong) UILabel *timeLabel;
@property (assign, nonatomic) NSUInteger timeout;
;
//倒计时
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, strong) UIButton *startBtn;

- (void)clickBackBtn:(id)sender;
- (void)clickStartBtn:(id)sender;

@end

@implementation JJFunctionVC

#pragma mark - Lifecycle

//单例
+ (JJFunctionVC *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static JJFunctionVC * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}


- (void)viewDidLoad {
    [super viewDidLoad];    
    [self layoutFuncionUI];
}

- (void)dealloc {
    [self removeCountDownTimer];
}

#pragma mark - Private Methods

- (void)layoutFuncionUI {
    [self.view addSubview:self.voiceBtn];
    [self.view addSubview:self.settingGuideBtn];
    [self.view addSubview:self.settingGuideBtn];
    [self.view addSubview:self.funSettingView];
    [self.view addSubview:self.funTimeView];
    [self.view addSubview:self.funBottomView];
}

- (void)timeCountDown {
    self.timeout--;
    NSUInteger minutes = self.timeout / 60;
    NSUInteger seconds = self.timeout % 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%.2lu:%.2lu",(long)minutes, (long)seconds];
    
    if (!minutes && !seconds) {
        [self removeCountDownTimer];
    }
}

#pragma mark - NSTimer


- (void)createCountDownTimer {
    
    [self removeCountDownTimer];
    
    NSLog(@"创建倒计时");
    
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCountDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSDefaultRunLoopMode];
    
    [self.countDownTimer fire];
    
}

- (void)removeCountDownTimer {
    if (self.countDownTimer) {
        NSLog(@"移除倒计时");
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}






#pragma mark - Event

- (void)clickSettingGuideBtn:(id)sender {
    JJSettingGuideVC *vc = [[JJSettingGuideVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)clickStartBtn:(id)sender {
    
//    NSString *time = [self.numberPickArr objectAtIndex:[self.numberPickView selectedRowInComponent:0]];
    NSString *time = nil;
    self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:00", (long)time.integerValue];
    self.timeout = time.integerValue * 60;
    
    if (self.countDownTimer) {
        [self removeCountDownTimer];
        [self.startBtn setTitle:@"Start" forState:UIControlStateNormal];
    }
    else {
        [self createCountDownTimer];
        [self.startBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    }
}



#pragma mark - Property
- (UIButton *)voiceBtn {
    if (_voiceBtn) {
        return _voiceBtn;
    }
    _voiceBtn = [[UIButton alloc] init];
    _voiceBtn.frame = CGRectMake(5, 20, 25, 25);
    [_voiceBtn setImage:[UIImage imageNamed:@"icon_soundon"] forState:UIControlStateNormal];
    [_voiceBtn setImage:[UIImage imageNamed:@"icon_soundoff"] forState:UIControlStateHighlighted];
    return _voiceBtn;
}

- (UIButton *)settingGuideBtn {
    if (_settingGuideBtn) {
        return _settingGuideBtn;
    }
    _settingGuideBtn = [[UIButton alloc] init];
    _settingGuideBtn.frame = CGRectMake(M_SCREEN_W - 5 - 100, 20, 100, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 25)];
    label.userInteractionEnabled = NO;
    label.text = @"setting guide";
    [_settingGuideBtn addSubview:label];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 0, 25, 25)];
    imageView.userInteractionEnabled = NO;
    imageView.image = [UIImage imageNamed:@"icon_soundoff"];
    [_settingGuideBtn addSubview:imageView];
    [_settingGuideBtn addTarget:self action:@selector(clickSettingGuideBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _settingGuideBtn;
}

- (JJFunSettingView *)funSettingView {
    if (_funSettingView) {
        return _funSettingView;
    }
    CGFloat funSettingViewY = 120;
    if (IS_IPHONE5) {
        funSettingViewY = 140;
    }
    else if (IS_IPHONE6) {
        funSettingViewY = 160;
    }
    else if (IS_IPHONE6_PLUS) {
        funSettingViewY = 180;
    }
    _funSettingView = [[JJFunSettingView alloc] initWithFrame:CGRectMake(0, funSettingViewY, self.view.width, F_S_View_H)];
    return _funSettingView;
}

- (JJFunTimeView *)funTimeView {
    if (_funTimeView) {
        return _funTimeView;
    }
    _funTimeView = [[JJFunTimeView alloc] initWithFrame:CGRectMake(0, self.funSettingView.bottom + 5, self.view.width, F_T_View_H)];
    return _funTimeView;
}

- (JJFunBottomView *)funBottomView {
    if (_funBottomView) {
        return _funBottomView;
    }
    _funBottomView = [[JJFunBottomView alloc] initWithFrame:CGRectMake(0, self.view.bottom - F_B_View_H, self.view.width, F_B_View_H)];
    return _funBottomView;
}

@end
