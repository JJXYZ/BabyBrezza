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
#import "JJBLEValue.h"

#define PickerView_H 100

#define NumberPickerViewNum 1000

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

- (NSUInteger)pNumberRow:(NSUInteger)row {
    return row % self.numberPickArr.count;
}

- (NSUInteger)pSetNumberRow:(NSUInteger)row {
    return row + self.numberPickArr.count * NumberPickerViewNum / 2;
}

- (void)updatePickViewRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 9) {
        [self reloadPickViewType:1];
    }
    else {
        [self reloadPickViewType:0];
    }
}

- (void)reloadPickViewType:(NSUInteger)type {
    [self setTempPickArrType:type];
    [self setSpeedPickArrType:type];
    [self.funSettingPickView reloadComponent:1];
    [self.funSettingPickView reloadComponent:2];
}


#pragma mark - Public Methods

- (NSUInteger)getPickViewNumber {
    NSUInteger curRow = [self.funSettingPickView selectedRowInComponent:0];
    NSUInteger number = [self pNumberRow:curRow] + 1;
    return number;
}

- (void)setStartPickViewNumber:(NSString *)number {
    NSInteger row = number.integerValue - 1;
    [self.funSettingPickView selectRow:[self pSetNumberRow:row] inComponent:0 animated:YES];
}

- (void)setPickViewNumber:(NSString *)number {
    NSInteger row = number.integerValue - 1;
    NSUInteger curRow = [self.funSettingPickView selectedRowInComponent:0];
    if (row != [self pNumberRow:curRow]) {
        [self.funSettingPickView selectRow:row + self.numberPickArr.count * NumberPickerViewNum/2 inComponent:0 animated:YES];
    }
}

- (NSUInteger)getPickViewTemp {
    NSUInteger curRow = [self.funSettingPickView selectedRowInComponent:1];
    return curRow + 1;
}

- (void)setPickViewTemp:(NSString *)temp {
    NSInteger row = temp.integerValue - 1;
    NSUInteger curRow = [self.funSettingPickView selectedRowInComponent:1];
    if (row != curRow) {
        [self.funSettingPickView selectRow:row inComponent:1 animated:YES];
    }
}

- (NSUInteger)getPickViewSpeed {
    NSUInteger curRow = [self.funSettingPickView selectedRowInComponent:2];
    return curRow + 1;
}

- (void)setPickViewSpeed:(NSString *)speed {
    NSInteger row = speed.integerValue - 1;
    NSUInteger curRow = [self.funSettingPickView selectedRowInComponent:2];
    if (row != curRow) {
        [self.funSettingPickView selectRow:row inComponent:2 animated:YES];
    }
}

- (void)setValueNumberRow:(NSUInteger)row {
    NSUInteger number = row + 1;
    BLE_VALUE.number = [NSString stringWithFormat:@"%lu", (unsigned long)number];
}

- (void)setValueTempRow:(NSUInteger)row {
    NSUInteger temp = row + 1;
    BLE_VALUE.temp = [NSString stringWithFormat:@"%lu", (unsigned long)temp];
}

- (void)setValueSpeedRow:(NSUInteger)row {
    NSUInteger speed = row + 1;
    BLE_VALUE.speed = [NSString stringWithFormat:@"%lu", (unsigned long)speed];
}

- (void)disable {
    self.funSettingPickView.userInteractionEnabled = NO;
    self.funSettingBtnView.userInteractionEnabled = NO;
}

- (void)enable {
    self.funSettingPickView.userInteractionEnabled = YES;
    self.funSettingBtnView.userInteractionEnabled = YES;
}

- (void)setCurState {
    NSUInteger numberRow = [self.funSettingPickView selectedRowInComponent:0];
    NSUInteger tempRow = [self.funSettingPickView selectedRowInComponent:1];
    NSUInteger speedRow = [self.funSettingPickView selectedRowInComponent:2];
    
    [self setValueNumberRow:[self pNumberRow:numberRow]];
    [self setValueTempRow:tempRow];
    [self setValueSpeedRow:speedRow];
    
    [BLE_VALUE setTimeValue];
}

#pragma mark - Event

- (void)clickNumberBtnType:(JJFunBtnType)type {
    NSUInteger row = [self.funSettingPickView selectedRowInComponent:0];
    if (type == FunBtnType_NumUp) {
        ++row;
    }
    else if (type == FunBtnType_NumDown) {
        --row;
    }
    [self.funSettingPickView selectRow:row inComponent:0 animated:YES];
    row = [self pNumberRow:row];
    [self setValueNumberRow:row];
    [self updatePickViewRow:row inComponent:0];
}

- (BOOL)clickTempBtnType:(JJFunBtnType)type {
    BOOL isValidClick = NO;
    NSUInteger row = [self.funSettingPickView selectedRowInComponent:1];
    if (type == FunBtnType_TempUp) {
        if (row == 0) {
            isValidClick = YES;
            ++row;
        }
    }
    else if (type == FunBtnType_TempDown) {
        if (row == 1) {
            isValidClick = YES;
            --row;
        }
    }
    [self.funSettingPickView selectRow:row inComponent:1 animated:YES];
    [self setValueTempRow:row];
    return isValidClick;
}

- (BOOL)clickSpeedBtnType:(JJFunBtnType)type {
    BOOL isValidClick = NO;
    NSUInteger row = [self.funSettingPickView selectedRowInComponent:2];
    if (type == FunBtnType_SpeedUp) {
        if (row == 0) {
            isValidClick = YES;
            ++row;
        }
    }
    else if (type == FunBtnType_SpeedDown) {
        if (row == 1) {
            isValidClick = YES;
            --row;
        }
    }
    [self.funSettingPickView selectRow:row inComponent:2 animated:YES];
    [self setValueSpeedRow:row];
    return isValidClick;
}


#pragma mark - JJFunSettingBtnViewDelegate
- (void)clickFunSettingBtnView:(JJFunSettingBtn *)btn {
    BOOL isValidClick = YES;
    JJFunBtnType type = btn.type;
    if (type == FunBtnType_NumUp || type == FunBtnType_NumDown) {
        [self clickNumberBtnType:type];
    }
    else if (type == FunBtnType_TempUp || type == FunBtnType_TempDown) {
        isValidClick = [self clickTempBtnType:type];
    }
    else if (type == FunBtnType_SpeedUp || type == FunBtnType_SpeedDown) {
        isValidClick = [self clickSpeedBtnType:type];
    }
    
    if (isValidClick) {
        [BLE_VALUE setTimeValue];
        if (_delegate && [_delegate respondsToSelector:@selector(clickFunSettingView:)]) {
            [_delegate clickFunSettingView:btn];
        }
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return self.numberPickArr.count * NumberPickerViewNum;
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
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return (S_SCALE_H_4(27));
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        row = [self pNumberRow:row];
        [self setValueNumberRow:row];
        [self.funSettingPickView selectRow:[self pSetNumberRow:row] inComponent:0 animated:NO];
        [self updatePickViewRow:row inComponent:component];
    }
    else if (component == 1) {
        [self setValueTempRow:row];
    }
    else if (component == 2) {
        [self setValueSpeedRow:row];
    }
    
    [BLE_VALUE setTimeValue];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectRowNumber:temp:speed:)]) {
        [_delegate didSelectRowNumber:nil temp:nil speed:nil];
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        return [self.numberPickArr objectAtIndex:[self pNumberRow:row]];
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
    _numberPickArr = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"defrost", nil];
    return _numberPickArr;
}

- (NSArray *)speedPickArr {
    if (_speedPickArr) {
        return _speedPickArr;
    }
    _speedPickArr = [NSArray arrayWithObjects:@"steady",@"quick", nil];
    return _speedPickArr;
}

- (void)setSpeedPickArrType:(NSUInteger)type {
    if (type == 0) {
        _speedPickArr = [NSArray arrayWithObjects:@"steady",@"quick", nil];
    }
    else {
        _speedPickArr = [NSArray arrayWithObjects:@"steady", nil];
    }
}


- (NSArray *)tempPickArr {
    if (_tempPickArr) {
        return _tempPickArr;
    }
    _tempPickArr = [NSArray arrayWithObjects:@"room",@"cold", nil];
    return _tempPickArr;
}

- (void)setTempPickArrType:(NSUInteger)type {
    if (type == 0) {
        _tempPickArr = [NSArray arrayWithObjects:@"room",@"cold", nil];
    }
    else {
        _tempPickArr = [NSArray arrayWithObjects:@"cold", nil];
    }
}


@end
