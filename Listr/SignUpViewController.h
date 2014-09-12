//
//  SignUpViewController.h
//  Listr
//
//  Created by Robert Figueras on 9/11/14.
//
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
- (IBAction)signUp:(id)sender;
@end
