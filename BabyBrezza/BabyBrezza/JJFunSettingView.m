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

@interface JJFunSettingView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *funSettingPickView;

@property (nonatomic, strong) JJFunSettingLabelView *funSettingLabelView;
@property (nonatomic, strong) JJFunSettingBtnView *funSettingBtnView;

@property (nonatomic, strong) NSArray *numberPickArr;
@property (nonatomic, strong) NSArray *tempPickArr;
@property (nonatomic, strong) NSArray *speedPickArr;


@property (nonatomic, strong) JJFunSettingBtn *numberUpBtn;
@property (nonatomic, strong) JJFunSettingBtn *numberDownBtn;

@property (nonatomic, strong) JJFunSettingBtn *tempUpBtn;
@property (nonatomic, strong) JJFunSettingBtn *tempDownBtn;

@property (nonatomic, strong) JJFunSettingBtn *speedUpBtn;
@property (nonatomic, strong) JJFunSettingBtn *speedDownBtn;



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
    
    [self.funSettingBtnView addSubview:self.numberUpBtn];
    [self.funSettingBtnView addSubview:self.numberDownBtn];
    [self.funSettingBtnView addSubview:self.tempUpBtn];
    [self.funSettingBtnView addSubview:self.tempDownBtn];
    [self.funSettingBtnView addSubview:self.speedUpBtn];
    [self.funSettingBtnView addSubview:self.speedDownBtn];
    
    
    [self autolayoutFunSettingViewUI];
    [self autolayoutFunSettingBtnViewUI];
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

- (void)autolayoutFunSettingBtnViewUI {
    
    [self.funSettingBtnView addSubview:self.numberUpBtn];
    [self.funSettingBtnView addSubview:self.numberDownBtn];
    [self.funSettingBtnView addSubview:self.tempUpBtn];
    [self.funSettingBtnView addSubview:self.tempDownBtn];
    [self.funSettingBtnView addSubview:self.speedUpBtn];
    [self.funSettingBtnView addSubview:self.speedDownBtn];
    
    [self.numberUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.funSettingBtnView.mas_top);
        make.bottom.equalTo(self.funSettingBtnView.mas_bottom);
        make.left.equalTo(self.funSettingBtnView.mas_left);
        make.width.equalTo(@((M_SCREEN_W-20)/6));
    }];
    
    [self.numberDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.funSettingBtnView.mas_top);
        make.bottom.equalTo(self.funSettingBtnView.mas_bottom);
        make.left.equalTo(self.numberUpBtn.mas_right);
        make.width.equalTo(self.numberUpBtn.mas_width);
    }];
    
    [self.tempUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.funSettingBtnView.mas_top);
        make.bottom.equalTo(self.funSettingBtnView.mas_bottom);
        make.left.equalTo(self.numberDownBtn.mas_right);
        make.width.equalTo(self.numberUpBtn.mas_width);
    }];
    
    [self.tempDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.funSettingBtnView.mas_top);
        make.bottom.equalTo(self.funSettingBtnView.mas_bottom);
        make.left.equalTo(self.tempUpBtn.mas_right);
        make.width.equalTo(self.numberUpBtn.mas_width);
    }];
    
    [self.speedUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.funSettingBtnView.mas_top);
        make.bottom.equalTo(self.funSettingBtnView.mas_bottom);
        make.left.equalTo(self.tempDownBtn.mas_right);
        make.width.equalTo(self.numberUpBtn.mas_width);
    }];
    
    [self.speedDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.funSettingBtnView.mas_top);
        make.bottom.equalTo(self.funSettingBtnView.mas_bottom);
        make.left.equalTo(self.speedUpBtn.mas_right);
        make.width.equalTo(self.numberUpBtn.mas_width);
    }];
    
    
    
}
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {

}
#pragma mark - Event
- (void)clickFunBtn:(JJFunSettingBtn *)btn {
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
        return self.speedPickArr.count;
    }
    else if (component == 2) {
        return self.tempPickArr.count;
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSString *number = [self.numberPickArr objectAtIndex:row];
    }
    else if (component == 1) {
        NSString *speed = [self.speedPickArr objectAtIndex:row];
    }
    else if (component == 2) {
        NSString *temp = [self.tempPickArr objectAtIndex:row];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        return [self.numberPickArr objectAtIndex:row];
    }
    else if (component == 1) {
        return [self.speedPickArr objectAtIndex:row];
    }
    else if (component == 2) {
        return [self.tempPickArr objectAtIndex:row];
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
    _funSettingBtnView.backgroundColor = [UIColor clearColor];
    return _funSettingBtnView;
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


- (JJFunSettingBtn *)numberUpBtn {
    if (_numberUpBtn) {
        return _numberUpBtn;
    }
    _numberUpBtn = [[JJFunSettingBtn alloc] init];
    _numberUpBtn.type = FunBtnType_NumUp;
    [_numberUpBtn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
    [_numberUpBtn addTarget:self action:@selector(clickFunBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _numberUpBtn;
}

- (JJFunSettingBtn *)numberDownBtn {
    if (_numberDownBtn) {
        return _numberDownBtn;
    }
    _numberDownBtn = [[JJFunSettingBtn alloc] init];
    _numberDownBtn.type = FunBtnType_NumDown;
    [_numberDownBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [_numberDownBtn addTarget:self action:@selector(clickFunBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _numberUpBtn;
}

- (JJFunSettingBtn *)speedUpBtn {
    if (_speedUpBtn) {
        return _speedUpBtn;
    }
    _speedUpBtn = [[JJFunSettingBtn alloc] init];
    _speedUpBtn.type = FunBtnType_SpeedUp;
    [_speedUpBtn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
    [_speedUpBtn addTarget:self action:@selector(clickFunBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _speedUpBtn;
}

- (JJFunSettingBtn *)speedDownBtn {
    if (_speedDownBtn) {
        return _speedDownBtn;
    }
    _speedDownBtn = [[JJFunSettingBtn alloc] init];
    _speedDownBtn.type = FunBtnType_SpeedDown;
    [_speedDownBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [_speedDownBtn addTarget:self action:@selector(clickFunBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _speedDownBtn;
}

- (JJFunSettingBtn *)tempUpBtn {
    if (_tempUpBtn) {
        return _tempUpBtn;
    }
    _tempUpBtn = [[JJFunSettingBtn alloc] init];
    _tempUpBtn.type = FunBtnType_TempUp;
    [_tempUpBtn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
    [_tempUpBtn addTarget:self action:@selector(clickFunBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _tempUpBtn;
}

- (JJFunSettingBtn *)tempDownBtn {
    if (_tempDownBtn) {
        return _tempDownBtn;
    }
    _tempDownBtn = [[JJFunSettingBtn alloc] init];
    _tempDownBtn.type = FunBtnType_TempDown;
    [_tempDownBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [_tempDownBtn addTarget:self action:@selector(clickFunBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _tempDownBtn;
}

@end
