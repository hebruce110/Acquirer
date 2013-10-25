//
//  PlainTableCell.h
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlainTableCell : UITableViewCell{
    UILabel *titleLabel;
    UILabel *textLabel;
}

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *textLabel;

@end
