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
#import "JJLanguageBtn.h"
/** VC */
#import "JJConnectVC.h"
#import "JJFunctionVC.h"



@interface JJMainVC () 

@property (nonatomic, strong) UIButton *scanBtn;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) JJLanguageBtn *enBtn;

@property (nonatomic, strong) JJLanguageBtn *frBtn;

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
    [self languageBinding];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addMainNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeMainNotification];
}

#pragma mark - Private Methods
- (void)layoutMainUI {
    [self.view addSubview:self.scanBtn];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.enBtn];
    [self.view addSubview:self.frBtn];
    
    [CENTRAL_MANAGER initData];
    [BLE_MANAGER initData];
    
}

- (void)languageBinding {
    @weakify(self);
    [RACObserve([JJBLEManager sharedInstance], languageType) subscribeNext:^(NSNumber *languageType) {
        @strongify(self);
        self.textLabel.text = [BBUtils languageStrType:JJLanguageStrTypeSFYBW];
        if (languageType.integerValue == JJLanguageTypeEN) {
            [self.enBtn boldTitle:YES];
            [self.frBtn boldTitle:NO];
        }
        else {
            [self.enBtn boldTitle:NO];
            [self.frBtn boldTitle:YES];
        }
    }];
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
    [BLE_VALUE initData];
    CENTRAL_MANAGER.isAutoConnect = YES;
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

- (void)clickENBtn:(id)sender {
    [BBUtils saveLanguageType:JJLanguageTypeEN];
}

- (void)clickFRBtn:(id)sender {
    [BBUtils saveLanguageType:JJLanguageTypeFR];
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
    _textLabel.font = VAGRounded_FONT(S_SCALE_W_4(18));
    _textLabel.text = kScanForYourBottleWarmer_EN;
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
    _versionLabel.font = VAGRounded_FONT(S_SCALE_W_4(18));
    _versionLabel.text = @"Brezza v1.1";  //LLY 0818
    return _versionLabel;
}

- (JJLanguageBtn *)enBtn {
    if (!_enBtn) {
        _enBtn = [[JJLanguageBtn alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
        _enBtn.tLabel.text = kEN;
        [_enBtn boldTitle:YES];
        [_enBtn addTarget:self action:@selector(clickENBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _enBtn;
}

- (JJLanguageBtn *)frBtn {
    if (!_frBtn) {
        _frBtn = [[JJLanguageBtn alloc] initWithFrame:CGRectMake(60, 10, 44, 44)];
        _frBtn.tLabel.text = kFR;
        [_enBtn boldTitle:NO];
        [_frBtn addTarget:self action:@selector(clickFRBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _frBtn;
}

@end
