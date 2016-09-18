//
//  JMFriend.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 14.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMFriend.h"

@implementation JMFriend

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_surname forKey:@"surname"];
    [coder encodeObject:_userId forKey:@"userId"];
    [coder encodeObject:_city forKey:@"city"];
    [coder encodeObject:_photo100url forKey:@"photo100url"];
    [coder encodeObject:_isOnline forKey:@"isOnline"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self != nil) {
        _name = [coder decodeObjectForKey:@"name"];
        _surname = [coder decodeObjectForKey:@"surname"];
        _userId = [coder decodeObjectForKey:@"userId"];
        _city = [coder decodeObjectForKey:@"city"];
        _photo100url = [coder decodeObjectForKey:@"photo100url"];
        _isOnline = [coder decodeObjectForKey:@"isOnline"];
    }
    return self;
}

@end
