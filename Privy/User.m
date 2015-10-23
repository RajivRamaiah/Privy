//
//  User.m
//  Privy
//
//  Created by Kellen Pierson on 10/22/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "User.h"
#import <Parse/PFObject+Subclass.h>

@implementation User

@dynamic fullname;
@dynamic profilePhoto;
@dynamic coverPhoto;
@dynamic bio;
@dynamic gender;
@dynamic posts;
@dynamic likes;

//@synthesize likes = _likes;
//
//- (void)setLikes:(PFRelation *)likes {
//    _likes = likes;
//}
//
//- (PFRelation *)likes {
//    if (_likes == nil) {
//        <#statements#>
//    }
//}

+ (void)load {
    [self registerSubclass];
}

@end
