//
//  SearchCollectionViewCell.h
//  Privy
//
//  Created by Kellen Pierson on 10/26/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@class User;

@interface SearchCollectionViewCell : UICollectionViewCell

@property (nonatomic) User *user;
@property (weak, nonatomic) IBOutlet PFImageView *pfImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

- (void)loadCell;

@end
