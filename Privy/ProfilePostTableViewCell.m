//
//  ProfilePostTableViewCell.m
//  Privy
//
//  Created by Kellen Pierson on 10/24/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "ProfilePostTableViewCell.h"

@implementation ProfilePostTableViewCell

- (void)awakeFromNib {

    self.userProfileImageView.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
