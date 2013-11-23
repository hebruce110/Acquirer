//
//  SLBHelper.h
//  Acquirer
//
//  Created by Soal on 13-10-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface SLBHelper : NSObject

//第一次进生利宝
+ (BOOL)isFirstTimeEnterSLB;

//flag对应ys为YES
+ (BOOL)blFromSLBAgentSlbFlag:(id)flag equalYESString:(NSString *)ys;

//取得类cls属性列表
+ (NSArray *)propertyListOfClass:(Class)cls;

//证件类型编号取得类型
+ (NSString *)certNameFromCertType:(id)type;

@end

//-----------------------------------------------------
//-----------------------------------------------------

@interface NSString(ExamineInput)

//是否是退格键
+ (BOOL)isBackString:(NSString *)string;
//rangeString是否包含string
+ (BOOL)string:(NSString *)string isRangeOfString:(NSString *)rangeString;

@end

//-----------------------------------------------------
//-----------------------------------------------------

@interface NSString(micrometerSymbol)

//float生成带千分符的string
+ (NSString *)micrometerSymbolAmount:(CGFloat)amount;
//带千分符的micrometerSymbolString去掉string后得到的float
+ (CGFloat)amountFromMicrometerSymbolString:(NSString *)micrometerSymbolString withOutString:(NSString *)string;

@end

//-----------------------------------------------------
//-----------------------------------------------------

@interface NSString(SerialNumber)

//得到长度为length的年月日时分秒毫秒＋随机数的string,20位以上才安全
+ (NSString *)slbSerialNumberWithLength:(NSUInteger)length;

@end

//-----------------------------------------------------
//-----------------------------------------------------

@interface UIColor(SLBColor)

//生利宝常用的3种颜色，跟标准颜色有差别
+ (UIColor *)slbRedColor;
+ (UIColor *)slbBlueColor;
+ (UIColor *)slbGreenColor;

@end

//-----------------------------------------------------
//-----------------------------------------------------

@interface NSAttributedString (SLBCustomString)

//计算富文本高度
+ (CGFloat)heightOfAttributedString:(NSAttributedString *)attString WidthWidth:(CGFloat)width;

@end

//-----------------------------------------------------
//-----------------------------------------------------

@interface UIFont (CTFont)
//需自己释放内存
- (CTFontRef)ctFont;

@end

