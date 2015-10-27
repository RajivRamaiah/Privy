//
//  Activity.m
//  Privy
//
//  Created by Kellen Pierson on 10/26/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "Activity.h"

@implementation Activity

@dynamic fromUser;
@dynamic toUser;
@dynamic post;
@dynamic type;
@dynamic text;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Activity";
}

@end
