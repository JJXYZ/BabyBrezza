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
#import "JJCBCentralManager.h"
#import "JJSelectBtn.h"
#import "JJLocalNotificationManager.h"

@interface JJFunctionVC () <JJFunSettingViewDelegate, JJFunTimeViewDelegate>

@property (nonatomic, strong) JJSelectBtn *voiceBtn;
@property (nonatomic, strong) UIButton *settingGuideBtn;

@property (nonatomic, strong) JJFunSettingView *funSettingView;

@property (nonatomic, strong) JJFunAlertView *funAlertView;

@property (nonatomic, strong) JJFunTimeView *funTimeView;

@property (nonatomic, strong) JJFunBottomView *funBottomView;

@property (assign, nonatomic) NSUInteger timeout;

/** 倒计时 */
@property (nonatomic, strong) NSTimer *countDownTimer;

/** 闪烁5s */
@property (nonatomic, strong) NSTimer *showTimer;

@property (assign, nonatomic) NSUInteger showTimerCount;

@property (nonatomic, assign) FunStatusType funStausType;

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
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [self removeCountDownTimer];
    [self removeFunctionNotification];
}

#pragma mark - Private Methods
- (void)loadData {
    _funStausType = FunStatusType_Normal;
    [self.funSettingView setStartPickViewNumber:BLE_VALUE.number];
    [self.funSettingView setPickViewTemp:BLE_VALUE.temp];
    [self.funSettingView setPickViewSpeed:BLE_VALUE.speed];
    [self setFunTimeViewText:BLE_VALUE.getTime.integerValue];
    [JJMessage sendSettingData];
}

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nDidWriteData) name:NOTIFY_DidWriteData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nStatePoweredOff) name:NOTIFY_StatePoweredOff object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nDidFailToConnectPeripheral) name:NOTIFY_DidFailToConnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nDidDisconnectPeripheral) name:NOTIFY_DidDisconnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nDidConnectPeripheral) name:NOTIFY_DidConnectPeripheral object:nil];
}

- (void)removeFunctionNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showFunSettingView {
    self.funSettingView.hidden = NO;
    self.funAlertView.hidden = YES;
}

- (void)showFunAlertView {
    self.funSettingView.hidden = YES;
    self.funAlertView.hidden = NO;
}

- (void)setFunTimeViewText:(NSUInteger)time {
    NSUInteger minutes = time / 60;
    NSUInteger seconds = time % 60;
    [self.funTimeView setTimeText:[NSString stringWithFormat:@"%.2lu:%.2lu",(long)minutes, (long)seconds]];
}

- (void)setValueFunUI {
    self.timeout = BLE_VALUE.minute.intValue * 60 + BLE_VALUE.second.intValue;
    NSString *timeText = [NSString stringWithFormat:@"%@:%@", BLE_VALUE.minute, BLE_VALUE.second];
    [self.funTimeView setTimeText:timeText];
    
    [self.funSettingView setPickViewNumber:BLE_VALUE.number];
    [self.funSettingView setPickViewTemp:BLE_VALUE.temp];
    [self.funSettingView setPickViewSpeed:BLE_VALUE.speed];
    
    
}

- (void)timeCountDown {
    
    NSUInteger minutes = self.timeout / 60;
    NSUInteger seconds = self.timeout % 60;
    
    [self.funTimeView setTimeText:[NSString stringWithFormat:@"%.2lu:%.2lu",(long)minutes, (long)seconds]];
    self.timeout--;
    
    [self funSuccessMinutes:minutes seconds:seconds];
    
}

- (void)timeShow {
    
}

- (void)setFunStausType:(FunStatusType)funStausType {
    _funStausType = funStausType;
    if (_funStausType == FunStatusType_Start) {
        [self createCountDownTimer];
        [self showFunSettingView];
        [self.funTimeView showTimeLabel];
        [self.funTimeView showCancelBtn];
        [self.funSettingView disable];
    }
    else if (_funStausType == FunStatusType_Normal) {
        [self removeCountDownTimer];
        [self showFunSettingView];
        [self.funTimeView showTimeLabel];
        [self.funTimeView showStartBtn];
        [self.funSettingView enable];
    }
    else if (_funStausType == FunStatusType_Error) {
        [self removeCountDownTimer];
        [self showFunSettingView];
        [self.funTimeView showTextLabel];
        [self.funTimeView showStartBtn];
        [self.funSettingView enable];
    }
    else if (_funStausType == FunStatusType_Finish) {
        [self removeCountDownTimer];
        [self showFunAlertView];
        [self.funTimeView showTimeLabel];
        [self.funTimeView showOKBtn];
        [self.funSettingView enable];
        [BLE_VALUE playNotiSound:!self.voiceBtn.isHigh];
        [self.funTimeView animationTimeLabel];
        UIApplication *application = [UIApplication sharedApplication];
        if (application.applicationState != UIApplicationStateActive) {
            [[JJLocalNotificationManager sharedInstance] addLocalNotification];
        }
    }
}


- (void)funSuccessMinutes:(NSUInteger)minutes seconds:(NSUInteger)seconds {
    if (!minutes && !seconds && self.funStausType == FunStatusType_Start) {
        self.funStausType = FunStatusType_Finish;
    }
}

#pragma mark - Notification
- (void)nDidConnectPeripheral {
    [self.funBottomView setConnectText];
    if (self.funStausType != FunStatusType_Finish) {
        [self.funSettingView setCurValue];
        [self setFunTimeViewText:BLE_VALUE.getTime.integerValue];
        self.funStausType = FunStatusType_Normal;
    }
}

- (void)nStatePoweredOff {
    [self.funBottomView setDisconnectText];
    [self.funTimeView hideStartCancleBtn];
}

- (void)nDidFailToConnectPeripheral{
    [self.funBottomView setDisconnectText];
    [self.funTimeView hideStartCancleBtn];
}

- (void)nDidDisconnectPeripheral{
    [self.funBottomView setDisconnectText];
    [self.funTimeView hideStartCancleBtn];
}

- (void)nDidWriteData {
    
}

- (void)nDidReceiveData {
    if (BLE_VALUE.command.intValue == 5) {
        if (BLE_VALUE.system.intValue == 2) {
            self.funStausType = FunStatusType_Normal;
            [self setValueFunUI];
        }
        else if (BLE_VALUE.system.intValue == 3) {
            [self setValueFunUI];
            if (BLE_VALUE.minute.integerValue == 0 &&
                BLE_VALUE.second.integerValue == 0) {
                [self funSuccessMinutes:BLE_VALUE.minute.integerValue seconds:BLE_VALUE.second.integerValue];
            }
            else {
                self.funStausType = FunStatusType_Start;
            }
        }
        else {
            self.funStausType = FunStatusType_Error;
        }
    }
}


#pragma mark - NSTimer


- (void)createCountDownTimer {
    if (!_countDownTimer) {
        NSLog(@"创建倒计时");
        
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCountDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSDefaultRunLoopMode];
        [_countDownTimer fire];
    }
}

- (void)removeCountDownTimer {
    if (_countDownTimer) {
        NSLog(@"移除倒计时");
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    }
}

- (void)createShowTimer {
    if (!_showTimer) {
        self.showTimerCount = 0;
        _showTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeShow) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSDefaultRunLoopMode];
        [_showTimer fire];
    }
}

- (void)removeShowTimer {
    if (_showTimer) {
        [_showTimer invalidate];
        _showTimer = nil;
    }
}

#pragma mark - Event
- (void)clickVoiceBtn:(id)sender {
    self.voiceBtn.isHigh = !self.voiceBtn.isHigh;
    BLE_VALUE.isSoundOpen = !self.voiceBtn.isHigh;
}

- (void)clickSettingGuideBtn:(id)sender {
    JJSettingGuideVC *vc = [[JJSettingGuideVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - JJFunSettingViewDelegate

- (void)clickFunSettingView:(JJFunSettingBtn *)btn {
    [JJMessage sendSettingData];
    [self setFunTimeViewText:BLE_VALUE.getTime.integerValue];
}

- (void)didSelectRowNumber:(NSString *)number temp:(NSString *)temp speed:(NSString *)speed {
    [JJMessage sendSettingData];
    [self setFunTimeViewText:BLE_VALUE.getTime.integerValue];
}

#pragma mark - JJFunTimeViewDelegate

- (void)clickFunTimeStartBtn:(JJFunSettingControlBtn *)btn {
    if((BLE_VALUE.minute.intValue + BLE_VALUE.second.intValue) == 0) return;
    [JJMessage sendStartData];
}

- (void)clickFunTimecancelBtn:(JJFunSettingControlBtn *)btn {
    [self.funSettingView setCurValue];
    [self setValueFunUI];
    [JJMessage sendCancelData];
    [self removeCountDownTimer];
    [self.funTimeView showStartBtn];
    [self.funSettingView enable];
}

- (void)clickFunTimeOKBtn:(JJFunSettingControlBtn *)btn {
    [CENTRAL_MANAGER cancelPeripheralConnection];
    [CENTRAL_MANAGER removeRetrieveTimer];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Property
- (JJSelectBtn *)voiceBtn {
    if (_voiceBtn) {
        return _voiceBtn;
    }
    _voiceBtn = [[JJSelectBtn alloc] init];
    _voiceBtn.frame = CGRectMake(8, 15, 35, 35);
    _voiceBtn.normalImage = @"icon_soundon";
    _voiceBtn.highImage = @"icon_soundoff";
    _voiceBtn.isHigh = !BLE_VALUE.isSoundOpen;
    [_voiceBtn addTarget:self action:@selector(clickVoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _voiceBtn;
}

- (UIButton *)settingGuideBtn {
    if (_settingGuideBtn) {
        return _settingGuideBtn;
    }
    _settingGuideBtn = [[UIButton alloc] init];
    _settingGuideBtn.frame = CGRectMake(M_SCREEN_W - 5 - 130, 20, 130, 25);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    label.font = VAGRounded_FONT(16);
    label.textAlignment = NSTextAlignmentRight;
    label.userInteractionEnabled = NO;
    label.text = @"setting guide";
    [_settingGuideBtn addSubview:label];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 25, 25)];
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
