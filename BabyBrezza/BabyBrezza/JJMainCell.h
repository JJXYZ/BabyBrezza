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

@class JJMainCell;
@protocol JJMainCellDelegate <NSObject>

- (void)mainCell:(JJMainCell *)cell longTap:(UILongPressGestureRecognizer *)longRecognizer;

@end

@interface JJMainCell : UITableViewCell

@property (nonatomic, weak) id<JJMainCellDelegate> delegate;

- (void)cellWithPeripheral:(KSCBPeripheral *)peripheral;

@end
