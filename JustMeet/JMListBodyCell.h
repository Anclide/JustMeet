//
//  JMListBodyCell.h
//  JustMeet
//
//  Created by Victor Bogatyrev on 15.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMListBodyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *meetingImageView;
@property (weak, nonatomic) IBOutlet UILabel *meetingAddress;

@end
