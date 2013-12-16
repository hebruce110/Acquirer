//
//  CustomTitleTextView.h
//  TextViewTest
//
//  Created by soal on 13-11-29.
//  Copyright (c) 2013年 soal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTitleTextView : UIView

@property (assign, nonatomic) CGFloat space;

@property (retain, nonatomic, readonly) UILabel *titleLabel;
@property (retain, nonatomic, readonly) UILabel *dateLabel;
@property (retain, nonatomic, readonly) UITextView *textView;

@end
