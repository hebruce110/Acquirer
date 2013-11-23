//
//  SLBAttributedView.h
//  Acquirer
//
//  Created by Soal on 13-10-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>
#import <CoreText/CoreText.h>

@interface SLBAttributedView : UIView

- (void)setAttributeString:(NSAttributedString *)attributeString;
- (NSAttributedString *)attributeString;

@end
