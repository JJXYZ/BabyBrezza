//
//  JJBLEValue.m
//  BabyBrezza
//
//  Created by Jay on 16/6/4.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "JJBLEValue.h"
#import "JJBLEConfig.h"
#import <AVFoundation/AVFoundation.h>
#import "JJSafeDefine.h"

@interface JJBLEValue () {
    NSString *_speed;
}

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, strong) NSArray *tQuickRoomArr;
@property (nonatomic, strong) NSArray *tQuickColdArr;
@property (nonatomic, strong) NSArray *tSteadyRoomArr;
@property (nonatomic, strong) NSArray *tSteadyColdArr;
@property (nonatomic, strong) NSArray *tDeforstArr;


@end
@implementation JJBLEValue
@synthesize speed = _speed;

#pragma mark - Lifecycle

+ (JJBLEValue *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static JJBLEValue * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isSoundOpen = YES;
    }
    return self;
}


#pragma mark - Public Methods

- (void)clearParam {
    self.head1 = nil;
    self.head2 = nil;
    
    self.command = nil;
    
    self.hour = nil;
    self.minute = nil;
    self.second = nil;
    
    self.number = nil;
    self.speed = nil;
    self.temp = nil;
    self.temperature = nil;
    
    self.var = nil;
    
    self.reserve_1 = nil;
    self.reserve_2 = nil;
    
    self.system = nil;
    
    self.flagl = nil;
}

- (void)playNotiSound:(BOOL)isSound {
    if (isSound) {
        if (!self.player.isPlaying) {
            [self.player prepareToPlay];
            [self.player play];
        }
    }
    else {
        [self playVibrate];
    }
}

- (void)playVibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)setTimeValue {
    NSUInteger timeInt = [self getTime].integerValue;
    _minute = [NSString stringWithFormat:@"%02lu", timeInt/60];
    _second = [NSString stringWithFormat:@"%02lu", timeInt%60];
}

- (NSString *)getTime {
    NSString *time = [self getTimeWithNumber:_number.integerValue temp:_temp.integerValue speed:_speed.integerValue];
    return time;
}


- (NSString *)getTimeWithNumber:(NSUInteger)number temp:(NSUInteger)temp speed:(NSUInteger)speed {
    
    NSArray *tArr = nil;
    NSString *timeStr = nil;
    
    if (number == 10) {
        tArr = self.tDeforstArr;
    }
    else if (temp == 1 && speed == 1) {
        tArr = self.tQuickRoomArr;
    }
    else if (temp == 2 && speed == 1) {
        tArr = self.tQuickColdArr;
    }
    else if (temp == 1 && speed == 2) {
        tArr = self.tSteadyRoomArr;
    }
    else if (temp == 2 && speed == 2) {
        tArr = self.tSteadyColdArr;
    }
    
    if (number == 10) {
        timeStr = [self.tDeforstArr firstObject];
    }
    else {
        timeStr = [tArr safeObjectAtIndex:number - 1];
    }
    
    return timeStr;
}


#pragma mark - Property

- (NSString *)number {
    if (_number) {
        return _number;
    }
    _number = @"4";
    return _number;
}

- (NSString *)speed {
    if (_speed) {
        return _speed;
    }
    _speed = @"1";
    return _speed;
}

- (void)setSpeed:(NSString *)speed {
    _speed = speed;
}

- (NSString *)temp {
    if (_temp) {
        return _temp;
    }
    _temp = @"1";
    return _temp;
}

- (NSString *)startFlagl {
    if (_startFlagl) {
        return _startFlagl;
    }
    _startFlagl = @"-1";
    return _startFlagl;
}

- (AVAudioPlayer *)player {
    if (_player) {
        return _player;
    }
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"noti_sound" ofType:@"mp3"]] error:nil];
    _player.numberOfLoops = 0;
    return _player;
}

- (NSArray *)tQuickRoomArr {
    if (_tQuickRoomArr) {
        return _tQuickRoomArr;
    }
    _tQuickRoomArr = [NSArray arrayWithObjects:@"115",@"135",@"140",@"155",@"170",@"180",@"190",@"205",@"220", nil];
    return _tQuickRoomArr;
}

- (NSArray *)tQuickColdArr {
    if (_tQuickColdArr) {
        return _tQuickColdArr;
    }
    _tQuickColdArr = [NSArray arrayWithObjects:@"140",@"160",@"180",@"205",@"240",@"240",@"260",@"285",@"290", nil];
    return _tQuickColdArr;
}

- (NSArray *)tSteadyRoomArr {
    if (_tSteadyRoomArr) {
        return _tSteadyRoomArr;
    }
    _tSteadyRoomArr = [NSArray arrayWithObjects:@"225",@"260",@"270",@"330",@"335",@"390",@"410",@"490",@"540", nil];
    return _tSteadyRoomArr;
}


- (NSArray *)tSteadyColdArr {
    if (_tSteadyColdArr) {
        return _tSteadyColdArr;
    }
    _tSteadyColdArr = [NSArray arrayWithObjects:@"225",@"260",@"295",@"320",@"355",@"390",@"410",@"490",@"540", nil];
    return _tSteadyColdArr;
}

- (NSArray *)tDeforstArr {
    if (_tDeforstArr) {
        return _tDeforstArr;
    }
    _tDeforstArr = [NSArray arrayWithObjects:@"600", nil];
    return _tDeforstArr;
}

@end
