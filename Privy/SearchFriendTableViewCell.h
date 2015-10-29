//
//  SearchFriendTableViewCell.h
//  Privy
//
//  Created by Rajiv Ramaiah on 10/28/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@class User;
@class Post;
@class PostTableViewCell;

@protocol SearchFriendTableViewCellDelegate <NSObject>

- (void)didTapLikeButton:(UIButton *)sender onCell:(PostTableViewCell *)cell;
- (void)didTapCommentButton:(UIButton *)sender onCell:(PostTableViewCell *)cell;

@end

@interface SearchFriendTableViewCell : UITableViewCell

@property (nonatomic, assign) id <SearchFriendTableViewCellDelegate> delegate;
@property (nonatomic) User *currentUser;
@property (nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end
