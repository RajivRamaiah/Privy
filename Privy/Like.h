//
//  Like.h
//  Privy
//
//  Created by Kellen Pierson on 10/22/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>

@class User;

@interface Like : PFObject <PFSubclassing>

@property (nonatomic) User *user;

+ (NSString *)parseClassName;

@end
