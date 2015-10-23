//
//  Comment.h
//  Privy
//
//  Created by Kellen Pierson on 10/22/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>

@class User;
@class Post;

@interface Comment : PFObject <PFSubclassing>

@property (nonatomic) User *user;
@property (nonatomic) NSString *text;

+ (NSString *)parseClassName;

@end
