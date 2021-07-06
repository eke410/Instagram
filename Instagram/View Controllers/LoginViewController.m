//
//  LoginViewController.m
//  Instagram
//
//  Created by Elizabeth Ke on 7/6/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) UIAlertController *emptyAlert;
@property (strong, nonatomic) UIAlertController *registerErrorAlert;
@property (strong, nonatomic) UIAlertController *loginErrorAlert;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.emptyAlert = [UIAlertController alertControllerWithTitle:@"Required field empty" message:@"Please try again." preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
     }];
    [self.emptyAlert addAction:okAction];
    
    self.registerErrorAlert = [UIAlertController alertControllerWithTitle:@"Error registering user" message:@"Please try again." preferredStyle:(UIAlertControllerStyleAlert)];
    [self.registerErrorAlert addAction:okAction];
    
    self.loginErrorAlert = [UIAlertController alertControllerWithTitle:@"Error logging in user" message:@"Please try again." preferredStyle:(UIAlertControllerStyleAlert)];
    [self.loginErrorAlert addAction:okAction];
}

- (IBAction)loginUser:(id)sender {
    
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        [self presentViewController:self.emptyAlert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    } else {
        NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error != nil) {
                NSLog(@"User log in failed: %@", error.localizedDescription);
                [self presentViewController:self.loginErrorAlert animated:YES completion:^{
                    // optional code for what happens after the alert controller has finished presenting
                }];
            } else {
                NSLog(@"User logged in successfully");
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
        }];
    }
}


- (IBAction)registerUser:(id)sender {
    
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        [self presentViewController:self.emptyAlert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    } else {
        // initialize a user object
        PFUser *newUser = [PFUser user];
        
        // set user properties
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self presentViewController:self.registerErrorAlert animated:YES completion:^{
                    // optional code for what happens after the alert controller has finished presenting
                }];
            } else {
                NSLog(@"User registered successfully");
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
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
