//
//  AddNewListViewController.m
//  Listr
//
//  Created by Robert Figueras on 9/12/14.
//
//

#import "AddNewListViewController.h"
#import <Parse/Parse.h>


@interface AddNewListViewController ()
@property (strong, nonatomic) IBOutlet UITextField *listNameTextField;
@end

@implementation AddNewListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark IBAction Methods

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}



- (IBAction)addButtonTapped:(id)sender
{
    if (self.listNameTextField.text.length > 0)
    {
        self.listName = self.listNameTextField.text;
        [self createNewList:self.listNameTextField.text];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



- (void)createNewList:(NSString *)listName
{
    PFObject *list = [PFObject objectWithClassName:@"Lists"];
    list[@"parent"] = [PFUser currentUser];
    list[@"listName"] = listName;
    [list saveInBackground];
}

@end
