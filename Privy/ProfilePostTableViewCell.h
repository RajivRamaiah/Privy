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
@class ProfilePostTableViewCell;

@protocol ProfilePostTableViewCellDelegate <NSObject>

- (void)didTapLikeButton:(UIButton *)sender onCell:(ProfilePostTableViewCell *)cell;
- (void)didTapCommentButton:(UIButton *)sender onCell:(ProfilePostTableViewCell *)cell;
- (void)didTapMoreButton:(UIButton *)sender onCell:(ProfilePostTableViewCell *)cell;

@end

@interface ProfilePostTableViewCell : UITableViewCell

@property (nonatomic, assign) id <ProfilePostTableViewCellDelegate> delegate;

@property (nonatomic) User *user;
@property (nonatomic) User *currentUser;
@property (nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCommentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;

- (void)loadCell;

@end
