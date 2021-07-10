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

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *const profileImage;
@property (weak, nonatomic) IBOutlet UITextField *const usernameField;
@property (weak, nonatomic) IBOutlet UITextField *const bioField;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameField.delegate = self;
    self.bioField.delegate = self;
    
    UITapGestureRecognizer *const tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    PFUser *const user = [PFUser currentUser];
    [user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        PFFileObject *const image = user[@"profile_image"];
        NSURL *const url = [NSURL URLWithString:image.url];
        [self.profileImage setImageWithURL:url];
        self.usernameField.text = user.username;
        self.bioField.text = user[@"bio"];
    }];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 3;
    self.profileImage.clipsToBounds = YES;
    
    self.profileImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *const tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(_tapImageGesture:)];
    tapGesture1.numberOfTapsRequired = 1;
    [self.profileImage addGestureRecognizer:tapGesture1];
}

#pragma mark - Private

- (IBAction)_cancelDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)_saveDidTap:(id)sender {
    
    if (![self _isTextFieldEmpty]){
        UIImage *const resizeImage = [self _resizeImage:self.profileImage.image withSize:CGSizeMake(200, 200)];
        NSData *const data = UIImagePNGRepresentation(resizeImage);
        PFFileObject *const image = [PFFileObject fileObjectWithName:@"image.png" data:data];
        PFUser *const user = [PFUser currentUser];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            user[@"profile_image"] = image;
            [user saveInBackground];
        }];
        PFUser.currentUser[@"username"] = self.usernameField.text;
        PFUser.currentUser[@"bio"] = self.bioField.text;
        [PFUser.currentUser saveInBackground];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIImage *)_resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *const resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *const newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)_tapImageGesture: (id)sender {
    
    UIImagePickerController *const imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    UIAlertController *const usernameAlert = [UIAlertController alertControllerWithTitle:@"Choose"
                                                                           message:@""
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *const takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            NSLog(@"Camera 🚫 available so we will use photo library instead");
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    [usernameAlert addAction:takePhotoAction];
    UIAlertAction *cameraRollAction = [UIAlertAction actionWithTitle:@"Camera Roll"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    [usernameAlert addAction:cameraRollAction];
    [self presentViewController:usernameAlert animated:YES completion:^{
    }];
}

-(void)_dismissKeyboard {
    [self.usernameField resignFirstResponder];
    [self.bioField resignFirstResponder];
}

- (BOOL)_isTextFieldEmpty {
    
    BOOL flag = FALSE;
    
    if ([self.usernameField.text isEqual:@""]) {
        UIAlertController *const usernameAlert = [UIAlertController alertControllerWithTitle:@"Title"
                                                                               message:@"Is empty the username"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *const cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
        }];
        [usernameAlert addAction:cancelAction];
        UIAlertAction *const okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        }];
        [usernameAlert addAction:okAction];
        [self presentViewController:usernameAlert animated:YES completion:^{
        }];
        
        flag = TRUE;
    }
    return flag;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *const editedImage = info[UIImagePickerControllerEditedImage];
    self.profileImage.image = editedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
