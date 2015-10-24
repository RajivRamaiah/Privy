//
//  LoginViewController.m
//  Privy
//
//  Created by Rajiv Ramaiah on 10/23/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property AppDelegate *delegate;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = [[UIApplication sharedApplication] delegate];
//    if ([User currentUser]){
//        self.user = [User currentUser];
//    }
    // Do any additional setup after loading the view.
}
- (IBAction)onBackButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)onLoginButtonPressed:(UIButton *)sender {

    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;

    if (username.length < 4 || password.length < 6){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Insufficient Username or Password length." message:@"Please make sure your username is over 4 characters and your password is over six characters!" preferredStyle:UIAlertControllerStyleAlert];

        [self presentViewController:alert animated:YES completion:^{

        }];
    }

    else{
        [User logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {

            if(user != nil){
                NSLog(@"Successful Login");
                self.delegate.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *vc= [loginStoryboard instantiateViewControllerWithIdentifier:@"main"];
                [self.delegate.window setRootViewController:vc];
                [self.delegate.window makeKeyAndVisible];
            }
            else
                NSLog(@"Login Failed");

        }];
    }

}


@end
