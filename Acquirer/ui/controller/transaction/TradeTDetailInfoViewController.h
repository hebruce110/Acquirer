//
//  TradeTDetailInfoViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "PlainTableView.h"

@interface TradeTDetailInfoViewController : BaseViewController{
    PlainTableView *tradeInfoTV;
}

@property (nonatomic, retain) PlainTableView *tradeInfoTV;

@end
