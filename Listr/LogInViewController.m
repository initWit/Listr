//
//  LogInViewController.m
//  Listr
//
//  Created by Robert Figueras on 9/11/14.
//
//

#import "LogInViewController.h"
#import <Parse/Parse.h>


@interface LogInViewController () <UITextFieldDelegate>
@property BOOL didScroll;
@end

@implementation LogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;

}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (IBAction)login:(id)sender {

    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Make sure you enter all information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [myAlert show];
    }
    else {

        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {

            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
            }
            else {
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
                [currentInstallation saveInBackground];

                [self.navigationController popToRootViewControllerAnimated:YES];
            }

        }];

    }
}


#pragma mark - text field keyboard methods

#define kScrollHeight 120
#define kCenterY 284

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self animateViewToCenterAndDismissKeyboard];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender
{
    [self animateViewToCenterAndDismissKeyboard];
}


-(void) animateViewToCenterAndDismissKeyboard
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];

    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.center.x, ([[UIScreen mainScreen] bounds].size.height/2));
    }];
    self.didScroll = NO;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger tagValue = textField.tag;
    if (tagValue > 0 && self.didScroll == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 200);
        }];
    }
    self.didScroll = YES;
}




@end
