//
//  SearchFriendProfileViewController.m
//  Privy
//
//  Created by Kellen Pierson on 10/26/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "SearchFriendProfileViewController.h"
#import "User.h"
#import "Post.h"
#import "Activity.h"
#import "Like.h"
#import "Comment.h"
#import <ParseUI/ParseUI.h>

@interface SearchFriendProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postsLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectionsLabel;
@property (weak, nonatomic) IBOutlet PFImageView *coverPhotoImageView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePhotoImageView;

@property User* currentUser;

@end

@implementation SearchFriendProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [User currentUser];
    // Do any additional setup after loading the view.
}

- (IBAction)onUnfollowButtonPressed:(UIButton *)sender {

    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    User *user = self.user;
    [friendsRelation removeObject:user];

    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {

    }];
}


@end
