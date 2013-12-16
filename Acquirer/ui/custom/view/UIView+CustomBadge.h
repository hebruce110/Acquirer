//
//  UIView+CustomBadge.h
//  SUBTest
//
//  Created by chinaPnr on 13-11-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"

@interface UIView(CustomBadge)

- (CustomBadge *)badgeView;
- (void)setBadge:(NSInteger)badge contentCenter:(CGPoint)center;

@end
