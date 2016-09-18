//
//  JMNetManager.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 14.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMNetManager.h"
#import <AFNetworking/AFNetworking.h>
#import "JMUser.h"
#import "JMFriend.h"
#import "JMUserMapper.h"
#import "JMFriendMapper.h"


@interface JMNetManager()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation JMNetManager

+ (id)sharedManager {
    static JMNetManager *sharedNetManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetManager = [[self alloc] init];
        sharedNetManager.sessionManager = [sharedNetManager configureSessionManager];
    });
    return sharedNetManager;
}

- (AFHTTPSessionManager *)configureSessionManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    //AFHTTPResponseSerializer
    [serializer setReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer = serializer;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain",@"text/html",@"application/json"]];
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status)
        {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"SO REACHABLE");
                
                break;
            }
                
            case AFNetworkReachabilityStatusNotReachable:
            default:
            {
                NSLog(@"SO UNREACHABLE");
                
                //not reachable,inform user perhaps
                break;
            }
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return manager;
}

- (void)setToken:(NSString *)token {
    _token = token;
}

- (void)saveUserModelWithDictionary:(NSDictionary *)dictionary {
    _userModel = [[JMUserMapper alloc] userWithDictionary:dictionary[@"response"][0]];
}

- (void)fetchUserInfoWithId:(NSString *)userId andCompletion:(void (^)(NSDictionary *, NSError *))completion {
    NSString *url = @"https://api.vk.com/method/users.get";
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSDictionary *params = @{
                             @"user_id":userId,
                             @"v":@"5.53",
                             @"token":_token ? _token : token,
                             @"fields":@"city, photo_200, photo_400_orig, bdate",
                             @"name_case":@"Nom"
                             };
    
    [self.sessionManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self saveUserModelWithDictionary:responseObject];
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)fetchFriendListWithCompletion:(void (^)(NSArray *, NSError *))completion {
    NSString *url = @"https://api.vk.com/method/friends.get";
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSDictionary *params = @{
                             @"user_id":_userModel.userId ? _userModel.userId : userId,
                             @"v":@"5.53",
                             @"access_token":_token ? _token : token,
                             @"fields":@"city,photo_100, online"
                             };
    [self.sessionManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *friends = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"response"][@"items"]) {
            [friends addObject:[[JMFriendMapper alloc] friendWithDictionary:dict]];
        }
        completion([friends copy], nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

@end
