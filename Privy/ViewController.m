//
//  ViewController.m
//  Privy
//
//  Created by Rajiv Ramaiah on 10/22/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Post.h"
#import "Like.h"
#import "Comment.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    PFObject *post = [PFObject objectWithClassName:@"Post"];
//    post[@"filter"] = @"willow";
//    [post saveInBackground];

//    User *user = [User user];
//    user.username = @"jonnyblessed";
//    user.password = @"blessed";
//    user.email = @"jonnyblessed@imblessed.com";
//    user.bio = @"Hi. I'm Jonny Blessed. I am so blessed.";
//    user.gender = @"male";
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (!error) {
//            NSLog(@"yaaay");
//        } else {
//            NSLog(@"%@", error.description);
//        }
//    }];
    User *user = [User currentUser];

    Post *post= [Post new];
    post[@"createdBy"] = user;
    post.caption = @"testing relationships";
//    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (!error) {
//            NSLog(@"yay");
//        }
//    }];


    Comment *comment = [Comment new];
    comment.user = user;
    comment.text = @"Yet another awesome comment";
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"woohoo");
        }
    }];

    Like *like = [Like new];
    like.user = user;
    [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"liked");
        }
    }];

    [user.likes addObject:like];
//    PFRelation *relation = [user relationForKey:@"posts"];
//    [relation addObject:post];
//    [user.likes addObject:post];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"nice");
        } else {
            NSLog(@"%@", error.description);
        }
    }];

//
//    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
//    [query whereKey:@"objectId" equalTo:@"UHVfhnyWcz"];


//
//    Post *post = [Post new];
//    post.comment = comment;
//    post.caption = @"Just won 10Gs on a 1$ slot. So blessed";
//    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (!error) {
//            NSLog(@"nice");
//        }
//    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
