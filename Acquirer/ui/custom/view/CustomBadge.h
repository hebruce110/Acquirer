//
//  CustomBadge.h
//  SUBTest
//
//  Created by chinaPnr on 13-11-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEF_MAX_BADGE   99
#define DEF_BADGE_HEIGHT 16.0f

@interface CustomBadge : UIImageView

@property (strong, nonatomic, readonly) UILabel *badgeLabel;

@end
