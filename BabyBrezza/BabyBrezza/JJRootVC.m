//
//  JJBaseVC.m
//  BabyBrezza
//
//  Created by Jay on 15/9/30.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "JJRootVC.h"
#import "UIColor+JJColor.h"
#import "JJBLEManager.h"

@interface JJRootVC ()



@end

@implementation JJRootVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutBaseUI];
}

#pragma mark - Private Methods

- (void)layoutBaseUI {
    [self.view addSubview:self.bgImgView];
    
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self rootBinding];
}

- (void)rootBinding {
    @weakify(self);
    [RACObserve([JJBLEManager sharedInstance], languageType) subscribeNext:^(NSNumber *languageType) {
        @strongify(self);
        NSString *imageStrEN = [BBUtils getI4:@"app_bg_i4" i5:@"app_bg_i5" i6:@"app_bg_i6" i6p:@"app_bg_i6p"];
        
        NSString *imageStrFR = [BBUtils getI4:@"app_bg_i4_fr" i5:@"app_bg_i5_fr" i6:@"app_bg_i6_fr" i6p:@"app_bg_i6p_fr"];
        
        self.bgImgView.image = [UIImage imageNamed:[BBUtils languageEN:imageStrEN FR:imageStrFR]];
    }];
}


#pragma mark - Property

- (UIImageView *)bgImgView {
    if (_bgImgView) {
        return _bgImgView;
    }
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.frame = self.view.bounds;
    NSString *imageStr = [BBUtils getI4:@"app_bg_i4" i5:@"app_bg_i5" i6:@"app_bg_i6" i6p:@"app_bg_i6p"];
    _bgImgView.image = [UIImage imageNamed:imageStr];
    _bgImgView.userInteractionEnabled = YES;
    return _bgImgView;
}

@end
