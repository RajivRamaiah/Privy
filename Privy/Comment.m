//
//  Comment.m
//  Privy
//
//  Created by Kellen Pierson on 10/22/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "Comment.h"
#import <Parse/PFObject+Subclass.h>
#import "User.h"
#import "Post.h"

@implementation Comment

@dynamic user;
@dynamic text;

+(void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Comment";
}

@end
