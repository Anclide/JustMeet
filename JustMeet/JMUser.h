//
//  JMUser.h
//  JustMeet
//
//  Created by Victor Bogatyrev on 14.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *surname;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *photo200url;
@property (strong, nonatomic) NSString *photo400url;
@property (strong, nonatomic) NSString *bdate;

@end
