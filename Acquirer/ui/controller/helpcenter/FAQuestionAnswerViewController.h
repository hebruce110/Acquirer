//
//  FAQuestionAnswerViewController.h
//  Acquirer
//
//  Created by peer on 11/4/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class FAQModel;
@class GeneralTableView;

@interface FAQuestionAnswerViewController : BaseViewController{
    FAQModel *faqModel;
    
    GeneralTableView *faqTV;
}

@property (nonatomic, retain) FAQModel *faqModel;
@property (nonatomic, retain) GeneralTableView *faqTV;

@end
