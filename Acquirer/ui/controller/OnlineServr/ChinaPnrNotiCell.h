//
//  ChinaPnrNotiCell.h
//  SUBTest
//
//  Created by chinaPnr on 13-11-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChinaPnrNotiCell : UITableViewCell

//自动竖直方向居中
@property (assign, nonatomic) BOOL autoAlignmentVXCenter;

//img的大小
@property (assign, nonatomic) CGSize imgContentSize;

@property (retain, nonatomic) UIImageView *imgView;
@property (retain, nonatomic) UILabel *dateLabel;
@property (retain, nonatomic) UITextView *textView;

@end
