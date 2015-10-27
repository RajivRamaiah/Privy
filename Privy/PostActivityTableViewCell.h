//
//  PostActivityTableViewCell.h
//  Privy
//
//  Created by Anthony Tran on 10/24/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>



@interface PostActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *activityFromUserImageView;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityFromUserLabel;



@end
