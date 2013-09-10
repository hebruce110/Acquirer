//
//  TitleTextTableView.h
//  Acquirer
//
//  Created by chinapnr on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleTextTableView : UITableView

@end

@interface TitleTextDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>{
    CGFloat rowHeight;
}

@end