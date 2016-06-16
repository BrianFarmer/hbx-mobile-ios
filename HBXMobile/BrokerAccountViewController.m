//
//  BrokerAccountViewController.m
//  HBXMobile
//
//  Created by David Boyd on 5/9/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "BrokerAccountViewController.h"
#import "brokerPlanDetailViewController.h"
#import "MGSwipeButton.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

@interface NumberPair : NSObject
@property (nonatomic, assign) long section;
@property (nonatomic, assign) long row;
@end

@implementation NumberPair
@synthesize section, row;
@end

@implementation tabTypeItem
@synthesize companyName, planYear, employeesEnrolled, employeesWaived, planMinimum, employeesTotal, open_enrollment_begins, open_enrollment_ends;
@synthesize renewal_applicable_available, renewal_application_due, binder_payment_due,total_premium,employee_contribution, employer_contribution;
@synthesize employer_address_1, employer_city, employer_state, employer_zip;
@end

@interface BrokerAccountViewController ()

@end

#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_PHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@implementation BrokerAccountViewController

static NSString *BrokerCellIdentifier = @"BrokerCellIdentifier";
static NSString *DetailCellIdentifier = @"DetailCellIdentifier";

//@synthesize personalInfoTable;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = nil;

//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
    clients_needing_immediate_attention = 0;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    NSData *data;
    
    NSLog(@"%li", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"whichServer"] );
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"whichServer"] intValue] == 1003 || [[[NSUserDefaults standardUserDefaults] stringForKey:@"whichServer"] intValue] == 0)
    {
        NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/dchealthlink/HBX-mobile-app-APIs/master/enroll/broker/employers_list/response/example.json"];
        data = [NSData dataWithContentsOfURL:url];
    }
    else
        data = [_jsonData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strData);
    
//    NSString* filepath = [[NSBundle mainBundle] pathForResource:@"brokerDataJson" ofType:@"txt"];
//    NSData *data = [NSData dataWithContentsOfFile:filepath];

    NSError *error = nil;
    
    if (data != nil)
    {
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        subscriberPlans = [dictionary valueForKeyPath:@"broker_clients"];
    }
    
    brokerTable.backgroundColor = [UIColor clearColor];
    brokerTable.backgroundView = nil;
/*
    int uu = self.view.bounds.size.height;
    int oo = self.navigationController.navigationBar.frame.size.height;
    int pp = brokerTable.tableHeaderView.frame.size.height;
    CGFloat height = brokerTable.contentSize.height;
    CGFloat maxHeight1 = brokerTable.superview.frame.size.height - 150;
*/
//    CGFloat maxHeight = brokerTable.superview.frame.size.height - brokerTable.frame.origin.y;
//     int uu = self.view.bounds.size.height;
//     int ww = self.view.frame.size.height;
    
//    brokerTable.frame = CGRectMake(0, 0, screenSize.width, screenSize.height - (self.navigationController.navigationBar.frame.size.height + 44));// - 100);
    brokerTable.frame = CGRectMake(0, 0, screenSize.width, self.view.frame.size.height - 65);
//    brokerTable.frame = CGRectMake(0, 0, screenSize.width, maxHeight + 50);
    
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    
    if (!expandedCompanies)
    {
        expandedCompanies = [[NSMutableIndexSet alloc] init];
    }
 
    if (!ipath)
    {
        ipath = [[NSMutableArray alloc] init];
    }

    sections = [[NSArray alloc] initWithObjects: @"OPEN ENROLLMENT IN PROGRESS", @"RENEWALS IN PROGRESS", @"ALL OTHER CLIENTS", nil];
    
    listOfCompanies = [[NSMutableArray alloc] init];
    
    open_enrollment = [[NSMutableArray alloc] init];
    renewals = [[NSMutableArray alloc] init];
    all_others = [[NSMutableArray alloc] init];

    [self processBuckets];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 600)
        [self setIntroHeader:13];
    else
        [self setIntroHeader:12];
/*
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    searchController.searchResultsUpdater = self;
    
    searchController.dimsBackgroundDuringPresentation = NO;
    
    searchController.hidesNavigationBarDuringPresentation = NO;
    
    searchController.searchBar.frame = CGRectMake(searchController.searchBar.frame.origin.x, searchController.searchBar.frame.origin.y, searchController.searchBar.frame.size.width, 44.0);
    
    brokerTable.tableHeaderView = searchController.searchBar;
*/    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonTapped:)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = searchButton;
/*
    self.searchButton = [[UIButton alloc] init];
    // add button images, etc.
    [_searchButton addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.searchItem = [[UIBarButtonItem alloc] initWithCustomView:_searchButton];
    self.navigationItem.rightBarButtonItem = _searchItem;
    
    self.searchBar = [[UISearchBar alloc] init];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
*/
//     _searchBar.showsCancelButton = YES;
//        _searchBar.delegate = self;
    
//    self.searchDisplayController.searchBar.tintColor = [UIColor blueColor];
//    self.searchDisplayController.searchBar.hidden = TRUE;
  
    [self.searchDisplayController.searchResultsTableView setRowHeight:brokerTable.rowHeight];

}

-(void)setIntroHeader:(int)iFontsize
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, brokerTable.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, brokerTable.frame.size.width, 40)];
    labelView.numberOfLines = 2;
    labelView.lineBreakMode = NSLineBreakByWordWrapping;
    labelView.textAlignment = NSTextAlignmentCenter;
    labelView.font = [UIFont fontWithName:@"Roboto-Regular" size:iFontsize];
    labelView.textColor = [UIColor darkGrayColor];

    NSString *temp = [NSString stringWithFormat:@"Good Morning David\nYou have %lu clients with", (unsigned long)[subscriberPlans count]];
    NSString *temp1 = [NSString stringWithFormat:@" %d requiring immediate attention", clients_needing_immediate_attention];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:temp];
    
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:temp1];
    
    [string1 addAttribute:NSForegroundColorAttributeName
                 value:[UIColor redColor]
                 range:NSMakeRange(0, 3)];
    
    [string appendAttributedString:string1];
    
    [labelView setAttributedText: string];
    
    [headerView addSubview:labelView];
    brokerTable.tableHeaderView = headerView;
}

- (void)searchButtonTapped:(id)sender {
    brokerTable.tableHeaderView = self.searchDisplayController.searchBar;
    self.searchDisplayController.searchBar.hidden = FALSE;
    [self.searchDisplayController.searchBar becomeFirstResponder];
    /*
    [UIView animateWithDuration:0.5 animations:^{
        _searchButton.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        // remove the search button
        self.navigationItem.rightBarButtonItem = nil;
        // add the search bar (which will start out hidden).
        self.navigationItem.titleView = self.searchDisplayController.searchBar; //_searchBar;
        self.searchDisplayController.searchBar.alpha = 0.0;
        
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.searchDisplayController.searchBar.alpha = 1.0;
                         } completion:^(BOOL finished) {
                             [self.searchDisplayController.searchBar becomeFirstResponder];
                         }];
        
    }];
     */
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    /*
    // called when cancel button pressed
    [UIView animateWithDuration:0.5f animations:^{
        self.searchDisplayController.searchBar.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.navigationItem.titleView = nil;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonTapped:)];
        self.searchDisplayController.searchBar.alpha = 0.0;  // set this *after* adding it back
        [UIView animateWithDuration:0.5f animations:^ {
            self.searchDisplayController.searchBar.hidden = TRUE;
            self.searchDisplayController.searchBar.alpha = 1.0;
        }];
    }];
*/
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 600)
        [self setIntroHeader:13];
    else
        [self setIntroHeader:12];

//    [brokerTable setNeedsLayout];
    
}

- (void)check3DTouch {
    
    // register for 3D Touch (if available)
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
        NSLog(@"3D Touch is available! Hurra!");
        
        // no need for our alternative anymore
/////        self.longPress.enabled = NO;
        
    } else {
        
        NSLog(@"3D Touch is not available on this device. Sniff!");
        
        // handle a 3D Touch alternative (long gesture recognizer)
 /////       self.longPress.enabled = YES;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(NSString*)getValue:(NSArray*)pk valueForKey:(NSString*)key
{
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
        
        tabTypeItem *pCompany = [[tabTypeItem alloc] init];
        pCompany.type = 0;

        pCompany.companyName = [ck valueForKey:@"employer_name"];
        pCompany.employer_address_1 = [ck valueForKeyPath:@"contact_info.address_1"];
        pCompany.employer_city = [ck valueForKeyPath:@"contact_info.city"];
        pCompany.employer_state = [ck valueForKeyPath:@"contact_info.state"];
        pCompany.employer_zip = [ck valueForKeyPath:@"contact_info.zip"];
        
        pCompany.planYear = [ck valueForKey:@"plan_year_begins"];
        pCompany.employeesEnrolled = [self getValue:ck valueForKey:@"employees_enrolled"];
        pCompany.employeesWaived = [self getValue:ck valueForKey:@"employees_waived"]; //[[ck valueForKey:@"employees_waived"] stringValue];
        pCompany.planMinimum = [self getValue:ck valueForKey:@"minimum_participation_required"]; //[[ck valueForKey:@"minimum_participation_required"] stringValue];;
        pCompany.employeesTotal = [self getValue:ck valueForKey:@"employees_total"]; //[[ck valueForKey:@"employees_total"] stringValue];
        pCompany.open_enrollment_begins = [ck valueForKey:@"open_enrollment_begins"];
        pCompany.open_enrollment_ends = [ck valueForKey:@"open_enrollment_ends"];
        pCompany.renewal_application_due = [ck valueForKey:@"renewal_application_due"];
        pCompany.renewal_applicable_available = [ck valueForKey:@"renewal_applicable_available"];
        
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
        
        if (pCompany.open_enrollment_begins == (NSString *)[NSNull null])
        {
            BOOL bRenewal = [[ck valueForKey:@"renewal_in_progress"] boolValue];
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
            // this is imporant - we set our input date format to match our input string
            // if format doesn't match you'll get nil from your string, so be careful
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            NSDate *dateFromString = [[NSDate alloc] init];
            
            dateFromString = [dateFormatter dateFromString:pCompany.open_enrollment_begins];
            NSDate *endEnrollmentDate = [dateFormatter dateFromString:pCompany.open_enrollment_ends];
            
            NSDate *today = [NSDate date];

            if ([dateFromString compare:today] == NSOrderedAscending && [endEnrollmentDate compare:today] == NSOrderedDescending)
            {
             //   NSLog(@"myDate is EARLIER than today");
                if ([pCompany.employeesEnrolled intValue] < [pCompany.planMinimum intValue])
                {
             //       [ia addObject:pCompany];
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
                NSDate *today = [NSDate date];
                
                NSDateFormatter *f = [[NSDateFormatter alloc] init];
                [f setDateFormat:@"MM-dd-yyyy"];
                
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                    fromDate:today
                                                                      toDate:endEnrollmentDate
                                                                     options:NSCalendarWrapComponents];
                
                if ([components day] <= 60)
                {
                    pCompany.status = RENEWAL_IN_PROGRESS;
                    [renewals addObject:pCompany];
                }
                else
                {
                    pCompany.status = NO_ACTION_REQUIRED;
//                    [ao addObject:pCompany];
                }
                
            }
        }

    }
    
    [listOfCompanies addObject:open_enrollment];
    [listOfCompanies addObject:renewals];
    [listOfCompanies addObject:all_others];
    
    [expandedSections addIndex:0];
    [expandedSections addIndex:1];
    [expandedSections addIndex:2];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)filterContentForSearchText:(NSString*)searchText //scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [pCompanies filteredArrayUsingPredicate:resultPredicate];
    
    NSLog(@"%@", searchResults);
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    //    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", searchText];
    
    //    searchResults = [self.arrCharacters filteredArrayUsingPredicate:resultPredicate];
    //searchResults = [ia filteredArrayUsingPredicate:resultPredicate];
    NSMutableArray *group;

    if (searchData == nil)
        searchData = [[NSMutableArray alloc] init];

    for(group in listOfCompanies) //take the n group (eg. group1, group2, group3)
        //in the original data
    {
        NSMutableArray *newGroup = [[NSMutableArray alloc] init];
     //   NSString *element;
        tabTypeItem *element;
        
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
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [searchData removeAllObjects];
    /*before starting the search is necessary to remove all elements from the
     array that will contain found items */
    
//    NSArray *group;
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    /* in this loop I search through every element (group) (see the code on top) in
     the "originalData" array, if the string match, the element will be added in a
     new array called newGroup. Then, if newGroup has 1 or more elements, it will be
     added in the "searchData" array. shortly, I recreated the structure of the
     original array "originalData". */
    /*
     for(group in originalData) //take the n group (eg. group1, group2, group3)
     //in the original data
     {
     NSMutableArray *newGroup = [[NSMutableArray alloc] init];
     NSString *element;
     
     for(element in group) //take the n element in the group
     {                    //(eg. @"Napoli, @"Milan" etc.)
     NSRange range = [element rangeOfString:searchString
     options:NSCaseInsensitiveSearch];
     
     if (range.length > 0) { //if the substring match
     [newGroup addObject:element]; //add the element to group
     }
     }
     
     if ([newGroup count] > 0) {
     [searchData addObject:newGroup];
     }
     
     //        [newGroup release];
     }
     */
    return YES;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self filterContentForSearchText:searchString];//]scope:searchController.searchBar.selectedScopeButtonIndex];
    [brokerTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return [searchData count];
    else
        return [listOfCompanies count]; //Must include create button row
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        long iCnt = [[searchData objectAtIndex:section] count];
        return iCnt;//[searchData count];
    }

    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section])
        {
            long iCnt = [[listOfCompanies objectAtIndex:section] count];
//            if ([expandedCompanies containsIndex:section])
            NSIndexPath *item;
            for (item in ipath)
            {
//                if (item.section == section)
//                    iCnt = iCnt + 1;    // return rows when expanded
            }

            return iCnt;
        }
        
        return 0; // only top row showing
    }
/*
    // Return the number of rows in the section.
    if (section == 0)
        return 3;
    
    return 4;
 */
    return [[listOfCompanies objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section == 3)
    //        return 80;
//    if ([indexPath section] == 4)
//        return 60;
    
//    return 44;
//    tabTypeItem *ttype = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    tabTypeItem *ttype;
    if (tableView == self.searchDisplayController.searchResultsTableView)
        ttype = [[searchData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    else
        ttype = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    
    if (ttype.type == 0)
        return 44;
    else
        return 114;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    
 //   UIView* progressIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
 //   progressIndicatorView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
    headerView.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;//[UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    headerView.tag = section;
    
    //    [headerView addSubview:progressIndicatorView];
    
    // 3. Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 0, tableView.frame.size.width - 5, 34);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor darkGrayColor];
    headerLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16.0];
    headerLabel.text = [sections objectAtIndex:section];///  @"This is the custom header view";
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // 4. Add the label to the header view
    [headerView addSubview:headerLabel];
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [headerView addGestureRecognizer:recognizer];
    // 5. Finally return
    return headerView;
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    UIView *pHeaderView = (UIView*)sender.view;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
    
    [self tableView:brokerTable didSelectHeader:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    return YES;
    
    return NO;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    tabTypeItem *ttype;
    if (tableView == self.searchDisplayController.searchResultsTableView)
        ttype = [[searchData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    else
        ttype = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
//    tabTypeItem *ttype = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (ttype.type == 1)
    {
//     cell.contentView.backgroundColor = [UIColor grayColor];
     UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(10,0,self.view.frame.size.width-20,20)];
     cardView.backgroundColor = [UIColor lightGrayColor];
//        cardView.layer.borderWidth = 1;
     cardView.layer.masksToBounds = NO;
//     cardView.layer.cornerRadius = 3.0;
 //    cardView.layer.shadowOffset = CGSizeMake(1, -1);
//     cardView.layer.shadowOpacity = 0.3;
        
    UILabel *lbl = [[UILabel alloc] init];
        lbl.frame = cardView.frame;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont fontWithName:@"Roboto-Regular" size:12.0];
    lbl.text = @"OPEN ENROLLMENT IS MAY 1, 2016 - MAY 31, 2016";
    [cardView addSubview:lbl];
     [cell.contentView addSubview:cardView];
     [cell.contentView sendSubviewToBack:cardView];
    }
    
}
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Clona" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your editAction here

    }];
//    editAction.backgroundColor = [UIColor blueColor];
    UIView * yourView = [[UIView alloc] initWithFrame:CGRectMake(10.f, 100.f, 300.f, 100.f)];
    UIImage * targetImage = [UIImage imageNamed:@"chat.png"];
    
    // redraw the image to fit |yourView|'s size
    UIGraphicsBeginImageContextWithOptions(yourView.frame.size, NO, 0.f);
    [targetImage drawInRect:CGRectMake(0.f, 0.f, yourView.frame.size.width, yourView.frame.size.height)];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [editAction setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];
    
 //       editAction.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat.png"]];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your deleteAction here
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction,editAction];
}
*/
-(NSArray *) createLeftButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
//    UIColor * colors[3] = {[UIColor greenColor],
//        [UIColor colorWithRed:0 green:0x99/255.0 blue:0xcc/255.0 alpha:1.0],
//        [UIColor colorWithRed:0.59 green:0.29 blue:0.08 alpha:1.0]};
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
                [self phoneEmployer:sender];
            }

            if (i == 1)
            {
                [self smsEmployer:sender];
            }
       
            if (i == 2)
            {
                [self showDirections:sender];
            }

            if (i == 3)
            {
                [self emailEmployer:sender];
            }

            return YES;
        }];
        [result addObject:button];
    }
    return result;
}


-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {@"Delete", @"More"};
    UIColor * colors[2] = {[UIColor redColor], [UIColor lightGrayColor]};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            NSLog(@"Convenience callback received (right).");
            BOOL autoHide = i != 0;
            return autoHide; //Don't autohide in delete button to improve delete expansion animation
        }];
        [result addObject:button];
    }
    return result;
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
//    }
}

- (IBAction)phoneEmployer:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"2024686571"]]];
    else
    {
        NSString *newString = [[@"202.468-6571" componentsSeparatedByCharactersInSet:
                                [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                               componentsJoinedByString:@""];
        
        NSMutableString *stringts = [NSMutableString stringWithString:newString];
        [stringts insertString:@"(" atIndex:0];
        [stringts insertString:@")" atIndex:4];
        [stringts insertString:@"-" atIndex:5];
        [stringts insertString:@"-" atIndex:9];
        
        newString = stringts;
        
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Phone Number" message:newString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
}

- (IBAction)smsEmployer:(id)sender {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.recipients = [NSArray arrayWithObjects:@"12024686571", nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)emailEmployer:(id)sender {
    
    //    NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from HBX!";
    NSString *recipients = @"mailto:hbx@mobile.com&subject=Hello from HBX!";
    
    NSString *body = @"&body=It is raining in sunny DC!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    
    /*
     // Email Subject
     NSString *emailTitle = @"Test Email";
     // Email Content
     NSString *messageBody = @"<h1>Message Body</h1>"; // Change the message body to HTML
     // To address
     NSArray *toRecipents = [NSArray arrayWithObject:@"dboyd.papermoon@gmail.com"];
     
     MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
     mc.mailComposeDelegate = self;
     [mc setSubject:emailTitle];
     [mc setMessageBody:messageBody isHTML:YES];
     [mc setToRecipients:toRecipents];
     
     // Present mail view controller on screen
     [self presentViewController:mc animated:YES completion:NULL];
     */
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    switch(result) {
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

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void)showDirections:(id)sender
{
    NSIndexPath *indexPath = [brokerTable indexPathForCell:sender];
    tabTypeItem *pTab = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //    [self performSegueWithIdentifier:@"Show Map View" sender:self];
    //    return;
    NSString *destinationAddress = [NSString stringWithFormat:@"%@, %@, %@, %@", pTab.employer_address_1, pTab.employer_city, pTab.employer_state, pTab.employer_zip]; //@"130 M Street NE, Washington, DC, 20002";
//    destinationAddress = @"2107 S 320th St, FederalWay, WA 98003";
/*
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:destinationAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding address");
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
        }
    }];
*/
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

/*
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier1 = @"CellIdentifier1";
    [self.searchDisplayController.searchResultsTableView registerClass:[brokerPlanTableViewCell class] forCellReuseIdentifier:CellIdentifier1];
//    [brokerTable registerClass:[brokerPlanTableViewCell class] forCellReuseIdentifier:CellIdentifier1];
}
*/
-(BOOL)iPhone6PlusDevice{
    if (!IS_PHONE) return NO;
    if ([UIScreen mainScreen].scale > 2.9) return YES;   // Scale is only 3 when not in scaled mode for iPhone 6 Plus
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
//    static NSString *CellIdentifier1 = @"CellIdentifier1";
//    static NSString *CellIdentifier = @"BrokerCellIdentifier";
    static NSString *CellIdentifier2 = @"prototypeCell";
    
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    
    if ( cell == nil )
    {
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
//        cell = [[brokerPlanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    CGRect screenBound = [[UIScreen mainScreen] bounds];
//    CGSize screenSize = screenBound.size;
    
//    int yy = cell.frame.size.width;
//    int uu = tableView.frame.size.width;
    
    cell.frame = CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height);
//    yy = cell.employerLabel.frame.size.width;
    
    int iOffset = 0;
    int secondaryOffset = 0;
    
    if (IS_IPHONE_6_PLUS)
        iOffset = 60;
    else if (IS_IPHONE_6)
        iOffset = 20;
    else
    {
        iOffset = 0;
        secondaryOffset = 15;
    }

    cell.lblDaysLeftText.frame = CGRectMake(tableView.frame.size.width - cell.lblDaysLeftText.frame.size.width - 25, cell.lblDaysLeftText.frame.origin.y, cell.lblDaysLeftText.frame.size.width, cell.lblDaysLeftText.frame.size.height);
    cell.daysleftLabel.frame = CGRectMake(cell.lblDaysLeftText.frame.origin.x - cell.daysleftLabel.frame.size.width - 4, cell.daysleftLabel.frame.origin.y, cell.daysleftLabel.frame.size.width, cell.daysleftLabel.frame.size.height);
    cell.lblEmployeesNeeded.frame = CGRectMake(cell.daysleftLabel.frame.origin.x - cell.lblEmployeesNeeded.frame.size.width, cell.lblEmployeesNeeded.frame.origin.y, cell.lblEmployeesNeeded.frame.size.width, cell.lblEmployeesNeeded.frame.size.height);
    cell.employeesLabel.frame = CGRectMake(cell.lblEmployeesNeeded.frame.origin.x - cell.employeesLabel.frame.size.width - 5, cell.employeesLabel.frame.origin.y, cell.employeesLabel.frame.size.width, cell.employeesLabel.frame.size.height);
    cell.employerLabel.frame = CGRectMake(cell.employerLabel.frame.origin.x, cell.employerLabel.frame.origin.y, cell.employeesLabel.frame.origin.x - 10, cell.employerLabel.frame.size.height);

    if (iOffset > 0)
    {
//        cell.employerLabel.frame = CGRectMake(cell.employerLabel.frame.origin.x, cell.employerLabel.frame.origin.y, 180, cell.employerLabel.frame.size.height);
//        cell.employeesLabel.frame = CGRectMake(166 + iOffset + secondaryOffset, cell.employeesLabel.frame.origin.y, cell.employeesLabel.frame.size.width, cell.employeesLabel.frame.size.height);
//        cell.lblEmployeesNeeded.frame = CGRectMake(198 + iOffset + secondaryOffset, cell.lblEmployeesNeeded.frame.origin.y, cell.lblEmployeesNeeded.frame.size.width, cell.lblEmployeesNeeded.frame.size.height);
//        cell.daysleftLabel.frame = CGRectMake(259 + (iOffset + 10), cell.daysleftLabel.frame.origin.y, cell.daysleftLabel.frame.size.width, cell.daysleftLabel.frame.size.height);
//        cell.lblDaysLeftText.frame = CGRectMake(289 + (iOffset + 10), cell.lblDaysLeftText.frame.origin.y, cell.lblDaysLeftText.frame.size.width, cell.lblDaysLeftText.frame.size.height);
    }
//    cell.employerLabel.backgroundColor = [UIColor blueColor];
//    cell.employeesLabel.backgroundColor = [UIColor greenColor];
//    cell.lblEmployeesNeeded.backgroundColor = [UIColor redColor];
//    cell.daysleftLabel.backgroundColor = [UIColor grayColor];
//    cell.lblDaysLeftText.backgroundColor = [UIColor blueColor];
    
    
    //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.allowsMultipleSwipe = NO;
    cell.delegate = self;
    
    tabTypeItem *ttype;
    if (tableView == self.searchDisplayController.searchResultsTableView)
        ttype = [[searchData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    else
        ttype = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (ttype.status == NEEDS_ATTENTION)
    {
            UIView *right = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, cell.frame.size.height)];
            right.backgroundColor = [UIColor redColor];
            
            [cell.contentView addSubview:right];
            
            UIImage *image = [UIImage imageNamed:@"alert2.png"];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect frame = CGRectMake(cell.frame.size.width - 22, cell.frame.size.height/2-8, 16, 16); //image.size.width, image.size.height);
            button.frame = frame;
            [button setBackgroundImage:image forState:UIControlStateNormal];
            
 //           [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:button];
    }
    
        cell.employerLabel.text = ttype.companyName;
        cell.employeesLabel.text = ttype.employeesEnrolled;
        
        NSDate *today = [NSDate date];
        
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"MM-dd-yyyy"];
        
        NSDate *endDate = [f dateFromString:ttype.open_enrollment_ends];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:today
                                                              toDate:endDate
                                                             options:NSCalendarWrapComponents];
        
        if (ttype.status == NEEDS_ATTENTION)
        {
            cell.lblEmployeesNeeded.text = @"EMPLOYEES NEEDED";
            if (ttype.status == NEEDS_ATTENTION)
                cell.daysleftLabel.textColor = [UIColor redColor];
            else
                cell.daysleftLabel.textColor = [UIColor darkGrayColor];
            cell.daysleftLabel.text = [NSString stringWithFormat:@"%ld", (long)[components day]];
        }
        
        if (ttype.status == OPEN_ENROLLMENT_MET)
        {
            cell.lblEmployeesNeeded.text = [NSString stringWithFormat:@"OF %@ ENROLLED", ttype.employeesTotal];
            cell.daysleftLabel.text = [NSString stringWithFormat:@"%ld", (long)[components day]];
        }

        if (ttype.status == RENEWAL_IN_PROGRESS || ttype.status == NO_ACTION_REQUIRED)
        {
            cell.lblEmployeesNeeded.text = @"PLAN\nYEAR";
            
/*
            CGSize expectedLabelSize = [cell.lblEmployeesNeeded.text sizeWithFont:cell.lblEmployeesNeeded.font
                                              constrainedToSize:maximumLabelSize
                                                  lineBreakMode:cell.lblEmployeesNeeded.lineBreakMode];
            
            CGRect labelRect = [cell.lblEmployeesNeeded.text
                                boundingRectWithSize:labelSize
                                options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{
                                             NSFontAttributeName : [UIFont systemFontOfSize:14]
                                             }
                                context:nil];
*/
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            NSDate *dateFromString = [[NSDate alloc] init];
            
            dateFromString = [dateFormatter dateFromString:ttype.planYear];
            [dateFormatter setDateFormat:@"MMM dd"];
            NSString *stringFromDate = [dateFormatter stringFromDate:dateFromString];
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
                
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectHeader:(NSIndexPath *)indexPath
{
    if ([self tableView:tableView canCollapseSection:indexPath.section])
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
            
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                //              cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
                
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                //            cell.accessoryView =  [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
                
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Broker Detail Page"])
    {
        NSIndexPath *indexPath = [brokerTable indexPathForSelectedRow];
        // Get destination view
        brokerPlanDetailViewController *vc = [segue destinationViewController];
 //       vc.covered = (NSString *)sender;
        tabTypeItem *ttype = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        vc.bucket = indexPath.section;
        vc.type = ttype;

        
        // Get button tag number (or do whatever you need to do here, based on your object
        //       NSInteger tagIndex = [(UIButton *)sender tag];
        
        // Pass the information to your destination view
        //        [vc setSelectedButton:tagIndex];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 5)
    {
        /*
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UIViewController *brokerPlanDetails = [mainStoryboard instantiateViewControllerWithIdentifier:@"Broker Detail Page"];
        [self.navigationController pushViewController:brokerPlanDetails animated:YES];
        */
        [self performSegueWithIdentifier:@"Broker Detail Page" sender:self];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];        
        return;
    }
}
@end
