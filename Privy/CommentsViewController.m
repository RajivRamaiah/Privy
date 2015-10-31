//
//  CommentsViewController.m
//  Privy
//
//  Created by Kellen Pierson on 10/27/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CommentsViewController.h"
#import "CommentTableViewCell.h"
#import "User.h"
#import "Post.h"
#import "Comment.h"
#import "Activity.h"

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) User *currentUser;
@property (nonatomic) NSMutableArray *comments;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addCommentButton;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];

    PFRelation *relation = [self.post relationForKey:@"commentsRelation"];
    PFQuery *query = [relation query];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.comments = [objects mutableCopy];
        [self.tableView reloadData];
    }];


    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - TableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    Comment *comment = self.comments[indexPath.row];

    [comment fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        cell.userImageView.file = comment.user.profilePhoto;
        [cell.userImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (image != nil) {
                cell.userImageView.image = image;
            } else {
                cell.userImageView.image = [UIImage imageNamed:@"profile-image-ph"];
            }
        }];
        cell.usernameLabel.text = comment.user.username;
        cell.contentLabel.text = comment.text;
        cell.timeLabel.text = [self formatTimeStampForActivity:comment];
    }];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@", comment.user.username, comment.text];


    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    Comment *comment = self.comments[indexPath.row];

    if (comment.user.objectId == self.currentUser.objectId)
        return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Comment *comment = self.comments[indexPath.row];

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        self.post.numberOfComments = @(self.post.numberOfComments.integerValue - 1);
        PFRelation *relation = [self.post relationForKey:@"commentsRelation"];
        [relation removeObject:comment];
        [self.post saveInBackground];

        [self.comments removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    }
}

- (IBAction)onAddCommentButtonPressed:(UIBarButtonItem *)sender {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add a comment" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {

    }];
    UIAlertAction *post = [UIAlertAction actionWithTitle:@"Add comment" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        if (textField.text.length >= 1) {
            Comment *comment = [Comment object];
            comment.user = self.currentUser;
            comment.text = textField.text;
            [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:self.comments.count + 1];
//                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
                [self.comments addObject:comment];
                [self.tableView reloadData];
                if (succeeded){
                    NSLog(@"comment saved");
                }

                self.post.numberOfComments = @(self.post.numberOfComments.integerValue + 1);
                PFRelation *relation = [self.post relationForKey:@"commentsRelation"];
                [relation addObject:comment];
                [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded){
                        NSLog(@"post saved");
                    }
                }];

                Activity *activity = [Activity object];
                activity.fromUser = self.currentUser;
                activity.toUser = self.post.createdBy;
                activity.post = self.post;
                activity.type = @1;
                [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    // Send a push notification
                    NSLog(@"Comment Activity Saved");
                }];
            }];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // Do something
    }];

    [alert addAction:post];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)formatTimeStampForActivity:(Comment *)comment {

    NSString *timeStamp;
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDate *d1 = [NSDate date];
    NSDate *d2 = comment.createdAt;

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
