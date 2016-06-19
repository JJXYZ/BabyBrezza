//
//  JJSettingVC.m
//  BabyBrezza
//
//  Created by Jay on 16/5/28.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJSettingGuideVC.h"

@interface JJSettingGuideVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *backBtn;

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
    self.bgImgView.hidden = YES;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.backBtn];
    [self layoutSettingScrollView];
}

- (void)layoutSettingScrollView {
    for (NSUInteger i=0; i<self.dataArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (i * self.scrollView.height), self.scrollView.width, self.scrollView.height)];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:[self.dataArr objectAtIndex:i]];
        [self.scrollView addSubview:imageView];
    }
}


- (void)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIScrollViewDelegate

#pragma mark - Property

- (UIScrollView *)scrollView {
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 55, M_SCREEN_W, M_SCREEN_H - 55);
    _scrollView.contentSize = CGSizeMake(self.view.width, self.dataArr.count * _scrollView.height);
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

- (UIButton *)backBtn {
    if (_backBtn) {
        return _backBtn;
    }
    _backBtn = [[UIButton alloc] init];
    _backBtn.frame = CGRectMake(5, 20, 35, 35);
    [_backBtn setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    return _backBtn;
}



@end
