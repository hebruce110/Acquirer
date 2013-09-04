//
//  LoginTableCell.h
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTableCell : UITableViewCell <UITextFieldDelegate>{
    UILabel *titleLabel;
    UITextField *contentTextField;
}

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UITextField *contentTextField;

@end
