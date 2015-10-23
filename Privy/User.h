//
//  User.h
//  Privy
//
//  Created by Kellen Pierson on 10/22/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import "Post.h"

@interface User : PFUser <PFSubclassing>

@property (nonatomic) NSString *fullname;
@property (nonatomic) PFFile *profilePhoto;
@property (nonatomic) PFFile *coverPhoto;
@property (nonatomic) NSString *bio;
@property (nonatomic) NSString *gender;
@property (nonatomic) PFRelation *likes;
@property (nonatomic) PFRelation *posts;

@end
