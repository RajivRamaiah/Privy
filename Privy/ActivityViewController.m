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
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSMutableArray *activities;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];
    self.activities = [NSMutableArray array];
    [self loadRefreshControl];

    self.title = @"Activity";
    self.tableView.estimatedRowHeight = 66;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"toUser" equalTo:self.currentUser];
    [query includeKey:@"fromUser"];
    [query includeKey:@"post"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.activities = objects.mutableCopy;
        [self.tableView reloadData];
    }];
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
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"toUser" equalTo:self.currentUser];
    [query includeKey:@"fromUser"];
    [query includeKey:@"post"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.activities = objects.mutableCopy;
        [self.tableView reloadData];
    }];
    [self.refreshControl endRefreshing];
}

#pragma mark - TableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    Activity *activity = self.activities[indexPath.row];

    if (activity.type.integerValue == 0) {
        cell.postImageView.file = activity.post.image;
        [cell.postImageView loadInBackground];
        NSMutableAttributedString *cellText = [self boldUserNameWithMessage:@"liked your post." forActivity:activity inCell:cell];
        cell.activityLabel.attributedText = cellText;
        cell.timeLabel.text = [self formatTimeStampForActivity:activity];
    } else if (activity.type.integerValue == 1) {
        cell.postImageView.file = activity.post.image;
        [cell.postImageView loadInBackground];
        NSMutableAttributedString *cellText = [self boldUserNameWithMessage:@"commented on your post." forActivity:activity inCell:cell];
        cell.activityLabel.attributedText = cellText;
        cell.timeLabel.text = [self formatTimeStampForActivity:activity];
    } else {
        cell.postImageView.image = [UIImage imageNamed:@"profile-photo-ph"];
        NSMutableAttributedString *cellText = [self boldUserNameWithMessage:@"sent you a friend request." forActivity:activity inCell:cell];
        cell.activityLabel.attributedText = cellText;
    }

    cell.fromUserImageView.file = activity.fromUser.profilePhoto;
    [cell.fromUserImageView loadInBackground];


    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Activity *activity = self.activities[indexPath.row];
        [self.activities removeObject:activity];
        [self.tableView reloadData];
        [activity deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            NSLog(@"Activity Deleted");
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Activity *activity = self.activities[indexPath.row];

    if (activity.type.integerValue == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Friend Request" message:[NSString stringWithFormat:@"%@ has sent you a friend request.", activity.fromUser.username] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *accept = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            PFRelation *relation = [activity.fromUser relationForKey:@"friendsRelation"];
//            [relation addObject:activity.toUser];
//            [activity.fromUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                if (error) {
//                    NSLog(@"%@", error.localizedDescription);
//                }
//            }];

            PFRelation *friendRelation = [activity.toUser relationForKey:@"friendsRelation"];
            [friendRelation addObject:activity.fromUser];
            [activity.toUser saveInBackground];
        }];
        UIAlertAction *ignore = [UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // ignore friend request
        }];
        [alert addAction:accept];
        [alert addAction:ignore];
        [self presentViewController:alert animated:YES completion:nil];
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableAttributedString *)boldUserNameWithMessage:(NSString *)message forActivity:(Activity *)activity inCell:(ActivityTableViewCell *)cell {

    const CGFloat fontSize = 14;
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize],
                            NSForegroundColorAttributeName: [UIColor colorWithRed:25.0/255.0 green:118.0/255.0 blue:210.0/255.0 alpha:1.0]};
    NSDictionary *subAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize weight:UIFontWeightLight]};
    const NSRange range = NSMakeRange(0, activity.fromUser.username.length);

    NSMutableAttributedString *cellText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", activity.fromUser.username, message] attributes:subAttrs];
    [cellText setAttributes:attrs range:range];

    return cellText;
}

- (NSString *)formatTimeStampForActivity:(Activity *)activity {

    NSString *timeStamp;
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDate *d1 = [NSDate date];
    NSDate *d2 = activity.createdAt;

    NSDateComponents *components = [c components:NSCalendarUnitHour fromDate:d2 toDate:d1 options:0];
    NSInteger diff = components.hour;


    if (diff < 1) {
        NSDateComponents *components = [c components:NSCalendarUnitMinute fromDate:d2 toDate:d1 options:0];
        NSInteger diff = components.minute;
        timeStamp = [NSString stringWithFormat:@"%lum", diff];
    } else {
        timeStamp = [NSString stringWithFormat:@"%luh", diff];
    }

    return timeStamp;
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
