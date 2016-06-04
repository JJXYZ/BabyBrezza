//
//  JJMainVC.m
//  BabyBrezza
//
//  Created by Jay on 15/9/30.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "JJMainVC.h"
#import "SVProgressHUD.h"
#import "JJCBCentralManager.h"
#import "JJBLEManager.h"
#import "JJMessage.h"
/** VC */
#import "JJConnectVC.h"
#import "JJFunctionVC.h"



@interface JJMainVC () 

@property (nonatomic, strong) UIButton *scanBtn;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation JJMainVC

#pragma mark - Lifecycle

//单例
+ (JJMainVC *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static JJMainVC * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutMainUI];
    [self addtMainNotification];
}

#pragma mark - Private Methods
- (void)layoutMainUI {
    [self.view addSubview:self.scanBtn];
    [self.view addSubview:self.textLabel];
    
    [JJCBCentralManager sharedInstance];
    [JJBLEManager sharedInstance];
}

- (void)addtMainNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nDidConnectPeripheral) name:NOTIFY_DidConnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nTimerStopScan) name:NOTIFY_TimerStopScan object:nil];
    
}

- (void)pushConnectedVC {
    JJConnectVC *vc = [[JJConnectVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Notification
- (void)nDidConnectPeripheral {
    [SVProgressHUD dismiss];
    [self pushConnectedVC];
}

- (void)nTimerStopScan {
    [SVProgressHUD dismiss];
}

#pragma mark - Event


- (void)clickScanBtn:(id)sender {
#if 0
    [self pushConnectedVC];
    return ;
#endif
    [BLE_MANAGER stopScan];
    [BLE_MANAGER createScanTimer];
    [SVProgressHUD show];
}




#pragma mark - Property
- (UIButton *)scanBtn {
    if (_scanBtn){
        return _scanBtn;
    }
    _scanBtn = [[UIButton alloc] init];
    _scanBtn.frame = CGRectMake(0, 0, S_SCALE_W_4(100), S_SCALE_W_4(150));
    _scanBtn.center = CGPointMake(self.view.center.x, self.view.center.y);
    [_scanBtn setImage:[UIImage imageNamed:@"bluetooth_icon"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(clickScanBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _scanBtn;
}

- (UILabel *)textLabel {
    if (_textLabel) {
        return _textLabel;
    }
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - S_SCALE_W_4(50) - S_SCALE_W_4(30), self.view.width, S_SCALE_W_4(30))];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.font = S_FONT(S_SCALE_W_4(18));
    _textLabel.text = @"scan for your bottle warmer";
    return _textLabel;
}

@end
