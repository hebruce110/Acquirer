//
//  FormCellContent.h
//  Acquirer
//
//  Created by ben on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellContent.h"
@interface FormCellContent : CellContent{
    //标题
    NSString *titleSTR;
    //默认提示字符串
    NSString *placeHolderSTR;
    //预留的UITextField值
    NSString *textSTR;
    
    //标题字体
    UIFont *titleFont;
    //标题颜色
    UIColor *titleColor;
    //标题排布方式
    NSTextAlignment titleAlignment;
    
    //输入问题字体
    UIFont *textFont;
    //text布局
    NSTextAlignment textAlignment;
    
    //弹出键盘类型
    UIKeyboardType keyboardType;
    //键盘returnKeyType类型
    UIReturnKeyType returnKeyType;
    
    //是否为密码输入框
    BOOL secure;
    //最大输入长度
    int maxLength;
    
    //ViewController 滑动偏移
    CGPoint scrollOffset;
    
    //创建的Cell类
    Class formCellClass;
}

@property (nonatomic, copy) NSString *titleSTR;
@property (nonatomic, copy) NSString *placeHolderSTR;
@property (nonatomic, copy) NSString *textSTR;

@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, assign) NSTextAlignment titleAlignment;

@property (nonatomic, retain) UIFont *textFont;
@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) UIReturnKeyType returnKeyType;

@property (nonatomic, assign) BOOL secure;
@property (nonatomic, assign) int maxLength;

@property (nonatomic, assign) CGPoint scrollOffset;

@property (nonatomic, assign) Class formCellClass;

@end
