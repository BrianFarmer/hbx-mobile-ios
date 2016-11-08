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
#import "tutorialViewcontroller.h"
#import "detailBrokerEmployerViewController.h"
#import "employerTabController.h"
#import "Constants.h"

static NSDateFormatter *sUserVisibleDateFormatter = nil;

@interface BrokerAccountTableViewController ()

@end

@implementation BrokerAccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBarHidden = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    pHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 0, 200, 40)];
    pHeaderImage.backgroundColor = [UIColor clearColor];
    pHeaderImage.image = [UIImage imageNamed:@"navHeader"];
    pHeaderImage.contentMode = UIViewContentModeCenter;// UIViewContentModeScaleAspectFill;
    
    self.navigationItem.titleView = pHeaderImage;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor lightGrayColor];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl layoutIfNeeded];
//    NSDictionary *attrs = @{ NSForegroundColorAttributeName : [UIColor blackColor] };
    
//    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:@"Update Employer List" attributes:attrs];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MMM d, h:mm a"];
//    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
//    NSString *title = @"Pull to refresh";
//    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrs];
//    refreshControl.attributedTitle = attributedTitle; //[[NSAttributedString alloc] initWithString:@"Update Employer List"];

/*
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"refresh.png"];
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:@"My label text"];
    [myString appendAttributedString:attachmentString];
    
    refreshControl.attributedTitle = myString;
 */   
    
    [self.tableView addSubview:refreshControl];
    
    self.view.autoresizesSubviews = YES;
    
    bAlreadyShownTutorial = [[NSUserDefaults standardUserDefaults] boolForKey:@"alreadyShownTutorial"];
    
    brokerSearchResultTableViewController *_resultsTableController = [[brokerSearchResultTableViewController alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:_resultsTableController];
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.showsCancelButton = TRUE;
    _resultsTableController.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    self.definesPresentationContext = YES;
    
    searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonTapped:)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = searchButton;

    bAllClientsSortedByClient = FALSE;
    bSortAscending = YES;
    
    if (!expandedSections)
        expandedSections = [[NSMutableIndexSet alloc] init];
    
    sections = [[NSArray alloc] initWithObjects: NSLocalizedString(@"table-section-open-enrollment", @"OPEN ENROLLMENT IN PROGRESS"), NSLocalizedString(@"table-section-renewals-in-progress", @"RENEWALS IN PROGRESS"), NSLocalizedString(@"table-section-all-others", @"ALL OTHER CLIENTS"), nil];

    listOfCompanies = [[NSMutableArray alloc] init];
    open_enrollment = [[NSMutableArray alloc] init];
    renewals = [[NSMutableArray alloc] init];
    all_others = [[NSMutableArray alloc] init];

    [self processData];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!bAlreadyShownTutorial)
    {
        tutorialViewController *sub = [[tutorialViewController alloc] initWithNibName:@"tutorialViewController" bundle:nil];
        sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:sub animated:YES completion: nil];
        bAlreadyShownTutorial = TRUE;
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"alreadyShownTutorial"];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchController.searchBar resignFirstResponder];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
    
    [self setIntroHeader:12];
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    if (refreshControl) {
/*
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
//        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
//                                                                    forKey:NSForegroundColorAttributeName];
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : [UIColor blackColor] };
        

        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrs];
        refreshControl.attributedTitle = attributedTitle;
        
        [refreshControl endRefreshing];
 */
    }
    // Do your job, when done:
    [refreshControl endRefreshing];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
        self.tableView.frame = CGRectMake(0, 64, self.tableView.frame.size.width, self.tableView.frame.size.height);
//    [self.searchController.searchBar resignFirstResponder];
}

-(void)willPresentSearchController:(UISearchController *)searchController
{
//    [self.searchController setActive:TRUE];
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    [searchController.searchBar becomeFirstResponder];
}

- (void)searchButtonTapped:(id)sender
{
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.searchBar.hidden = FALSE;
    self.navigationItem.rightBarButtonItem = nil;

    [self.searchController.searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchController.searchBar resignFirstResponder];
    self.searchController.searchBar.hidden = TRUE;
    self.navigationController.navigationBar.topItem.rightBarButtonItem = searchButton;
    self.navigationItem.titleView = pHeaderImage;
}

-(void)processData
{
//    CGRect screenBound = [[UIScreen mainScreen] bounds];
//    CGSize screenSize = screenBound.size;
    NSData *data;
    [listOfCompanies removeAllObjects];
    [open_enrollment removeAllObjects];
    [renewals removeAllObjects];
    [all_others removeAllObjects];
    clients_needing_immediate_attention = 0;
    
    if (PRODUCTION_BUILD)
        data = [_jsonData dataUsingEncoding:NSUTF8StringEncoding];
    else
    {
        NSLog(@"%li", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"whichServer"] );
        
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"whichServer"] intValue] == 1003 || [[[NSUserDefaults standardUserDefaults] stringForKey:@"whichServer"] intValue] == 0)
        {
            // NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/dchealthlink/HBX-mobile-app-APIs/feature/multiple-contacts/enroll/broker/employers_list/response/example.json"];
            NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/dchealthlink/HBX-mobile-app-APIs/master/enroll/broker/employers_list/response/example.json"];
            data = [NSData dataWithContentsOfURL:url];
        }
        else
            data = [_jsonData dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strData);
    
    NSError *error = nil;
    
    if (data != nil)
    {
        subscriberPlans = nil;
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        subscriberPlans = [dictionary valueForKeyPath:@"broker_clients"];
        
        Settings *obj=[Settings getInstance];
        obj.sUser = [dictionary valueForKey:@"broker_name"];
    }
    
    [self processBuckets];
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 600)
        [self setIntroHeader:13];
//    else
//        [self setIntroHeader:12];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
}

-(void)setIntroHeader:(int)iFontsize
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.tableView.frame.size.width, 140)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelWelcome = [[UILabel alloc] initWithFrame:CGRectMake(0,20,headerView.frame.size.width, 40)];
    labelWelcome.numberOfLines = 1;
    labelWelcome.lineBreakMode = NSLineBreakByWordWrapping;
    labelWelcome.textAlignment = NSTextAlignmentCenter;
    labelWelcome.font = [UIFont fontWithName:@"Roboto-Bold" size:24];
    labelWelcome.textColor = UIColorFromRGB(0x555555);

    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0,labelWelcome.frame.origin.y + labelWelcome.frame.size.height, headerView.frame.size.width, 80)];//headerView.bounds];
    labelView.numberOfLines = 3;
    labelView.lineBreakMode = NSLineBreakByWordWrapping;
    labelView.textAlignment = NSTextAlignmentCenter;
    labelView.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
    labelView.textColor = UIColorFromRGB(0x555555);
    
    Settings *obj=[Settings getInstance];
    NSString *temp;
    
    if ([obj.sUser length] > 0)
        temp = [NSString stringWithFormat:@"Welcome back, %@\n", obj.sUser];//(unsigned long)[subscriberPlans count]];
    else
        temp = [NSString stringWithFormat:@"Welcome back, %@\n", @"GitHub"];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:temp];
//    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x007bc4) range:NSMakeRange(14, temp.length - 14)];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x555555) range:NSMakeRange(14, temp.length - 14)];
//    [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(14, temp.length - 14)]

//    [string addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:NSMakeRange(13, temp.length - 13)];
    
    [labelWelcome setAttributedText: string];

    NSString *sNumberOfClients = [NSString stringWithFormat:@"%lu", (unsigned long)total_active_clients];//[subscriberPlans count]];
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x007bc4) };
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:sNumberOfClients attributes:attrs];
    
    [attributedTitle beginEditing];
    
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:18.0] range:NSMakeRange(0, attributedTitle.length)];

    [attributedTitle endEditing];
    
    NSString *temp_a = @"You currently have ";
    NSString *temp_b;
    if (total_active_clients != 1)
        temp_b = @" active clients.\n";
    else
        temp_b = @" active client.\n";
    
    NSString *temp2 = [NSString stringWithFormat:@" %@ not met minimum participation.", (clients_needing_immediate_attention > 1) ? @"have" : @"has"];
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:temp_a];
    NSMutableAttributedString *string1_b = [[NSMutableAttributedString alloc] initWithString:temp_b];
    
    [string1 appendAttributedString:attributedTitle];
    [string1 appendAttributedString:string1_b];
    
    NSString *sNumberOfClientsMinimumParticipation = [NSString stringWithFormat:@"%d", clients_needing_immediate_attention];
    NSDictionary *attrsRed = @{ NSForegroundColorAttributeName : [UIColor redColor] };
    NSMutableAttributedString *attributedMinuimumPartication = [[NSMutableAttributedString alloc] initWithString:sNumberOfClientsMinimumParticipation attributes:attrsRed];

    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:temp2];

    if (clients_needing_immediate_attention > 0)
    {
        [string1 appendAttributedString:attributedMinuimumPartication];
        [string1 appendAttributedString:string2];
    }


    [labelView setAttributedText: string1];

    [labelView sizeToFit];
    labelView.frame = CGRectMake(headerView.frame.size.width / 2 - labelView.frame.size.width / 2, labelView.frame.origin.y, labelView.frame.size.width, labelView.frame.size.height);
    
    [headerView addSubview:labelWelcome];
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
    NSArray *ck;
    bAddedOpenEnrollmentDivider = FALSE;
    total_active_clients = 0;
    
    for (int x=0;x<[subscriberPlans count];x++)
    {
        ck = [subscriberPlans objectAtIndex:x];

        if ([ck valueForKey:@"plan_year_begins"] != [NSNull null])
        {
            total_active_clients += 1;
            brokerEmployersData *pCompany = [[brokerEmployersData alloc] init];
            pCompany.type = 0;
            
            pCompany.companyName = [ck valueForKey:@"employer_name"];
            
            pCompany.employeesTotal = [self getValue:ck valueForKey:@"employees_total"];
            pCompany.employeesEnrolled = [self getValue:ck valueForKey:@"employees_enrolled"];
            pCompany.employeesWaived = [self getValue:ck valueForKey:@"employees_waived"];

            pCompany.open_enrollment_begins = [self getValue:ck valueForKey:@"open_enrollment_begins"];
            pCompany.open_enrollment_ends = [self getValue:ck valueForKey:@"open_enrollment_ends"];
            pCompany.planYear = [self getValue:ck valueForKey:@"plan_year_begins"];

            pCompany.renewal_application_due = [self getValue:ck valueForKey:@"renewal_application_due"];
            pCompany.renewal_application_available = [self getValue:ck valueForKey:@"renewal_application_available"];

            pCompany.detail_url = [ck valueForKeyPath:@"employer_details_url"];
            pCompany.roster_url = [ck valueForKeyPath:@"employee_roster_url"];
            
            pCompany.emails = [ck valueForKeyPath:@"contact_info.emails"];
            pCompany.contact_info = [ck valueForKeyPath:@"contact_info"];
            
            pCompany.planMinimum = [self getValue:ck valueForKey:@"minimum_participation_required"];

            if ([ck valueForKey:@"binder_payment_due"] == (NSString *)[NSNull null])
                pCompany.binder_payment_due = @"";
            else
                pCompany.binder_payment_due = [ck valueForKey:@"binder_payment_due"];
            
            pCompany.active_general_agency = [ck valueForKey:@"active_general_agency"];
            
            if ([pCompany.open_enrollment_begins isEqualToString:@""])
            {
                BOOL bRenewal = FALSE;
                if ([ck valueForKey:@"renewal_in_progress"] == (NSString *)[NSNull null])
                    bRenewal = FALSE;
                else
                    bRenewal = [[ck valueForKey:@"renewal_in_progress"] boolValue];
                
                pCompany.open_enrollment_begins = @"";
                
                if (bRenewal)
                {
                    pCompany.status = RENEWAL_IN_PROGRESS;
                    [renewals addObject:pCompany];
                    [all_others addObject:pCompany];
                }
                else
                {
                    pCompany.status = NO_ACTION_REQUIRED;
                    [all_others addObject:pCompany];
                }
            }
            else
            {
                /*
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                // this is important - we set our input date format to match our input string
                // if format doesn't match you'll get nil from your string, so be careful
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dateFromString = [[NSDate alloc] init];
                */
                NSDate *dateFromString = [self userVisibleDateTimeForRFC3339Date:pCompany.open_enrollment_begins];
                
               // dateFromString = [dateFormatter dateFromString:pCompany.open_enrollment_begins];
                NSDate *endEnrollmentDate = [self userVisibleDateTimeForRFC3339Date:pCompany.open_enrollment_ends]; //[dateFormatter dateFromString:pCompany.open_enrollment_ends];
                
                NSDate *today = [NSDate date];
                
                if ([dateFromString compare:today] == NSOrderedAscending && [endEnrollmentDate compare:today] == NSOrderedDescending) //If today is greater than open_enrollment_begin AND less than open_enrollment_end
                {
                    if (([pCompany.employeesEnrolled intValue] + [pCompany.employeesWaived intValue]) < [pCompany.planMinimum intValue])
                    {
                        pCompany.status = NEEDS_ATTENTION;
                      //  [open_enrollment addObject:pCompany];
                        [open_enrollment insertObject:pCompany atIndex:0];
                        clients_needing_immediate_attention += 1;
                    }
                    else if ( [pCompany.employeesEnrolled intValue] + [pCompany.employeesWaived intValue] >= [pCompany.planMinimum intValue] )
                    {
                        if (!bAddedOpenEnrollmentDivider)
                        {
                            brokerEmployersData *pCompanyDivider = [[brokerEmployersData alloc] init];
                            pCompanyDivider.type = 1;
                            [open_enrollment addObject:pCompanyDivider];
                            bAddedOpenEnrollmentDivider = TRUE;
                        }
                        pCompany.status = OPEN_ENROLLMENT_MET;
                        [open_enrollment addObject:pCompany];
                    }
                    [all_others addObject:pCompany];
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
                        [all_others addObject:pCompany];
                    }
                    else
                    {
                        pCompany.status = NO_ACTION_REQUIRED;
                        [all_others addObject:pCompany];
                    }
                    
                }
            }            
        }
    }
    
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"planYear" ascending:YES];
    //    subscriberPlans = [all_others sortedArrayUsingDescriptors:@[sort]];
    
    [listOfCompanies addObject:open_enrollment];
    [listOfCompanies addObject:renewals];
    [listOfCompanies addObject:[all_others sortedArrayUsingDescriptors:@[sort]]]; //all_others];

    if ([open_enrollment count] > 0)
        [expandedSections addIndex:0];
    else
    {
        if ([renewals count] > 0)
            [expandedSections addIndex:1];
        else
            [expandedSections addIndex:2];
    }
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

-(void) swipeTableCellWillBeginSwiping:(MGSwipeTableCell *) cell;
{
    UIButton *button = [cell.contentView viewWithTag:55];
    button.hidden = TRUE;
}

-(void) swipeTableCellWillEndSwiping:(MGSwipeTableCell *) cell;
{
    UIButton *button = [cell.contentView viewWithTag:55];
    button.hidden = FALSE;    
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings;
{    
    expansionSettings.buttonIndex = 1;
    expansionSettings.fillOnTrigger = NO;
    return [self createLeftButtons:4];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(NSArray *) createLeftButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    UIColor * colors[4] = {[UIColor clearColor],
        [UIColor clearColor],
        [UIColor clearColor],[UIColor clearColor]};
//    UIImage * icons[4] = {[UIImage imageNamed:@"phone.png"], [UIImage imageNamed:@"message.png"], [UIImage imageNamed:@"location.png"], [UIImage imageNamed:@"email.png"]};
    UIImage *pEmail = [[self imageWithImage:[UIImage imageNamed:@"email-2.png"] scaledToSize:CGSizeMake(38, 38)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *pLocation = [[self imageWithImage:[UIImage imageNamed:@"location-2.png"] scaledToSize:CGSizeMake(38, 38)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *pMsg = [[self imageWithImage:[UIImage imageNamed:@"message-2.png"] scaledToSize:CGSizeMake(38, 38)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *pPhone = [[self imageWithImage:[UIImage imageNamed:@"phone-2.png"] scaledToSize:CGSizeMake(38, 38)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UIImage * icons[4] = {pEmail, pLocation, pMsg, pPhone};
    
//    UIImage * icons[4] = {[UIImage imageNamed:@"email-2.png"],  [UIImage imageNamed:@"location-2.png"], [UIImage imageNamed:@"message-2.png"], [UIImage imageNamed:@"phone-2.png"]};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:@"" icon:icons[i] backgroundColor:colors[i] padding:10 callback:^BOOL(MGSwipeTableCell * sender)
        {
            NSLog(@"Convenience callback received (left).");
            if (i == 3)
            {
//                [self phoneEmployer:sender];
                NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
                brokerEmployersData *pTab = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

                popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
                sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                sub.messageTitle = pTab.companyName;
                sub.messageArray = pTab.contact_info;
                sub.messageType = typePopupPhone;
                [self presentViewController:sub animated:YES completion: nil];
            }
            
            if (i == 2)
                [self smsEmployer:sender];
            
            if (i == 1)
                [self showDirections:sender];
            
            if (i == 0)
                [self emailEmployer:sender];
            
            return YES;
        }];
        [result addObject:button];
    }
    return result;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([expandedSections containsIndex:section])// || )
    {
        if (section == 0 && clients_needing_immediate_attention > 0)
            return 80;
        if (section == 1)
            return 80;
        if (section == 2)
            return 90;
    }
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    brokerEmployersData *ttype = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (ttype.type == 1)
        return (indexPath.section == 2) ? 30:20;
    
    return EMPLOYER_LIST_ROW_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, ([expandedSections containsIndex:section] && clients_needing_immediate_attention > 0) ? 60:90)];
    
    // Set a custom background color and a border
//    headerView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
//    headerView.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;//[UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
//    headerView.layer.borderWidth = 1.0;
    
    headerView.tag = section;
    
    // Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    
    switch (section) {
        case 0:
            headerView.backgroundColor = EMPLOYER_LIST_HEADER_DRAWERS_OE;//UIColorFromRGB(0x00a99e);//[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
//            headerLabel.backgroundColor = UIColorFromRGB(0x00a99e);
            break;
        case 1:
            headerView.backgroundColor = EMPLOYER_LIST_HEADER_DRAWERS_RIP;//UIColorFromRGB(0x00a3e2);//[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
 //           headerLabel.backgroundColor = UIColorFromRGB(0x00a3e2);
            break;
        case 2:
            headerView.backgroundColor = EMPLOYER_LIST_HEADER_DRAWERS_AC;//UIColorFromRGB(0x625ba8);//[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
   //         headerLabel.backgroundColor = UIColorFromRGB(0x625ba8);
            break;
            
        default:
            break;
    }

    headerLabel.frame = CGRectMake(8, 0, tableView.frame.size.width - 5, 60);
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16.0];
    headerLabel.text = [sections objectAtIndex:section];///  @"This is the custom header view";
    headerLabel.textAlignment = NSTextAlignmentLeft;
    // Add the label to the header view
    [headerView addSubview:headerLabel];
    

    if ([expandedSections containsIndex:section])
    {
        UIImageView *imgVew = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width-50, 14, 32, 32)];
        imgVew.backgroundColor = [UIColor clearColor];
        imgVew.image = [UIImage imageNamed:@"uparrowWHT.png"];
        imgVew.contentMode = UIViewContentModeScaleAspectFit;
        // Add the image to the header view
        [headerView addSubview:imgVew];

        if ((section == 0 && clients_needing_immediate_attention > 0) || section > 0)
        {
            UIView* subHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, tableView.frame.size.width, (section == 2) ? 30:20)];
            subHeaderView.backgroundColor = UIColorFromRGB(0xebebeb);
            
            UILabel* headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 100, (section == 2) ? 30:20)];
            headerTitle.text = @"CLIENT";
            headerTitle.textColor = [UIColor darkGrayColor];
            headerTitle.font = [UIFont fontWithName:@"Roboto-Bold" size:10.0];
            headerTitle.userInteractionEnabled = NO;

            // Add the header title to the header view
            [subHeaderView addSubview:headerTitle];

            UILabel* headerTitle1 = [[UILabel alloc] init];
            headerTitle1.userInteractionEnabled = NO;
            if (section == 0)
            {
                [headerTitle1 setFrame:CGRectMake(tableView.frame.size.width - 195, 0, 135, 20)];
                headerTitle1.text = @"EMPLOYEES NEEDED";
            }
            else
            {
                if (section != 2)
                {
                    [headerTitle1 setFrame:CGRectMake(tableView.frame.size.width - 165, 0, 100, 20)];
                    headerTitle1.text = @"PLAN YEAR";
                }
                else
                {
                    /*
                    UIButton* buttonClient = [[UIButton alloc] initWithFrame:CGRectMake(8, 0, 100, 20)];
                    [buttonClient setBackgroundColor:[UIColor greenColor]];
                    buttonClient.tag = section;
                    buttonClient.titleLabel.textAlignment = NSTextAlignmentLeft;
                    buttonClient.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    
                    buttonClient.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
                    buttonClient.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:10.0];
                    [buttonClient addTarget:self action:@selector(sortByClient:) forControlEvents:UIControlEventTouchUpInside];
                    [buttonClient setTitle:@"CLIENT" forState:UIControlStateNormal];
                    UIImage *pImage = [UIImage imageNamed:@"OpenCaret.png"];
                    [buttonClient setImage:pImage forState:UIControlStateNormal];
                    
                    [buttonClient setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    
                    buttonClient.imageEdgeInsets = UIEdgeInsetsMake(0., buttonClient.frame.size.width - (pImage.size.width + 15.), 0., 0.);
                    buttonClient.titleEdgeInsets = UIEdgeInsetsMake(0., 0., 0., pImage.size.width);
                    
                    [subHeaderView addSubview:buttonClient];

                    */
                    [headerTitle1 setFrame:CGRectMake(tableView.frame.size.width - 165, 0, 100, 30)];
                    headerTitle1.text = @"PLAN YEAR";

                    headerTitle.userInteractionEnabled = YES;
                    headerTitle1.userInteractionEnabled = YES;
                    subHeaderView.userInteractionEnabled = YES;

                    //This could go to handler to figure out which sort and automatically do the other one
                    UITapGestureRecognizer * recognizerNil = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nilTap:)];
                    [subHeaderView addGestureRecognizer:recognizerNil];

                    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortByClient:)];
                    [headerTitle addGestureRecognizer:recognizer];
                    
                    UITapGestureRecognizer * recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortByPlanYear:)];
                    [headerTitle1 addGestureRecognizer:recognizer1];

                    UIImageView *imageHolder = [[UIImageView alloc] init];
                    UIImage *image;
                    if (bSortAscending)
                        image = [UIImage imageNamed:@"OpenCaret.png"];
                    else
                        image = [UIImage imageNamed:@"CloseCaret.png"];
                    
                    imageHolder.image = image;
                    imageHolder.tag = 321;
                    imageHolder.userInteractionEnabled = YES;
                    
                    if (bAllClientsSortedByClient)
                    {
                        UITapGestureRecognizer * recognizerIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortByClient:)];

                        [imageHolder setFrame:CGRectMake(headerTitle.frame.origin.x + headerTitle.frame.size.width - 40, 15 - 7, 14, 14)];
                        [imageHolder addGestureRecognizer:recognizerIcon];
                    }
                    else
                    {
                        UITapGestureRecognizer * recognizerIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortByPlanYear:)];

                        [imageHolder setFrame:CGRectMake(headerTitle1.frame.origin.x + headerTitle1.frame.size.width, 15 - 7, 14, 14)];
                        [imageHolder addGestureRecognizer:recognizerIcon];
                    }
                    
                    [subHeaderView addSubview:imageHolder];
                    

/*
 
                    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 180, 0, 135, 20)];
                    [button setBackgroundColor:[UIColor clearColor]];
                    button.tag = section;
                    button.titleLabel.textAlignment = NSTextAlignmentRight;
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    
                    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
                    button.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:10.0];
                    [button addTarget:self action:@selector(sortByPlanYear:) forControlEvents:UIControlEventTouchUpInside];
                    [button setTitle:@"PLAN YEAR" forState:UIControlStateNormal];
                    UIImage *pImage = [UIImage imageNamed:@"OpenCaret.png"];
                    [button setImage:pImage forState:UIControlStateNormal];
                    
                    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    
                    button.imageEdgeInsets = UIEdgeInsetsMake(0., button.frame.size.width - (pImage.size.width + 15.), 0., 0.);
                    button.titleEdgeInsets = UIEdgeInsetsMake(0., 0., 0., pImage.size.width);
                    
                    [subHeaderView addSubview:button];
 */
                }
            }
            
            headerTitle1.textAlignment = NSTextAlignmentCenter;
            headerTitle1.textColor = [UIColor darkGrayColor];
            headerTitle1.font = [UIFont fontWithName:@"Roboto-Bold" size:10.0];
            // Add the header title to the header view
            [subHeaderView addSubview:headerTitle1];

            if (section < 2)
            {
                UILabel* headerTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 70, 0, 135, 20)];
                headerTitle2.text = @"DAYS LEFT";
                headerTitle2.textColor = [UIColor darkGrayColor];
                headerTitle2.font = [UIFont fontWithName:@"Roboto-Bold" size:10.0];
                // Add the header title to the header view
                [subHeaderView addSubview:headerTitle2];
            }

            [headerView addSubview:subHeaderView];
        }
    }
    else
    {
        if (section == 0 && clients_needing_immediate_attention > 0)
        {
            UIView *_leftColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, headerView.frame.size.height)];
            _leftColor.backgroundColor = [UIColor redColor];
            [headerView addSubview:_leftColor];
        }

        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-50, 14, 32, 32)];
        button.layer.cornerRadius = 16;
        button.layer.borderWidth = 2;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.clipsToBounds = YES;
        button.tag = section;
        button.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:12.0];
        [button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        if (section == 0 && bAddedOpenEnrollmentDivider)
        {
            [button setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)[[self.filteredProducts objectAtIndex:section] count]-1] forState:UIControlStateNormal];
        }
        else
        {
        [button setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)[[self.filteredProducts objectAtIndex:section] count]] forState:UIControlStateNormal];
        }
        [headerView addSubview:button];
    }
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [headerView addGestureRecognizer:recognizer];
    
    return headerView;
}

- (void)nilTap:(id)sender {
}

- (void)sortByPlanYear:(id)sender {
    if (bAllClientsSortedByClient)
        bSortAscending = NO;
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"planYear" ascending:(bSortAscending ? NO:YES)];

    [listOfCompanies replaceObjectAtIndex:2 withObject:[all_others sortedArrayUsingDescriptors:@[sort]]];
    
    bSortAscending = (bSortAscending ? NO:YES);
    bAllClientsSortedByClient = NO;
    [self.tableView reloadData];
}

- (void)sortByClient:(id)sender {
    if (!bAllClientsSortedByClient)
        bSortAscending = NO;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:(bSortAscending ? NO:YES)];
    
    [listOfCompanies replaceObjectAtIndex:2 withObject:[all_others sortedArrayUsingDescriptors:@[sort]]];

    bSortAscending = (bSortAscending ? NO:YES);
    bAllClientsSortedByClient = YES;
/*
    UIImageView *pview = [self.view viewWithTag:321];
    UIImage *image = [UIImage imageNamed:@"CloseCaret.png"];
    pview.image = image;
    */
    [self.tableView reloadData];
}

- (void)handleButtonTap:(id)sender {
    UIView *pHeaderView = (UIView*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
    [self tableView:self.tableView didSelectHeader:indexPath];
    
    [self.tableView endUpdates];
    
    if ([expandedSections containsIndex:pHeaderView.tag])
    {
        if ( [[self.filteredProducts objectAtIndex:pHeaderView.tag] count] > 0)
        {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }

}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    UIView *pHeaderView = (UIView*)sender.view;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
    [self tableView:self.tableView didSelectHeader:indexPath];
    
    [self.tableView endUpdates];
    
    if ([expandedSections containsIndex:pHeaderView.tag])
    {
        if ( [[self.filteredProducts objectAtIndex:pHeaderView.tag] count] > 0)
        {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }

//    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier2 = @"prototypeCell";

    brokerEmployersData *ttype = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    
    MGSwipeTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    if (!cell) {
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier2];
        
        UIImage *image = [UIImage imageNamed:@"chevron_right.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
//        CGRect frame = CGRectMake(tableView.frame.size.width - 20.0, 88/2-8, 16, 16);
//        button.frame = frame;   // match the button's size with the image size
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.tag = 55;
        button.hidden = FALSE;
        
        [cell.contentView addSubview:button];
    }

    UIButton *b1 = [cell.contentView viewWithTag:55];
    b1.frame = CGRectMake(tableView.frame.size.width - 20.0, 88/2-8, 16, 16);
    b1.hidden = FALSE;
/*
    UILabel *h1 = [cell.contentView viewWithTag:120];
    UILabel *h2 = [cell.contentView viewWithTag:121];
    UILabel *h3 = [cell.contentView viewWithTag:122];

    h1.hidden = TRUE;
    h2.hidden = TRUE;
    h3.hidden = TRUE;

    b1.hidden = FALSE;    //shows chevron
*/
    cell.headerTitle.hidden = TRUE;
    cell.headerTitle1.hidden = TRUE;
    cell.headerTitle2.hidden = TRUE;
    

    if (ttype.type == 1)
    {
        cell.backgroundColor = UIColorFromRGB(0xebebeb);

        cell.employerLabel.text = @"";
        cell.employeesLabel.text = @"";
        cell.daysleftLabel.text = @"";
        cell.leftColor.hidden = TRUE;
        
        cell.headerTitle.hidden = FALSE;
        cell.headerTitle1.hidden = FALSE;
        cell.headerTitle2.hidden = FALSE;
        
        [cell.headerTitle1 sizeToFit];
        
        cell.headerTitle2.frame = CGRectMake(tableView.frame.size.width - 70, 0, 75, 20);
        cell.headerTitle1.frame = CGRectMake(cell.headerTitle2.frame.origin.x - cell.headerTitle1.frame.size.width - 20, 0, cell.headerTitle1.frame.size.width, 20);
//        h1.hidden = FALSE;
//        h2.hidden = FALSE;
//        h3.hidden = FALSE;
        b1.hidden = TRUE;    //hides chevron
        
//        NSString *pp = h3.text;
//        h3.text = @"DAYS LEFT";

        return cell;
    }
    else
        cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.frame = CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height);

//    cell.leftColor.frame = CGRectMake(0, 0, 5, 10);
    
    cell.delegate = self;
    cell.leftSwipeSettings.transition = MGSwipeTransition3D;
    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    
    cell.allowsMultipleSwipe = NO;
    cell.delegate = self;
    cell.daysleftLabel.textColor = [UIColor darkGrayColor];
    
    cell.lblDaysLeftText.text = @"";//@"DAYS LEFT";
    
    cell.employerLabel.text = ttype.companyName;
//    cell.alertButton.hidden = TRUE;
    
    cell.employerLabel.textColor = UIColorFromRGB(0x555555);
    cell.employeesLabel.textColor = UIColorFromRGB(0x555555);
    
    cell.employerLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    cell.leftColor.hidden = TRUE;
    
    int iOffset = 0;
    
    cell.lblEmployeesNeeded.text = @"";
    
    if (ttype.status == NEEDS_ATTENTION)
    {
        cell.daysleftLabel.textColor = UIColorFromRGB(0x555555);
//        cell.alertButton.hidden = FALSE;
        cell.leftColor.hidden = FALSE;
        cell.employeesLabel.text = [NSString stringWithFormat:@"%d", [ttype.planMinimum intValue] - ([ttype.employeesEnrolled intValue] + [ttype.employeesWaived intValue])];
        cell.employeesLabel.textColor = [UIColor redColor];
        cell.leftColor.frame = CGRectMake(0, 0, 5, 86);
    }
    else
        cell.employeesLabel.text = [NSString stringWithFormat:@"%d", [ttype.employeesEnrolled intValue] ]; //removed "waived" on 09-21-16.
    
    if (ttype.status == RENEWAL_IN_PROGRESS || ttype.status == NO_ACTION_REQUIRED || indexPath.section == 2)
    {
        cell.employeesLabel.text = [self userVisibleDateTime:ttype.planYear];;
        
        int width = ceil([cell.employeesLabel.text sizeWithAttributes:@{NSFontAttributeName: cell.employeesLabel.font}].width);
        
        cell.employeesLabel.frame = CGRectMake(cell.employeesLabel.frame.origin.x, cell.employeesLabel.frame.origin.y, width, 20);

        iOffset = 15;
    }
    
    if (ttype.status == NO_ACTION_REQUIRED || indexPath.section == 2)
    {
        cell.lblDaysLeftText.text = @"";
        cell.daysleftLabel.text = @"";
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *dateString=[dateFormatter stringFromDate:[NSDate date]];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:[self userVisibleDateTimeForRFC3339Date:dateString]
                                                              toDate:[self userVisibleDateTimeForRFC3339Date:ttype.open_enrollment_ends]
                                                             options:NSCalendarWrapComponents];
        cell.daysleftLabel.text = [NSString stringWithFormat:@"%ld", (long)[components day]];
    }
    
    [cell.employeesLabel sizeToFit];
    [cell.daysleftLabel sizeToFit];
    
    cell.daysleftLabel.frame = CGRectMake(tableView.frame.size.width - 82/2 - cell.daysleftLabel.frame.size.width/2, 0, cell.daysleftLabel.frame.size.width, EMPLOYER_LIST_ROW_HEIGHT);
    cell.employeesLabel.frame = CGRectMake(cell.daysleftLabel.frame.origin.x - 80 - iOffset, 0, cell.employeesLabel.frame.size.width, EMPLOYER_LIST_ROW_HEIGHT);
    cell.employerLabel.frame = CGRectMake(cell.employerLabel.frame.origin.x, 1, cell.employeesLabel.frame.origin.x - 25, EMPLOYER_LIST_ROW_HEIGHT);

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
            [tableView deleteRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationBottom];
            
            //              cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
        }
        else
        {
            [tableView insertRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationTop];
            //            cell.accessoryView =  [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
        }
//        [tableView scrollToRowAtIndexPath:indexPath
//                         atScrollPosition:UITableViewScrollPositionTop
//                                 animated:YES];

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
        vc.type = (brokerEmployersData*)sender;
        vc.enrollHost = _enrollHost;
        vc.customCookie_a = _customCookie_a;
    }
    
    if ([[segue identifier] isEqualToString:@"Broker Employer Detail"])
    {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Get destination view
        employerTabController *tabar=segue.destinationViewController;
        
        NSMutableArray *sequeTransfer = sender;
        
        tabar.employerData = [sequeTransfer objectAtIndex:0];// (brokerEmployersData*)sender;
        tabar.detailDictionary = [sequeTransfer objectAtIndex:1];
        tabar.enrollHost = _enrollHost;
        tabar.customCookie_a = _customCookie_a;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Settings *obj=[Settings getInstance];
    obj.dTimingStart = [NSDate date];
    
    brokerEmployersData *ttype = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (ttype.type == 1)
        return;
 //   [self performSegueWithIdentifier:@"Broker Detail Page" sender:ttype];
 
    CGFloat x = UIScreen.mainScreen.applicationFrame.size.width/2;
    CGFloat y = UIScreen.mainScreen.applicationFrame.size.height/2;
    // Offset. If tableView has been scrolled
    CGFloat yOffset = self.tableView.contentOffset.y;
    
    UIActivityIndicatorView *activityIndicator= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(x - 50, (y + yOffset) - 50, 100, 100)]; //self.view.frame.origin.y
    activityIndicator.layer.cornerRadius = 05;
    activityIndicator.opaque = NO;
    activityIndicator.tag = 44;
    activityIndicator.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;// UIActivityIndicatorViewStyleGray;
    [activityIndicator setColor:[UIColor whiteColor]];
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    
    MGSwipeTableCell *cell = (MGSwipeTableCell *)[(UITableView *)self.view cellForRowAtIndexPath:indexPath];
    if (ttype.status == NEEDS_ATTENTION)
        cell.leftColor.backgroundColor = [UIColor redColor];

    [self loadJSON:ttype];

    return;
}

-(void)loadJSON:(brokerEmployersData*)eData
{
    
    NSString *pUrl;// = [NSString stringWithFormat:@"%@%@", _enrollHost, employerData.detail_url];
    NSString *e_url = eData.detail_url;
    //if (![e_url hasPrefix:@"http://"] || ![e_url hasPrefix:@"https://"])
    BOOL pp = [e_url hasPrefix:@"https://"];
    BOOL ll = [e_url hasPrefix:@"http://"];
    if (!pp && !ll)
        pUrl = [NSString stringWithFormat:@"%@%@", _enrollHost, eData.detail_url];
    else
        pUrl = eData.detail_url;

    NSURL* url = [NSURL URLWithString:pUrl];
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                _enrollHost, NSHTTPCookieDomain,
                                @"/", NSHTTPCookiePath,  // IMPORTANT!
                                @"_session_id", NSHTTPCookieName,
                                _customCookie_a, NSHTTPCookieValue,
                                nil];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    NSArray* cookies = [NSArray arrayWithObjects: cookie, nil];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [urlRequest setAllHTTPHeaderFields:headers];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse* response,
                                               NSData* data,
                                               NSError* error)
     {
         if (data) {
             NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
             
             if (httpResponse.statusCode == 200) { // /* OK */ && range.length != 0) {
                 NSError* error;
                 id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // self.model = jsonObject;
                         NSLog(@"jsonObject: %@", jsonObject);

                         NSMutableArray *segueTransfer = [[NSMutableArray alloc] init];
                         
                         [segueTransfer addObject:eData];
                         [segueTransfer addObject:jsonObject];
                         
                         UIActivityIndicatorView *activityIndicator = [self.view viewWithTag:44];
                         [activityIndicator stopAnimating];
                         [activityIndicator removeFromSuperview];
                         
                         [self performSegueWithIdentifier:@"Broker Employer Detail" sender:segueTransfer];

                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //[self handleError:error];
                         NSLog(@"ERROR: %@", error);
                     });
                 }
             }
             else {
                 // status code indicates error, or didn't receive type of data requested
                 NSString* desc = [[NSString alloc] initWithFormat:@"HTTP Request failed with status code: %d (%@)",
                                   (int)(httpResponse.statusCode),
                                   [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]];
                 NSError* error = [NSError errorWithDomain:@"HTTP Request"
                                                      code:-1000
                                                  userInfo:@{NSLocalizedDescriptionKey: desc}];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //[self handleError:error];  // execute on main thread!
                     NSLog(@"ERROR: %@", error);
                 });
             }
         }
         else {
             // request failed - error contains info about the failure
             dispatch_async(dispatch_get_main_queue(), ^{
                 //[self handleError:error]; // execute on main thread!
                 NSLog(@"ERROR: %@", error);
             });
         }
     }];
}

- (void)didSelectSearchItem:(id)ttype
{
    firstTime = TRUE;
    if (((brokerEmployersData *)ttype).type == 1)
        return;
    [self performSegueWithIdentifier:@"Broker Employer Detail" sender:(brokerEmployersData *)ttype];
    return;
}


- (void)emailEmployer:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    brokerEmployersData *pTab = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sub.messageTitle = pTab.companyName;
    sub.messageArray = pTab.contact_info;
    sub.messageType = typePopupEmail;
    [self presentViewController:sub animated:YES completion: nil];
}

- (IBAction)smsEmployer:(id)sender {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    brokerEmployersData *pTab = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sub.messageTitle = pTab.companyName;
    sub.messageArray = pTab.contact_info;
    sub.messageType = typePopupSMS;
    sub.delegate = self;
    
    [self presentViewController:sub animated:YES completion: nil];
}

- (void)SMSThesePeople:(id)ttype
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.recipients = [NSArray arrayWithObjects:@"12024686571", nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch(result)
    {
        case MessageComposeResultCancelled:
            // user canceled sms
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultSent:
            // user sent sms
            //perhaps put an alert here and dismiss the view on one of the alerts buttons
            break;
        case MessageComposeResultFailed:
            // sms send failed
            //perhaps put an alert here and dismiss the view when the alert is canceled
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)showDirections:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    brokerEmployersData *pTab = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sub.messageTitle = pTab.companyName;
    sub.messageArray = pTab.contact_info;
    sub.messageType = typePopupMAP;
    sub.delegate = self;
    
    [self presentViewController:sub animated:YES completion: nil];
}

-(void)MAPTheseDirections:(id)sender
{
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//    brokerEmployersData *pTab = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSArray *ck = [sender objectAtIndex:0];
    NSDictionary *pk = [ck objectAtIndex:0];
    
    //(DB) NEW API CHANGE
    NSString *destinationAddress= [NSString stringWithFormat:@"%@, %@, %@, %@", [pk valueForKey:@"address_1"], [pk valueForKey:@"city"], [pk valueForKey:@"state"], [pk valueForKey:@"zip"]]; //@"130 M Street NE, Washington, DC, 20002";

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:destinationAddress
                 completionHandler:^(NSArray *placemarks, NSError *error)
     {
         
         // Convert the CLPlacemark to an MKPlacemark
         // Note: There's no error checking for a failed geocode
         CLPlacemark *geocodedPlacemark = [placemarks objectAtIndex:0];
         MKPlacemark *placemark = [[MKPlacemark alloc]
                                   initWithCoordinate:geocodedPlacemark.location.coordinate
                                   addressDictionary:geocodedPlacemark.addressDictionary];
         
         // Create a map item for the geocoded address to pass to Maps app
         MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
         [mapItem setName:geocodedPlacemark.name];
         
         // Set the directions mode to "Driving"
         // Can use MKLaunchOptionsDirectionsModeWalking instead
         NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
         
         // Get the "Current User Location" MKMapItem
         MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
         
         // Pass the current location and destination map items to the Maps app
         // Set the direction mode in the launchOptions dictionary
         [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
         
     }];
}

- (NSDate *)userVisibleDateTimeForRFC3339Date:(NSString *)rfc3339DateTimeString {
    /*
     Returns a user-visible date time string that corresponds to the specified
     RFC 3339 date time string. Note that this does not handle all possible
     RFC 3339 date time strings, just one of the most common styles.
     */
    
    // If the date formatters aren't already set up, create them and cache them for reuse.
    static NSDateFormatter *sRFC3339DateFormatter = nil;
    if (sRFC3339DateFormatter == nil) {
        sRFC3339DateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [sRFC3339DateFormatter setLocale:enUSPOSIXLocale];
        //[sRFC3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [sRFC3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd"];
        [sRFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [sRFC3339DateFormatter dateFromString:rfc3339DateTimeString];

    return date;
}

- (NSString *)userVisibleDateTime:(NSString *)rfc3339DateTimeString {
    /*
     Returns a user-visible date time string that corresponds to the specified
     RFC 3339 date time string. Note that this does not handle all possible
     RFC 3339 date time strings, just one of the most common styles.
     */
    
    // If the date formatters aren't already set up, create them and cache them for reuse.
    static NSDateFormatter *sRFC3339DateFormatter = nil;
    if (sRFC3339DateFormatter == nil) {
        sRFC3339DateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        [sRFC3339DateFormatter setLocale:enUSPOSIXLocale];
        //[sRFC3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [sRFC3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd"];
        [sRFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [sRFC3339DateFormatter dateFromString:rfc3339DateTimeString];
    
    NSString *userVisibleDateTimeString;
    if (date != nil) {
        if (sUserVisibleDateFormatter == nil) {
            sUserVisibleDateFormatter = [[NSDateFormatter alloc] init];
            [sUserVisibleDateFormatter setDateFormat:@"MMM dd"];
           // [sUserVisibleDateFormatter setDateStyle:NSDateFormatterShortStyle];
           // [sUserVisibleDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
        // Convert the date object to a user-visible date string.
        userVisibleDateTimeString = [sUserVisibleDateFormatter stringFromDate:date];
    }
    return userVisibleDateTimeString;

}


@end
