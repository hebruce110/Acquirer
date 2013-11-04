//
//  FAQViewController.h
//  Acquirer
//
//  Created by peer on 11/4/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class GeneralTableView;

@interface FAQViewController : BaseViewController{
    GeneralTableView *faqTV;
}

@property (nonatomic, retain) GeneralTableView *faqTV;

@end
