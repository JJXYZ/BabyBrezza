//
//  JJFunctionVC.m
//  BabyBrezza
//
//  Created by Jay on 15/10/1.
//  Copyright © 2015年 XJ. All rights reserved.
//

#import "JJFunctionVC.h"
#import "JJFunSettingView.h"

@interface JJFunctionVC () 

@property (nonatomic, strong) JJFunSettingView *funSettingView;


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
    [self.view addSubview:self.funSettingView];
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

- (void)clickBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)clickStartBtn:(id)sender {
    
    NSString *time = [self.numberPickArr objectAtIndex:[self.numberPickView selectedRowInComponent:0]];
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


@end
