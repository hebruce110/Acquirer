//
//  DetailTableCell.m
//  Acquirer
//
//  Created by chinapnr on 13-9-23.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DetailTableCell.h"

@implementation DetailTableCell

@synthesize bankCardLabel, swipeTimeLabel;
@synthesize expenseLabel, tradeTypeLabel, tradeStatLabel;

-(void)dealloc{
    [bankCardLabel release];
    [swipeTimeLabel release];
    [expenseLabel release];
    [tradeTypeLabel release];
    [tradeStatLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat leftOffset = 10;
        CGFloat rightOffset = 20;
        
        bankCardLabel = [[[UILabel alloc] init] autorelease];
        bankCardLabel.frame = CGRectMake(leftOffset, 5, 120, 20);
        bankCardLabel.textAlignment = UITextAlignmentLeft;
        bankCardLabel.font = [UIFont systemFontOfSize:14];
        bankCardLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:bankCardLabel];
        
        swipeTimeLabel = [[[UILabel alloc] init] autorelease];
        swipeTimeLabel.frame = CGRectMake(leftOffset, 25, 120, 20);
        swipeTimeLabel.font = [UIFont systemFontOfSize:12];
        swipeTimeLabel.textAlignment = UITextAlignmentLeft;
        swipeTimeLabel.textColor = [UIColor darkGrayColor];
        swipeTimeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:swipeTimeLabel];
        
        expenseLabel = [[[UILabel alloc] init] autorelease];
        expenseLabel.frame = CGRectMake(self.bounds.size.width-100-rightOffset, 5, 100, 20);
        expenseLabel.font = [UIFont boldSystemFontOfSize:14];
        expenseLabel.textAlignment = UITextAlignmentRight;
        expenseLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:expenseLabel];
        
        tradeTypeLabel = [[[UILabel alloc] init] autorelease];
        tradeStatLabel.frame = CGRectMake(self.bounds.size.width-rightOffset-70, 25, 30, 20);
        tradeStatLabel.font = [UIFont systemFontOfSize:14];
        tradeStatLabel.textColor = [UIColor darkGrayColor];
        tradeStatLabel.textAlignment = UITextAlignmentLeft;
        tradeStatLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tradeTypeLabel];
        
        tradeStatLabel = [[[UILabel alloc] init] autorelease];
        tradeStatLabel.frame = CGRectMake(self.bounds.size.width-rightOffset-30, 25, 30, 20);
        tradeStatLabel.font = [UIFont boldSystemFontOfSize:14];
        tradeStatLabel.textAlignment = UITextAlignmentRight;
        tradeStatLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tradeStatLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
