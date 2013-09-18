//
//  PlainTableDelegate.h
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlainTableDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *plainList;
}

@property (nonatomic, retain) NSMutableArray *plainList;

@end
