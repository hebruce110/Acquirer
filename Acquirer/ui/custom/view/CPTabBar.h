//
//  CPTabBar.h
//  Acquirer
//
//  Created by chinaPnr on 13-7-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTabBarDelegate.h"
#import "UIView+CustomBadge.h"

@interface CPTabBar : UIView{
    //store tab
    NSMutableArray *tabViewList;
    
    //tab view
    NSMutableArray *tabIconList;
    NSMutableArray *tabIconHoverList;
    NSMutableArray *tabTitleList;
    
    id<CPTabBarDelegate> delegate;
    
    int index;
}

@property (nonatomic, retain) NSMutableArray *tabViewList;

@property (nonatomic, assign) id<CPTabBarDelegate> delegate;

@property (nonatomic, assign) int index;

//process tap event
-(void) tapGesture:(UITapGestureRecognizer *)tapGesuture;

-(void) setTabSelected:(int)tab_index;

//badge
- (void)setBadge:(NSInteger)badge itemIndex:(NSInteger)ix;
- (CustomBadge *)badgeViewAtItemIndex:(NSInteger)ix;

@end

