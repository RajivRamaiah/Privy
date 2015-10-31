//
//  CommentTableViewCell.m
//  Privy
//
//  Created by Kellen Pierson on 10/29/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.userImageView.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
