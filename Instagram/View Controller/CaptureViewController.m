//
//  CaptureViewController.m
//  Instagram
//
//  Created by jose1009 on 7/6/21.
//

#import "CaptureViewController.h"
#import "FeedViewController.h"
#import "Parse/Parse.h"
#import "PFObject.h"
#import "AppDelegate.h"
#import "Post.h"

@interface CaptureViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation CaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.descriptionTextView.delegate = self;
    self.postImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(_tapImageGesture:)];
    tapGesture1.numberOfTapsRequired = 1;
    [self.postImage addGestureRecognizer:tapGesture1];
}

#pragma mark - Private

- (IBAction)_cancelDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)_postDidTap:(id)sender {
    UIImage *resizeImage = [self _resizeImage:self.postImage.image withSize:CGSizeMake(400, 400)];
    [Post postUserImage: resizeImage withCaption:self.descriptionTextView.text withCompletion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)_resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)_tapImageGesture: (id)sender {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    UIAlertController *usernameAlert = [UIAlertController alertControllerWithTitle:@"Choose"
                                                                           message:@""
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo"
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.postImage.image = editedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write a caption..."]){
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write a caption...";
    }
    [textView resignFirstResponder];
}

@end
