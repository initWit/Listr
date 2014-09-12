//
//  ListViewController.m
//  Listr
//
//  Created by Robert Figueras on 9/11/14.
//
//

#import "ListViewController.h"
#import <Parse/Parse.h>
#import "AddNewListViewController.h"
#import "ListItemsViewController.h"

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property NSMutableArray *listsArray;
@end

@implementation ListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.listsArray = [NSMutableArray array];

    if (![PFUser currentUser])
    {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    PFQuery *query = [PFQuery queryWithClassName:@"Lists"];
    [query whereKey:@"parent" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            [self.listsArray removeAllObjects];

            for (PFObject *object in objects)
            {
                [self.listsArray addObject:object];
            }
            [self.listTableView reloadData];
        }
        else
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];


}

#pragma mark TableView Delegate Methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];

    PFObject *currentListObject = [self.listsArray objectAtIndex:indexPath.row];

    cell.textLabel.text = currentListObject[@"listName"];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d"];
    cell.detailTextLabel.text = [dateFormat stringFromDate:currentListObject.createdAt];

    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showListItemsSegue"])
    {
        ListItemsViewController *listItemsVC = segue.destinationViewController;
        PFObject *selectedListObject = [self.listsArray objectAtIndex:self.listTableView.indexPathForSelectedRow.row];
        listItemsVC.passedInListName = selectedListObject[@"listName"];
    }
}


@end
