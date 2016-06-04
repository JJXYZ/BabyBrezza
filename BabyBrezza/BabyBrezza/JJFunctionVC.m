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
#import "JJFunAlertView.h"
#import "JJBLEValue.h"
#import "JJMessage.h"

@interface JJFunctionVC () <JJFunSettingViewDelegate, JJFunTimeViewDelegate>

@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *settingGuideBtn;

@property (nonatomic, strong) JJFunSettingView *funSettingView;

@property (nonatomic, strong) JJFunAlertView *funAlertView;

@property (nonatomic, strong) JJFunTimeView *funTimeView;

@property (nonatomic, strong) JJFunBottomView *funBottomView;

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
    
    [self addFunNotification];
}

- (void)dealloc {
    [self removeCountDownTimer];
}

#pragma mark - Private Methods

- (void)layoutFuncionUI {
    [self.view addSubview:self.voiceBtn];
    [self.view addSubview:self.settingGuideBtn];
    [self.view addSubview:self.funSettingView];
    [self.view addSubview:self.funAlertView];
    [self.view addSubview:self.funTimeView];
    [self.view addSubview:self.funBottomView];
}

- (void)addFunNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nDidReceiveData) name:NOTIFY_DidReceiveData object:nil];
}


- (void)timeCountDown {
    self.timeout--;
    NSUInteger minutes = self.timeout / 60;
    NSUInteger seconds = self.timeout % 60;
    
    [self.funTimeView setTimeText:[NSString stringWithFormat:@"%.2lu:%.2lu",(long)minutes, (long)seconds]];
    
    if (!minutes && !seconds) {
        [self removeCountDownTimer];
    }
}

#pragma mark - Notification
- (void)nDidReceiveData {
    NSString *timeText = [NSString stringWithFormat:@"%@:%@", BLE_VALUE.minute, BLE_VALUE.second];
    [self.funTimeView setTimeText:timeText];
    
    [self.funSettingView setNumber:BLE_VALUE.number];
    [self.funSettingView setTemp:BLE_VALUE.temp];
    [self.funSettingView setSpeed:BLE_VALUE.speed];
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
    [self.funTimeView setTimeText:[NSString stringWithFormat:@"%.2ld:00", (long)time.integerValue]];
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

#pragma mark - JJFunSettingViewDelegate

- (void)clickFunSettingView:(JJFunSettingBtn *)btn {
    [JJMessage sendData];
}

#pragma mark - JJFunTimeViewDelegate

- (void)clickFunTimeStartBtn:(JJFunSettingControlBtn *)btn {
    
}

- (void)clickFunTimeCancleBtn:(JJFunSettingControlBtn *)btn {
    self.funSettingView.hidden = YES;
    self.funAlertView.hidden = NO;
}

- (void)clickFunTimeOKBtn:(JJFunSettingControlBtn *)btn {
    self.funSettingView.hidden = NO;
    self.funAlertView.hidden = YES;
}

#pragma mark - Property
- (UIButton *)voiceBtn {
    if (_voiceBtn) {
        return _voiceBtn;
    }
    _voiceBtn = [[UIButton alloc] init];
    _voiceBtn.frame = CGRectMake(8, 15, 25, 25);
    [_voiceBtn setImage:[UIImage imageNamed:@"icon_soundon"] forState:UIControlStateNormal];
    [_voiceBtn setImage:[UIImage imageNamed:@"icon_soundoff"] forState:UIControlStateHighlighted];
    return _voiceBtn;
}

- (UIButton *)settingGuideBtn {
    if (_settingGuideBtn) {
        return _settingGuideBtn;
    }
    _settingGuideBtn = [[UIButton alloc] init];
    _settingGuideBtn.frame = CGRectMake(M_SCREEN_W - 5 - 110, 15, 110, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 82, 25)];
    label.font = S_FONT(13);
    label.textAlignment = NSTextAlignmentRight;
    label.userInteractionEnabled = NO;
    label.text = @"setting guide";
    [_settingGuideBtn addSubview:label];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 0, 25, 25)];
    imageView.userInteractionEnabled = NO;
    imageView.image = [UIImage imageNamed:@"rightArrow"];
    [_settingGuideBtn addSubview:imageView];
    [_settingGuideBtn addTarget:self action:@selector(clickSettingGuideBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _settingGuideBtn;
}

- (JJFunSettingView *)funSettingView {
    if (_funSettingView) {
        return _funSettingView;
    }
    CGFloat funSettingViewY = [BBUtils getFloatI4:120 i5:140 i6:160 i6p:180];
    _funSettingView = [[JJFunSettingView alloc] initWithFrame:CGRectMake(0, funSettingViewY, self.view.width, F_S_View_H)];
    _funSettingView.delegate = self;
    return _funSettingView;
}

- (JJFunAlertView *)funAlertView {
    if (_funAlertView) {
        return _funAlertView;
    }
    CGFloat funSettingViewY = [BBUtils getFloatI4:120 i5:140 i6:160 i6p:180];
    _funAlertView = [[JJFunAlertView alloc] initWithFrame:CGRectMake(0, funSettingViewY, self.view.width, F_A_View_H)];
    _funAlertView.hidden = YES;
    return _funAlertView;
}

- (JJFunTimeView *)funTimeView {
    if (_funTimeView) {
        return _funTimeView;
    }
    _funTimeView = [[JJFunTimeView alloc] initWithFrame:CGRectMake(0, self.funSettingView.bottom + S_SCALE_H_4(10), self.view.width, F_T_View_H)];
    _funTimeView.delegate = self;
    return _funTimeView;
}

- (JJFunBottomView *)funBottomView {
    if (_funBottomView) {
        return _funBottomView;
    }
    _funBottomView = [[JJFunBottomView alloc] initWithFrame:CGRectMake(0, self.view.bottom - F_B_View_H - 5, self.view.width, F_B_View_H)];
    return _funBottomView;
}

@end
