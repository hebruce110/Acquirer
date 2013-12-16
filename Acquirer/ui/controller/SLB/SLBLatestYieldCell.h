//
//  SLBLatestYieldCell.h
//  Acquirer
//
//  Created by Soal on 13-10-29.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBAttributedView.h"

@interface SLBLatestYieldCell : UITableViewCell

@property (retain, nonatomic) UIImageView *imgView;
@property (retain, nonatomic) UILabel *tlLabel;
@property (retain, nonatomic, readonly) SLBAttributedView *attView;

@end
