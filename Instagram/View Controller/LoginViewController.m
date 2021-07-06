//
//  LoginViewController.m
//  Instagram
//
//  Created by jose1009 on 7/6/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)signUpDidTap:(id)sender {
    if (![self isTextFieldEmpty]){
        [self registerUser];
    }
}

- (IBAction)logInDidTap:(id)sender {
    if (![self isTextFieldEmpty]){
        [self loginUser];
    }
}

- (void)registerUser {
    PFUser *newUser = [PFUser user];

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

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            [self performSegueWithIdentifier:@"tabBarSegue" sender:nil];
        }
    }];
}

-(void)dismissKeyboard {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)isTextFieldEmpty {
    
    BOOL flag = FALSE;
    
    if ([self.usernameField.text isEqual:@""]) {
        UIAlertController *usernameAlert = [UIAlertController alertControllerWithTitle:@"Title"
                                                                       message:@"Is empty the username"
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        // create a cancel action
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
            // handle cancel response here. Doing nothing will dismiss the view.
        }];
        // add the cancel action to the alertController
        [usernameAlert addAction:cancelAction];
        
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
            // handle response here.
        }];
        // add the OK action to the alert controller
        [usernameAlert addAction:okAction];
        
        [self presentViewController:usernameAlert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
        
        flag = TRUE;
        
    }
    else if ([self.passwordField.text isEqual:@""]){
        UIAlertController *passwordAlert = [UIAlertController alertControllerWithTitle:@"Title"
                                                                       message:@"Is empty the password"
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        // create a cancel action
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
            // handle cancel response here. Doing nothing will dismiss the view.
        }];
        // add the cancel action to the alertController
        [passwordAlert addAction:cancelAction];
        
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
            // handle response here.
        }];
        // add the OK action to the alert controller
        [passwordAlert addAction:okAction];
        [self presentViewController:passwordAlert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
        flag = TRUE;
    }
    
    return flag;
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
