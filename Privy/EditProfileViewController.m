//
//  EditProfileViewController.m
//  Privy
//
//  Created by Kellen Pierson on 10/25/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "EditProfileViewController.h"
#import "User.h"
#import "ProfileViewController.h"

@interface EditProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITextField *fullnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bioTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet PFImageView *profilePhotoImageView;
@property (nonatomic) UIImage *editedProfilePhoto;
@property (nonatomic) BOOL didSelectNewProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *editPhotoButton;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];

    self.profilePhotoImageView.layer.cornerRadius = 4;
    self.editPhotoButton.layer.cornerRadius = 4;

    [PFImageView new];

    self.fullnameTextField.text = self.currentUser.fullname;
    self.usernameTextField.text = self.currentUser.username;
    self.bioTextField.text = self.currentUser.bio;
    self.emailTextField.text = self.currentUser.email;
    self.genderTextField.text = self.currentUser.gender;
    self.profilePhotoImageView.file = self.currentUser.profilePhoto;
    if (!self.currentUser.profilePhoto) {
        self.profilePhotoImageView.image = [UIImage imageNamed:@"profile-image-ph"];
    }
}

- (IBAction)onCancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDoneButtonPressed:(UIBarButtonItem *)sender {

    if (self.didSelectNewProfileImage == YES) {
        NSData *imageData = UIImagePNGRepresentation(self.editedProfilePhoto);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        self.currentUser.profilePhoto = imageFile;
    }

    self.currentUser.fullname = self.fullnameTextField.text;
    self.currentUser.username = self.usernameTextField.text;
    self.currentUser.bio = self.bioTextField.text;
    self.currentUser.email = self.emailTextField.text;
    self.currentUser.gender = self.genderTextField.text;
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        // TODO: Set needs display on profile view controller
    }];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onEditPhotoButtonPressed:(UIButton *)sender {
    [self library];
}

- (void)library {

    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    picker.allowsEditing = YES;
    picker.delegate = self;

    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    self.didSelectNewProfileImage = YES;
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.editedProfilePhoto = pickedImage;
    self.profilePhotoImageView.image = pickedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
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
