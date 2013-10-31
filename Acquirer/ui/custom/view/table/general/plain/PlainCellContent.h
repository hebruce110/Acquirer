//
//  PlainContent.h
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellContent.h"


@interface PlainCellContent : CellContent{
    NSString *titleSTR;
    NSString *textSTR;
    
    NSString *imgNameSTR;
    
    //cell的背景颜色
    UIColor *bgColor;
    
    UITableViewCellAccessoryType accessoryType;
    
    Class jumpClass;
}

@property (nonatomic, copy) NSString *titleSTR;
@property (nonatomic, copy) NSString *textSTR;
@property (nonatomic, copy) NSString *imgNameSTR;
@property (nonatomic, copy) UIColor *bgColor;

@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

@property (nonatomic, assign) Class jumpClass;

@end
