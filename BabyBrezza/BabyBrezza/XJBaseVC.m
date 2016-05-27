//
//  XJBaseVC.m
//  BabyBrezza
//
//  Created by Jay on 15/9/30.
//  Copyright © 2015年 XJ. All rights reserved.
//

#import "XJBaseVC.h"
#import "UIColor+XJColor.h"

@interface XJBaseVC ()

@end

@implementation XJBaseVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutBaseUI];
    
}

#pragma mark - Private Methods

- (void)layoutBaseUI {
    [self.view addSubview:self.bgImgView];
    
//    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
//    view.image = [UIImage imageNamed:@"App_Icon_Art"];
//    [self.navigationController.navigationBar addSubview:view];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(53, 8, 100, 30)];
//    label.text = @"babybrezza";
//    label.textColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar addSubview:label];
    
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = [UIColor homeBG];
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
    return _bgImgView;
}

@end
