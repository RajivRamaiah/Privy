//
//  PostActivityTableViewCell.m
//  Privy
//
//  Created by Anthony Tran on 10/24/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "PostActivityTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PostActivityTableViewCell

- (void)awakeFromNib {
    self.activityFromUserImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.activityFromUserImageView.layer.cornerRadius=10;
    self.activityFromUserImageView.layer.borderWidth=1.0;
    self.activityFromUserImageView.layer.masksToBounds = YES;
   self.activityFromUserImageView.layer.borderColor=[[UIColor yellowColor] CGColor];

    self.postImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.postImageView.layer.borderWidth=1.0;
    self.postImageView.layer.masksToBounds = YES;
    self.postImageView.layer.borderColor=[[UIColor yellowColor] CGColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
