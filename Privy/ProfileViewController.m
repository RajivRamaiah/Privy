//
//  ProfileViewController.m
//  Privy
//
//  Created by Kellen Pierson on 10/24/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import "ProfileViewController.h"
#import "ProfilePostTableViewCell.h"
#import "User.h"
#import "Post.h"
#import "Activity.h"
#import "EditProfileViewController.h"
#import "ProfileOptionsViewController.h"
#import "CommentsViewController.h"


@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, ProfilePostTableViewCellDelegate>

@property (nonatomic) NSMutableArray *posts;
@property (nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profilePhotoImageView;
@property (weak, nonatomic) IBOutlet PFImageView *coverPhotoImageView;
@property (weak, nonatomic) IBOutlet UIView *profilePhotoOutlineView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPostsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfFriendsLabel;
@property (nonatomic) NSMutableArray *likedPosts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];

    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"createdBy" equalTo:self.currentUser];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            self.posts = [objects mutableCopy];
            self.numberOfPostsLabel.text = [@(self.posts.count) stringValue];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    self.profilePhotoOutlineView.layer.cornerRadius = 6;
    self.profilePhotoImageView.layer.cornerRadius = 4;

    PFRelation *relation = [self.currentUser relationForKey:@"likesRelation"];
    PFQuery *likeQuery = [relation query];
    [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.likedPosts = [objects mutableCopy];
        [self.tableView reloadData];
    }];

    [PFImageView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    PFRelation *relation = [self.currentUser relationForKey:@"friendsRelation"];
    PFQuery *friendsQuery = [relation query];
    [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.numberOfFriendsLabel.text = [@(objects.count) stringValue];
    }];

    self.profilePhotoImageView.file = self.currentUser.profilePhoto;
    [self.profilePhotoImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (!image) {
            self.coverPhotoImageView.image = [UIImage imageNamed:@"profile-image-ph"];
        } else {
            self.profilePhotoImageView.image = image;
        }
    }];
    self.coverPhotoImageView.file = self.currentUser.coverPhoto;
    [self.coverPhotoImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (!image) {
//            self.coverPhotoImageView.image = [UIImage imageNamed:@"profile-image-ph"];
        } else {
            self.coverPhotoImageView.image = image;
        }
    }];
    self.fullnameLabel.text = self.currentUser.fullname;
    self.usernameLabel.text = self.currentUser.username;
    self.bioLabel.text = self.currentUser.bio;

    PFRelation *likesRelation = [self.currentUser relationForKey:@"likesRelation"];
    PFQuery *likeQuery = [likesRelation query];
    [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.likedPosts = [objects mutableCopy];
        [self.tableView reloadData];
    }];
}

#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfilePostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];

    if ([self.likedPosts containsObject:post]) {
        cell.likeButton.selected = YES;
    } else {
        cell.likeButton.selected = NO;
    }

    cell.delegate = self;
    cell.user = self.currentUser;
    cell.post = post;
    [cell loadCell];
    cell.likesLabel.text = [NSString stringWithFormat:@"%@", [post.numberOfLikes stringValue]];
    cell.numberOfCommentsLabel.text = [NSString stringWithFormat:@"%@", [post.numberOfComments stringValue]];
    cell.captionLabel.text = post.caption;

    return cell;
}

#pragma mark - ProfilePostTableViewCell Delegate Methods

- (void)didTapLikeButton:(UIButton *)sender onCell:(ProfilePostTableViewCell *)cell {
    if ([self.likedPosts containsObject:cell.post]) {
        [self.likedPosts removeObject:cell.post];
    } else {
        [self.likedPosts addObject:cell.post];
        Activity *activity = [Activity object];
        activity.fromUser = self.currentUser;
        activity.toUser = cell.post.createdBy;
        activity.post = cell.post;
        activity.type = @0;
        [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            // Send a push notification
            NSLog(@"Like Activity Saved");
        }];
    }
}

- (void)didTapCommentButton:(UIButton *)sender onCell:(ProfilePostTableViewCell *)cell {
    [self performSegueWithIdentifier:@"ShowTheCommentsSegue" sender:cell];
}

- (void)didTapMoreButton:(UIButton *)sender onCell:(ProfilePostTableViewCell *)cell {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Actions" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *deletePost = [UIAlertAction actionWithTitle:@"Delete this post" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        if ([self.likedPosts containsObject:cell.post]) {
            [self.likedPosts removeObject:cell.post];
            PFRelation *relation = [self.currentUser relationForKey:@"likesRelation"];
            [relation removeObject:cell.post];
            [self.currentUser saveInBackground];
        }

        [self.posts removeObject:cell.post];

        [cell.post deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self.tableView reloadData];
        }];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // do something
    }];

    [alert addAction:deletePost];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}



#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(ProfilePostTableViewCell *)sender {
     if ([segue.identifier isEqualToString:@"ShowTheCommentsSegue"]) {
         CommentsViewController *destinationVC = segue.destinationViewController;
         destinationVC.post = sender.post;
     }
 }

@end
