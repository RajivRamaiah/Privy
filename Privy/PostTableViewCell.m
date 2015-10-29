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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapToLike:)];
        tapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tapGesture];
    }

    return self;
}

- (void)awakeFromNib {
    self.currentUser = [User currentUser];

}

- (void)doubleTapToLike:(PostTableViewCell *)cell {


    if (self.likeButton.isSelected == NO) {
        self.heartImageView.image = [UIImage imageNamed:@"heart-lg-icon"];
    } else {
        self.heartImageView.image = [UIImage imageNamed:@"heart-lg-broken-icon"];
    }

    self.heartImageView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.3f animations:^{
        [self.heartImageView setAlpha:1.0];
        self.heartImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            self.heartImageView.transform = CGAffineTransformMakeScale(1.0001, 1.0001);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3f animations:^{
                self.heartImageView.transform = CGAffineTransformMakeScale(0.6, 0.6);
                [self.heartImageView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                // completion
            }];
        }];
    }];

    [UIView animateWithDuration:0.1f animations:^{
        self.likeButton.transform = CGAffineTransformMakeScale(1.2,1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            self.likeButton.transform = CGAffineTransformMakeScale(1.0,1.0);
            [UIView animateWithDuration:0.1f animations:^{
                self.likesLabel.transform = CGAffineTransformMakeScale(1.4,1.4);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1f animations:^{
                    self.likesLabel.transform = CGAffineTransformMakeScale(1.0,1.0);
                }];
            }];
        }];
    }];

    if (self.likeButton.isSelected == NO) {
        self.likeButton.selected = YES;
        PFRelation *like = [self.currentUser relationForKey:@"likesRelation"];
        [like addObject:self.post];
        self.post.numberOfLikes = @(self.post.numberOfLikes.integerValue + 1);
        self.likesLabel.text = [@(self.likesLabel.text.integerValue + 1) stringValue];
    } else {
        self.likeButton.selected = NO;
        PFRelation *like = [self.currentUser relationForKey:@"likesRelation"];
        [like removeObject:self.post];
        self.post.numberOfLikes = @(self.post.numberOfLikes.integerValue - 1);
        self.likesLabel.text = [@(self.likesLabel.text.integerValue - 1) stringValue];
    }

    [self.currentUser saveInBackground];
    [self.post saveInBackground];
    [self.delegate didTapLikeButton:nil onCell:self];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onLikeButtonPressed:(UIButton *)sender {

    [UIView animateWithDuration:0.1f animations:^{
        self.likeButton.transform = CGAffineTransformMakeScale(1.2,1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            self.likeButton.transform = CGAffineTransformMakeScale(1.0,1.0);
            [UIView animateWithDuration:0.1f animations:^{
                self.likesLabel.transform = CGAffineTransformMakeScale(1.4,1.4);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1f animations:^{
                    self.likesLabel.transform = CGAffineTransformMakeScale(1.0,1.0);
                }];
            }];
        }];
    }];

    if (sender.isSelected == NO) {
        sender.selected = YES;
        PFRelation *like = [self.currentUser relationForKey:@"likesRelation"];
        [like addObject:self.post];
        self.post.numberOfLikes = @(self.post.numberOfLikes.integerValue + 1);
        self.likesLabel.text = [@(self.likesLabel.text.integerValue + 1) stringValue];
    } else {
        sender.selected = NO;
        PFRelation *like = [self.currentUser relationForKey:@"likesRelation"];
        [like removeObject:self.post];
        self.post.numberOfLikes = @(self.post.numberOfLikes.integerValue - 1);
        self.likesLabel.text = [@(self.likesLabel.text.integerValue - 1) stringValue];
    }

    [self.currentUser saveInBackground];
    [self.post saveInBackground];
    [self.delegate didTapLikeButton:sender onCell:self];
}

- (IBAction)onCommentButtonPressed:(UIButton *)sender {
    [self.delegate didTapCommentButton:sender onCell:self];

    [UIView animateWithDuration:0.1f animations:^{
        self.commentButton.transform = CGAffineTransformMakeScale(1.2,1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            self.commentButton.transform = CGAffineTransformMakeScale(1.0,1.0);
        }];
    }];
}

- (IBAction)onMoreButtonPressed:(UIButton *)sender {

    [self.delegate didTapMoreButton:sender onCell:self];

    [UIView animateWithDuration:0.1f animations:^{
        self.moreButton.transform = CGAffineTransformMakeScale(1.2,1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            self.moreButton.transform = CGAffineTransformMakeScale(1.0,1.0);
        }];
    }];
}





@end
