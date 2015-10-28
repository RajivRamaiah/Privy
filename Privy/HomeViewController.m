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
#import "PostTableViewCell.h"
#import "PostHeaderTableViewCell.h"
#import "CommentsViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, PostTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) User *currentUser;
@property (nonatomic) NSArray *posts;
@property (nonatomic) NSMutableArray *likedPosts;
@property UIRefreshControl *refreshControl;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];
    [self loadRefreshControl];

    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"createdBy"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.posts = objects;
            [self.tableView reloadData];

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
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
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.posts = objects;
            [self.tableView reloadData];

        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
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
    cell.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", [post.numberOfLikes stringValue]];
    cell.captionLabel.text = post.caption;


    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PostHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostHeaderCell"];
    Post *post = self.posts[section];

//    cell.user = post.createdBy;
    cell.userProfilePhotoImageView.file = post.createdBy.profilePhoto;
    [cell.userProfilePhotoImageView loadInBackground];
    cell.usernameLabel.text = post.createdBy.username;
#warning Completion handler needed to load profile images
//    [cell loadCell];

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
    }
}

- (void)didTapCommentButton:(UIButton *)sender onCell:(PostTableViewCell *)cell {
    [self performSegueWithIdentifier:@"ShowCommentsSegue" sender:cell];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(PostTableViewCell *)sender {
    CommentsViewController *destinationVC = segue.destinationViewController;
    destinationVC.post = sender.post;
}


@end
