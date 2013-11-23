//
//  SLBDetailListCell.h
//  Acquirer
//
//  Created by Soal on 13-10-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBAttributedView.h"

@interface SLBDetailListCell : UITableViewCell
{
    UIImageView *_icImageView;
    SLBAttributedView *_amountView;
    UILabel *_dateLabel;
    UILabel *_typeLabel;
}
@property (retain, nonatomic) UIImageView *icImageView;
@property (retain, nonatomic) SLBAttributedView *amountView;
@property (retain, nonatomic) UILabel *dateLabel;
@property (retain, nonatomic) UILabel *typeLabel;

@end
