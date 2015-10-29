//
//  ChangePasswordViewController.m
//  Privy
//
//  Created by Kellen Pierson on 10/27/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import "ChangePasswordViewController.h"
#import "User.h"

@interface ChangePasswordViewController ()

@property (nonatomic) User *currentUser;
//@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
//@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];
}

- (IBAction)onCancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onResetPasswordButtonPressed:(UIButton *)sender {

    [User requestPasswordResetForEmailInBackground:self.currentUser.email];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Password reset requested" message:[NSString stringWithFormat:@"An email has been sent to %@ with instructions on how to reset your password!", self.currentUser.email] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    [alert addAction:okay];
    [self presentViewController:alert animated:YES completion:nil];
}

//- (IBAction)onSaveButtonPressed:(UIBarButtonItem *)sender {
//
//    if (self.passwordAgainTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid password" message:@"Please enter your new password into both text fields to continue." preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            self.passwordTextField.text = @"";
//            self.passwordAgainTextField.text = @"";
//            [self.passwordTextField becomeFirstResponder];
//        }];
//
//        [alert addAction:okay];
//        [self presentViewController:alert animated:YES completion:nil];
//    } else if ([self.passwordTextField.text isEqualToString:self.passwordAgainTextField.text]) {
//        NSString *username = self.currentUser.username;
//        self.currentUser.password = self.passwordAgainTextField.text;
//        [self.currentUser saveInBackground];
//        [User logInWithUsernameInBackground:username password:self.passwordAgainTextField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }];
//    } else {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Passwords don't match" message:@"Please make sure you enter the same new password in both text fields." preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            self.passwordTextField.text = @"";
//            self.passwordAgainTextField.text = @"";
//            [self.passwordTextField becomeFirstResponder];
//        }];
//
//        [alert addAction:okay];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
