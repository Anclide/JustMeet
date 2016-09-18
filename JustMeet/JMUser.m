//
//  JMUser.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 14.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMUser.h"

@implementation JMUser

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_surname forKey:@"surname"];
    [coder encodeObject:_userId forKey:@"userId"];
    [coder encodeObject:_city forKey:@"city"];
    [coder encodeObject:_bdate forKey:@"bdate"];
    [coder encodeObject:_photo200url forKey:@"photo200url"];
    [coder encodeObject:_photo400url forKey:@"photo400url"];
    
    
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self != nil) {
        _name = [coder decodeObjectForKey:@"name"];
        _surname = [coder decodeObjectForKey:@"surname"];
        _userId = [coder decodeObjectForKey:@"userId"];
        _city = [coder decodeObjectForKey:@"city"];
        _bdate = [coder decodeObjectForKey:@"bdate"];
        _photo200url = [coder decodeObjectForKey:@"photo200url"];
        _photo400url = [coder decodeObjectForKey:@"photo400url"];
    }
    return self;
}

@end
