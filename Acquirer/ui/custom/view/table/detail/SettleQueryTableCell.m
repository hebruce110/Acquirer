//
//  SettleQueryTableCell.m
//  Acquirer
//
//  Created by chinapnr on 13-10-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SettleQueryTableCell.h"

@implementation SettleQueryTableCell

@synthesize bankCardLabel, tradeTimeLabel, balanceAmtLabel;

-(void)dealloc{
    [bankCardLabel release];
    [tradeTimeLabel release];
    [balanceAmtLabel release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat leftOffset = 30;
        CGFloat rightOffset = 40;
        
        bankCardLabel = [[UILabel alloc] init] ;
        bankCardLabel.frame = CGRectMake(leftOffset, 5, 120, 20);
        bankCardLabel.textAlignment = UITextAlignmentLeft;
        bankCardLabel.font = [UIFont systemFontOfSize:15];
        bankCardLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:bankCardLabel];
        
        tradeTimeLabel = [[UILabel alloc] init];
        tradeTimeLabel.frame = CGRectMake(leftOffset, 25, 120, 20);
        tradeTimeLabel.font = [UIFont systemFontOfSize:13];
        tradeTimeLabel.textAlignment = UITextAlignmentLeft;
        tradeTimeLabel.textColor = [UIColor darkGrayColor];
        tradeTimeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tradeTimeLabel];
        
        balanceAmtLabel = [[UILabel alloc] init];
        balanceAmtLabel.frame = CGRectMake(self.bounds.size.width-rightOffset, 0, self.bounds.size.width, self.bounds.size.height);
        balanceAmtLabel.font = [UIFont boldSystemFontOfSize:16];
        balanceAmtLabel.textAlignment =  UITextAlignmentLeft;
        balanceAmtLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:balanceAmtLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
