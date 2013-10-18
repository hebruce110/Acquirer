//
//  SettleQueryTableCell.h
//  Acquirer
//
//  Created by chinapnr on 13-10-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettleQueryTableCell : UITableViewCell{
    UILabel *bankCardLabel;
    UILabel *tradeTimeLabel;
    UILabel *balanceAmtLabel;
}

@property (nonatomic, readonly) UILabel *bankCardLabel;
@property (nonatomic, readonly) UILabel *tradeTimeLabel;
@property (nonatomic, readonly) UILabel *balanceAmtLabel;

@end
