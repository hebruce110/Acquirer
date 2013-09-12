//
//  BaseViewController.h
//  Acquirer
//
//  Created by chinaPnr on 13-7-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTabBar.h"
#import "Helper.h"
#import "NSNotificationCenter+CP.h"
#import "AcquirerService.h"

//def utility
CGFloat frameHeighOffset(CGRect rect);

#define DEFAULT_NAVIGATION_TITLE_WIDTH 180

@interface BaseViewController : UIViewController{
    //背景图片
    UIImageView *bgImageView;
    
    //导航栏
    UIImageView *naviBgView;
    //导航栏的文字
    UILabel *naviTitleLabel;
    //导航栏返回按钮
    UIButton *naviBackBtn;
    
    //中间部分
    UIView *contentView;
    
    //导航栏, TabBar
    BOOL isShowNaviBar;
    BOOL isShowTabBar;
}

@property (nonatomic, retain) UIImageView *bgImageView;

@property (nonatomic, retain) UIImageView *naviBgView;
@property (nonatomic, retain) UILabel *naviTitleLabel;
@property (nonatomic, retain) UIButton *naviBackBtn;

@property (nonatomic, retain) UIView *contentView;

@property (nonatomic, assign) BOOL isShowNaviBar;
@property (nonatomic, assign) BOOL isShowTabBar;

-(void) hideBackButton;
-(void)backToPreviousView:(id)sender;
-(void)setNavigationTitle:(NSString *)title;
-(NSString *)controllerName;

/**
 跟踪用户行为，获取View的Id号
 @returns 返回跟踪View的Id号
 */
-(NSString*) getViewId;

-(void)tabBarAnimation;

//reserved for bgScrollView
-(void)adjustForTextFieldDidBeginEditing:(UITextField *)textField contentOffset:(CGPoint)offset;
-(void)adjustForTextFieldDidEndEditing:(UITextField *)textField contentOffset:(CGPoint)offset;

-(BOOL)adjustForTextFieldShouldReturn:(UITextField *)textField;

@end










