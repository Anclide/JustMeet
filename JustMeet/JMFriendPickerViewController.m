//
//  JMFriendPickerViewController.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 15.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMFriendPickerViewController.h"
#import "JMFriendTableViewCell.h"
#import "JMNetManager.h"
#import <AFMInfoBanner.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "JMFriend.h"

@interface JMFriendPickerViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *friends;
}


@end

@implementation JMFriendPickerViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_selectedFriends) {
        _selectedFriends = [[NSMutableArray alloc] init];
    }
    [self reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submit:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(setFriends:)]) {
        [delegate setFriends:[_selectedFriends copy]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)reloadData {
    [[JMNetManager sharedManager] fetchFriendListWithCompletion:^(NSArray *arr, NSError *err) {
        if (!err) {
            friends = arr;
            [self.table reloadData];
        } else {
            [AFMInfoBanner showAndHideWithText:err.localizedDescription style:AFMInfoBannerStyleError];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMFriendTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //NSArray *tmpArray = [_selectedFriends copy];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        for (JMFriend *tmpFriend in _selectedFriends) {
            if ([cell.userId isEqualToNumber:tmpFriend.userId]) {
                [_selectedFriends removeObject:tmpFriend];
                cell.accessoryType = UITableViewCellAccessoryNone;
                return;
            }
        }
    } else {
        if (_selectedFriends.count > 0) {
            for (JMFriend *tmpFriend in _selectedFriends) {
                if (![cell.userId isEqualToNumber:tmpFriend.userId]) {
                    [_selectedFriends addObject:friends[indexPath.row]];
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    return;
                }
            }
        } else {
            [_selectedFriends addObject:friends[indexPath.row]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMFriend *userFriend = friends[indexPath.row];
    JMFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell.friendImage sd_setImageWithURL:[NSURL URLWithString:userFriend.photo100url]];
    cell.friendName.text = [NSString stringWithFormat:@"%@ %@", userFriend.name, userFriend.surname];
    cell.friendCity.text = userFriend.city;
    cell.onlineView.backgroundColor = [userFriend.isOnline boolValue] ? [UIColor greenColor] : [UIColor grayColor];
    cell.userId = userFriend.userId;
    for (JMFriend *fri in _selectedFriends) {
        if ([cell.userId isEqualToNumber:fri.userId]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSLog(@"cell: %@, model: %@, fri: %@", cell.userId, userFriend.userId, fri.userId);
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
