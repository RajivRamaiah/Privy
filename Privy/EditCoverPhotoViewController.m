//
//  EditCoverPhotoViewController.m
//  Privy
//
//  Created by Kellen Pierson on 10/28/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "EditCoverPhotoViewController.h"
#import "User.h"

@interface EditCoverPhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *coverPhotoImageView;
@property (nonatomic) BOOL didSelectNewCoverPhotoImage;
@property (nonatomic) UIImage *coverPhotoImage;
@property (nonatomic) User *currentUser;

@end

@implementation EditCoverPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];

    self.coverPhotoImageView.layer.cornerRadius = 4;
    self.coverPhotoImageView.file = self.currentUser.coverPhoto;
    [self.coverPhotoImageView loadInBackground];
}

- (IBAction)onCancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSaveButtonPressed:(UIBarButtonItem *)sender {

    if (self.didSelectNewCoverPhotoImage == YES) {
        NSData *imageData = UIImagePNGRepresentation(self.coverPhotoImage);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        self.currentUser.coverPhoto = imageFile;
    }

    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        // TODO: Set needs display on profile view controller
    }];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onEditButtonPressed:(UIButton *)sender {
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

    self.didSelectNewCoverPhotoImage = YES;
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.coverPhotoImage = pickedImage;
    self.coverPhotoImageView.image = pickedImage;
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
