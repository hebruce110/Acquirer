//
//  ChatMessageCell.m
//  Acquirer
//
//  Created by peer on 11/19/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "ChatMessageCell.h"


@implementation ChatMessageCell

@synthesize cm, msgStateTimer;

-(void)dealloc{
    [bubbleView release];
    [failImageView release];
    [csHeadView release];
    [cm release];

    self.msgStateTimer = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bubbleView = [[ChatBubbleView alloc] init];
        bubbleView.backgroundColor = [UIColor clearColor];
        bubbleView.opaque = YES;
        bubbleView.clearsContextBeforeDrawing = YES;
        bubbleView.contentMode = UIViewContentModeRedraw;
        bubbleView.autoresizingMask = 0;
        [self.contentView addSubview:bubbleView];
        
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:loadingIndicator];
        
        UIImage *failImg = [UIImage imageNamed:@"icon_mes_fail.png"];
        failImageView = [[UIImageView alloc] initWithImage:failImg];
        [self.contentView addSubview:failImageView];
        failImageView.hidden = YES;
        
        UIImage *csImg = [UIImage imageNamed:@"pic_gril.png"];
        csHeadView = [[UIImageView alloc] initWithImage:csImg];
        [self.contentView addSubview:csHeadView];
        csHeadView.hidden = YES;
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (cm.sentBy == MessageSentByUser) {
        csHeadView.hidden = YES;
        bubbleView.center = CGPointMake(bubbleView.center.x, CGRectGetMidY(self.bounds));
        
    }else if (cm.sentBy == MessageSentByCS){
        
        csHeadView.hidden = NO;
        failImageView.hidden = YES;
        bubbleView.center = CGPointMake(bubbleView.center.x, CGRectGetMidY(self.bounds));
        csHeadView.center = CGPointMake(csHeadView.bounds.size.width/2+HORIZONTAL_PADDING, csHeadView.center.y);
        
        csHeadView.frame = CGRectMake(csHeadView.frame.origin.x,
                                      bubbleView.frame.origin.y,
                                      csHeadView.bounds.size.width,
                                      csHeadView.bounds.size.height);
    }
    
    [self processSendState];
}

-(void)processSendState{
    if (cm.sentBy == MessageSentByUser) {
        failImageView.hidden = YES;
        
        if (cm.sentState == MessageSentStatePending) {
            loadingIndicator.center = CGPointMake(bubbleView.frame.origin.x-15, CGRectGetMidY(self.bounds));
            [loadingIndicator startAnimating];
        }
        else if (cm.sentState == MessageSentStateFailure){
            failImageView.hidden = NO;
            failImageView.center = CGPointMake(bubbleView.frame.origin.x-15, CGRectGetMidY(self.bounds));
            [loadingIndicator stopAnimating];
        }
        else if (cm.sentState == MessageSentStateSucceed){
            [loadingIndicator stopAnimating];
        }
    }
}

#define CHAT_MSG_TIME_OUT 15

- (void)setMessage:(ChatMessage*)message{
    self.cm = message;
    
    CGPoint point = CGPointZero;
    
    BubbleType bubbleType = 0;
    if (message.sentBy == MessageSentByUser) {
        bubbleType = BubbleTypeRight;
        point.x = self.bounds.size.width - message.bubbleSize.width-10;
    }else if(message.sentBy == MessageSentByCS){
        bubbleType = BubbleTypeLeft;
        point.x = csHeadView.bounds.size.width + HORIZONTAL_PADDING*2;
    }
    
    CGRect rect;
    rect.origin = point;
    rect.size = message.bubbleSize;
    bubbleView.frame = rect;
    [bubbleView setText:message.messageSTR bubbleType:bubbleType];
    
    if (cm.sentBy == MessageSentByUser) {
        self.msgStateTimer = [NSTimer scheduledTimerWithTimeInterval:CHAT_MSG_TIME_OUT
                                                              target:self
                                                            selector:@selector(chatMsgSentFailure)
                                                            userInfo:nil
                                                             repeats:NO];
    }
}

-(void)chatMsgSentFailure{
    if (cm.sentState == MessageSentStatePending) {
        cm.sentState = MessageSentStateFailure;
        [self setNeedsLayout];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
