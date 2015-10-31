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

- (IBAction)onLoginButtonPressed:(UIButton *)sender {

    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;

    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];

    if (username.length < 4 || password.length < 4){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Insufficient Username or Password length." message:@"Please make sure your username is over 4 characters and your password is over six characters!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // do something
        }];

        [alert addAction:okay];
        [self presentViewController:alert animated:YES completion:nil];

    } else {
        [User logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {

            if(user != nil){
                NSLog(@"Successful Login");
                self.delegate.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *vc= [loginStoryboard instantiateViewControllerWithIdentifier:@"main"];
                [self.delegate.window setRootViewController:vc];
                [self.delegate.window makeKeyAndVisible];
            }
            else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // do something
                }];

                [alert addAction:okay];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}


@end
