//
//  PostHeaderTableViewCell.h
//  Privy
//
//  Created by Kellen Pierson on 10/23/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "User.h"

@interface PostHeaderTableViewCell : UITableViewCell

@property (nonatomic) User *user;
@property (weak, nonatomic) IBOutlet PFImageView *userProfilePhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

- (void)loadCell;

@end
