//
//  XJMainCell.m
//  BabyBrezza
//
//  Created by Jay on 15/10/1.
//  Copyright © 2015年 JJ. All rights reserved.
//

#import "JJMainCell.h"


@implementation JJMainCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutMainCellUI];
    }
    return self;
}


- (void)awakeFromNib {
    
}


#pragma mark - Private Methods
- (void)layoutMainCellUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    self.textLabel.textColor = [UIColor grayColor];
    self.detailTextLabel.textColor = [UIColor grayColor];
    
    self.detailTextLabel.font = [UIFont systemFontOfSize:10.0];
    
    [self addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];
}

- (void)longTap:(UILongPressGestureRecognizer *)longRecognizer
{
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        if (_delegate && [_delegate respondsToSelector:@selector(mainCell:longTap:)]) {
            [_delegate mainCell:self longTap:longRecognizer];
        }
    }
}

#pragma mark - Public Methods

- (void)cellWithPeripheral:(KSCBPeripheral *)ksc {
    self.textLabel.text = ksc.peripheral.name;
    self.detailTextLabel.text = ksc.peripheral.identifier.UUIDString;
    if (ksc.isAppConnected) {
        self.textLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.textColor = [UIColor whiteColor];
    }
    else {
        self.textLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.textColor = [UIColor grayColor];
    }
}

#pragma mark - Inherit

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
