//
//  Post.h
//  Privy
//
//  Created by Kellen Pierson on 10/22/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import "Comment.h"
#import "Like.h"

@class User;

@interface Post : PFObject <PFSubclassing>

@property (nonatomic) User *user;
@property (nonatomic) PFFile *image;
@property (nonatomic) PFGeoPoint *location;
@property (nonatomic) Comment *comment;
@property (nonatomic) NSString *filter;
@property (nonatomic) NSString *caption;
//@property (nonatomic) PFRelation *likes;


+ (NSString *)parseClassName;

@end
