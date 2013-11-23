//
//  SLBHelper.m
//  Acquirer
//
//  Created by Soal on 13-10-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <objc/runtime.h>
#import "SLBHelper.h"
#import "Helper.h"
#import "SafeObject.h"

@implementation SLBHelper

//第一次进生利宝
+ (BOOL)isFirstTimeEnterSLB
{
    static NSString *fristTimeEnterSLBKey = @"fristTimeEnterSLBKey";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:fristTimeEnterSLBKey])
    {
        return (NO);
    }
    [userDefaults setValue:@"" forKey:fristTimeEnterSLBKey];
    return (YES);
}

//flag对应ys为YES
+ (BOOL)blFromSLBAgentSlbFlag:(id)flag equalYESString:(NSString *)ys
{
    if(!flag)
    {
        return (NO);
    }
    
    NSString *flagStr = nil;
    if(![flag isKindOfClass:[NSString class]])
    {
        flagStr = [NSString stringWithFormat:@"%@", flag];
    }
    else
    {
        flagStr = (NSString *)flag;
    }
    if([flagStr isEqualToString:ys])
    {
        return (YES);
    }
    return (NO);
}

//取得类cls属性列表
+ (NSArray *)propertyListOfClass:(Class)cls
{
    NSUInteger outCount = 0;
    
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    for(NSUInteger i = 0; i < outCount; i++) {
        [array addObject:[NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding]];
    }
    
    return array;
}

//证件类型编号取得类型
+ (NSString *)certNameFromCertType:(id)type
{
    if(!type)
    {
        return (@"其他:");
    }
    
    NSInteger typeInt = [type integerValue];
    switch(typeInt)
    {
        case 1:
        {
            return (@"身份证号码:");
        }break;
            
        case 2:
        {
            return (@"护照:");
        }break;
            
        case 9:
        {
            return (@"港澳台身份证:");
        }break;
            
        case 99:
        default:
        {
            return (@"其他:");
        }break;
    }
}

@end

//-----------------------------------------------------
//-----------------------------------------------------

@implementation NSString(ExamineInput)

//是否是退格键
+ (BOOL)isBackString:(NSString *)string
{
    const char *backStr = "\b";
    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, backStr);
    return (isBackSpace == -8);
}

//rangeString是否包含string
+ (BOOL)string:(NSString *)string isRangeOfString:(NSString *)rangeString
{
    NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:rangeString] invertedSet];
    NSString *trimmingCharString = [string stringByTrimmingCharactersInSet:nonNumberSet];
    return ((trimmingCharString.length == string.length));
}

@end

//-----------------------------------------------------
//-----------------------------------------------------

@implementation NSString(micrometerSymbol)

//float生成带千分符的string
+ (NSString *)micrometerSymbolAmount:(CGFloat)amount
{
    NSNumber *testNumber = [NSNumber numberWithFloat:amount];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *amountStr = [numberFormatter stringFromNumber:testNumber];
    [numberFormatter release];
    return (amountStr);
}

//带千分符的micrometerSymbolString去掉string后得到的float
+ (CGFloat)amountFromMicrometerSymbolString:(NSString *)micrometerSymbolString withOutString:(NSString *)string
{
    if(micrometerSymbolString && micrometerSymbolString.length > 0)
    {
        NSRange rg = [micrometerSymbolString rangeOfString:string];
        NSString *waiteString = micrometerSymbolString;
        if(rg.length > 0)
        {
            waiteString = nil;
            waiteString = [micrometerSymbolString substringWithRange:rg];
        }
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"###,##0.00;"];
        NSNumber *number = [numberFormatter numberFromString:waiteString];
        [numberFormatter release];
        return ([number floatValue]);
    }
    else
    {
        return (0);
    }
}

@end

//-----------------------------------------------------
//-----------------------------------------------------

@implementation NSString(SerialNumber)

//得到长度为length的年月日时分秒毫秒＋随机数的string,20位以上才安全
+ (NSString *)slbSerialNumberWithLength:(NSUInteger)length
{
    NSString *ftString = @"yyyyMMddHHmmssSSS";
    NSUInteger minLength = MAX(ftString.length, length);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:ftString];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    NSMutableString *serialStr = [NSMutableString stringWithString:dateStr];
    NSUInteger appendLength = minLength - dateStr.length;
    for(NSUInteger ix = 0; ix < appendLength; ix++)
    {
        [serialStr appendFormat:@"%i", arc4random() % 10];
    }
    return (serialStr);
}

@end

//-----------------------------------------------------
//-----------------------------------------------------

@implementation UIColor(SLBColor)

//生利宝常用的3种颜色，跟标准的有差别
+ (UIColor *)slbRedColor
{
    return ([UIColor colorWithRed:190 / 255.0f green:38 / 255.0f blue:23 / 255.0f alpha:1.0f]);
}

+ (UIColor *)slbGreenColor
{
    return ([UIColor colorWithRed:56 / 255.0f green:137 / 255.0f blue:31 / 255.0f alpha:1.0f]);
}

+ (UIColor *)slbBlueColor
{
    return ([UIColor colorWithRed:19 / 255.0f green:53 / 255.0f blue:100 / 255.0f alpha:1.0f]);
}

@end

//-----------------------------------------------------
//-----------------------------------------------------

@implementation NSAttributedString(SLBCustomString)

+ (CGFloat)heightOfAttributedString:(NSAttributedString *)attString WidthWidth:(CGFloat)width
{
    CGFloat total_height = 0;
    if(attString && attString.length > 0)
    {
        CGFloat maxHeight = 2000.0f;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
        
        CGRect drawingRect = CGRectMake(0, 0, width, maxHeight);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, drawingRect);
        CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
        CGPathRelease(path);
        CFRelease(framesetter);
        
        NSArray *linesArray = (NSArray *)CTFrameGetLines(textFrame);
        
        CGPoint origins[[linesArray count]];
        CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
        
        CGFloat line_y = (CGFloat) origins[[linesArray count] -1].y;
        
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        
        CTLineRef line = (CTLineRef) [linesArray safeObjectAtIndex:[linesArray count] - 1];
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        total_height = maxHeight - line_y + (CGFloat)descent + 1;
        
        CFRelease(textFrame);
        
        UIGraphicsPopContext();
    }
    
    return (total_height);
}

@end

//-----------------------------------------------------
//-----------------------------------------------------

@implementation UIFont (CTFont)
//需自己释放内存
- (CTFontRef)ctFont
{
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)self.fontName, self.pointSize, NULL);
    return (ctFont);
}

@end
