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


@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *posts;
@property (nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profilePhotoImageView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];

    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"createdBy" equalTo:self.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            self.posts = objects;

            NSLog(@"Successfully retrieved %lu posts.", (unsigned long)self.posts.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    [PFImageView new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    self.profilePhotoImageView.file = self.currentUser.profilePhoto;
#warning Profile image won't update from Options screen if still uploading in background
    [self.profilePhotoImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.profilePhotoImageView setNeedsDisplay];
        });
    }];
    self.fullnameLabel.text = self.currentUser.fullname;
    self.usernameLabel.text = self.currentUser.username;
    self.bioLabel.text = self.currentUser.bio;
}

#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfilePostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];

    cell.usernameLabel.text = post.username;

    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
