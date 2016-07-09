//
//  BrokerAccountTableViewController.m
//  HBXMobile
//
//  Created by David Boyd on 7/5/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "BrokerAccountTableViewController.h"
#import "MGSwipeButton.h"

@interface BrokerAccountTableViewController ()

@end

@implementation BrokerAccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    /*
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonTapped:)];
//    self.navigationController.navigationBar.topItem.rightBarButtonItem = searchButton;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
 //   self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
 //   [self.searchController.searchBar sizeToFit];

    
//    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
//    self.searchController.searchBar.showsCancelButton = TRUE;
//    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.searchController.searchBar.delegate = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
//    self.tableView.tableHeaderView = self.searchController.searchBar;
self.navigationItem.titleView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return  self.filteredProducts.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier2 = @"prototypeCell";
    
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
//    MGSwipeTableCell *cell = (MGSwipeTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
    if ( cell == nil )
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];

    cell.delegate = self;
    cell.leftSwipeSettings.transition = MGSwipeTransition3D;
    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    
    cell.employerLabel.text = @"HERE";
    return cell;
    
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings;
{
    
    //    TestData * data = [tests objectAtIndex:[_tableView indexPathForCell:cell].row];
    //    swipeSettings.transition = data.transition;
    
    //    if (direction == MGSwipeDirectionLeftToRight) {
    //    expansionSettings.buttonIndex = 1; //data.leftExpandableIndex;
    //        expansionSettings.fillOnTrigger = NO;
    //    return [self createLeftButtons:2];//data.leftButtonsCount];
    //    }
    //    else {
    
    expansionSettings.buttonIndex = 1;//data.rightExpandableIndex;
    expansionSettings.fillOnTrigger = NO;
    return [self createLeftButtons:4];//data.rightButtonsCount];
}

-(NSArray *) createLeftButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    UIColor * colors[4] = {[UIColor clearColor],
        [UIColor clearColor],
        [UIColor clearColor],[UIColor clearColor]};
    UIImage * icons[4] = {[UIImage imageNamed:@"phoneCirclelightBlue.png"], [UIImage imageNamed:@"chatWithCircleLightBlue.png"], [UIImage imageNamed:@"markerWithCircleLightBlue.png"], [UIImage imageNamed:@"emailWithCirclelightBlue.png"]};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:@"" icon:icons[i] backgroundColor:colors[i] padding:10 callback:^BOOL(MGSwipeTableCell * sender){
            NSLog(@"Convenience callback received (left).");
            if (i == 0)
            {
//                [self phoneEmployer:sender];
            }
            
            if (i == 1)
            {
//                [self smsEmployer:sender];
            }
            
            if (i == 2)
            {
//                [self showDirections:sender];
            }
            
            if (i == 3)
            {
 //               [self emailEmployer:sender];
            }
            
            return YES;
        }];
        [result addObject:button];
    }
    return result;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end
