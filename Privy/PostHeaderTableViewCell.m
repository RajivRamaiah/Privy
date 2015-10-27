//
//  PostHeaderTableViewCell.m
//  Privy
//
//  Created by Kellen Pierson on 10/23/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "PostHeaderTableViewCell.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Post.h"
#import "Like.h"
#import "Comment.h"

@implementation PostHeaderTableViewCell

- (void)awakeFromNib {

    self.userProfilePhotoImageView.layer.cornerRadius = 4;
}

- (void)loadCell {

    if (!self.userProfilePhotoImageView.file) {
        self.userProfilePhotoImageView.image = [UIImage imageNamed:@"profile-image-ph"];
    } else {
        self.userProfilePhotoImageView.file = self.user.profilePhoto;
        [self.userProfilePhotoImageView loadInBackground];
    }
    self.usernameLabel.text = self.user.username;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
