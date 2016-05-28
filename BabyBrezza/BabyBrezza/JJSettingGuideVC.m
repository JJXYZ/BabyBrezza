//
//  JJSettingVC.m
//  BabyBrezza
//
//  Created by Jay on 16/5/28.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "JJSettingGuideVC.h"

@interface JJSettingGuideVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation JJSettingGuideVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSettingUI];
}

#pragma mark - Private Methods

- (void)layoutSettingUI {
    [self.bgImgView addSubview:self.scrollView];
    [self layoutSettingScrollView];
}

- (void)layoutSettingScrollView {
    for (NSUInteger i=0; i<self.dataArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i * self.scrollView.width), 0, self.scrollView.width, self.scrollView.height)];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:[self.dataArr objectAtIndex:i]];
        [self.scrollView addSubview:imageView];
    }
}

#pragma mark - UIScrollViewDelegate

#pragma mark - Property

- (UIScrollView *)scrollView {
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.bounds;
    _scrollView.contentSize = CGSizeMake(self.view.width, self.dataArr.count * self.view.height);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    return _scrollView;
}

- (NSArray *)dataArr {
    if (_dataArr) {
        return _dataArr;
    }
    _dataArr = [[NSArray alloc] initWithObjects:@"steady_room",@"quick_room",@"quick_cold",@"steady_cold", nil];
    return _dataArr;
}

@end
