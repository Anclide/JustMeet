//
//  JMHeaderListCell.h
//  JustMeet
//
//  Created by Victor Bogatyrev on 15.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMHeaderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *creatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *creatorName;
@property (weak, nonatomic) IBOutlet UILabel *meetingName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
