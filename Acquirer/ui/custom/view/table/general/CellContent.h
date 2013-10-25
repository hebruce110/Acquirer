//
//  CellContent.h
//  Acquirer
//
//  Created by peer on 10/25/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _CellStyle{
    //系统标准列表
    Cell_Style_Standard = 0,
    //左title, 右text
    Cell_Style_Plain,
    //title在上, text在下
    Cell_Style_LineBreak,
    //title在左, text在右,右侧text换行
    Cell_Style_Text_LineBreak,
    //表单样式, 左侧title，右侧输入框
    Cell_Style_Form,
}CellStyle;

@interface CellContent : NSObject{
    CellStyle cellStyle;
}

@property (nonatomic, assign) CellStyle cellStyle;

@end
