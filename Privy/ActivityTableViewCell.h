//
//  ActivityTableViewCell.h
//  Privy
//
//  Created by Kellen Pierson on 10/26/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface ActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *fromUserImageView;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@end
