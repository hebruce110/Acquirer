//
//  FormTableDelegate.h
//  Acquirer
//
//  Created by ben on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseViewController;

@interface FormTableDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>{
    BaseViewController *CTRL;
    
    CGFloat rowHeight;
    NSMutableArray *formList;
}

@property (nonatomic,assign) BaseViewController *CTRL;

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, retain) NSMutableArray *formList;

@end
