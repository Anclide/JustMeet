//
//  JMFriendTableViewCell.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 15.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMFriendTableViewCell.h"

@implementation JMFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _friendImage.layer.cornerRadius = _friendImage.frame.size.height/2;
    _friendImage.layer.masksToBounds = YES;
    _onlineView.layer.cornerRadius = 4;
    _onlineView.layer.masksToBounds = YES;
    self.accessoryView.tintColor = [UIColor whiteColor];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
