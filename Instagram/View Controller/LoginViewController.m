//
//  LoginViewController.m
//  Instagram
//
//  Created by jose1009 on 7/6/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *const usernameField;
@property (weak, nonatomic) IBOutlet UITextField *const passwordField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    UITapGestureRecognizer *const tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Private

- (IBAction)_signUpDidTap:(id)sender {
    if (![self _isTextFieldEmpty]){
        [self _registerUser];
    }
}

- (IBAction)_logInDidTap:(id)sender {
    if (![self _isTextFieldEmpty]){
        [self _loginUser];
    }
}

- (void)_registerUser {
    PFUser *const newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"tabBarSegue" sender:nil];
        }
    }];
}

- (void)_loginUser {
    NSString *const username = self.usernameField.text;
    NSString *const password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"tabBarSegue" sender:nil];
        }
    }];
}

-(void)_dismissKeyboard {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
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
    else if ([self.passwordField.text isEqual:@""]){
        UIAlertController *const passwordAlert = [UIAlertController alertControllerWithTitle:@"Title"
                                                                               message:@"Is empty the password"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *const cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
        }];
        [passwordAlert addAction:cancelAction];
        UIAlertAction *const okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        }];
        [passwordAlert addAction:okAction];
        [self presentViewController:passwordAlert animated:YES completion:^{
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

@end
