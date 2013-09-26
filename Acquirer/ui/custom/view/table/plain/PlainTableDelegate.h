//
//  PlainTableDelegate.h
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseViewController;

@interface PlainTableDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>{
    BaseViewController *CTRL;
    
    NSMutableArray *plainList;
}

@property (nonatomic,assign) BaseViewController *CTRL;
@property (nonatomic, retain) NSMutableArray *plainList;

@end
