//
//  XJMainVC.m
//  BabyBrezza
//
//  Created by Jay on 15/9/30.
//  Copyright © 2015年 XJ. All rights reserved.
//

#import "XJMainVC.h"
#import "SVProgressHUD.h"
#import "KSCentralManager.h"
#import "XJDefine.h"
#import "KSCBPeripheral.h"
#import "Config.h"
#import "XJMainCell.h"
#import "XJFunctionVC.h"
#import "XJMessage.h"

@interface XJMainVC () <UITableViewDataSource, UITableViewDelegate,KSCentralManagerDelegate, XJMainCellDelegate>

//是否显示Progress
@property (nonatomic, assign) BOOL isShowProgress;

@property (nonatomic, strong) UITableView *tableView;

//自动扫描定时器 30秒
@property (nonatomic, strong) NSTimer *scanTimer;

//重新连接定时器
@property (nonatomic, strong) NSTimer *retrieveTimer;

//中心类
@property (nonatomic, strong) KSCentralManager *centralManager;

//设备(扫描的设备,操作系统连接的设备)
@property (nonatomic, strong) NSMutableArray *peripheralArr;

@end

@implementation XJMainVC

#pragma mark - Lifecycle

//单例
+ (XJMainVC *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static XJMainVC * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.centralManager = CENTRAL_MANAGER;
    self.centralManager.delegate = self;
    
    [self.view addSubview:self.tableView];
}



#pragma mark - Private Methods

- (void)stopScanPeripheral
{
    [self.centralManager stopScanForPeripherals];
    
    [SVProgressHUD dismiss];
    
    [self removeScanTimer];
}

//断线重连
- (void)retrieveConnectPeripheral
{
    NSLog(@"断线重连....");
    [self connectLastConnectedPeripheral];
}

//获取操作系统已经连接的设备
- (void)addConnectedPeripherals
{
    
    NSArray *connectedArr = [self.centralManager getConnectedSystemPeripherals];
    
    for (KSCBPeripheral *addKsp in connectedArr) {
        
        //判断是否有重复的,当前已连接的,不需要加入
        if ([addKsp.peripheral.name rangeOfString:@"Brezza" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [self.peripheralArr addObject:addKsp];
        }
    }
    
    [self.tableView reloadData];
}

//连接上次连接过的设备
- (void)connectLastConnectedPeripheral
{
    NSString *lastUUIDString = [[NSUserDefaults standardUserDefaults] objectForKey:UD_KEY_CUR_PERIPHERAL_UUID];
    
    for (KSCBPeripheral *ksp in self.peripheralArr) {
        //存在上次连接过的设备,就连接
        if ([ksp.peripheral.identifier.UUIDString isEqualToString:lastUUIDString]) {
            [self.centralManager connectToPeripherl:ksp];
            break;
        }
    }
}

//判断是否已经在数组里面
- (BOOL)isExistedKSPeripheral:(KSCBPeripheral *)ksp
{
    BOOL isExisted = NO;
    
    for (KSCBPeripheral *p in self.peripheralArr) {
        if ([ksp.peripheral.identifier.UUIDString isEqualToString:p.peripheral.identifier.UUIDString]) {
            isExisted = YES;
            break ;
        }
    }
    
    return isExisted;
}

- (void)pushFunctionVC {
    XJFunctionVC *vc = [[XJFunctionVC alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:^{}];
}

#pragma mark - Event


- (IBAction)clickScanBtn:(id)sender {
    
    [self stopScanPeripheral];
    
    //移除所有的Peripherals
    [self.peripheralArr removeAllObjects];
    [self.tableView reloadData];
    
    //获取操作系统已经连接的设备
    [self addConnectedPeripherals];
    
    //开始扫描
    [self createScanTimer];
    
    [SVProgressHUD show];
}

#pragma mark - NSTimer

//=========================ScanTimer=======================
- (void)createScanTimer {
    
    [self removeScanTimer];
    
    NSLog(@"创建自动扫描定时器 30秒");
    
    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(stopScanPeripheral) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.scanTimer forMode:NSDefaultRunLoopMode];
    
    [self.centralManager scanForPeripherals];
}

- (void)removeScanTimer {
    if (self.scanTimer) {
        NSLog(@"移除自动扫描定时器 30秒");
        [self.scanTimer invalidate];
        self.scanTimer = nil;
    }
}
//=============================================================


//=========================RetrieveTimer=======================
//断线重连定时器
- (void)creatRetrieveTimer
{
    [self removeRetrieveTimer];
    
    NSLog(@"创建重连定时器");
    self.retrieveTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(retrieveConnectPeripheral) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.retrieveTimer forMode:NSDefaultRunLoopMode];
}

- (void)removeRetrieveTimer
{
    if (self.retrieveTimer) {
        NSLog(@"移除重连定时器");
        [self.retrieveTimer invalidate];
        self.retrieveTimer = nil;
    }
}

//=============================================================


#pragma mark - XJMainCellDelegate
- (void)mainCell:(XJMainCell *)cell longTap:(UILongPressGestureRecognizer *)longRecognizer {
    
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"Notification on the connected device" message:@"Do you want to turn off the device" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancle");
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK");
        [XJMessage closeCurPeripheral];
    }];
    
    [alertCtl addAction:cancleAction];
    [alertCtl addAction:okAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

#pragma mark - KSCentralManagerDelegate

/** 蓝牙不可用 */
- (void)ksCentralManagerStatePoweredOff {
    
    self.centralManager.curPeripheral = nil;
    
    [self.peripheralArr removeAllObjects];
    [self.tableView reloadData];
}

/** 可以进行扫描 */
- (void)ksCentralManager:(KSCentralManager *)central canScanForPeripherals:(BOOL)isScan {
    
    NSLog(@"已设置为可扫描状态");
    
    [self creatRetrieveTimer];
}

/** 扫描到了设备 */
- (void)ksCentralManager:(KSCentralManager *)central displayPeripheral:(KSCBPeripheral *)ksPeripheral {
    
    [SVProgressHUD dismiss];
    
    if (ksPeripheral.peripheral.name) {
        
        NSRange range = [ksPeripheral.peripheral.name rangeOfString:@"Brezza"];
        
        if ((range.location != NSNotFound) && ([self isExistedKSPeripheral:ksPeripheral] == NO)) {
            [self.peripheralArr addObject:ksPeripheral];
        }
    }
    
    [self.tableView reloadData];
}

/** 已经连接了设备 */
- (void)ksCentralManager:(KSCentralManager *)central didConnectPeripheral:(KSCBPeripheral *)ksPeripheral {
    
    [SVProgressHUD dismiss];
    
    [self removeScanTimer];
    [self removeRetrieveTimer];
    
    [self.peripheralArr removeAllObjects];
    [self.peripheralArr addObject:ksPeripheral];
    [self.tableView reloadData];
    
    NSLog(@"已经连接了设备 %@", ksPeripheral.peripheral.name);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pushFunctionVC];
    });
    
}

/** 连接失败 */
- (void)ksCentralManager:(KSCentralManager *)central didFailToConnectPeripheral:(KSCBPeripheral *)ksPeripheral {
    
}

/** 失去连接 */
- (void)ksCentralManager:(KSCentralManager *)central didDisconnectPeripheral:(KSCBPeripheral *)ksPeripheral {
    
    NSLog(@"%@ 失去连接", ksPeripheral.peripheral.name);
    
    [self creatRetrieveTimer];
}

/** 订阅成功 可以收发数据 */
- (void)ksCentralManager:(KSCentralManager *)central readyToSendDataForService:(CBService *)service withCharacteristic:(CBCharacteristic *)characteristic {
    
    //订阅成功 会写一次数据   确保手机和设备数据同步
    [XJMessage sendData];
    
}

/** 接收/读取数据成功 */
- (void)ksCentralManager:(KSCentralManager *)central didReceiveData:(NSData *)data {
    [XJMessage receiveData:data];
}

/** 发送/写数据成功 */
- (void)ksCentralManager:(KSCentralManager *)central didWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"写数据成功");
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MAIN_CELL_H;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.peripheralArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifiy = @"peripheralID";
    XJMainCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiy];
    if (cell == nil) {
        cell = [[XJMainCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifiy];
        cell.delegate = self;
    }
    
    KSCBPeripheral *ksp = [self.peripheralArr objectAtIndex:indexPath.row];
    
    [cell cellWithPeripheral:ksp];
    
    return cell;
    
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KSCBPeripheral *ksp = [self.peripheralArr objectAtIndex:indexPath.row];
    
    if ([ksp.peripheral.identifier.UUIDString isEqualToString:self.centralManager.curPeripheral.peripheral.identifier.UUIDString]) {
        [self pushFunctionVC];
    }
    else {
        //取消当前设备的连接
        [self.centralManager cancelPeripheralConnection];
        
        KSCBPeripheral *ksp = [self.peripheralArr objectAtIndex:indexPath.row];
        
        //连接设备
        [self.centralManager connectToPeripherl:ksp];
    }
    
}


#pragma mark - Property

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH - 40, 200) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return _tableView;
}

- (NSMutableArray *)peripheralArr
{
    if (_peripheralArr){
        return _peripheralArr;
    }
    
    _peripheralArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    return _peripheralArr;
}


@end
