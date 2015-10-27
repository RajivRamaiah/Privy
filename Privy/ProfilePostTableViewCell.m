//
//  ProfilePostTableViewCell.m
//  Privy
//
//  Created by Kellen Pierson on 10/24/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "ProfilePostTableViewCell.h"
#import "User.h"
#import "Post.h"

@implementation ProfilePostTableViewCell

- (void)awakeFromNib {

    self.userProfileImageView.layer.cornerRadius = 4;
}

- (void)loadCell {
    self.usernameLabel.text = self.user.username;
    self.userProfileImageView.file = self.user.profilePhoto;
    [self.userProfileImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        self.userProfileImageView.image = image;
    }];
    self.postImageView.file = self.post.image;
    [self.postImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        self.postImageView.image = image;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
