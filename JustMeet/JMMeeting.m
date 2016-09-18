//
//  JMMeeting.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 15.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMMeeting.h"

@implementation JMMeeting

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_phone forKey:@"phone"];
    [coder encodeObject:_address forKey:@"address"];
    [coder encodeObject:_meetDescription forKey:@"meetDescription"];
    [coder encodeObject:_image forKey:@"image"];
    [coder encodeObject:_counters forKey:@"counters"];
    [coder encodeObject:_creationDate forKey:@"creationDate"];
    [coder encodeObject:_creator forKey:@"creator"];
    [coder encodeObject:_latitude forKey:@"latitude"];
    [coder encodeObject:_longitude forKey:@"longitude"];
    [coder encodeObject:_meetId forKey:@"meetId"];

}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self != nil) {
        _name = [coder decodeObjectForKey:@"name"];
        _phone = [coder decodeObjectForKey:@"phone"];
        _address = [coder decodeObjectForKey:@"address"];
        _meetDescription = [coder decodeObjectForKey:@"meetDescription"];
        _image = [coder decodeObjectForKey:@"image"];
        _counters = [coder decodeObjectForKey:@"counters"];
        _creationDate = [coder decodeObjectForKey:@"creationDate"];
        _creator = [coder decodeObjectForKey:@"creator"];
        _latitude = [coder decodeObjectForKey:@"latitude"];
        _longitude = [coder decodeObjectForKey:@"longitude"];
        _meetId = [coder decodeObjectForKey:@"meetId"];
    }
    return self;
}

@end
