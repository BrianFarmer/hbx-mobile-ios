//
//  brokerSearchResultTableViewController.m
//  HBXMobile
//
//  Created by David Boyd on 7/8/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "brokerSearchResultTableViewController.h"

#import "brokerPlanDetailViewController.h"

@interface brokerSearchResultTableViewController ()

@end

@implementation brokerSearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    sections = [[NSArray alloc] initWithObjects: NSLocalizedString(@"table-section-open-enrollment", @"OPEN ENROLLMENT IN PROGRESS"), NSLocalizedString(@"table-section-renewals-in-progress", @"RENEWALS IN PROGRESS"), NSLocalizedString(@"table-section-all-others", @"ALL OTHER CLIENTS"), nil];

    if (!expandedSections)
        expandedSections = [[NSMutableIndexSet alloc] init];

    [expandedSections addIndex:0];
    [expandedSections addIndex:1];
    [expandedSections addIndex:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.filteredProducts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([expandedSections containsIndex:section])
        return [[self.filteredProducts objectAtIndex:section] count];
    
    return 0; // only top row showing
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings;
{
    expansionSettings.buttonIndex = 1;
    expansionSettings.fillOnTrigger = NO;
    return [self createLeftButtons:4];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    
    // Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
    headerView.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;//[UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    headerView.tag = section;
    
    // Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 0, tableView.frame.size.width - 5, 34);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor darkGrayColor];
    headerLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16.0];
    headerLabel.text = [sections objectAtIndex:section];///  @"This is the custom header view";
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // Add the label to the header view
    [headerView addSubview:headerLabel];
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [headerView addGestureRecognizer:recognizer];
    
    return headerView;
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

- (void)handleTap:(UITapGestureRecognizer *)sender {
    UIView *pHeaderView = (UIView*)sender.view;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
    
    [self tableView:self.tableView didSelectHeader:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier2 = @"prototypeCell";
    
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    
    brokerEmployersData *ttype = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if ( cell == nil )
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];

    cell.frame = CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height);

    if (cell.alertButton.currentBackgroundImage == nil)
    {
        cell.alertButton.backgroundColor = [UIColor whiteColor];
        UIImage *image = [UIImage imageNamed:@"alert2.png"];
        [cell.alertButton setBackgroundImage:image forState:UIControlStateNormal];
    }

    cell.alertButton.frame = CGRectMake(cell.frame.size.width - 20, cell.frame.size.height/2-8, 16, 16);
    cell.lblDaysLeftText.frame = CGRectMake(tableView.frame.size.width - cell.lblDaysLeftText.frame.size.width - 25, cell.lblDaysLeftText.frame.origin.y, cell.lblDaysLeftText.frame.size.width, cell.lblDaysLeftText.frame.size.height);
    cell.daysleftLabel.frame = CGRectMake(cell.lblDaysLeftText.frame.origin.x - cell.daysleftLabel.frame.size.width - 4, cell.daysleftLabel.frame.origin.y, cell.daysleftLabel.frame.size.width, cell.daysleftLabel.frame.size.height);
    cell.lblEmployeesNeeded.frame = CGRectMake(cell.daysleftLabel.frame.origin.x - cell.lblEmployeesNeeded.frame.size.width, cell.lblEmployeesNeeded.frame.origin.y, cell.lblEmployeesNeeded.frame.size.width, cell.lblEmployeesNeeded.frame.size.height);
    cell.employeesLabel.frame = CGRectMake(cell.lblEmployeesNeeded.frame.origin.x - cell.employeesLabel.frame.size.width - 5, cell.employeesLabel.frame.origin.y, cell.employeesLabel.frame.size.width, cell.employeesLabel.frame.size.height);
    cell.employerLabel.frame = CGRectMake(cell.employerLabel.frame.origin.x, cell.employerLabel.frame.origin.y, cell.employeesLabel.frame.origin.x - 10, cell.employerLabel.frame.size.height);

    cell.delegate = self;
    cell.leftSwipeSettings.transition = MGSwipeTransition3D;
    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    
    cell.allowsMultipleSwipe = NO;
    cell.delegate = self;
    cell.daysleftLabel.textColor = [UIColor darkGrayColor];
    cell.lblDaysLeftText.text = @"DAYS LEFT";
    
    cell.employerLabel.text = ttype.companyName;
    cell.employeesLabel.text = ttype.employeesEnrolled;
    cell.alertButton.hidden = TRUE;
    
    NSDate *today = [NSDate date];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"MM-dd-yyyy"];
    
    cell.leftColor.hidden = TRUE;

    
    if (ttype.status == NEEDS_ATTENTION)
    {
        cell.lblEmployeesNeeded.text = @"EMPLOYEES NEEDED";
        cell.daysleftLabel.textColor = [UIColor redColor];
        cell.alertButton.hidden = FALSE;
        cell.leftColor.hidden = FALSE;
    }
    
    if (ttype.status == OPEN_ENROLLMENT_MET)
        cell.lblEmployeesNeeded.text = [NSString stringWithFormat:@"OF %@ ENROLLED", ttype.employeesTotal];
    
    if (ttype.status == RENEWAL_IN_PROGRESS || ttype.status == NO_ACTION_REQUIRED)
    {
        cell.lblEmployeesNeeded.text = @"PLAN\nYEAR";
        
        NSDate *dateFromString = [f dateFromString:ttype.planYear];
        [f setDateFormat:@"MMM dd"];
        NSString *stringFromDate = [f stringFromDate:dateFromString];
        cell.employeesLabel.text = stringFromDate;
        
        int width = ceil([cell.employeesLabel.text sizeWithAttributes:@{NSFontAttributeName: cell.employeesLabel.font}].width);
        
        cell.employeesLabel.frame = CGRectMake(cell.employeesLabel.frame.origin.x, cell.employeesLabel.frame.origin.y, width, 20);
        cell.lblEmployeesNeeded.frame = CGRectMake(cell.employeesLabel.frame.origin.x + width + 2, cell.lblEmployeesNeeded.frame.origin.y, cell.lblEmployeesNeeded.frame.size.width, cell.lblEmployeesNeeded.frame.size.height);
        
        cell.lblEmployeesNeeded.text = @"PLAN\nYEAR";
    }
    
    if (ttype.status == NO_ACTION_REQUIRED)
    {
        cell.lblDaysLeftText.text = @"";
        cell.daysleftLabel.text = @"";
    }
    else
    {
        [f setDateFormat:@"MM-dd-yyyy"];
        NSDate *endDate = [f dateFromString:ttype.open_enrollment_ends];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:today
                                                              toDate:endDate
                                                             options:NSCalendarWrapComponents];
        cell.daysleftLabel.text = [NSString stringWithFormat:@"%ld", (long)[components day]];
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectHeader:(NSIndexPath *)indexPath
{
    if (!indexPath.row)
    {
        // only first row toggles exapand/collapse
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSInteger section = indexPath.section;
        BOOL currentlyExpanded = [expandedSections containsIndex:section];
        NSInteger rows;
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        
        if (currentlyExpanded)
        {
            rows = [self tableView:tableView numberOfRowsInSection:section];
            [expandedSections removeIndex:section];
        }
        else
        {
            [expandedSections addIndex:section];
            rows = [self tableView:tableView numberOfRowsInSection:section];
        }
        
        for (int i=0; i<rows; i++) ///(DB) modified this from i=1 to i=0 to account for viewHeader being clicked and not first row.
        {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                           inSection:section];
            [tmpArray addObject:tmpIndexPath];
        }
        
        if (currentlyExpanded)
        {
            [tableView deleteRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationTop];
            
            //              cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
        }
        else
        {
            [tableView insertRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationTop];
            //            cell.accessoryView =  [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
        }
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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
    [_delegate didSelectSearchItem:[[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return;
}
@end
