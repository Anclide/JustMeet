//
//  JMNetManager.h
//  JustMeet
//
//  Created by Victor Bogatyrev on 14.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JMUser;

@interface JMNetManager : NSObject

@property (nonatomic, strong) JMUser *userModel;
@property (nonatomic, strong) NSString *token;

+ (id)sharedManager;

- (void)setToken:(NSString *)token;

- (void)fetchUserInfoWithId:(NSString *)userId andCompletion:(void(^)(NSDictionary *, NSError *))completion;

- (void)fetchFriendListWithCompletion:(void(^)(NSArray *, NSError *))completion;

@end
