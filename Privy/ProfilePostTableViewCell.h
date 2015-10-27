//
//  ProfilePostTableViewCell.h
//  Privy
//
//  Created by Kellen Pierson on 10/24/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@class User;
@class Post;

@interface ProfilePostTableViewCell : UITableViewCell

@property (nonatomic) User *user;
@property (nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;

- (void)loadCell;

@end
