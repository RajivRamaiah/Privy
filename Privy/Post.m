//
//  Post.m
//  Privy
//
//  Created by Kellen Pierson on 10/22/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "Post.h"
#import <Parse/PFObject+Subclass.h>
#import "User.h"

@implementation Post

@dynamic user;
@dynamic image;
@dynamic location;
@dynamic comment;
@dynamic filter;
@dynamic caption;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Post";
}

@end
