//
//  JJFunSettingView.m
//  BabyBrezza
//
//  Created by Jay on 16/5/28.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJFunSettingView.h"
#import "JJFunSettingLabelView.h"
#import "JJFunSettingBtnView.h"
#import "JJFunSettingBtn.h"

#define PickerView_H 100

@interface JJFunSettingView () <UIPickerViewDataSource, UIPickerViewDelegate, JJFunSettingBtnViewDelegate>

@property (nonatomic, strong) UIPickerView *funSettingPickView;

@property (nonatomic, strong) JJFunSettingLabelView *funSettingLabelView;
@property (nonatomic, strong) JJFunSettingBtnView *funSettingBtnView;

@property (nonatomic, strong) NSArray *numberPickArr;
@property (nonatomic, strong) NSArray *tempPickArr;
@property (nonatomic, strong) NSArray *speedPickArr;


@end

@implementation JJFunSettingView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutFunSettingViewUI];
    }
    return self;
}

#pragma mark - Private Methods

- (void)layoutFunSettingViewUI {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.funSettingLabelView];
    [self addSubview:self.funSettingPickView];
    [self addSubview:self.funSettingBtnView];
    
    [self autolayoutFunSettingViewUI];
}

- (void)autolayoutFunSettingViewUI {
    [self.funSettingLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self);
        make.height.equalTo(@(F_S_L_View_H));
    }];
    
    [self.funSettingPickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.funSettingLabelView.mas_bottom);
        make.bottom.equalTo(self.funSettingBtnView.mas_top);
    }];
    
    [self.funSettingBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@(F_S_L_View_H));
        make.bottom.equalTo(self.mas_bottom);
    }];
}


#pragma mark - JJFunSettingBtnViewDelegate
- (void)clickFunSettingBtnView:(JJFunSettingBtn *)btn {
    JJFunBtnType type = btn.type;
    if (type == FunBtnType_NumUp) {
        NSUInteger curRow = [self.funSettingPickView selectedRowInComponent:0];
        [self.funSettingPickView selectRow:++curRow inComponent:0 animated:YES];
    }
    else if (type == FunBtnType_NumDown) {
        NSUInteger curRow = [self.funSettingPickView selectedRowInComponent:0];
        [self.funSettingPickView selectRow:--curRow inComponent:0 animated:YES];
    }
    else if (type == FunBtnType_TempUp) {
        NSUInteger curRow = [self.funSettingPickView selectedRowInComponent:1];
        [self.funSettingPickView selectRow:++curRow inComponent:1 animated:YES];
    }
    else if (type == FunBtnType_TempDown) {
        NSUInteger curRow = [self.funSettingPickView selectedRowInComponent:1];
        [self.funSettingPickView selectRow:--curRow inComponent:1 animated:YES];
    }
    else if (type == FunBtnType_SpeedUp) {
        NSUInteger curRow = [self.funSettingPickView selectedRowInComponent:2];
        [self.funSettingPickView selectRow:++curRow inComponent:2 animated:YES];
    }
    else if (type == FunBtnType_SpeedDown) {
        NSUInteger curRow = [self.funSettingPickView selectedRowInComponent:2];
        [self.funSettingPickView selectRow:--curRow inComponent:2 animated:YES];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickFunSettingView:)]) {
        [_delegate clickFunSettingView:btn];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return self.numberPickArr.count;
    }
    else if (component == 1) {
        return self.tempPickArr.count;
    }
    else if (component == 2) {
        return self.speedPickArr.count;
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSString *number = [self.numberPickArr objectAtIndex:row];
        NSLog(@"%@", number);
    }
    else if (component == 1) {
        NSString *speed = [self.tempPickArr objectAtIndex:row];
        NSLog(@"%@", speed);
    }
    else if (component == 2) {
        NSString *temp = [self.speedPickArr objectAtIndex:row];
        NSLog(@"%@", temp);
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        return [self.numberPickArr objectAtIndex:row];
    }
    else if (component == 1) {
        return [self.tempPickArr objectAtIndex:row];
    }
    else if (component == 2) {
        return [self.speedPickArr objectAtIndex:row];
    }
    
    return nil;
}


#pragma mark - Property

- (JJFunSettingLabelView *)funSettingLabelView {
    if (_funSettingLabelView) {
        return _funSettingLabelView;
    }
    _funSettingLabelView = [[JJFunSettingLabelView alloc] init];
    _funSettingLabelView.backgroundColor = [UIColor clearColor];
    return _funSettingLabelView;
}

- (UIPickerView *)funSettingPickView {
    if (_funSettingPickView) {
        return _funSettingPickView;
    }
    _funSettingPickView = [[UIPickerView alloc] init];
    _funSettingPickView.backgroundColor = [UIColor clearColor];
    _funSettingPickView.delegate = self;
    _funSettingPickView.dataSource = self;
    return _funSettingPickView;
}

- (JJFunSettingBtnView *)funSettingBtnView {
    if (_funSettingBtnView) {
        return _funSettingBtnView;
    }
    _funSettingBtnView = [[JJFunSettingBtnView alloc] init];
    _funSettingBtnView.delegate = self;
    _funSettingBtnView.backgroundColor = [UIColor clearColor];
    return _funSettingBtnView;
}



- (NSArray *)numberPickArr {
    if (_numberPickArr) {
        return _numberPickArr;
    }
    _numberPickArr = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"Bottle oz", nil];
    return _numberPickArr;
}

- (NSArray *)speedPickArr {
    if (_speedPickArr) {
        return _speedPickArr;
    }
    _speedPickArr = [NSArray arrayWithObjects:@"quick",@"steady", nil];
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
