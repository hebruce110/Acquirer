//
//  UILabel+Size.h
//  Acquirer
//
//  Created by chinapnr on 13-10-21.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (Size)

+(CGSize) calcLabelSizeWithString:(NSString *)string andFont:(UIFont *)font maxLines:(NSInteger)lines lineWidth:(float)lineWidth;
+(NSInteger) calcLabelLineWithString:(NSString *)string andFont:(UIFont *)font lineWidth:(float)lineWidth;

@end
