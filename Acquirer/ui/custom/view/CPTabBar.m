//
//  CPTabBar.m
//  Acquirer
//
//  Created by chinaPnr on 13-7-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "CPTabBar.h"

@implementation CPTabBar

@synthesize tabViewList, delegate;
@synthesize index;

-(void)dealloc{
    [tabViewList release];
    
    [tabIconList release];
    [tabIconHoverList release];
    [tabTitleList release];
    
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = CPTABBAR_UIVIEW_TAG;
        
        //select first tab
        index = 0;
        
        tabViewList = [[NSMutableArray alloc] initWithCapacity:4];
        
        tabIconList = [[NSMutableArray alloc] initWithObjects:
                       [UIImage imageNamed:@"deal-ico"],
                       [UIImage imageNamed:@"tb_online"], nil];
        
        tabIconHoverList = [[NSMutableArray alloc] initWithObjects:
                            [UIImage imageNamed:@"deal-ico-hover"],
                            [UIImage imageNamed:@"tb_online_hover"], nil];
        
        tabTitleList = [[NSMutableArray alloc] initWithObjects: @"刷卡交易", @"服务中心", nil];
        
        
        for (int i=0; i<tabIconList.count; i++) {
            CGRect tabframe = CGRectMake(i*DEFAULT_TAB_WIDTH, 0, DEFAULT_TAB_WIDTH, DEFAULT_TAB_BAR_HEIGHT);
            UIImageView *tabView = [[UIImageView alloc] initWithFrame:tabframe];
            tabView.image = [UIImage imageNamed:@"menu-bg"];
            
            UIImageView *iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 20)] autorelease];
            iconView.image = [tabIconList objectAtIndex:i];
            [tabView addSubview:iconView];
            iconView.center = CGPointMake(CGRectGetMidX(tabView.bounds), CGRectGetMidY(tabView.bounds)-7);
            
            UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(10, 24, 60, 30)] autorelease];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont boldSystemFontOfSize:11];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor lightGrayColor];
            titleLabel.text = [tabTitleList objectAtIndex:i];
            titleLabel.center = CGPointMake(CGRectGetMidX(tabView.bounds), titleLabel.center.y);
            [tabView addSubview:titleLabel];
            
            [tabViewList addObject:tabView];
            [self addSubview:tabView];
            [tabView release];
        }
        
        //注册触摸事件
        UITapGestureRecognizer *_tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:_tapGesture];
        [_tapGesture release];
    }
    return self;
}

//处理选中事件
-(void) tapGesture:(UITapGestureRecognizer *)tapGesuture{
    CGPoint tapPoint = [tapGesuture locationInView:self];//触摸点
    if (self.delegate!=nil) {
        int tab_index = tapPoint.x / DEFAULT_TAB_WIDTH;
        [self.delegate changeToIndex:tab_index];
        [self setTabSelected:tab_index];
    }
}

//设置选中Tab
-(void) setTabSelected:(int)tab_index{
    UIImageView *preTabView = (UIImageView *)[tabViewList objectAtIndex:abs(tab_index-1)];
    preTabView.image = [UIImage imageNamed:@"menu-bg"];
    
    //将之前选中的Tab里面的图片和文字修改成普通状态
    for(UIView *subView in preTabView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            label.textColor = [UIColor lightGrayColor];
        }
        
        if ([subView isKindOfClass:[UIImageView class]]) {
            //徽记例外
            if(![subView isKindOfClass:[CustomBadge class]])
            {
                UIImageView *preIconView = (UIImageView *)subView;
                preIconView.image = [tabIconList objectAtIndex:abs(tab_index-1)];
            }
        }
    }
    
    index = tab_index;
    
    //将当前选中的Tab背景色修改成选中状态
    UIImageView *nowBgView = (UIImageView *)[tabViewList objectAtIndex:tab_index];
    nowBgView.image = [UIImage imageNamed:@"menu-bg-hover"];
    //将当前选中的Tab中的图片，修改成选中状态的图片
    for(UIView *subView in nowBgView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            label.textColor = [UIColor whiteColor];
        }
        
        if ([subView isKindOfClass:[UIImageView class]]) {
            //徽记例外
            if(![subView isKindOfClass:[CustomBadge class]])
            {
                UIImageView *preIconView = (UIImageView *)subView;
                preIconView.image = [tabIconHoverList objectAtIndex:index];
            }
        }
    }
}

//badge
- (void)setBadge:(NSInteger)badge itemIndex:(NSInteger)ix
{
    if(tabViewList && tabViewList.count > ix)
    {
        UIView *vw = [tabViewList objectAtIndex:ix];
        [vw setBadge:badge contentCenter:CGPointMake((CGRectGetWidth(vw.frame) + DEF_BADGE_HEIGHT) / 2.0f, DEF_BADGE_HEIGHT / 2.0f)];
    }
}

- (CustomBadge *)badgeViewAtItemIndex:(NSInteger)ix
{
    if(tabViewList && tabViewList.count > ix)
    {
        UIView *vw = [tabViewList objectAtIndex:ix];
        return (vw.badgeView);
    }
    return (nil);
}

@end

