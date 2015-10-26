//
//  SearchProfileCollectionViewCell.h
//  Privy
//
//  Created by Rajiv Ramaiah on 10/25/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface SearchProfileCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPosts;
@property (weak, nonatomic) IBOutlet UILabel *numberOfConnections;

@property (weak, nonatomic) IBOutlet PFImageView *pfImageView;


@end
