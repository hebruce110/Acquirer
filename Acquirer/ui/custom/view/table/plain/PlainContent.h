//
//  PlainContent.h
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _CellStyle{
    Cell_Style_Standard = 0,
    Cell_Style_Plain,
    //title在上, text在下
    Cell_Style_LineBreak,
    //title在左, text在右
    Cell_Style_Text_LineBreak,
}CellStyle;

@interface PlainContent : NSObject{
    NSString *titleSTR;
    NSString *textSTR;
    
    NSString *imgNameSTR;
    
    CellStyle cellStyle;
    
    Class jumpClass;
}

@property (nonatomic, copy) NSString *titleSTR;
@property (nonatomic, copy) NSString *textSTR;
@property (nonatomic, copy) NSString *imgNameSTR;
@property (nonatomic, assign) CellStyle cellStyle;

@property (nonatomic, assign) Class jumpClass;

@end
