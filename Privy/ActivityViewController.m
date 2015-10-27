//
//  ActivityViewController.m
//  Privy
//
//  Created by Kellen Pierson on 10/26/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "ActivityViewController.h"
#import "Activity.h"
#import "Post.h"
#import "User.h"
#import "Comment.h"
#import "Like.h"
#import "ActivityTableViewCell.h"

@interface ActivityViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) User *currentUser;
@property (nonatomic) NSMutableArray *activities;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];
    self.activities = [NSMutableArray array];

    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"toUser" equalTo:self.currentUser];
    [query includeKey:@"fromUser"];
    [query includeKey:@"post"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.activities = objects.mutableCopy;
        [self.tableView reloadData];
    }];
}

#pragma mark - TableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    Activity *activity = self.activities[indexPath.row];

    if (activity.type.integerValue == 0) {
        cell.activityLabel.text = [NSString stringWithFormat:@"%@ liked a your post. 10m", activity.fromUser.username];
    } else if (activity.type.integerValue == 1) {
        cell.activityLabel.text = [NSString stringWithFormat:@"%@ commented on your post. 10m", activity.fromUser.username];
    } else {
        cell.activityLabel.text = [NSString stringWithFormat:@"%@ has requested to be your friend. 20m", activity.fromUser.username];
    }

    cell.fromUserImageView.file = activity.fromUser.profilePhoto;
    [cell.fromUserImageView loadInBackground];

    cell.postImageView.file = activity.post.image;
    [cell.postImageView loadInBackground];

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
