//
//  Like.m
//  Privy
//
//  Created by Kellen Pierson on 10/22/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "Like.h"
#import <Parse/PFObject+Subclass.h>
#import "User.h"

@implementation Like

@dynamic user;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Like";
}

@end
