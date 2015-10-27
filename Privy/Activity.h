//
//  Activity.h
//  Privy
//
//  Created by Kellen Pierson on 10/26/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Post.h"

@interface Activity : PFObject <PFSubclassing>

@property (nonatomic) User *fromUser;
@property (nonatomic) User *toUser;
@property (nonatomic) Post *post;
@property (nonatomic) NSNumber *type;
@property (nonatomic) NSString *text;

+ (NSString *)parseClassName;

@end
