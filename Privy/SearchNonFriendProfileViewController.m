//
//  SearchNonFriendProfileViewController.m
//  Privy
//
//  Created by Rajiv Ramaiah on 10/27/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "SearchNonFriendProfileViewController.h"
#import "User.h"
#import "Post.h"
#import "Activity.h"
#import "Like.h"
#import "Comment.h"

@interface SearchNonFriendProfileViewController ()

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property User *currentUser;
@property (weak, nonatomic) IBOutlet PFImageView *profilePhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation SearchNonFriendProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [User currentUser];

    self.profilePhotoImageView.layer.cornerRadius = 4;

    self.profilePhotoImageView.file = self.user.profilePhoto;
    [self.profilePhotoImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        self.profilePhotoImageView.image = image;
    }];

    self.fullnameLabel.text = self.user.fullname;
    self.usernameLabel.text = self.user.username;
}

- (void)viewWillAppear:(BOOL)animated {
    PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
    [activityQuery whereKey:@"type" equalTo:@2];
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            for (Activity *activity in objects) {
                if (activity.fromUser == self.currentUser && activity.toUser == self.user) {
                    self.followButton.enabled = NO;
                    [self.followButton setTitle:@"Friend request sent" forState:UIControlStateNormal];
                    self.followButton.alpha = 0.6;
                } else {
                    self.followButton.enabled = YES;
                    [self.followButton setTitle:@"Send friend request" forState:UIControlStateNormal];
                    self.followButton.alpha = 1.0;
                }
            }
        }
    }];
}

- (IBAction)onFollowButtonPressed:(UIButton *)sender {

    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    User *user = self.user;
    [friendsRelation addObject:user];

    self.followButton.enabled = NO;
    [self.followButton setTitle:@"Friend request sent" forState:UIControlStateNormal];
    self.followButton.alpha = 0.6;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Friend Request Sent" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Return" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Activity *activity = [Activity object];
        activity.fromUser = self.currentUser;
        activity.type = @2;
        activity.toUser = self.user;
        [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            // do something
        }];

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
