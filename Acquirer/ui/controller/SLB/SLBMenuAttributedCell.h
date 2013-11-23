//
//  SLBMenuAttributedCell.h
//  Acquirer
//
//  Created by Soal on 13-10-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, SLBMenutCellDetailVXAlignment)//竖直方向对齐方式
{
    alinmentToCenter = 0,
    alinmentToTop,
    alinmentToBottom,
};

@interface SLBMenuAttributedCell : UITableViewCell

@property (assign, nonatomic) SLBMenutCellDetailVXAlignment vxAlignment;

- (void)setAttributedTitle:(NSAttributedString *)attrTitle;
- (NSAttributedString *)attributedTitle;

- (void)setAttributedText:(NSAttributedString *)attrText;
- (NSAttributedString *)attributedText;

@end
