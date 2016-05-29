//
//  JJBaseVC.m
//  BabyBrezza
//
//  Created by Jay on 15/9/30.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "JJRootVC.h"
#import "UIColor+JJColor.h"

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
}


#pragma mark - Property

- (UIImageView *)bgImgView {
    if (_bgImgView) {
        return _bgImgView;
    }
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.frame = self.view.bounds;
    NSString *imageString = @"app_bg_i4";
    if (IS_IPHONE5) {
        imageString = @"app_bg_i5";
    }
    else if (IS_IPHONE6) {
        imageString = @"app_bg_i6";
    }
    else if (IS_IPHONE6_PLUS) {
        imageString = @"app_bg_i6p";
    }
    _bgImgView.image = [UIImage imageNamed:imageString];
    _bgImgView.userInteractionEnabled = YES;
    return _bgImgView;
}

@end
