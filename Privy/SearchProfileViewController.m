//
//  SearchProfileViewController.m
//  Privy
//
//  Created by Rajiv Ramaiah on 10/25/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "SearchProfileViewController.h"
#import "User.h"

@interface SearchProfileViewController ()

@end

@implementation SearchProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.user.username);
}


@end
