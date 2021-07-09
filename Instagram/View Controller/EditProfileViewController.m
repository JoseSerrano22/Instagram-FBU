//
//  EditProfileViewController.m
//  Instagram
//
//  Created by jose1009 on 7/9/21.
//

#import "EditProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>

#import "Post.h"

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *bioField;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *user = [PFUser currentUser];
    [user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        PFFileObject *image = user[@"profile_image"];
        NSURL *url = [NSURL URLWithString:image.url];
        [self.profileImage setImageWithURL:url];
        self.usernameField.text = user.username;
        self.bioField.text = user[@"bio"];
    }];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds = YES;
    
    self.profileImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapImageGesture:)];
    tapGesture1.numberOfTapsRequired = 1;
    [self.profileImage addGestureRecognizer:tapGesture1];
}
- (IBAction)cancelDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveDidTap:(id)sender {
    UIImage *resizeImage = [self resizeImage:self.profileImage.image withSize:CGSizeMake(400, 400)];
    NSData *data = UIImagePNGRepresentation(resizeImage);
    PFFileObject *image = [PFFileObject fileObjectWithName:@"image.png" data:data];
    PFUser *user = [PFUser currentUser];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        user[@"profile_image"] = image;
        [user saveInBackground];
    }];
    //    PFUser.currentUser[@"profile_image"] = [PFFileObject fileObjectWithData:UIImagePNGRepresentation(self.profileImage.image)];
    PFUser.currentUser[@"username"] = self.usernameField.text;
    PFUser.currentUser[@"bio"] = self.bioField.text;
    [self dismissViewControllerAnimated:YES completion:nil];
    [PFUser.currentUser saveInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)dismissKeyboard {
    [self.usernameField endEditing:YES];
    [self.bioField endEditing:YES];
}


- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void) tapImageGesture: (id)sender {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    UIAlertController *usernameAlert = [UIAlertController alertControllerWithTitle:@"Choose"
                                                                           message:@""
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
    // create a take photo action
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
        // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            NSLog(@"Camera 🚫 available so we will use photo library instead");
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        
    }];
    // add the cancel action to the alertController
    [usernameAlert addAction:takePhotoAction];
    
    // create an OK action
    UIAlertAction *cameraRollAction = [UIAlertAction actionWithTitle:@"Camera Roll"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
        
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        // handle response here.
    }];
    // add the OK action to the alert controller
    [usernameAlert addAction:cameraRollAction];
    
    [self presentViewController:usernameAlert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    //    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    self.profileImage.image = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//- (void)viewDidAppear:(BOOL)animated {
//    PFUser *user = [PFUser currentUser];
//    [user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
//        PFFileObject *image = user[@"profile_image"];
//        NSURL *url = [NSURL URLWithString:image.url];
//        [self.profileImage setImageWithURL:url];
//        self.usernameField.text = user.username;
//        self.bioField.text = user[@"bio"];
//    }];
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
