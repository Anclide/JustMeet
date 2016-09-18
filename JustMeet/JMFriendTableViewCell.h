//
//  JMFriendTableViewCell.h
//  JustMeet
//
//  Created by Victor Bogatyrev on 15.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMFriendTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *friendImage;
@property (nonatomic, weak) IBOutlet UILabel *friendName;
@property (nonatomic, weak) IBOutlet UILabel *friendCity;
@property (nonatomic, weak) IBOutlet UIView *onlineView;
@property (nonatomic, strong) NSNumber *userId;
@end
