//
//  JMMeeting.h
//  JustMeet
//
//  Created by Victor Bogatyrev on 15.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JMUser;
@interface JMMeeting : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *meetDescription;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSArray *counters;
@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) JMUser *creator;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *meetId;

@end
