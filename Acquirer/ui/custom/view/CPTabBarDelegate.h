//
//  CPTabBarDelegate.h
//  Acquirer
//
//  Created by chinaPnr on 13-7-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CPTabBarDelegate <NSObject>

//change tab index
-(void)changeToIndex:(int)index;

@end