//
//  SearchCollectionViewCell.m
//  Privy
//
//  Created by Kellen Pierson on 10/26/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "SearchCollectionViewCell.h"
#import "User.h"

@implementation SearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)loadCell {

    self.pfImageView.file = self.user.profilePhoto;
    [self.pfImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (!image){
            self.pfImageView.image = [UIImage imageNamed:@"profile-image-ph"];
        }
    }];
    self.fullnameLabel.text = self.user.fullname;
    self.usernameLabel.text = self.user.username;
}

@end
