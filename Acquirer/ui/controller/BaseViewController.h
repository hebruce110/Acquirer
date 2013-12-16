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
#import "MessageNumberData.h"

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
    BOOL isShowRefreshBtn;
    BOOL isShowTabBar;
    BOOL isNeedfresh;
    BOOL isNeedRefresh;
}

@property (nonatomic, retain) UIImageView *bgImageView;

@property (nonatomic, retain) UIImageView *naviBgView;
@property (nonatomic, retain) UILabel *naviTitleLabel;
@property (nonatomic, retain) UIButton *naviBackBtn;

@property (nonatomic, retain) UIView *contentView;

@property (nonatomic, assign) BOOL isShowRefreshBtn;
@property (nonatomic, assign) BOOL isShowNaviBar;
@property (nonatomic, assign) BOOL isShowTabBar;

//继续加载
@property (assign, nonatomic) BOOL isNeedfresh;
//重新加载
@property (assign, nonatomic) BOOL isNeedRefresh;

-(void)hideBackButton;
-(void)backToPreviousView:(id)sender;
-(void)setNavigationTitle:(NSString *)title;

-(NSString *)controllerName;

-(void)popToRootViewController;

//press refresh button
-(void)refreshCurrentTableView;

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

//tableview callback
//选中cell后回调
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end










