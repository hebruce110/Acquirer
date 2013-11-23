//
//  ChatTimeLabelCell.h
//  Acquirer
//
//  Created by peer on 11/21/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

@interface ChatTimeLabelCell : UITableViewCell{
    UILabel *timeLabel;
}

-(void)formatDateTime:(NSDate *)date;

@end
