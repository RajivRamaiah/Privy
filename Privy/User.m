//
//  User.m
//  Privy
//
//  Created by Kellen Pierson on 10/22/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "User.h"
#import <Parse/PFObject+Subclass.h>
#import "Post.h"

@implementation User

@dynamic fullname;
@dynamic profilePhoto;
@dynamic coverPhoto;
@dynamic bio;
@dynamic gender;
@dynamic postsRelation;
@dynamic likesRelation;
@dynamic friendsRelation;
@dynamic numberOfFriends;
@dynamic numberOfPosts;

+ (void)load {
    [self registerSubclass];
}

@end
