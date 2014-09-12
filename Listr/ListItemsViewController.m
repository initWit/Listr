//
//  ListItemsViewController.m
//  Listr
//
//  Created by Robert Figueras on 9/12/14.
//
//

#import "ListItemsViewController.h"

@interface ListItemsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *listItemsTableView;

@end

@implementation ListItemsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.passedInListName;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
}

#pragma mark TableView Delegate Methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listItemCell"];
    cell.textLabel.text = @"item";
    return cell;
}

@end
