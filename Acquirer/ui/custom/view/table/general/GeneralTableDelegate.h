//
//  GeneralTableDelegate.h
//  Acquirer
//
//  Created by peer on 10/25/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseViewController;

@interface GeneralTableDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>{
    BaseViewController *CTRL;
    
    NSMutableArray *genList;
}

@property (nonatomic,assign) BaseViewController *CTRL;
@property (nonatomic, retain) NSMutableArray *genList;

@end
