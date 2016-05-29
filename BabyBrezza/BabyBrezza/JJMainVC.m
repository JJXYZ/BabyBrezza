//
//  JJMainVC.m
//  BabyBrezza
//
//  Created by Jay on 15/9/30.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "JJMainVC.h"
#import "SVProgressHUD.h"
#import "KSCentralManager.h"
#import "KSCBPeripheral.h"
#import "Config.h"
#import "JJMainCell.h"
#import "JJMessage.h"
/** VC */
#import "JJConnectVC.h"
#import "JJFunctionVC.h"

/** 扫描定时器时间 */
#define SCAN_TIME 30

@interface JJMainVC () <KSCentralManagerDelegate, JJMainCellDelegate>

@property (nonatomic, strong) UIButton *scanBtn;

@property (nonatomic, strong) UILabel *textLabel;

//扫描定时器
@property (nonatomic, strong) NSTimer *scanTimer;

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
    
    CENTRAL_MANAGER.delegate = self;
    
    [self layoutMainUI];
}

#pragma mark - Private Methods
- (void)layoutMainUI {
    [self.view addSubview:self.scanBtn];
    [self.view addSubview:self.textLabel];
}

- (void)pushConnectedVC {
    JJConnectVC *vc = [[JJConnectVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)stopScanPeripheral
{
    [CENTRAL_MANAGER stopScanForPeripherals];
    [SVProgressHUD dismiss];
    [self removeScanTimer];
}


#pragma mark - Event


- (void)clickScanBtn:(id)sender {
    [self stopScanPeripheral];
    /** 开始扫描 */
    [self createScanTimer];
    [SVProgressHUD show];
}


#pragma mark - NSTimer

- (void)createScanTimer {
    
    [self removeScanTimer];
    
    NSLog(@"创建扫描定时器 %lu秒", (unsigned long)SCAN_TIME);
    
    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:SCAN_TIME target:self selector:@selector(stopScanPeripheral) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.scanTimer forMode:NSDefaultRunLoopMode];
    
    [CENTRAL_MANAGER scanForPeripherals];
}

- (void)removeScanTimer {
    if (self.scanTimer) {
        NSLog(@"移除扫描定时器 %lu秒", (unsigned long)SCAN_TIME);
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }
}

#pragma mark - JJMainCellDelegate
- (void)mainCell:(JJMainCell *)cell longTap:(UILongPressGestureRecognizer *)longRecognizer {
    
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"Notification on the connected device" message:@"Do you want to turn off the device" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancle");
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK");
        [JJMessage closeCurPeripheral];
    }];
    
    [alertCtl addAction:cancleAction];
    [alertCtl addAction:okAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

#pragma mark - KSCentralManagerDelegate

/** 蓝牙不可用 */
- (void)ksCentralManagerStatePoweredOff {
    
}

/** 可以进行扫描 */
- (void)ksCentralManager:(KSCentralManager *)central canScanForPeripherals:(BOOL)isScan {
    NSLog(@"已设置为可扫描状态");
}

/** 扫描到了设备 */
- (void)ksCentralManager:(KSCentralManager *)central displayPeripheral:(KSCBPeripheral *)ksPeripheral {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSRange range = [ksPeripheral.peripheral.name rangeOfString:@"Brezza"];
        if (range.location != NSNotFound) {
            //取消当前设备的连接
            [CENTRAL_MANAGER cancelPeripheralConnection];
            //连接设备
            [CENTRAL_MANAGER connectToPeripherl:ksPeripheral];
        }
    });
}

/** 已经连接了设备 */
- (void)ksCentralManager:(KSCentralManager *)central didConnectPeripheral:(KSCBPeripheral *)ksPeripheral {
    
    [SVProgressHUD dismiss];
    
    [self removeScanTimer];
    
    NSLog(@"已经连接了设备 %@", ksPeripheral.peripheral.name);
    
    [self pushConnectedVC];
}

/** 连接失败 */
- (void)ksCentralManager:(KSCentralManager *)central didFailToConnectPeripheral:(KSCBPeripheral *)ksPeripheral {
    
}

/** 失去连接 */
- (void)ksCentralManager:(KSCentralManager *)central didDisconnectPeripheral:(KSCBPeripheral *)ksPeripheral {
    NSLog(@"%@ 失去连接", ksPeripheral.peripheral.name);
}

/** 订阅成功 可以收发数据 */
- (void)ksCentralManager:(KSCentralManager *)central readyToSendDataForService:(CBService *)service withCharacteristic:(CBCharacteristic *)characteristic {
    
    //订阅成功 会写一次数据   确保手机和设备数据同步
    [JJMessage sendData];
    
}

/** 接收/读取数据成功 */
- (void)ksCentralManager:(KSCentralManager *)central didReceiveData:(NSData *)data {
    [JJMessage receiveData:data];
}

/** 发送/写数据成功 */
- (void)ksCentralManager:(KSCentralManager *)central didWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"写数据成功");
}

#pragma mark - Property
- (UIButton *)scanBtn {
    if (_scanBtn){
        return _scanBtn;
    }
    _scanBtn = [[UIButton alloc] init];
    _scanBtn.frame = CGRectMake(0, 0, 100, 200);
    _scanBtn.center = CGPointMake(self.view.center.x, self.view.center.y);
    [_scanBtn setImage:[UIImage imageNamed:@"bluetooth_icon"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(clickScanBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _scanBtn;
}

- (UILabel *)textLabel {
    if (_textLabel) {
        return _textLabel;
    }
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height - 20 - 30, self.view.width, 30)];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.font = S_FONT(14);
    _textLabel.text = @"scan for your bottle warmer";
    return _textLabel;
}

@end
