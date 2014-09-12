//
//  SignUpViewController.m
//  Listr
//
//  Created by Robert Figueras on 9/11/14.
//
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "GravatarHelper.h"

@interface SignUpViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property BOOL didScroll;
@property (strong, nonatomic) IBOutlet UIButton *profileImageButton;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property UIImagePickerController *imagePicker;
@property PFFile *capturedImage;
@property UIImage *imageForScaling;
@end

@implementation SignUpViewController

#define kScrollHeight 120
#define kCenterY 284


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.didScroll = NO;
    self.navigationController.navigationBarHidden = NO;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    self.imageForScaling = [[UIImage alloc] init];
}

- (IBAction)signUp:(id)sender {

    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (self.emailField.text.length>0 && self.profileImageView.image == nil) {
        dispatch_queue_t myQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
        dispatch_async(myQueue, ^{
            NSData *gravData = [NSData dataWithContentsOfURL:[GravatarHelper getGravatarURL:self.emailField.text]];
            self.capturedImage = [PFFile fileWithData:gravData];
            UIImage *gravImage = [UIImage imageWithData:gravData];
            [self setProfileImageToGravatarImage:gravImage];
        });
    }

    if ([username length] == 0 || [password length] == 0 || [email length] == 0 || self.profileImageView.image == nil) {
        UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Make sure you enter all information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [myAlert show];
    }
    else
    {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
        newUser[@"profilePicFull"] = self.capturedImage;

        CGSize scaleSize = CGSizeMake(25, 25);
        UIGraphicsBeginImageContextWithOptions(scaleSize, NO, 0.0);
        [self.imageForScaling drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
        UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        NSData* data = UIImagePNGRepresentation(resizedImage);
        newUser[@"profileIconSmall"] = [PFFile fileWithData:data];

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error)
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
            }
            else
            {
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
                [currentInstallation saveInBackground];

                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}


#pragma mark - text field keyboard methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self animateViewToCenterAndDismissKeyboard];

    if (self.emailField.text.length>0 && self.profileImageView.image == nil) {
        dispatch_queue_t myQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
        dispatch_async(myQueue, ^{
            NSData *gravData = [NSData dataWithContentsOfURL:[GravatarHelper getGravatarURL:self.emailField.text]];
            self.capturedImage = [PFFile fileWithData:gravData];
            UIImage *gravImage = [UIImage imageWithData:gravData];
            [self setProfileImageToGravatarImage:gravImage];
        });
    }

    return YES;
}


- (IBAction)backgroundTapped:(id)sender
{
    [self animateViewToCenterAndDismissKeyboard];

    if (self.emailField.text.length>0 && self.profileImageView.image == nil) {
        dispatch_queue_t myQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
        dispatch_async(myQueue, ^{
            NSData *gravData = [NSData dataWithContentsOfURL:[GravatarHelper getGravatarURL:self.emailField.text]];
            self.capturedImage = [PFFile fileWithData:gravData];
            UIImage *gravImage = [UIImage imageWithData:gravData];
            [self setProfileImageToGravatarImage:gravImage];
        });
    }
}


- (void) setProfileImageToGravatarImage: (UIImage *)gravatarImage
{
    dispatch_async(dispatch_get_main_queue(), ^{

        self.profileImageView.image = gravatarImage;
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.borderWidth = 0;
        self.imageForScaling = gravatarImage;

    });
}


-(void) animateViewToCenterAndDismissKeyboard
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.emailField resignFirstResponder];

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


#pragma mark - ImagePicker methods

- (IBAction)showProfileImagePicker:(id)sender {
    [self showImagePicker];
}


- (void) showImagePicker
{
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    //    self.imagePicker.videoMaximumDuration = 10; // *** limit the lenghth of the videos (10 sec)

    // *** check to see if a camera source is available; if not, show the photo library instead ***/

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    }
    else
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    }

    [self presentViewController:self.imagePicker animated:NO completion:nil];
}

- (void) showPhotoLibrary
{
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;

    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];

    [self presentViewController:self.imagePicker animated:NO completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.profileImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;

    NSData *imageData = UIImageJPEGRepresentation(self.profileImageView.image, 0.0);
    self.capturedImage = [PFFile fileWithData:imageData];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - action sheet


- (IBAction)showNormalActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add a pic to your profile"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles:@"Take a Photo", @"Choose a Photo", @"Use a Gravatar", nil];

    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) // take a photo
    {
        [self showImagePicker];
    }
    if (buttonIndex == 1) // choose a photo
    {
        [self showPhotoLibrary];
    }
    if (buttonIndex == 2) // use gravatar
    {
        dispatch_queue_t myQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
        dispatch_async(myQueue, ^{
            NSData *gravData = [NSData dataWithContentsOfURL:[GravatarHelper getGravatarURL:self.emailField.text]];
            self.capturedImage = [PFFile fileWithData:gravData];
            UIImage *gravImage = [UIImage imageWithData:gravData];
            [self setProfileImageToGravatarImage:gravImage];
        });
    }
}

@end
