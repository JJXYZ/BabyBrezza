//
//  JJConnectVC.m
//  BabyBrezza
//
//  Created by Jay on 16/5/28.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJConnectVC.h"
#import "JJFunctionVC.h"

@interface JJConnectVC ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JJConnectVC

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutConnectUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:@selector(pushFunctionVC) withObject:nil afterDelay:1];
}

#pragma mark - Inherit

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - Private Methods

- (void)layoutConnectUI {
    [self.view addSubview:self.titleLabel];
}

- (void)pushFunctionVC {
    JJFunctionVC *vc = [[JJFunctionVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Property

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = VAGRounded_FONT(S_SCALE_W_4(25));
    _titleLabel.numberOfLines = 0;
    _titleLabel.frame = CGRectMake(0, 0, S_SCALE_W_4(250), S_SCALE_W_4(100));
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"Bottle warmer \n connected!";
    _titleLabel.center = CGPointMake(self.view.center.x, self.view.center.y);
    return _titleLabel;
}
@end
