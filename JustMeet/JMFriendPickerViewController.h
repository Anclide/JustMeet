//
//  JMFriendPickerViewController.h
//  JustMeet
//
//  Created by Victor Bogatyrev on 15.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMFriendPickerDelegate <NSObject>
@required

- (void)setFriends:(NSArray *)array;

@end

@interface JMFriendPickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, assign) id <JMFriendPickerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *selectedFriends;


@end
