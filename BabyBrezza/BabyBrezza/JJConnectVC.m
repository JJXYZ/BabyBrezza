//
//  JJConnectVC.m
//  BabyBrezza
//
//  Created by Jay on 16/5/28.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "JJConnectVC.h"

@interface JJConnectVC ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JJConnectVC

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutConnectUI];
}

#pragma mark - Private Methods

- (void)layoutConnectUI {
    [self.bgImgView addSubview:self.titleLabel];
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(0, 0, 100, 60);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"Bottle warmer \n connected!";
    _titleLabel.center = CGPointMake(self.view.center.x, self.view.center.y);
    return _titleLabel;
}
@end
