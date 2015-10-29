//
//  ProfileOptionsViewController.m
//  Privy
//
//  Created by Kellen Pierson on 10/24/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import "ProfileOptionsViewController.h"
#import "User.h"
#import "EditProfileViewController.h"

@interface ProfileOptionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) User *currentUser;
@property (nonatomic) NSArray *sectionOneOptions;
@property (nonatomic) NSArray *sectionTwoOptions;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProfileOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sectionOneOptions = @[@"Edit Profile", @"Edit Cover Photo", @"Change Password", @"Posts you've liked"];
    self.sectionTwoOptions = @[@"Log Out"];

    self.title = @"Options";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount;

    if (section == 0) {
        rowCount = self.sectionOneOptions.count;
    } else if (section == 1) {
        rowCount = self.sectionTwoOptions.count;
    }

    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];

    if (indexPath.section == 0) {
        cell.textLabel.text = self.sectionOneOptions[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = self.sectionTwoOptions[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithRed:0.0f green:128.0f / 255.0f blue:1.0f alpha:1.0f];
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"ACCOUNT", @"ACCOUNT");
            break;
        case 1:
            sectionName = NSLocalizedString(@"", @"");
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"ShowEditProfileSegue" sender:self];
        } else if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"ShowEditCoverPhotoSegue" sender:self];
        } else if (indexPath.row == 2) {
            [self performSegueWithIdentifier:@"ShowChangePasswordSegue" sender:self];
        } else if (indexPath.row == 3) {
            // --> Posts you've Liked ??
        }
    } else if (indexPath.section == 1) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log out?" message:@"Are you sure you want to log out?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *logOut = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [User logOut];
            [self performSegueWithIdentifier:@"ShowLogin" sender:self];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // Do something
        }];

        [alert addAction:logOut];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];

    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
