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

@property (retain, nonatomic, readonly) UIImageView *imgView;
@property (retain, nonatomic, readonly) UILabel *tlLabel;
@property (retain, nonatomic, readonly) SLBAttributedView *attView;

@end
