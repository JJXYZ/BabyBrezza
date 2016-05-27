//
//  XJMainCell.h
//  BabyBrezza
//
//  Created by Jay on 15/10/1.
//  Copyright © 2015年 XJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCBPeripheral.h"

#define MAIN_CELL_H 60

@class XJMainCell;
@protocol XJMainCellDelegate <NSObject>

- (void)mainCell:(XJMainCell *)cell longTap:(UILongPressGestureRecognizer *)longRecognizer;

@end

@interface XJMainCell : UITableViewCell

@property (nonatomic, weak) id<XJMainCellDelegate> delegate;

- (void)cellWithPeripheral:(KSCBPeripheral *)peripheral;

@end
