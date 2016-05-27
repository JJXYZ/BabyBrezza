//
//  XJFunctionVC.m
//  BabyBrezza
//
//  Created by Jay on 15/10/1.
//  Copyright © 2015年 XJ. All rights reserved.
//

#import "XJFunctionVC.h"

@interface XJFunctionVC () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *numberPickView;
@property (nonatomic, strong) NSArray *numberPickArr;

@property (weak, nonatomic) IBOutlet UIPickerView *speedPickView;
@property (nonatomic, strong) NSArray *speedPickArr;

@property (weak, nonatomic) IBOutlet UIPickerView *tempPickView;
@property (nonatomic, strong) NSArray *tempPickArr;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (assign, nonatomic) NSUInteger timeout;
;
//倒计时
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

- (IBAction)clickBackBtn:(id)sender;
- (IBAction)clickStartBtn:(id)sender;

@end

@implementation XJFunctionVC

#pragma mark - Lifecycle

//单例
+ (XJFunctionVC *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static XJFunctionVC * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)dealloc {
    [self removeCountDownTimer];
}

#pragma mark - Private Methods

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




#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == self.numberPickView) {
        return self.numberPickArr.count;
    }
    else if (pickerView == self.speedPickView) {
        return self.speedPickArr.count;
    }
    else if (pickerView == self.tempPickView) {
        return self.tempPickArr.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.numberPickView) {
        NSString *time = [self.numberPickArr objectAtIndex:row];
        self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:00", (long)time.integerValue];
    }
    else if (pickerView == self.speedPickView) {
        
    }
    else if (pickerView == self.tempPickView) {
        
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView == self.numberPickView) {
        return [self.numberPickArr objectAtIndex:row];
    }
    else if (pickerView == self.speedPickView) {
        return [self.speedPickArr objectAtIndex:row];
    }
    else if (pickerView == self.tempPickView) {
        return [self.tempPickArr objectAtIndex:row];
    }
    
    return nil;
}


#pragma mark - Event

- (IBAction)clickBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)clickStartBtn:(id)sender {
    
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

#pragma mark - Property
- (NSArray *)numberPickArr {
    if (_numberPickArr) {
        return _numberPickArr;
    }
    _numberPickArr = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
    return _numberPickArr;
}

- (NSArray *)speedPickArr {
    if (_speedPickArr) {
        return _speedPickArr;
    }
    _speedPickArr = [NSArray arrayWithObjects:@"fast",@"slow", nil];
    return _speedPickArr;
}


- (NSArray *)tempPickArr {
    if (_tempPickArr) {
        return _tempPickArr;
    }
    _tempPickArr = [NSArray arrayWithObjects:@"room",@"cold", nil];
    return _tempPickArr;
}

@end
