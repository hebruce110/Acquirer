//
//  SLBMenuTopCell.h
//  Acquirer
//
//  Created by Soal on 13-10-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBAttributedView.h"

@class SLBMenuTopCell;
@protocol SLBMenuTopCellDelegate <NSObject>

- (void)slbCellDidSelected:(SLBMenuTopCell *)cell;

@end

@interface SLBMenuTopCell : UITableViewCell

- (void)setBackgroundImage:(UIImage *)bkImage;
- (UIImage *)backgroundImage;

- (void)setAttributedString:(NSAttributedString *)attrString;
- (NSAttributedString *)attributedString;

@property (assign, nonatomic) id<SLBMenuTopCellDelegate>delegate;

@end
