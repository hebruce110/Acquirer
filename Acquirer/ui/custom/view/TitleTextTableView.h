//
//  TitleTextTableView.h
//  Acquirer
//
//  Created by chinapnr on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TitleTextDelegate;

@interface TitleTextTableView : UITableView{
    TitleTextDelegate *TTDelegate;
}

@end

@interface TitleTextDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>{
    CGFloat rowHeight;
    NSMutableArray *contentList;
}

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, retain) NSMutableArray *contentList;

@end