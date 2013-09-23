//
//  DetailTableCell.h
//  Acquirer
//
//  Created by chinapnr on 13-9-23.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableCell : UITableViewCell{
    UILabel *bankCardLabel;
    UILabel *swipeTimeLabel;
    UILabel *expenseLabel;
    UILabel *tradeTypeLabel;
    UILabel *tradeStatLabel;
}

@property (nonatomic, readonly) UILabel *bankCardLabel;
@property (nonatomic, readonly) UILabel *swipeTimeLabel;
@property (nonatomic, readonly) UILabel *expenseLabel;
@property (nonatomic, readonly) UILabel *tradeTypeLabel;
@property (nonatomic, readonly) UILabel *tradeStatLabel;


@end
