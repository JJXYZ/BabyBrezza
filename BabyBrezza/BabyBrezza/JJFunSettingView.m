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


//LLY @0706
//#define LLY_SHOW_3LINES

#define PickerView_H 100

#define NumberPickerViewNum 1000

@interface JJFunSettingView () <UIPickerViewDataSource, UIPickerViewDelegate, JJFunSettingBtnViewDelegate>

@property (nonatomic, strong) UIPickerView *funSettingPickView;

@property (nonatomic, strong) JJFunSettingLabelView *funSettingLabelView;
@property (nonatomic, strong) JJFunSettingBtnView *funSettingBtnView;

@property (nonatomic, strong) NSArray *numberPickArr;
@property (nonatomic, strong) NSArray *tempPickArr;
@property (nonatomic, strong) NSArray *speedPickArr;

@property (nonatomic, assign) BOOL isShowDefrost;

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
        if (!self.isShowDefrost) {
            [self reloadPickViewType:1];
            [self.funSettingBtnView hiddenTempSpeedBtn];
        }
        self.isShowDefrost = YES;
    }
    else {
        if (self.isShowDefrost) {
            [self reloadPickViewType:0];
            [self.funSettingBtnView showTempSpeedBtn];
        }
        self.isShowDefrost = NO;
    }
    
    //LLY @0706
    #ifdef LLY_SHOW_3LINES
    [self.funSettingPickView reloadComponent:0];
    #endif
    
    
}

- (void)reloadPickViewType:(NSUInteger)type {
    [self setTempPickArrType:type];
    [self setSpeedPickArrType:type];
    [self.funSettingPickView reloadComponent:1];
    [self.funSettingPickView reloadComponent:2];
}

//LLY test
- (void)refeshPickerView{
    [self.funSettingPickView reloadComponent:0];
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
        [self updatePickViewRow:row inComponent:0];
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
    if (row == 0) {
        row = 1;
    }
    else {
        row = 0;
    }
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
    if (row == 0) {
        row = 1;
    }
    else {
        row = 0;
    }
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

- (void)setCurValue {
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

//LLY @0706 : added the mathod
#ifdef LLY_SHOW_3LINES
- (BOOL) checkDisplayedRow:(NSInteger)row{
    BOOL check;
    NSInteger i,n;
    
    
    n = [self getPickViewNumber];
    
    
    NSUInteger curRow = [self.funSettingPickView selectedRowInComponent:0];
    
    NSString *t = [NSString stringWithFormat:@"currow=%d, num=%d, titleForRow=", curRow, n];
    NSString *s = [self.numberPickArr objectAtIndex:[self pNumberRow:row]];
    t=[t stringByAppendingString:s];
    NSLog(t);
    
    if([s compare:@"defrost"] == 0)
    {
        i = self.numberPickArr.count;
    }
    else
    {
        i = s.intValue;
    }
    
    check = true;
    
    NSInteger i_1 = [self pNumberRow:i-1];
    NSInteger i_2 = [self pNumberRow:i+1];
    
    if(n != i)
    {
        n = [self pNumberRow:n];
        
        if((n != i_1) && (n != i_2))
        {
            check = false;
        }
    }
    t = [NSString stringWithFormat:@"currow=%d, n=%d, i=%d, i-1=%d, i+1=%d", curRow, n, i, i_1, i_2];
    NSLog(t);
    
    return check;
}
#endif //LLY_SHOW_3LINES


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
    [self setCurValue];
    if (isValidClick) {
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
    
    [self setCurValue];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectRowNumber:temp:speed:)]) {
        [_delegate didSelectRowNumber:nil temp:nil speed:nil];
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0)
    {
        //LLY @0706
        #ifdef LLY_SHOW_3LINES
        NSString *s = @"blank";
        bool check = [self checkDisplayedRow:row];
        if(check == true)
        {
            s = [self.numberPickArr objectAtIndex:[self pNumberRow:row]];
        };
        
        NSLog(s);
        return s;
        
        #else  //LLY_SHOW_3LINES
        //xugong's code
        return [self.numberPickArr objectAtIndex:[self pNumberRow:row]];
        
        #endif //LLY_SHOW_3LINES
    }
    else if (component == 1) {
        return [self.tempPickArr objectAtIndex:row];
    }
    else if (component == 2) {
        return [self.speedPickArr objectAtIndex:row];
    }
    
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    if (![pickerLabel isKindOfClass:[UILabel class]]) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.font = VAGRounded_FONT(24);             //LLY @0705 17-->24
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    //LLY @0706
    #ifdef LLY_SHOW_3LINES
    if((component == 0) && ([self checkDisplayedRow:row] == false))
    {
        pickerLabel.textColor = [UIColor clearColor];
    }
    else
    {
        pickerLabel.textColor = [UIColor blackColor];
    }
    #endif //LLY_SHOW_3LINES
    
    return pickerLabel;
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
