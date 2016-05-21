//
//  BrokerAccountViewController.m
//  HBXMobile
//
//  Created by David Boyd on 5/9/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "BrokerAccountViewController.h"
#import "brokerPlanTableViewCell.h"
#import "brokerPlanDetailTableViewCell.h"
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

@end

@interface BrokerAccountViewController ()

@end

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
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
/*
    brokerTable.frame = CGRectMake(0,0,screenSize.width,screenSize.height - 200);
//    detailTable.frame = CGRectMake(2, brokerTable.frame.origin.y + brokerTable.frame.size.height + 5, screenSize.width-2, screenSize.height - (screenSize.height - 200));
    int yy = screenSize.height - (screenSize.height - 200) - 10;
    yy = brokerTable.frame.origin.y + (brokerTable.frame.size.height - brokerTable.frame.origin.y) + 5;
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(2, brokerTable.frame.origin.y + (brokerTable.frame.size.height - brokerTable.frame.origin.y) + 5, screenSize.width-2, screenSize.height - (screenSize.height - 200) - 75)];
    detailView.backgroundColor = [UIColor whiteColor];
    detailView.layer.masksToBounds = NO;
    detailView.layer.cornerRadius = 8.0;
    detailView.layer.shadowOffset = CGSizeMake(-1, 1);
    detailView.layer.shadowOpacity = 0.5;
    detailView.alpha = 0.8;
    
    [self.view addSubview:detailView];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = nil;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    
    //   self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{
                                                                     NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:16.0],
                                                                     NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                     } forState:UIControlStateNormal];

    pCompanies =  [NSArray arrayWithObjects: @"Apple", @"Cheverolet", @"Ford", @"Lexus", @"Mercedes", @"Tesla", nil];
*/
//    searchData = [[NSMutableArray alloc] init];
    
    
/*
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 44)];
    ///the search bar widht must be &gt; 1, the height must be at least 44
    // (the real size of the search bar)
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    //contents controller is the UITableViewController, this let you to reuse
    // the same TableViewController Delegate method used for the main table.
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    //set the delegate = self. Previously declared in ViewController.h
    
//    self.tableView.tableHeaderView = searchBar; //this line add the searchBar
 //   searchBar.backgroundColor = [UIColor clearColor];
//    [searchBar setBackgroundColor:[UIColor clearColor]];
//    [searchBar setBarTintColor:[UIColor clearColor]]; //this is what you want

    [searchBar setTranslucent:YES];
    
    
    brokerTable.tableHeaderView = searchBar;
*/
//    self.view.backgroundColor = [UIColor lightGrayColor];
    brokerTable.backgroundColor = [UIColor clearColor];
    brokerTable.backgroundView = nil;
    
    brokerTable.frame = CGRectMake(0,0,screenSize.width,screenSize.height - 100);
    
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

    sections = [[NSArray alloc] initWithObjects:@"REQUIRES IMMEDIATE ATTENTION", @"OPEN ENROLLMENT IN PROGRESS", @"UPCOMING OPEN ENROLLMENT", @"ALL OTHER CLIENTS", nil];
    
    //Company, How Many signed up, minimum needed, goal/target, **DEMO** days to go ** SHOULD BE A DATE **
    //
    companies = [[NSArray alloc] initWithObjects:@"Courage, LLC", @"5", @"10", @"20", @"05-01-2016", @"06-01-2016", @"National Network to End Domestic Violence", @"2", @"20", @"30", @"05-01-2016", @"06-01-2016", @"OPEN Art Studio", @"15", @"15", @"20", @"05-01-2016", @"07-01-2016", @"District Yoga", @"20", @"20", @"30", @"05-01-2016", @"07-31-2016", @"McDonald's", @"0", @"32", @"40", @"06-01-2016", @"07-01-2016", @"DC Brau Brewing Company", @"0", @"32", @"40", @"08-01-2016", @"09-01-2016", @"Bistrot Du Coin", @"0", @"21", @"25", @"08-15-2016", @"09-01-2016", nil];
    
    listOfCompanies = [[NSMutableArray alloc] init];
    
    ia = [[NSMutableArray alloc] init];
    oe = [[NSMutableArray alloc] init];
    uoe = [[NSMutableArray alloc] init];
    ao = [[NSMutableArray alloc] init];
    
    [self processBuckets];

    [self.searchDisplayController.searchResultsTableView setRowHeight:brokerTable.rowHeight];

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

-(void)processBuckets
{
    for (int yy=0;yy<[companies count]/6; yy++)
    {
        /*
         if (previousSection == 0)
         sectionArray = [[NSMutableArray alloc] init];
         
         if ([[obj objectAtIndex:yy*3+2] intValue] != previousSection && previousSection != 0)
         {
         [menuTypes addObject:sectionArray];
         sectionArray = [[NSMutableArray alloc] init];
         }
         */
        //                  sectionArray = [[NSMutableArray alloc] init];
        tabTypeItem *pCompany = [[tabTypeItem alloc] init];
        pCompany.type = 0;
        pCompany.companyName = [companies objectAtIndex:yy*6];
        pCompany.employeesEnrolled = [companies objectAtIndex:yy*6+1];
        pCompany.planMinimum = [companies objectAtIndex:yy*6+2];
        pCompany.employeesTotal = [companies objectAtIndex:yy*6+3];
        pCompany.planEnrollmentStartDate = [companies objectAtIndex:yy*6+4];
        pCompany.planEnrollmentEndDate = [companies objectAtIndex:yy*6+5];
        
        //       NSString *dateString = @"01-02-2010";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        // voila!
        dateFromString = [dateFormatter dateFromString:pCompany.planEnrollmentStartDate];
        NSDate *endEnrollmentDate = [dateFormatter dateFromString:pCompany.planEnrollmentEndDate];
        
        NSDate *today = [NSDate date];
        
        if ([dateFromString compare:today] == NSOrderedAscending && [endEnrollmentDate compare:today] == NSOrderedDescending)
        {
            NSLog(@"myDate is EARLIER than today");
            if ([pCompany.employeesEnrolled intValue] < [pCompany.planMinimum intValue])
                [ia addObject:pCompany];
            else if ( [pCompany.employeesEnrolled intValue] >= [pCompany.planMinimum intValue] )
                [oe addObject:pCompany];
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
                [uoe addObject:pCompany];
            else
                [ao addObject:pCompany];
             
        }
    }
    
    [listOfCompanies addObject:ia];
    [listOfCompanies addObject:oe];
    [listOfCompanies addObject:uoe];
    [listOfCompanies addObject:ao];
    
    [expandedSections addIndex:0];
    [expandedSections addIndex:1];
    [expandedSections addIndex:2];
    [expandedSections addIndex:3];
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
    
    for(group in listOfCompanies) //take the n group (eg. group1, group2, group3)
        //in the original data
    {
        NSMutableArray *newGroup = [[NSMutableArray alloc] init];
     //   NSString *element;
        tabTypeItem *element;
        
        for(element in group) //take the n element in the group
        {                    //(eg. @"Napoli, @"Milan" etc.)
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
    
    NSArray *group;
    
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
    tabTypeItem *ttype = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
    
    tabTypeItem *ttype = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"12024686571"]]];
}

- (IBAction)smsEmployer:(id)sender {
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.recipients = [NSArray arrayWithObjects:@"12024686571", nil];
    
    [self presentModalViewController:picker animated:YES];
}

- (IBAction)emailEmployer:(id)sender {
    
    //    NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from HBX!";
    NSString *recipients = @"mailto:hbx@mobile.com&subject=Hello from HBX!";
    
    NSString *body = @"&body=It is raining in sunny California!";
    
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
    //    [self performSegueWithIdentifier:@"Show Map View" sender:self];
    //    return;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(38.8979,-77.0058);
    //create MKMapItem out of coordinates
    MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    if([destination respondsToSelector:@selector(openInMapsWithLaunchOptions:)])
    {
        NSIndexPath *indexPath = [brokerTable indexPathForCell:sender];
        tabTypeItem *pTab = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [destination setName:pTab.companyName];
        [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
        /*
         //using iOS6 native maps app
         if(_mode == 1)
         {
         [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
         
         }
         if(_mode == 2)
         {
         [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
         
         }
         if(_mode == 3)
         {
         [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit}];
         
         }
         */
    }
    
}

/*
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier1 = @"CellIdentifier1";
    [self.searchDisplayController.searchResultsTableView registerClass:[brokerPlanTableViewCell class] forCellReuseIdentifier:CellIdentifier1];
//    [brokerTable registerClass:[brokerPlanTableViewCell class] forCellReuseIdentifier:CellIdentifier1];
}
*/
/*
- (MGSwipeTableCell *) createCells:(NSString *)cellIdentifier myCell:(MGSwipeTableCell *)cell
{
    UILabel *_employerLabel = [[UILabel alloc] initWithFrame:(CGRectMake(14, -6, 173, 49))];
    _employerLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
    _employerLabel.numberOfLines = 2;
    _employerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _employerLabel.textColor = [UIColor darkGrayColor];
    _employerLabel.textAlignment = NSTextAlignmentLeft;
    _employerLabel.tag = 21;
    
    UILabel *_employeesLabel = [[UILabel alloc] initWithFrame:(CGRectMake(180, 7, 40, 21))];
    _employeesLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
    _employeesLabel.textAlignment = NSTextAlignmentRight;
    _employeesLabel.textColor = [UIColor darkGrayColor];
    _employeesLabel.tag = 22;
    
    UILabel *_lblEmployeesNeeded = [[UILabel alloc] initWithFrame:(CGRectMake(228, 3, 67, 35))];
    _lblEmployeesNeeded.font = [UIFont fontWithName:@"Roboto-Regular" size:11.0];
    _lblEmployeesNeeded.textAlignment = NSTextAlignmentLeft;
    _lblEmployeesNeeded.textColor = [UIColor darkGrayColor];
    _lblEmployeesNeeded.lineBreakMode = NSLineBreakByWordWrapping;
    _lblEmployeesNeeded.numberOfLines = 2;
    _lblEmployeesNeeded.tag = 23;
    
    UILabel *_daysleftLabel = [[UILabel alloc] initWithFrame:(CGRectMake(294, 8, 40, 21))];
    _daysleftLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
    _daysleftLabel.textAlignment = NSTextAlignmentRight;
    _daysleftLabel.textColor = [UIColor darkGrayColor];
    _daysleftLabel.tag = 24;
    
    UILabel *_lblDaysLeftText = [[UILabel alloc] initWithFrame:(CGRectMake(342, 3, 30, 34))];
    _lblDaysLeftText.font = [UIFont fontWithName:@"Roboto-Regular" size:11.0];
    _lblDaysLeftText.textAlignment = NSTextAlignmentLeft;
    _lblDaysLeftText.textColor = [UIColor darkGrayColor];
    _lblDaysLeftText.lineBreakMode = NSLineBreakByWordWrapping;
    _lblDaysLeftText.numberOfLines = 2;
    _lblDaysLeftText.tag = 25;
    
    [cell.contentView addSubview:_employerLabel];
    [cell.contentView addSubview:_employeesLabel];
    [cell.contentView addSubview:_lblEmployeesNeeded];
    [cell.contentView addSubview:_daysleftLabel];
    [cell.contentView addSubview:_lblDaysLeftText];
    
    return cell;
}
*/
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

    if (SCREEN_HEIGHT > 600)
    {
        cell.employerLabel.frame = CGRectMake(cell.employerLabel.frame.origin.x, cell.employerLabel.frame.origin.y, 184, cell.employerLabel.frame.size.height);

        cell.employeesLabel.frame = CGRectMake(166 + 40, cell.employeesLabel.frame.origin.y, cell.employeesLabel.frame.size.width, cell.employeesLabel.frame.size.height);
        cell.lblEmployeesNeeded.frame = CGRectMake(198 + 40, cell.lblEmployeesNeeded.frame.origin.y, cell.lblEmployeesNeeded.frame.size.width, cell.lblEmployeesNeeded.frame.size.height);
        cell.daysleftLabel.frame = CGRectMake(259 + 50, cell.daysleftLabel.frame.origin.y, cell.daysleftLabel.frame.size.width, cell.daysleftLabel.frame.size.height);
        cell.lblDaysLeftText.frame = CGRectMake(289 + 50, cell.lblDaysLeftText.frame.origin.y, cell.lblDaysLeftText.frame.size.width, cell.lblDaysLeftText.frame.size.height);
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.allowsMultipleSwipe = NO;
    cell.delegate = self;
    
    tabTypeItem *ttype;
    if (tableView == self.searchDisplayController.searchResultsTableView)
        ttype = [[searchData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    else
        ttype = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (ttype.type == 0)
    {
        /*
//        brokerPlanTableViewCell *cell = (brokerPlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BrokerCellIdentifier];
        brokerPlanTableViewCell *cell;
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            cell = (brokerPlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            cell.r
        }
        else
            cell = (brokerPlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:BrokerCellIdentifier];

        
//        if (tableView == self.searchDisplayController.searchResultsTableView) {
//            cell = [tableView dequeueReusableCellWithIdentifier:BrokerCellIdentifier];
//        }else{
        
//        }
        
        if (cell == nil) {
//            cell = [self.searchDisplayController.searchResultsTableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
//            cell = [[brokerPlanTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier1];
            cell = [[brokerPlanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];

        }
       */
        cell.employerLabel.text = ttype.companyName;
        
////        cell.employer = ttype.companyName;
        cell.employeesLabel.text = ttype.employeesEnrolled;
        
        
        NSDate *today = [NSDate date];
        
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"MM-dd-yyyy"];
        
        NSDate *endDate = [f dateFromString:ttype.planEnrollmentEndDate];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:today
                                                              toDate:endDate
                                                             options:NSCalendarWrapComponents];
        
        if (indexPath.section == 0)
        {
            cell.lblEmployeesNeeded.text = @"EMPLOYEES NEEDED";
            cell.daysleftLabel.textColor = [UIColor redColor];
            cell.daysleftLabel.text = [NSString stringWithFormat:@"%ld", [components day]];
        }
        if (indexPath.section == 1)
        {
            cell.lblEmployeesNeeded.text = [NSString stringWithFormat:@"OF %@ ENROLLED", ttype.employeesTotal];
            cell.daysleftLabel.text = [NSString stringWithFormat:@"%ld", [components day]];
        }
        if (indexPath.section == 2 || indexPath.section == 3)
        {
            cell.lblEmployeesNeeded.text = @"TOTAL EMPLOYEES";
            cell.employeesLabel.text = ttype.employeesTotal;
            cell.daysleftLabel.text = [NSString stringWithFormat:@"%ld", [components day]];
        }
        
        cell.lblDaysLeftText.text = @"DAYS LEFT";
        
        
        return cell;
    }
    else
    {
        brokerPlanDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];

        if (cell == nil) {
            cell = [[brokerPlanDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCellIdentifier];
        }
 
 /*
        NSIndexPath *item;
        for (item in ipath)
        {
            long irow1 = item.row;
            long isection2 = item.section;
            
            if (item==indexPath)
            {
             cell.backgroundColor = [UIColor lightGrayColor];
            }
        }
*/
        return cell;
    }
    
//    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
//        tabTypeItem *ttype = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
/*
        if (!indexPath.row)
        {
            if ([expandedCompanies containsIndex:indexPath.section])
                cell.textLabel.text = @"HERE";
            else
                cell.textLabel.text = ttype.companyName; // only top row showing
            
            if ([expandedSections containsIndex:indexPath.section])
            {
                //               cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
            }
            else
            {
                //               cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
            }
        }
        else
        {
 
        long irow = indexPath.row;
        long isection = indexPath.section;
        
            // all other rows
            BOOL bShowCard = FALSE;
            NSIndexPath *item;
            for (item in ipath)
            {
                long irow1 = item.row;
                long isection2 = item.section;
                
                if (item==indexPath)
                {
                    bShowCard = TRUE;
                }
            }
*/
//            if (bShowCard)
//                cell.textLabel.text = @"HERE";
//            else
            {
  //              tabTypeItem *ttype = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  //              cell.employer = ttype.companyName;
                
  //              cell.textLabel.text = ttype.companyName;
            }
 //           cell.accessoryView = nil;
          //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
    }
    else
    {
 //       cell.accessoryView = nil;
 //       cell.textLabel.text = @"Normal Cell";
    }
    
 //   return cell;
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
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
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
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
//        if (!indexPath.row)
        {
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded;// = [expandedCompanies containsIndex:section];
            NSInteger rows;
            
            currentlyExpanded = FALSE;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            NSIndexPath *item;
            
            for (item in ipath)
            {
                if (item==indexPath)
    //                [discardedItems addObject:item];
                //          [ipath removeObjectsInArray:item];
                    currentlyExpanded = TRUE;
            }
            
            if (!currentlyExpanded)
            {
                tabTypeItem *ttype = [[listOfCompanies objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                if (ttype.type == 1)
                    return;
            }
/*
            NSMutableArray * array = [NSMutableArray array];
            for (NSString * name in names) {
                for (MyObject * object in objects) {
                    if ([[myObject name] isEqualToString:name]) {
                        [array addObject:object];
                    }
                }
            }
            */

            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
            //    [expandedCompanies removeIndex:section];
             //   NSMutableArray * array = [NSMutableArray array];
/*
                NumberPair *item;
                for (item in ipath) {
                    if (item.section == indexPath.section && item.row == indexPath.row)
                        [ipath removeObject:item];
                }
*/
                
                [[listOfCompanies objectAtIndex:section] removeObjectAtIndex:indexPath.row+1];
                
                NSIndexPath *item;
                for (item in ipath)
                {
                    if (item==indexPath)
                        [ipath removeObject:item];
                }

            }
            else
            {
               // [expandedCompanies addIndex:section];
                /*
                NumberPair *newPair = [[NumberPair alloc] init];
                newPair.section = indexPath.section;
                newPair.row = indexPath.row;
                */
 //               NSIndexPath *tmpIndexPath1 = [NSIndexPath indexPathForRow:indexPath.row
  //                                                              inSection:section];
 //               [ipath addObject:tmpIndexPath1];
                
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }

//            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:indexPath.row
//                                                           inSection:section];
//            [tmpArray addObject:tmpIndexPath];
             
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];

                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                //              cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
/*
                NSMutableArray *discardedItems = [NSMutableArray array];
                NSIndexPath *item;
                for (item in ipath) {
                    if (item==tmpIndexPath)
                        [discardedItems addObject:item];
              //          [ipath removeObjectsInArray:item];
                }
                [ipath removeObjectsInArray:discardedItems];
*/                
            }
            else
            {
                long xx = indexPath.row;
                NSIndexPath *tmpIndexPath1 = [NSIndexPath indexPathForRow:indexPath.row+1
                                                               inSection:section];
                NSMutableArray *tmpArray1 = [NSMutableArray array];
                [tmpArray1 addObject:tmpIndexPath1];
                [ipath addObject:indexPath];
                tabTypeItem *pCompany = [[tabTypeItem alloc] init];
                pCompany.type = 1;
                pCompany.companyName = @"   New Card";
                pCompany.employeesEnrolled = @"";
                pCompany.planMinimum = @"";
                pCompany.employeesTotal = @"";
                pCompany.planEnrollmentStartDate = @"";
                pCompany.planEnrollmentEndDate = @"";
                [[listOfCompanies objectAtIndex:section] insertObject:pCompany atIndex:indexPath.row+1];
                
                [tableView insertRowsAtIndexPaths:tmpArray1 withRowAnimation:UITableViewRowAnimationTop];
                
 //               [tableView insertRowsAtIndexPaths:tmpArray
 //                                withRowAnimation:UITableViewRowAnimationTop];
                //            cell.accessoryView =  [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];

            }
        }
    }
}
@end
