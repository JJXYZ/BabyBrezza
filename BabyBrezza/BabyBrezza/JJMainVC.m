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
#import "JJBLEValue.h"
/** VC */
#import "JJConnectVC.h"
#import "JJFunctionVC.h"



@interface JJMainVC () 

@property (nonatomic, strong) UIButton *scanBtn;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *versionLabel;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addMainNotification];
    CENTRAL_MANAGER.isAutoConnect = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeMainNotification];
    CENTRAL_MANAGER.isAutoConnect = YES;
}

#pragma mark - Private Methods
- (void)layoutMainUI {
    [self.view addSubview:self.scanBtn];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.versionLabel];
    [JJCBCentralManager sharedInstance];
    [JJBLEManager sharedInstance];
}

- (void)addMainNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nDidConnectPeripheral) name:NOTIFY_DidConnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nTimerStopScan) name:NOTIFY_TimerStopScan object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nReadyToSendData) name:NOTIFY_ReadyToSendData object:nil];
    
}

- (void)removeMainNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_DidConnectPeripheral object:nil];
    
    
}

- (void)pushConnectedVC {
    JJConnectVC *vc = [[JJConnectVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Notification
- (void)nDidConnectPeripheral {
    self.scanBtn.hidden = NO;
    [SVProgressHUD dismiss];
    [self pushConnectedVC];
}

- (void)nTimerStopScan {
    self.scanBtn.hidden = NO;
    [SVProgressHUD dismiss];
}

- (void)nReadyToSendData {
    
}


#pragma mark - Event


- (void)clickScanBtn:(id)sender {
#if 0
    [BLE_VALUE playNotiSound:NO];
    return ;
#endif
    
#if 0
    [self pushConnectedVC];
    return ;
#endif
    
    self.scanBtn.hidden = YES;
    [BLE_MANAGER stopScan];
    [BLE_MANAGER createScanTimer];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
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
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.scanBtn.bottom + S_SCALE_W_4(20), self.view.width, S_SCALE_W_4(30))];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.font = S_FONT(S_SCALE_W_4(18));
    _textLabel.text = @"scan for your bottle warmer";
    return _textLabel;
}

- (UILabel *)versionLabel {
    if (_versionLabel) {
        return _versionLabel;
    }
    _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - S_SCALE_W_4(50) - S_SCALE_W_4(30), self.view.width, S_SCALE_W_4(30))];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.backgroundColor = [UIColor clearColor];
    _versionLabel.textColor = [UIColor blackColor];
    _versionLabel.font = S_FONT(S_SCALE_W_4(18));
    _versionLabel.text = @"Brezza v0.6.20";
    return _versionLabel;
}


@end
