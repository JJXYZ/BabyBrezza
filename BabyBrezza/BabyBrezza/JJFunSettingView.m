//
//  JJFunSettingView.m
//  BabyBrezza
//
//  Created by Jay on 16/5/28.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "JJFunSettingView.h"

#define PickerView_H 100

@interface JJFunSettingView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *numberPickView;
@property (nonatomic, strong) NSArray *numberPickArr;

@property (nonatomic, strong) UIPickerView *speedPickView;
@property (nonatomic, strong) NSArray *speedPickArr;

@property (nonatomic, strong) UIPickerView *tempPickView;
@property (nonatomic, strong) NSArray *tempPickArr;

@end

@implementation JJFunSettingView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
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


#pragma mark - Property
- (UIPickerView *)numberPickView {
    if (_numberPickView) {
        return _numberPickView;
    }
    _numberPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.width, PickerView_H)];
    _numberPickView.backgroundColor = [UIColor whiteColor];
    _numberPickView.delegate = self;
    _numberPickView.dataSource = self;
    return _numberPickView;
}

- (UIPickerView *)speedPickView {
    if (_speedPickView) {
        return _speedPickView;
    }
    _speedPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.width, PickerView_H)];
    _speedPickView.backgroundColor = [UIColor whiteColor];
    _speedPickView.delegate = self;
    _speedPickView.dataSource = self;
    return _speedPickView;
}


- (UIPickerView *)tempPickView {
    if (_tempPickView) {
        return _tempPickView;
    }
    _tempPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.width, PickerView_H)];
    _tempPickView.backgroundColor = [UIColor whiteColor];
    _tempPickView.delegate = self;
    _tempPickView.dataSource = self;
    return _tempPickView;
}


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
