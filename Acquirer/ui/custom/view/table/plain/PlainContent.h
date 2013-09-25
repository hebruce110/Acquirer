//
//  PlainContent.h
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _CellStyle{
    Cell_Style_Plain,
    Cell_Style_LineBreak,
}CellStyle;

@interface PlainContent : NSObject{
    NSString *titleSTR;
    NSString *textSTR;
    CellStyle *cellStyle;
}

@property (nonatomic, copy) NSString *titleSTR;
@property (nonatomic, copy) NSString *textSTR;
@property (nonatomic, assign) CellStyle *cellStyle;

@end
