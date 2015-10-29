//
//  CameraRootViewController.m
//  Privy
//
//  Created by Rajiv Ramaiah on 10/24/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CameraRootViewController.h"
#import "Post.h"
#import "User.h"
//#import <AVFoundation/AVFoundation.h>

@interface CameraRootViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//@property AVCaptureSession *session;
//@property AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet PFImageView *pfImageView;
@end

@implementation CameraRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [User currentUser];

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Device has no camera..." preferredStyle:UIAlertControllerStyleAlert];
//
//        [self presentViewController:alertController animated:YES completion:^{
//
//        }];;

    }
}
-(void)viewWillAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

- (IBAction)onSharePhotoPressed:(UIButton *)sender {
    Post *newPost = [Post object];
    NSData *data = UIImagePNGRepresentation(self.pfImageView.image);
    PFFile *file = [PFFile fileWithName:@"image.png" data:data];
    newPost.image = file;
    newPost.createdBy = self.currentUser;
    newPost.username = self.currentUser.username;
    newPost.caption = self.captionTextField.text;
    newPost.numberOfLikes = @0;
    newPost.numberOfComments = @0;

    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"yes");
        }
    }];
    [self performSegueWithIdentifier:@"showMain" sender:self];

}
- (IBAction)onTakePhotoPressed:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)takePhoto {

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:picker animated:YES completion:NULL];

}

- (IBAction)selectPhoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:picker animated:YES completion:NULL];


}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.pfImageView.image = chosenImage;

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    PostPhotoViewController *ppvc = segue.destinationViewController;
//    ppvc.image = self.pfImageView.image;
//}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//
//    self.session = [[AVCaptureSession alloc] init];
//    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
//
//    NSError *error;
//    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
//
//    if ([self.session canAddInput:deviceInput]) {
//        [self.session addInput:deviceInput];
//    }
//
//    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
//    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//    CALayer *rootLayer = self.view.layer;
//    [rootLayer setMasksToBounds:YES];
//    CGRect frame = self.frameForCamera.frame;
//
//    [previewLayer setFrame:frame];
//
//    [rootLayer insertSublayer:previewLayer atIndex:0];
//
//    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
//    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
//
//    [self.stillImageOutput setOutputSettings:outputSettings];
//
//    [self.session addOutput:self.stillImageOutput];
//    [self.session startRunning];
//
//
//}
//- (IBAction)onCaptureFramePressed:(UIButton *)sender {
//
//    AVCaptureConnection *videoConnection = nil;
//    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
//        for (AVCaptureInputPort *port in [connection inputPorts]) {
//            if ([port.mediaType isEqual:AVMediaTypeVideo]) {
//                videoConnection = connection;
//                break;
//            }
//        }
//
//        if (videoConnection) {
//            break;
//        }
//    }
//    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//        if (imageDataSampleBuffer != nil) {
//            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//            UIImage *image = [UIImage imageWithData:imageData];
//            self.PFImageView.image = image;
//        }
//    }];
//}

@end