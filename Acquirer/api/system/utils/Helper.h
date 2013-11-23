//
//  Helper.h
//  Acquirer
//
//  Created by chinaPnr on 13-7-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonDigest.h>

@interface Helper : NSObject

/**
 将UIView转换为UIImage
 @param view 待转换的UIView
 @returns 转换后的UIImage
 */
+ (UIImage *) imageWithView:(UIView *)view;


/**
 通过键值对存储数据
 @param values 存储值 Value
 @param key 存储键 Key
 */
+(void) saveValue:(id)value forKey:(id)key;

/**
 通过Key获取存储Value
 @param key 存储键 Key
 @returns 存储值 Value
 */
+(id) getValueByKey:(id)key;


/**
 计算UILabel的高度
 @param inputString 显示文字
 @param font 字体大小
 @param width Label的宽度
 @returns 返回Label的高度
 */
+(float) getLabelHeight:(NSString *)inputString setfont:(UIFont *)font setwidth:(float)width;


/**
 计算UILabel的宽度
 @param inputString 显示文字
 @param font 字体大小
 @param height Label高度
 @returns 返回Label宽度
 */
+(float )getLabelWidth:(NSString *)inputString setFont:(UIFont *)font setHeight:(float)height;


/**
 计算屏幕宽度
 @returns 屏幕宽度
 */
+(float) screenWidth;

/**
 计算屏幕高度
 @returns 屏幕高度
 */
+(float) screenHeight;


/**
 判断字符串是否位空
 @param inputString 输入字符串
 @returns 返回结果
 */
+(Boolean)stringNullOrEmpty:(NSString *)inputString;

/*
 判断字符串的每个字符是否为数字或字母
 @param string 输入字符串
 @returns 返回结果
 */
+(BOOL)containInvalidChar:(NSString *)string;

/*
 处理金额显示
 当输入金额为XXXXX.XX的格式时，小数点前的每三位加入一个逗号，分隔符,
 修改后的格式为: XX,XXX,XXX.XX 格式
 */

+(NSString *)processAmtDisplay:(NSString *)amtSTR;


//收单的显示金额红色RGB
+(UIColor *) amountRedColor;

//十六进制颜色字符串转UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;

/**
 MD5加密
 @param str 输入初始参数
 @returns 加密后字符串
 */
+(NSString *)md5_16:(NSString *)str;

/**
 将NSData转为Base64字符串
 @param theData 输入数据
 @returns 输出Base64编码字符串
 */
+(NSString*)base64forData:(NSData*)theData;

/**
 将base64字符串转换为NSData
 @param string base64字符串
 @returns 返回NSData
 */
+(NSData*)base64DataFromString:(NSString *)string;

/*
 处理unicode字符串, 将unicode字符串转换为可读的字符串
 @param unicodeSTR
 @return returnSTR
 */

+ (NSString *)replaceUnicode:(NSString *)unicodeSTR;

@end
