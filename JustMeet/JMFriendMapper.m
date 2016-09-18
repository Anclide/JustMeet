//
//  JMFriendMapper.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 14.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMFriendMapper.h"
#import "JMFriend.h"

@implementation JMFriendMapper

- (JMFriend *)friendWithDictionary:(NSDictionary *)dictionary {
    JMFriend *friend = [JMFriend new];
    friend.name = dictionary[@"first_name"];
    friend.surname = dictionary[@"last_name"];
    friend.city = dictionary[@"city"][@"title"];
    friend.photo100url = dictionary[@"photo_100"];
    friend.userId = dictionary[@"id"];
    friend.isOnline = dictionary[@"online"];
    return friend;
}

@end
