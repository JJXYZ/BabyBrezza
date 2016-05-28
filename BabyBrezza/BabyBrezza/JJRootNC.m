//
//  JJRootNC.m
//  BabyBrezza
//
//  Created by Jay on 16/5/28.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "JJRootNC.h"

@interface JJRootNC ()

@end

@implementation JJRootNC

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBar setTranslucent:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.hidden = YES;
}

@end
