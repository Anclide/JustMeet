//
//  JMFriend.h
//  JustMeet
//
//  Created by Victor Bogatyrev on 14.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMFriend : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *surname;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *photo100url;
@property (strong, nonatomic) NSNumber *isOnline;

@end
