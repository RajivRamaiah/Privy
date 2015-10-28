//
//  CommentsViewController.h
//  Privy
//
//  Created by Kellen Pierson on 10/27/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@class Post;

@interface CommentsViewController : UIViewController

@property (nonatomic) Post *post;

@end
