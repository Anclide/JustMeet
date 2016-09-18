//
//  JMHeaderListCell.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 15.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMHeaderListCell.h"

@implementation JMHeaderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _creatorImageView.layer.cornerRadius = _creatorImageView.frame.size.width/2 - 6;
    _creatorImageView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
