//
//  JJLanguageBtn.m
//  BabyBrezza
//
//  Created by Jay on 2017/3/6.
//  Copyright © 2017年 BabyBrezza. All rights reserved.
//

#import "JJLanguageBtn.h"

@interface JJLanguageBtn ()



@end

@implementation JJLanguageBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tLabel.frame = self.bounds;
        [self addSubview:self.tLabel];
    }
    return self;
}


- (void)boldTitle:(BOOL)isBold {
    if (isBold) {
        self.tLabel.font = BOLD_FONT(18);
    }
    else {
        self.tLabel.font = S_FONT(18);
    }
}

#pragma mark - Property

- (UILabel *)tLabel {
    if (!_tLabel) {
        _tLabel = [[UILabel alloc] init];
        _tLabel.backgroundColor = [UIColor clearColor];
        _tLabel.textColor = [UIColor blackColor];
        _tLabel.textAlignment = NSTextAlignmentCenter;
        _tLabel.userInteractionEnabled = NO;
    }
    return _tLabel;
}


@end
