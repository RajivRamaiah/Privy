//
//  PostTableViewCell.m
//  Privy
//
//  Created by Kellen Pierson on 10/23/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "PostTableViewCell.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Post.h"
#import "Like.h"
#import "Comment.h"

@implementation PostTableViewCell

- (void)awakeFromNib {
    self.currentUser = [User currentUser];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onLikeButtonPressed:(UIButton *)sender {

    [UIView animateWithDuration:0.05f animations:^{
        self.likeButton.transform = CGAffineTransformMakeScale(1.2,1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05f animations:^{
            self.likeButton.transform = CGAffineTransformMakeScale(1.0,1.0);
        }];
    }];

    if (sender.isSelected == NO) {
        sender.selected = YES;
        PFRelation *like = [self.currentUser relationForKey:@"likesRelation"];
        [like addObject:self.post];
        self.post.numberOfLikes = @(self.post.numberOfLikes.integerValue + 1);
        [self.likesLabel setNeedsDisplay];
    } else {
        sender.selected = NO;
        PFRelation *like = [self.currentUser relationForKey:@"likesRelation"];
        [like removeObject:self.post];
        self.post.numberOfLikes = @(self.post.numberOfLikes.integerValue - 1);
        [self.likesLabel setNeedsDisplay];
    }

    [self.currentUser saveInBackground];
    [self.post saveInBackground];
    [self.delegate didTapLikeButton:sender onCell:self];
}

- (IBAction)onCommentButtonPressed:(UIButton *)sender {
    [self.delegate didTapCommentButton:sender onCell:self];
}

@end
