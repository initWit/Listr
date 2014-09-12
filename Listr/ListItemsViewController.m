//
//  ListItemsViewController.m
//  Listr
//
//  Created by Robert Figueras on 9/12/14.
//
//

#import "ListItemsViewController.h"
#import <Parse/Parse.h>
#import "ListItemTableViewCell.h"

@interface ListItemsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listItemsTableView;
@property NSMutableArray *listItemsArray;
@end

@implementation ListItemsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.listItemsArray = [NSMutableArray array];
    self.title = self.passedInListObject[@"listName"];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    PFQuery *query = [PFQuery queryWithClassName:@"ListItems"];
    [query whereKey:@"parent" equalTo:self.passedInListObject];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             [self.listItemsArray removeAllObjects];

             for (PFObject *object in objects)
             {
                 [self.listItemsArray addObject:object];
             }
             [self.listItemsTableView reloadData];
         }
         else
         {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];

    
}

#pragma mark TableView Delegate Methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.listItemsArray.count + 1);
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listItemCell"];
    //cell.listItemDescriptionTextField.text = @"Hey now";
    //cell.textLabel.text = [self.listItemsArray objectAtIndex:indexPath.row][@"listItemDescription"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"YOU SELECTED ROW: %d",indexPath.row);

}


- (IBAction)listItemTableViewWasTapped:(id)sender
{
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ListItemTableViewCell *editCell = (ListItemTableViewCell *)[self.listItemsTableView cellForRowAtIndexPath:cellIndexPath];
    [editCell.listItemDescriptionTextField becomeFirstResponder];
    editCell.listItemDescriptionTextField.placeholder = @"Enter an item";
    editCell.checkMarkToggleButton.alpha = 1.0;

}



@end
