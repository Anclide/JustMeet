//
//  JMListFooterCell.h
//  JustMeet
//
//  Created by Victor Bogatyrev on 15.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMListFooterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UILabel *comments;

@end
