//
//  SignUpViewController.m
//  Privy
//
//  Created by Rajiv Ramaiah on 10/23/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "User.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property AppDelegate *delegate;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = [[UIApplication sharedApplication] delegate];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBackButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)onSignUpButtonPressed:(UIButton *)sender {

    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *email = self.emailTextField.text;

    if (username.length < 4 || password.length < 6 || email.length < 8){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Insufficient Username, Password, or Email length." message:@"Please make sure your username is over 4 characters, your password is over 6 characters, and your email is valid!" preferredStyle:UIAlertControllerStyleAlert];

        [self presentViewController:alert animated:YES completion:^{

        }];
    }
    else{
        User *newUser = [User new];

        newUser.username = username;
        newUser.password = password;
        newUser.email = email;

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.description);
            }
            else{
                NSLog(@"Success");
                self.delegate.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *vc= [loginStoryboard instantiateViewControllerWithIdentifier:@"main"];
                [self.delegate.window setRootViewController:vc];
                [self.delegate.window makeKeyAndVisible];
            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
