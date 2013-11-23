//
//  ChatBubbleView.h
//  Acquirer
//
//  Created by peer on 11/19/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _BubbleType{
    BubbleTypeLeft = 0,
    BubbleTypeRight,
} BubbleType;

@interface ChatBubbleView : UIView{
    NSString *textSTR;
    BubbleType bubbleType;
}

@property (nonatomic, copy) NSString *textSTR;
@property (nonatomic, assign) BubbleType bubbleType;

+(CGSize)sizeForText:(NSString *)text;

-(void)setText:(NSString *)newText bubbleType:(BubbleType)newBubbleType;

@end
