//
//  ActivityTableViewCell.m
//  Privy
//
//  Created by Kellen Pierson on 10/26/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "ActivityTableViewCell.h"

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.fromUserImageView.layer.cornerRadius = 4;
    self.postImageView.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
