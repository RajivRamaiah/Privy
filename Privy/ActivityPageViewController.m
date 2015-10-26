//
//  ActivityPageViewController.m
//  Privy
//
//  Created by Anthony Tran on 10/24/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "ActivityPageViewController.h"
#import "PostActivityTableViewCell.h"
#import "Activity.h"


@interface ActivityPageViewController () <UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray *activityArray;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ActivityPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityArray = [[NSMutableArray alloc] init];

    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"toUser" equalTo:[User currentUser]];
    [query includeKey:@"fromUser"];
    [query includeKey:@"post"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.activityArray = [NSMutableArray arrayWithArray:objects];
        [self.myTableView reloadData];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    Activity *activity = self.activityArray [indexPath.row];
    if ([activity.type intValue] == 0) {
        cell.activityFromUserLabel.text = [NSString stringWithFormat:@"%@ liked your photo. 4m", activity.fromUser.username];
        cell.postImageView.file = activity.post.image;
        [cell.postImageView loadInBackground];
    } else if ([activity.type intValue] == 1) {
        cell.activityFromUserLabel.text = [NSString stringWithFormat:@"%@ Nice hanging with you earlier bud. Let's do this more often. #Blessed. 10m", activity.fromUser.username];
        cell.postImageView.file = activity.post.image;
        [cell.postImageView loadInBackground];

    } else {
        cell.activityFromUserLabel.text = [NSString stringWithFormat:@"%@ wants a connection. 15m", activity.fromUser.username];
        cell.postImageView.image = [UIImage imageNamed:@"followicon"];
        [cell.postImageView loadInBackground];



    }
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return  self.activityArray.count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
- (IBAction)onPostImageTapped:(UITapGestureRecognizer *)sender {

    
}

@end
