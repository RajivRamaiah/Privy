//
//  SearchNonFriendProfileViewController.m
//  Privy
//
//  Created by Rajiv Ramaiah on 10/27/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "SearchNonFriendProfileViewController.h"
#import "User.h"
#import "Post.h"
#import "Activity.h"
#import "Like.h"
#import "Comment.h"

@interface SearchNonFriendProfileViewController ()

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property User *currentUser;

@end

@implementation SearchNonFriendProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [User currentUser];
}

- (IBAction)onFollowButtonPressed:(UIButton *)sender {


    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    User *user = self.user;
    [friendsRelation addObject:user];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Friend Request Sent" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Return" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSegueWithIdentifier:@"BackFromNonFriend" sender:nil];

    }];
    [alert addAction:save];
    [self presentViewController:alert animated:YES completion:nil];

    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
        }

    }];
    
}


@end
