
//
//  JMUserMapper.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 14.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMUserMapper.h"
#import "JMUser.h"

@implementation JMUserMapper

- (JMUser *)userWithDictionary:(NSDictionary *)dictionary {
    JMUser *user = [[JMUser alloc] init];
    user.name = dictionary[@"first_name"];
    user.surname = dictionary[@"last_name"];
    user.city = dictionary[@"city"][@"title"];
    user.photo200url = dictionary[@"photo_200"];
    user.photo400url = dictionary[@"photo_400_orig"];
    user.userId = dictionary[@"id"];
    user.bdate = dictionary[@"bdate"];
    return user;
}

@end
