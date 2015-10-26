//
//  Post.h
//  Privy
//
//  Created by Kellen Pierson on 10/22/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import "Comment.h"

@class Like;
@class User;

@interface Post : PFObject <PFSubclassing>

@property (nonatomic) User *createdBy;
@property (nonatomic) NSString *username;
@property (nonatomic) NSNumber *numberOfLikes;
@property (nonatomic) NSNumber *numberOfComments;
@property (nonatomic) PFFile *image;
@property (nonatomic) PFGeoPoint *location;
@property (nonatomic) PFRelation *likesRelation;
@property (nonatomic) PFRelation *commentsRelation;
@property (nonatomic) NSString *filter;
@property (nonatomic) NSString *caption;
//@property (nonatomic) PFRelation *likes;


+ (NSString *)parseClassName;

@end
