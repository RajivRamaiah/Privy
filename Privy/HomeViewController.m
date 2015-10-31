//
//  HomeViewController.m
//  Privy
//
//  Created by Kellen Pierson on 10/23/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "HomeViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Post.h"
#import "Like.h"
#import "Comment.h"
#import "Activity.h"
#import "PostTableViewCell.h"
#import "PostHeaderTableViewCell.h"
#import "CommentsViewController.h"
#import <MessageUI/MessageUI.h>

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, PostTableViewCellDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) User *currentUser;
@property (nonatomic) NSMutableArray *posts;
@property (nonatomic) NSMutableArray *friends;
@property (nonatomic) NSMutableArray *likedPosts;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) MFMailComposeViewController *mc;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];
    [self loadRefreshControl];
    self.friends = [NSMutableArray new];
    self.posts = [NSMutableArray new];

    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-logo"]];
    self.navigationItem.titleView = logoImage;

    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    PFQuery *friendsQuery = [friendsRelation query];
    [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable friends, NSError * _Nullable error) {
        self.friends = [friends mutableCopy];
        PFQuery *query = [PFQuery queryWithClassName:@"Post"];
        [query orderByDescending:@"createdAt"];
        [query includeKey:@"createdBy"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
            if (!error) {
//                self.posts = [objects mutableCopy];
                for (Post *post in posts) {
                    if (self.currentUser.objectId == post.createdBy.objectId) {
                        [self.posts addObject:post];
                    }

                    if ([self.friends containsObject:post.createdBy]) {
                        [self.posts addObject:post];
                    }
                }
                //            self.posts = [objects mutableCopy];
                [self.tableView reloadData];

            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }];


    PFRelation *relation = [self.currentUser relationForKey:@"likesRelation"];
    PFQuery *likeQuery = [relation query];
    [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.likedPosts = [objects mutableCopy];
        [self.tableView reloadData];
    }];

    [PFImageView new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

    [self.tableView reloadData];
}

- (void)loadRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.tableView.alwaysBounceVertical = YES;
}

- (void)refreshControlAction {
    [self.refreshControl beginRefreshing];

    self.posts = [NSMutableArray new];
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    PFQuery *friendsQuery = [friendsRelation query];
    [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable friends, NSError * _Nullable error) {
        self.friends = [friends mutableCopy];
        PFQuery *query = [PFQuery queryWithClassName:@"Post"];
        [query orderByDescending:@"createdAt"];
        [query includeKey:@"createdBy"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
            if (!error) {
                //                self.posts = [objects mutableCopy];
                for (Post *post in posts) {
                    if (self.currentUser.objectId == post.createdBy.objectId) {
                        [self.posts addObject:post];
                    }

                    if ([self.friends containsObject:post.createdBy]) {
                        [self.posts addObject:post];
                    }
                }
                //            self.posts = [objects mutableCopy];
                [self.tableView reloadData];

            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }        }];
    }];

    PFRelation *relation = [self.currentUser relationForKey:@"likesRelation"];
    PFQuery *likeQuery = [relation query];
    [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.likedPosts = [objects mutableCopy];
        [self.tableView reloadData];
    }];

    [self.refreshControl endRefreshing];
}


#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.posts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.section];
    cell.delegate = self;

    if ([self.likedPosts containsObject:post]) {
        cell.likeButton.selected = YES;
    } else {
        cell.likeButton.selected = NO;
    }

    cell.post = post;
    cell.postImageView.file = post.image;
    [cell.postImageView loadInBackground];
    cell.likesLabel.text = [NSString stringWithFormat:@"%@", [post.numberOfLikes stringValue]];
    cell.commentsLabel.text = [NSString stringWithFormat:@"%@", [post.numberOfComments stringValue]];
    cell.captionLabel.text = post.caption;


    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PostHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostHeaderCell"];
    Post *post = self.posts[section];

//    cell.user = post.createdBy;
    cell.userProfilePhotoImageView.file = post.createdBy.profilePhoto;
    [cell.userProfilePhotoImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (!image) {
            cell.userProfilePhotoImageView.image = [UIImage imageNamed:@"profile-image-ph"];
        } else {
            cell.userProfilePhotoImageView.image = image;
        }
    }];
    cell.usernameLabel.text = post.createdBy.username;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat f = 50.0;
    return f;
}

#pragma mark - PostTableViewCell Delegate Methods

- (void)didTapLikeButton:(UIButton *)sender onCell:(PostTableViewCell *)cell {

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

- (void)didTapCommentButton:(UIButton *)sender onCell:(PostTableViewCell *)cell {
    [self performSegueWithIdentifier:@"ShowCommentsSegue" sender:cell];
}

- (void)didTapMoreButton:(UIButton *)sender onCell:(PostTableViewCell *)cell {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Actions" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *report = [UIAlertAction actionWithTitle:@"Report this post" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self emailTapped:cell];
    }];

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

    if (cell.post.createdBy == self.currentUser) {
        [alert addAction:deletePost];
    } else {
        [alert addAction:report];
    }
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Post Report Email Handling Methods

- (void)emailTapped:(PostTableViewCell *)cell {
    // Email Subject
    NSString *emailTitle = @"Offensive Post Report";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Post ID: %@", cell.post.objectId];
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"kellenpierson@gmail.com"];

    self.mc = [[MFMailComposeViewController alloc] init];

    self.mc.mailComposeDelegate = self;
    [self.mc setSubject:emailTitle];
    [self.mc setMessageBody:messageBody isHTML:NO];
    [self.mc setToRecipients:toRecipents];


    // Present mail view controller on screen
    [self presentViewController:self.mc animated:YES completion:^{

    }];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    // Close the Mail Interface
    [self.mc dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(PostTableViewCell *)sender {
    CommentsViewController *destinationVC = segue.destinationViewController;
    destinationVC.post = sender.post;
}


@end
