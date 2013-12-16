//
//  UIView+CustomBadge.m
//  SUBTest
//
//  Created by chinaPnr on 13-11-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "UIView+CustomBadge.h"
#import <objc/runtime.h>
static NSString *badgeViewKey;

@implementation UIView(CustomBadge)

- (CustomBadge *)badgeView
{
    CustomBadge *badgeView = (CustomBadge *)objc_getAssociatedObject(self, badgeViewKey);
    return (badgeView);
}

- (void)setBadge:(NSInteger)badge contentCenter:(CGPoint)center
{
    if(badge > 0)
    {
        NSInteger ctBadge = MIN(MAX(badge, 0), DEF_MAX_BADGE);
        NSMutableString *badgeString = [NSMutableString stringWithFormat:@"%i", ctBadge];
        if(badge > DEF_MAX_BADGE)
        {
            [badgeString appendString:@"+"];
        }
        
        //需求改为不要数字,只显示“新”
        //CGFloat width = badgeString.length * (DEF_BADGE_HEIGHT * 0.75f);
        CGFloat width = DEF_BADGE_HEIGHT;
        
        CustomBadge *badgeView = [self badgeView];
        if(!badgeView)
        {
            badgeView = [[CustomBadge alloc] init];
            badgeView.image = [[UIImage imageNamed:@"badge_mes_new"] stretchableImageWithLeftCapWidth:DEF_BADGE_HEIGHT / 2.0f topCapHeight:DEF_BADGE_HEIGHT / 2.0f];
            objc_setAssociatedObject(self, badgeViewKey, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self addSubview:badgeView];
            [badgeView release];
        }
        //badgeView.badgeLabel.text = badgeString;
        badgeView.hidden = NO;
        
        center.x += MAX((width - DEF_BADGE_HEIGHT) / 2.0f, 0);
        badgeView.frame = CGRectMake(0, 0, MAX(width, DEF_BADGE_HEIGHT), DEF_BADGE_HEIGHT);
        badgeView.center = center;
    }
    else
    {
        CustomBadge *badgeView = [self badgeView];
        if(badgeView)
        {
            badgeView.hidden = YES;
        }
    }
}

@end
