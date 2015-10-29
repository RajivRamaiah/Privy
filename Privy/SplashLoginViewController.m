//
//  SplashLoginViewController.m
//  Privy
//
//  Created by Rajiv Ramaiah on 10/23/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "SplashLoginViewController.h"

@interface SplashLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SplashLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginButton.layer.borderWidth = 2;
    self.loginButton.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (IBAction)onLoginPressed:(UIButton *)sender {
    
}

- (IBAction)onSignUpPressed:(UIButton *)sender {

}


@end
