//
//  CustomTextView.m
//  自定义TextView，去掉TextView响应
//
//  Created by chinaPnr
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "CustomTextView.h"

@implementation CustomTextView

//禁用UITextView的响应copy 等事件
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [UIMenuController sharedMenuController].menuVisible = NO;  //donot display the menu
    [self resignFirstResponder];
    return NO;
}

@end

