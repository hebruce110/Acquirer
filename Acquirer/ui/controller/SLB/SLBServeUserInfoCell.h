//
//  SLBServeUserInfoCell.h
//  Acquirer
//
//  Created by Soal on 13-10-29.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLBServeUserInfoCell : UITableViewCell

@property (nonatomic, assign) CGFloat offset;

- (NSString *)title;
- (void)setTitle:(NSString *)title;
- (NSString *)detailTitle;
- (void)setDetailTitle:(NSString *)detailTitle;

@end
