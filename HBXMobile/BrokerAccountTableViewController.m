//
//  BrokerAccountTableViewController.m
//  HBXMobile
//
//  Created by David Boyd on 6/5/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "BrokerAccountTableViewController.h"
#import "Settings.h"
#import "MGSwipeButton.h"
#import "brokerEmployersData.h"
#import "brokerPlanDetailViewController.h"
#import "popupMessagebox.h"

@interface BrokerAccountTableViewController ()

@end

@implementation BrokerAccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBarHidden = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    brokerSearchResultTableViewController *_resultsTableController = [[brokerSearchResultTableViewController alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:_resultsTableController];
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.showsCancelButton = FALSE;
    _resultsTableController.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    self.definesPresentationContext = YES;
    
    searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonTapped:)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = searchButton;

    if (!expandedSections)
        expandedSections = [[NSMutableIndexSet alloc] init];
    
    sections = [[NSArray alloc] initWithObjects: NSLocalizedString(@"table-section-open-enrollment", @"OPEN ENROLLMENT IN PROGRESS"), NSLocalizedString(@"table-section-renewals-in-progress", @"RENEWALS IN PROGRESS"), NSLocalizedString(@"table-section-all-others", @"ALL OTHER CLIENTS"), nil];

    listOfCompanies = [[NSMutableArray alloc] init];
    open_enrollment = [[NSMutableArray alloc] init];
    renewals = [[NSMutableArray alloc] init];
    all_others = [[NSMutableArray alloc] init];

    [self processData];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)willDismissSearchController:(UISearchController *)searchController {
        self.tableView.frame = CGRectMake(0, 64, self.tableView.frame.size.width, self.tableView.frame.size.height);
}

- (void)searchButtonTapped:(id)sender {
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.searchBar.hidden = FALSE;
    self.navigationItem.rightBarButtonItem = nil;

    [self.searchController.searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchController.searchBar.hidden = TRUE;
    self.navigationController.navigationBar.topItem.rightBarButtonItem = searchButton;
}

-(void)processData
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    NSData *data;
    [listOfCompanies removeAllObjects];
    [open_enrollment removeAllObjects];
    [renewals removeAllObjects];
    [all_others removeAllObjects];
    clients_needing_immediate_attention = 0;
    
    NSLog(@"%li", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"whichServer"] );
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"whichServer"] intValue] == 1003 || [[[NSUserDefaults standardUserDefaults] stringForKey:@"whichServer"] intValue] == 0)
    {
        NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/dchealthlink/HBX-mobile-app-APIs/feature/multiple-contacts/enroll/broker/employers_list/response/example.json"];
        //   NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/dchealthlink/HBX-mobile-app-APIs/master/enroll/broker/employers_list/response/example.json"];
        data = [NSData dataWithContentsOfURL:url];
    }
    else
        data = [_jsonData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strData);
    
    NSError *error = nil;
    
    if (data != nil)
    {
        subscriberPlans = nil;
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        subscriberPlans = [dictionary valueForKeyPath:@"broker_clients"];
    }
    
    [self processBuckets];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 600)
        [self setIntroHeader:13];
    else
        [self setIntroHeader:12];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
}

-(void)setIntroHeader:(int)iFontsize
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.tableView.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *labelView = [[UILabel alloc] initWithFrame:headerView.bounds];
    labelView.numberOfLines = 2;
    labelView.lineBreakMode = NSLineBreakByWordWrapping;
    labelView.textAlignment = NSTextAlignmentCenter;
    labelView.font = [UIFont fontWithName:@"Roboto-Regular" size:iFontsize];
    labelView.textColor = [UIColor darkGrayColor];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    NSString *sPrefix;
    
    if(hour >= 0 && hour < 12)
        sPrefix = NSLocalizedString(@"GOOD_MORNING", @"Good morning");
    else if(hour >= 12 && hour < 17)
        sPrefix = NSLocalizedString(@"GOOD_AFTERNOON", @"Good afternoon"); //@"Good afternoon";
    else if(hour >= 17)
        sPrefix = NSLocalizedString(@"GOOD_EVENING", @"Good evening"); //@"Good evening";
    
    Settings *obj=[Settings getInstance];
    
    NSString *temp2 = [NSString stringWithFormat:NSLocalizedString(@"GREETING_1", nil), (unsigned long)[subscriberPlans count]];
    NSString *temp = [NSString stringWithFormat:@"%@ %@\n%@", sPrefix, obj.sUser, temp2];
    NSString *temp1 = [NSString stringWithFormat:@" %d %@", clients_needing_immediate_attention, NSLocalizedString(@"GREETING_2", nil)];
        
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:temp];
    
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:temp1];
    
    [string1 addAttribute:NSForegroundColorAttributeName
                    value:[UIColor redColor]
                    range:NSMakeRange(0, 3)];
    
    [string appendAttributedString:string1];
    
    [labelView setAttributedText: string];
    
    [headerView addSubview:labelView];
    self.tableView.tableHeaderView = headerView;
}

-(NSString*)getValue:(NSArray*)pk valueForKey:(NSString*)key
{
    if ([pk valueForKey:key] == (NSString *)[NSNull null])
        return @"";

    if ([[pk valueForKey:key] isKindOfClass:[NSString class]]) {
        //NSLog(@"it is a string");
        return [pk valueForKey:key];
    }
    else {
        //NSLog(@"it is number");
        return [[pk valueForKey:key] stringValue];
    }
    return @"";
    
}
-(void)processBuckets
{
    NSArray *clientKeys;
    NSArray *ck;
    
    for (int x=0;x<[subscriberPlans count];x++)
    {
        ck = [subscriberPlans objectAtIndex:x];
        clientKeys = [[dictionary valueForKeyPath:@"broker_clients"][x] allKeys];
        
        brokerEmployersData *pCompany = [[brokerEmployersData alloc] init];
        pCompany.type = 0;
        
        pCompany.companyName = [ck valueForKey:@"employer_name"];
        pCompany.employer_address_1 = [ck valueForKeyPath:@"contact_info.address_1"];
        pCompany.employer_city = [ck valueForKeyPath:@"contact_info.city"];
        pCompany.employer_state = [ck valueForKeyPath:@"contact_info.state"];
        pCompany.employer_zip = [ck valueForKeyPath:@"contact_info.zip"];
        
        pCompany.emails = [ck valueForKeyPath:@"contact_info.emails"];
        //        pCompany.emails = [ck valueForKeyPath:@"contact_info"];
        pCompany.phones = [ck valueForKeyPath:@"contact_info"];
        
        pCompany.planYear = [self getValue:ck valueForKey:@"plan_year_begins"];
        pCompany.employeesEnrolled = [self getValue:ck valueForKey:@"employees_enrolled"];
        pCompany.employeesWaived = [self getValue:ck valueForKey:@"employees_waived"];
        pCompany.planMinimum = [self getValue:ck valueForKey:@"minimum_participation_required"];
        pCompany.employeesTotal = [self getValue:ck valueForKey:@"employees_total"];
        pCompany.open_enrollment_begins = [self getValue:ck valueForKey:@"open_enrollment_begins"];
        pCompany.open_enrollment_ends = [self getValue:ck valueForKey:@"open_enrollment_ends"];
        pCompany.renewal_application_due = [self getValue:ck valueForKey:@"renewal_application_due"];
        pCompany.renewal_application_available = [self getValue:ck valueForKey:@"renewal_application_available"];
        
        if ([ck valueForKey:@"binder_payment_due"] == (NSString *)[NSNull null])
            pCompany.binder_payment_due = @"";
        else
            pCompany.binder_payment_due = [ck valueForKey:@"binder_payment_due"];
        
        pCompany.active_general_agency = [ck valueForKey:@"active_general_agency"];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [numberFormatter setMaximumFractionDigits:0];
        
        pCompany.employee_contribution = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[ck valueForKeyPath:@"estimated_premium.employee_contribution"] floatValue]]];
        pCompany.employer_contribution = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[ck valueForKeyPath:@"estimated_premium.employer_contribution"] floatValue]]];
        
        float total_premium = [[ck valueForKeyPath:@"estimated_premium.employee_contribution"] floatValue] + [[ck valueForKeyPath:@"estimated_premium.employer_contribution"] floatValue];
        
        pCompany.total_premium = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: total_premium]];
        
        //        if (pCompany.open_enrollment_begins == (NSString *)[NSNull null])
        if ([pCompany.open_enrollment_begins isEqualToString:@""])
        {
            BOOL bRenewal = FALSE;
            if ([ck valueForKey:@"renewal_in_progress"] == (NSString *)[NSNull null])
                bRenewal = FALSE;
            else
                bRenewal = [[ck valueForKey:@"renewal_in_progress"] boolValue];
            
            //            BOOL bRenewal = [[ck valueForKey:@"renewal_in_progress"] boolValue];
            pCompany.open_enrollment_begins = @"";
            
            if (bRenewal)
            {
                pCompany.status = RENEWAL_IN_PROGRESS;
                [renewals addObject:pCompany];
            }
            else
            {
                pCompany.status = NO_ACTION_REQUIRED;
                [all_others addObject:pCompany];
            }
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // this is important - we set our input date format to match our input string
            // if format doesn't match you'll get nil from your string, so be careful
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            NSDate *dateFromString = [[NSDate alloc] init];
            
            dateFromString = [dateFormatter dateFromString:pCompany.open_enrollment_begins];
            NSDate *endEnrollmentDate = [dateFormatter dateFromString:pCompany.open_enrollment_ends];
            
            NSDate *today = [NSDate date];
            
            if ([dateFromString compare:today] == NSOrderedAscending && [endEnrollmentDate compare:today] == NSOrderedDescending) //If today is greater than open_enrollment_begin AND less than open_enrollment_end
            {
                if ([pCompany.employeesEnrolled intValue] < [pCompany.planMinimum intValue])
                {
                    pCompany.status = NEEDS_ATTENTION;
                    [open_enrollment addObject:pCompany];
                    clients_needing_immediate_attention += 1;
                }
                else if ( [pCompany.employeesEnrolled intValue] >= [pCompany.planMinimum intValue] )
                {
                    pCompany.status = OPEN_ENROLLMENT_MET;
                    [open_enrollment addObject:pCompany];
                }
            }
            else
            {
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                    fromDate:today
                                                                      toDate:endEnrollmentDate
                                                                     options:NSCalendarWrapComponents];
                
                if ([components day] <= 60 && [components day] >= 0)
                {
                    pCompany.status = RENEWAL_IN_PROGRESS;
                    [renewals addObject:pCompany];
                }
                else
                {
                    pCompany.status = NO_ACTION_REQUIRED;
                    [all_others addObject:pCompany];
                }
                
            }
        }
        
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES];
    //    subscriberPlans = [all_others sortedArrayUsingDescriptors:@[sort]];
    
    [listOfCompanies addObject:open_enrollment];
    [listOfCompanies addObject:renewals];
    [listOfCompanies addObject:[all_others sortedArrayUsingDescriptors:@[sort]]]; //all_others];
    
    [expandedSections addIndex:0];
    [expandedSections addIndex:1];
    [expandedSections addIndex:2];
    
//    self.displayedItems = listOfCompanies;
    self.filteredProducts = listOfCompanies;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self filterContentForSearchText:searchController.searchBar.text scope:@""];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [searchData removeAllObjects];
    
    NSMutableArray *group;
    
    if (![searchText isEqualToString:@""])
    {
        if (searchData == nil)
            searchData = [[NSMutableArray alloc] init];
        
        for(group in listOfCompanies) //take the n group (eg. group1, group2, group3)
            //in the original data
        {
            NSMutableArray *newGroup = [[NSMutableArray alloc] init];
            //   NSString *element;
            brokerEmployersData *element;
            
            for(element in group)
            {
                NSRange range = [element.companyName rangeOfString:searchText
                                                           options:NSCaseInsensitiveSearch];
                
                if (range.length > 0) { //if the substring match
                    [newGroup addObject:element]; //add the element to group
                }
            }
            
            if ([newGroup count] > 0)
            {
                if (searchData == nil)
                    searchData = [[NSMutableArray alloc] init];
                
                [searchData addObject:newGroup];
            }
            
        }
        //self.filteredProducts = searchData;
        
        // hand over the filtered results to our search results table
        brokerSearchResultTableViewController *tableController = (brokerSearchResultTableViewController *)self.searchController.searchResultsController;
        tableController.filteredProducts = searchData;
        [tableController.tableView reloadData];
        
    }
    else
        self.filteredProducts = listOfCompanies;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
                NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
                brokerEmployersData *pTab = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

                popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
                sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                sub.messageTitle = pTab.companyName;
                sub.messageArray = pTab.phones;
                [self presentViewController:sub animated:YES completion: nil];
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
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

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Broker Detail Page"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Get destination view
        brokerPlanDetailViewController *vc = [segue destinationViewController];
        vc.bucket = indexPath.section;
        vc.type = (brokerEmployersData*)sender; //ttype;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    brokerEmployersData *ttype = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Broker Detail Page" sender:ttype];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return;
}

- (void)didSelectSearchItem:(id)ttype
{
    firstTime = TRUE;
    [self performSegueWithIdentifier:@"Broker Detail Page" sender:(brokerEmployersData *)ttype];
    return;
}

@end
