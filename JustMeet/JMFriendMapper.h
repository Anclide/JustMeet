//
//  JMFriendMapper.h
//  JustMeet
//
//  Created by Victor Bogatyrev on 14.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JMFriend;

@interface JMFriendMapper : NSObject

- (JMFriend *)friendWithDictionary:(NSDictionary *)dictionary;

@end
