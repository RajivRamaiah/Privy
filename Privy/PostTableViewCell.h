//
//  PostTableViewCell.h
//  Privy
//
//  Created by Kellen Pierson on 10/23/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@class User;
@class Post;
@class PostTableViewCell;

@protocol PostTableViewCellDelegate <NSObject>

- (void)didTapLikeButton:(UIButton *)sender onCell:(PostTableViewCell *)cell;
- (void)didTapCommentButton:(UIButton *)sender onCell:(PostTableViewCell *)cell;
- (void)didTapMoreButton:(UIButton *)sender onCell:(PostTableViewCell *)cell;

@end

@interface PostTableViewCell : UITableViewCell

@property (nonatomic, assign) id <PostTableViewCellDelegate> delegate;
@property (nonatomic) User *currentUser;
@property (nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;

@end
