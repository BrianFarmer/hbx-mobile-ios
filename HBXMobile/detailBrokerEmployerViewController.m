//
//  detailBrokerEmployerViewController.m
//  HBXMobile
//
//  Created by John Boyd on 9/10/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "detailBrokerEmployerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "employerTabController.h"
#import "rosterBrokerEmployerViewController.h"
#import "Constants.h"
#import "Settings.h"

@interface detailBrokerEmployerViewController ()

@end

@implementation detailBrokerEmployerViewController

@synthesize employerData;
//@synthesize pieChartRight = _pieChart;
//@synthesize slices = _slices;
//@synthesize sliceColors = _sliceColors;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataNotLoaded = TRUE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveRosterCostsNotification:)
                                                 name:@"rosterCostsLoaded"
                                               object:nil];
    //if Custom class
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    employerData = tabBar.employerData;
    _enrollHost = tabBar.enrollHost;
    _customCookie_a = tabBar.customCookie_a;
    
    self.slices = [NSMutableArray arrayWithCapacity:10];
    
    navImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 0, 200, 40)];
    
    navImage.backgroundColor = [UIColor clearColor];
    navImage.image = [UIImage imageNamed:@"navHeader"];
    navImage.contentMode = UIViewContentModeCenter;
    
    self.navigationController.topViewController.navigationItem.titleView = navImage;
    
    //self.navigationController.topViewController.title = @"info";
    vHeader.frame = CGRectMake(0,0,self.view.frame.size.width,185);
    vHeader.delegate = self;
    //[vHeader layoutHeaderView:employerData];
    vHeader.iCurrentPlanIndex = tabBar.current_coverage_year_index; //[employerData.plans count]-1;
//    tabBar.current_coverage_year_index = [employerData.plans count]-1;
    
    
//    iCurrentPlanIndex = [employerData.plans count]-1;
    
    [vHeader layoutHeaderView:employerData showcoverage:YES showplanyear:NO];
    
    if (!expandedSections)
        expandedSections = [[NSMutableIndexSet alloc] init];
    
    [expandedSections addIndex:0];
    
    sections = [[NSArray alloc] initWithObjects: @"RENEWAL DEADLINES", @"PARTICIPATION", @"MONTHLY COSTS", nil];

    detailTable.backgroundColor = [UIColor clearColor];
    detailTable.backgroundView = nil;
    
//    [self loadDictionary];
    /*
    _dictionary = ((employerTabController *) self.tabBarController).detailDictionary;
    
    int emp_total = ([_dictionary valueForKey:@"employees_total"] == (NSString *)[NSNull null]) ? 0:[[_dictionary valueForKey:@"employees_total"] intValue];

    int emp_enr = ([_dictionary valueForKey:@"employees_enrolled"] == (NSString *)[NSNull null]) ? 0:[[_dictionary valueForKey:@"employees_enrolled"] intValue];

    int emp_waiv = ([_dictionary valueForKey:@"employees_waived"] == (NSString *)[NSNull null]) ? 0:[[_dictionary valueForKey:@"employees_waived"] intValue];

    int iNotEnrolled = emp_total - emp_waiv - emp_enr;
*/
//    int iNotEnrolled = [[dictionary valueForKey:@"employees_total"] intValue] - [[dictionary valueForKey:@"employees_waived"] intValue] - [[dictionary valueForKey:@"employees_enrolled"] intValue];
/*
    NSNumber *one = [NSNumber numberWithInt:emp_enr];
    [_slices addObject:one];
    
    NSNumber *two = [NSNumber numberWithInt:emp_waiv];
    [_slices addObject:two];

    NSNumber *three = [NSNumber numberWithInt:iNotEnrolled];
    [_slices addObject:three];
*/
    
    [self processData];
}

-(void)processData
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    [f setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//    [f setDateStyle:NSDateFormatterFullStyle];
//    [f setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *today = [NSDate date];
    NSString *todayDateString = [f stringFromDate:[NSDate date]];
    
    
    NSDateFormatter *out = [[NSDateFormatter alloc] init];
//    [out setDateFormat:@"MMM dd, yyyy"];
    [out setDateFormat:@"MM/dd/yyyy"];
    
    employerTabController *tabBar = (employerTabController *) self.tabBarController;

    NSArray *employerData1 = [employerData.plans objectAtIndex:tabBar.current_coverage_year_index];//[employerData.plans count]-1];
    
    NSDate *endDate = [f dateFromString:[employerData1 valueForKey:@"open_enrollment_ends"]];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:[f dateFromString:todayDateString] //today
                                                          toDate:endDate
                                                         options:NSCalendarWrapComponents];

//    long ddif = [components day];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setMaximumFractionDigits:2];

    if (employerData.status == (enrollmentState)RENEWAL_IN_PROGRESS || employerData.status == (enrollmentState)NO_ACTION_REQUIRED)
    {
        NSDate *employerApplicationDate = [f dateFromString:[employerData1 valueForKey:@"renewal_application_due"]];
        NSDate *planYearDate = [f dateFromString:[employerData1 valueForKey:@"plan_year_begins"]];//]employerData.planYear]; //plan_year_begins
        NSDate *binderDate = [f dateFromString:employerData.binder_payment_due];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components1 = [gregorianCalendar components:NSCalendarUnitDay
                                                             fromDate:today
                                                               toDate:employerApplicationDate
                                                              options:NSCalendarWrapComponents];
        
        
        if (employerData.status == (enrollmentState)NO_ACTION_REQUIRED)
        {
            renewalNames = [[NSArray alloc] initWithObjects: @"", @"Renewal Available", @"Next Coverage Year Begins", @"Open Enrollment Ends", nil];
            renewalValues = [[NSArray alloc] initWithObjects: @"0", [out stringFromDate:[f dateFromString:[employerData1 valueForKey:@"renewal_application_available"]]], [out stringFromDate:planYearDate], [out stringFromDate:[f dateFromString:[employerData1 valueForKey:@"open_enrollment_ends"]]], nil];
        }
        else
        {
//            [f setDateFormat:@"MMM dd, yyyy"];
            [f setDateFormat:@"MM/dd/yyyy"];
            
            if ([employerData.binder_payment_due length] > 0)
            {
                renewalNames = [[NSArray alloc] initWithObjects: @"", @"Employer Application Due", @"Open Enrollment Ends", @"Coverage Begins", @"Binder Payment Due", nil];
                renewalValues = [[NSArray alloc] initWithObjects: @"0", [NSString stringWithFormat:@"%ld days left", (long)[components1 day]], [NSString stringWithFormat:@"%ld days left", (long)[components day]], [f stringFromDate:planYearDate], [f stringFromDate:binderDate], nil];
            }
            else
            {
                renewalNames = [[NSArray alloc] initWithObjects: @"", @"Employer Application Due", @"Open Enrollment Ends", @"Coverage Begins", nil];
                renewalValues = [[NSArray alloc] initWithObjects: @"0", [NSString stringWithFormat:@"%ld days left", (long)[components1 day]], [NSString stringWithFormat:@"%ld days left", (long)[components day]], [f stringFromDate:planYearDate], nil];
            }
        }
    }
    else
    {
        NSDate *startDate = [f dateFromString:[employerData1 valueForKey:@"open_enrollment_ends"]]; //employerData.open_enrollment_begins];
 //       [f setDateFormat:@"MMM dd, yyyy"];
        [f setDateFormat:@"MM/dd/yyyy"];
        
        if ([startDate compare:today] == NSOrderedAscending)
            renewalNames = [[NSArray alloc] initWithObjects: @"", @"Open Enrollment Began", @"Open Enrollment Closes", @"Days Left", @"BINDER PAYMENT DUE", nil];
        else
            renewalNames = [[NSArray alloc] initWithObjects: @"Open Enrollment Begins", @"Open Enrollment Closes", @"Days Left", @"BINDER PAYMENT DUE", nil];
        
        renewalValues = [[NSArray alloc] initWithObjects: @"0", [f stringFromDate:startDate], [f stringFromDate:endDate], [NSString stringWithFormat:@"%ld", (long)[components day]], employerData.binder_payment_due, nil];
    }
 /*
    monthlyCostNames = [[NSArray alloc] initWithObjects: @"Employee Contribution", @"Employer Contribution", @"TOTAL", nil];
    monthlyCostValues = [[NSArray alloc] initWithObjects: [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[_dictionary valueForKeyPath:@"employee_contribution"] floatValue]]], [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[_dictionary valueForKeyPath:@"employer_contribution"] floatValue]]], [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[_dictionary valueForKeyPath:@"total_premium"] floatValue]]], nil];
  */
    
    Settings *obj=[Settings getInstance];
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:obj.dTimingStart];
    NSLog(@"executionTime = %f\n\n\n", executionTime);
}


- (void) evenlySpaceTheseButtonsInThisView : (NSArray *) buttonArray : (UIView *) thisView {
    int widthOfAllButtons = 0;
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *thisButton = [buttonArray objectAtIndex:i];
        //    [thisButton setCenter:CGPointMake(0, thisView.frame.size.height / 2.0)];
        widthOfAllButtons = widthOfAllButtons + thisButton.frame.size.width;
    }
    
    int spaceBetweenButtons = (thisView.frame.size.width - widthOfAllButtons) / (buttonArray.count + 1);
    
    UIButton *lastButton = nil;
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *thisButton = [buttonArray objectAtIndex:i];
        if (lastButton == nil) {
            [thisButton setFrame:CGRectMake(spaceBetweenButtons, thisButton.frame.origin.y, thisButton.frame.size.width, thisButton.frame.size.height)];
        } else {
            [thisButton setFrame:CGRectMake(spaceBetweenButtons + lastButton.frame.origin.x + lastButton.frame.size.width, thisButton.frame.origin.y, thisButton.frame.size.width, thisButton.frame.size.height)];
        }
        
        lastButton = thisButton;
    }
}

- (void)HandleSegmentControlAction:(UISegmentedControl *)segment
{
    [self processData];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //    self.secondViewController = (YourSecondViewController*) viewController;
    //    self.secondViewController.aLabel.text = self.stringFromTableViewController;
}

-(void)receiveRosterCostsNotification:(NSNotification *) notification
{
//    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"last_name" ascending:YES];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    NSNumber *one = [NSNumber numberWithInt:tabBar.enrolled];
    [_slices addObject:one];
    
    NSNumber *two = [NSNumber numberWithInt:tabBar.waived];
    [_slices addObject:two];
    
    NSNumber *three = [NSNumber numberWithInt:tabBar.notenrolled];
    [_slices addObject:three];

    NSNumber *four = [NSNumber numberWithInt:tabBar.terminated];
    [_slices addObject:four];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setMaximumFractionDigits:2];

    monthlyCostNames = [[NSArray alloc] initWithObjects: @"Employee Contribution", @"Employer Contribution", @"TOTAL", nil];
    monthlyCostValues = [[NSArray alloc] initWithObjects: [numberFormatter stringFromNumber:[NSNumber numberWithFloat: tabBar.employee_costs]], [numberFormatter stringFromNumber:[NSNumber numberWithFloat: tabBar.employer_contribution]], [numberFormatter stringFromNumber:[NSNumber numberWithFloat:tabBar.employee_costs + tabBar.employer_contribution]], nil];
    [detailTable reloadData];
    
    Settings *obj=[Settings getInstance];
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:obj.dTimingStart];
    NSLog(@"executionWithRosterTime = %f\n\n\n", executionTime);

    dataNotLoaded = FALSE;
}

/*
-(void)loadDictionary
{
    NSString *pUrl;// = [NSString stringWithFormat:@"%@%@", _enrollHost, employerData.detail_url];
    NSString *e_url = employerData.detail_url;
    //if (![e_url hasPrefix:@"http://"] || ![e_url hasPrefix:@"https://"])
    BOOL pp = [e_url hasPrefix:@"https://"];
    BOOL ll = [e_url hasPrefix:@"http://"];
    if (!pp && !ll)
        pUrl = [NSString stringWithFormat:@"%@%@", _enrollHost, employerData.detail_url];
    else
        pUrl = employerData.detail_url;

    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pUrl]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    
    [urlRequest setURL:[NSURL URLWithString:pUrl]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"accept"];
    
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
    
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        _dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
}
*/

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
 //   if(pieChart == pieChartRight)
 //       return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            [self userTappedOnEnrolledLink:nil];
            break;
        case 1:
            [self userTappedOnWaivedLink:nil];
            break;
        case 2:
            [self userTappedOnNotEnrolledLink:nil];
            break;
        case 3:
            [self userTappedOnTerminatedLink:nil];
            break;
            
        default:
            break;
    }
 //   userTappedOnNotEnrolledLink
}

-(void)viewWillAppear:(BOOL)animated
{
    [vHeader drawCoverageYear:[self getPlanIndex]];
    
    int navbarHeight = self.navigationController.navigationBar.frame.size.height + 25; //Extra 25 must be accounted for. It is the status bar height (clock, batttery indicator)
    
    detailTable.frame = CGRectMake(0, vHeader.frame.origin.y + vHeader.frame.size.height + 5, self.view.frame.size.width, self.tabBarController.tabBar.frame.origin.y - navbarHeight - vHeader.frame.size.height);
    
    [self processData];
    
    [detailTable reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
//    detailTable.frame = CGRectMake(10, 65, self.view.frame.size.width - 10, self.tabBarController.view.frame.origin.y - 20);

//    [pieChartRight reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([expandedSections containsIndex:section])
    {
        if (section == 0)
            return 4;
        
        if (section == 1)
            return 1;
        
        return 3;
    }
    
    return 0; // only top row showing
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    
    // Set a custom background color and a border
    //    headerView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
    //    headerView.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;//[UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    //    headerView.layer.borderWidth = 1.0;
    
    headerView.tag = section; 
    
    // Add a label
    UILabel* headerLabel = [[UILabel alloc] init];

    switch (section) {
        case 0:
            headerView.backgroundColor = EMPLOYER_DETAIL_HEADER_DRAWER_RENEWAL;
            break;
        case 1:
            headerView.backgroundColor = EMPLOYER_DETAIL_HEADER_DRAWER_PART;
            break;
        case 2:
            headerView.backgroundColor = EMPLOYER_DETAIL_HEADER_DRAWER_COSTS;
            break;
        default:
            break;
    }
 
    if ([expandedSections containsIndex:section])
    {
        UIImageView *imgVew = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width-50, 9, 32, 32)];
        imgVew.backgroundColor = [UIColor clearColor];
        imgVew.image = [UIImage imageNamed:@"uparrowWHT.png"]; //close_arrow32x32.png
        imgVew.contentMode = UIViewContentModeScaleAspectFit;
        [headerView addSubview:imgVew];
    }
    else
    {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-50, 9, 32, 32)];
        button.layer.cornerRadius = 16;
        button.layer.borderWidth = 2;
        button.layer.borderColor = EMPLOYER_DETAIL_HEADER_DRAWER_TEXT.CGColor;//[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1].CGColor;
        button.clipsToBounds = YES;
        button.tag = section;
//        [button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:EMPLOYER_DETAIL_HEADER_DRAWER_TEXT forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:24.0];
        [button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitle:[NSString stringWithFormat:@"%@", @"+"] forState:UIControlStateNormal];
        [headerView addSubview:button];
    }
    
//    headerView.backgroundColor = UIColorFromRGB(0xebebeb);
    headerLabel.frame = CGRectMake(8, 0, tableView.frame.size.width - 5, 48);
    headerLabel.textColor = EMPLOYER_DETAIL_HEADER_DRAWER_TEXT;//[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];;//UIColorFromRGB(0x007bc4);
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
    
    [detailTable beginUpdates];
    [detailTable reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
    [self tableView:detailTable didSelectHeader:indexPath];
    
    [detailTable endUpdates];

    if ([expandedSections containsIndex:pHeaderView.tag])
        [detailTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)handleButtonTap:(id)sender {
    UIView *pHeaderView = (UIView*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
    
    [detailTable beginUpdates];
    [detailTable reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
    [self tableView:detailTable didSelectHeader:indexPath];
    
    [detailTable endUpdates];
    
    if ([expandedSections containsIndex:pHeaderView.tag])
        [detailTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
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
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 1 && indexPath.row == 0)
    return 240;
  if (indexPath.section == 0 && indexPath.row == 0)
      return 0;//80;
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
 
 //           if (indexPath.section == 1 && indexPath.row == 0)
            {
                int iPos = 170;
                if (self.view.frame.size.width <= 320)
                    iPos = 170;
                else
                    iPos = 200;
                XYPieChart *pieChartRight = [[XYPieChart alloc] initWithFrame:CGRectMake(detailTable.frame.size.width - 170, 60, iPos, iPos)]; //(iPos, 45, iPos, iPos)];
                [pieChartRight setDelegate:self];
                [pieChartRight setDataSource:self];
                [pieChartRight setPieCenter:CGPointMake(60, 60)];
                [pieChartRight setShowPercentage:NO];
                [pieChartRight setLabelColor:[UIColor whiteColor]];
                [pieChartRight setLabelFont:[UIFont fontWithName:@"Roboto-Bold" size:16.0f]];
                pieChartRight.tag = 970;
                
                self.sliceColors =[NSArray arrayWithObjects:
                                   EMPLOYER_DETAIL_PARTICIPATION_ENROLLED,
                                   EMPLOYER_DETAIL_PARTICIPATION_WAIVED,
                                   EMPLOYER_DETAIL_PARTICIPATION_NOT_ENROLLED,
                                   UI_COLOR_PURPLE,
                                   nil];
                
                pieChartRight.hidden = TRUE;
                
                [cell.contentView addSubview:pieChartRight];
 /*
                CGFloat x = UIScreen.mainScreen.applicationFrame.size.width/2;
                CGFloat y = UIScreen.mainScreen.applicationFrame.size.height/2;
                // Offset. If tableView has been scrolled
                CGFloat yOffset = detailTable.contentOffset.y;
*/
                UIActivityIndicatorView *activityIndicator= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(detailTable.frame.size.width - 150, 50, 100, 100)]; //(x - 50, (y + yOffset) - 50, 100, 100)]; //self.view.frame.origin.y
                activityIndicator.layer.cornerRadius = 05;
                activityIndicator.opaque = NO;
                activityIndicator.tag = 3;
                activityIndicator.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;// UIActivityIndicatorViewStyleGray;
                [activityIndicator setColor:[UIColor whiteColor]];
                [cell.contentView addSubview:activityIndicator];
                
                UILabel *pEnrolled = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 50)];
                pEnrolled.tag = 971;
                pEnrolled.hidden = TRUE;
                pEnrolled.numberOfLines = 2;
                pEnrolled.font = [UIFont fontWithName:@"Roboto-Bold" size:15.0f];
                pEnrolled.textColor = EMPLOYER_DETAIL_PARTICIPATION_ENROLLED;//UIColorFromRGB(0x00a99e);
                pEnrolled.backgroundColor = [UIColor clearColor];
                UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnEnrolledLink:)];

                [pEnrolled setUserInteractionEnabled:YES];
                [pEnrolled addGestureRecognizer:gesture];
                [cell.contentView addSubview:pEnrolled];
                /*
                CAGradientLayer *gradient = [CAGradientLayer layer];
                gradient.frame = pEnrolled.bounds;
                UIColor *startColour = [UIColor colorWithHue:.580555 saturation:0.31 brightness:0.90 alpha:1.0];
                UIColor *endColour = [UIColor colorWithHue:.58333 saturation:0.50 brightness:0.62 alpha:1.0];
                gradient.colors = [NSArray arrayWithObjects:(id)[startColour CGColor], (id)[endColour CGColor], nil];
                [pEnrolled.layer insertSublayer:gradient atIndex:0];
                */
                
                UILabel *pWaived = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 150, 50)];
                pWaived.tag = 972;
                pWaived.hidden = TRUE;
                pWaived.numberOfLines = 2;
                pWaived.font = [UIFont fontWithName:@"Roboto-Bold" size:15.0f];
                pWaived.textColor = EMPLOYER_DETAIL_PARTICIPATION_WAIVED; //UIColorFromRGB(0x625ba8);
                pWaived.backgroundColor = [UIColor clearColor];
                UITapGestureRecognizer* gestureWaived = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnWaivedLink:)];
  
                [pWaived setUserInteractionEnabled:YES];
                [pWaived addGestureRecognizer:gestureWaived];
                [cell.contentView addSubview:pWaived];

                
                UILabel *pNotEnrolled = [[UILabel alloc] initWithFrame:CGRectMake(10, 95, 150, 50)];
                pNotEnrolled.tag = 973;
                pNotEnrolled.hidden = TRUE;
                pNotEnrolled.numberOfLines = 2;
                pNotEnrolled.font = [UIFont fontWithName:@"Roboto-Bold" size:15.0f];
                pNotEnrolled.textColor = EMPLOYER_DETAIL_PARTICIPATION_NOT_ENROLLED;
                pNotEnrolled.backgroundColor = [UIColor clearColor];
                UITapGestureRecognizer* gestureNotEnrolled = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnNotEnrolledLink:)];

                [pNotEnrolled setUserInteractionEnabled:YES];
                [pNotEnrolled addGestureRecognizer:gestureNotEnrolled];
                [cell.contentView addSubview:pNotEnrolled];
                
                UILabel *pTerminated = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 150, 50)];
                pTerminated.tag = 974;
                pTerminated.hidden = TRUE;
                pTerminated.numberOfLines = 2;
                pTerminated.font = [UIFont fontWithName:@"Roboto-Bold" size:15.0f];
                pTerminated.textColor = UI_COLOR_PURPLE;
                pTerminated.backgroundColor = [UIColor clearColor];
                UITapGestureRecognizer* gestureTerminated = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnTerminatedLink:)];
                
                [pTerminated setUserInteractionEnabled:YES];
                [pTerminated addGestureRecognizer:gestureTerminated];
                [cell.contentView addSubview:pTerminated];

                
                UILabel *pTotalEmployees = [[UILabel alloc] initWithFrame:CGRectMake(10, 185, 150, 50)];
                pTotalEmployees.tag = 975;
                pTotalEmployees.hidden = TRUE;
                pTotalEmployees.numberOfLines = 2;
                pTotalEmployees.font = [UIFont fontWithName:@"Roboto-Bold" size:15.0f];
                pTotalEmployees.textColor = EMPLOYER_DETAIL_PARTICIPATION_ALL;
                pTotalEmployees.backgroundColor = [UIColor clearColor];
                UITapGestureRecognizer* gestureTotalEmployees = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnTotalLink:)];
                
                [pTotalEmployees setUserInteractionEnabled:YES];
                [pTotalEmployees addGestureRecognizer:gestureTotalEmployees];

                [cell.contentView addSubview:pTotalEmployees];
            }
        
//            if (indexPath.section == 0 && indexPath.row == 0)
            {
                UILabel * labelCoverage = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, tableView.frame.size.width, 50)];
                labelCoverage.tag = 976;
                labelCoverage.hidden = TRUE;
                labelCoverage.numberOfLines = 2;
                labelCoverage.backgroundColor = [UIColor clearColor];
                labelCoverage.font = [UIFont fontWithName:@"Roboto-Bold" size:16];
                labelCoverage.textAlignment = NSTextAlignmentCenter;
                labelCoverage.textColor = UIColorFromRGB(0x555555);
                [cell.contentView addSubview:labelCoverage];

                CGRect sepFrame = CGRectMake(0, 70, tableView.frame.size.width - 10, 1);
                UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
                seperatorView.hidden = TRUE;
                seperatorView.tag = 977;
                seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
                [cell.contentView addSubview:seperatorView];
            }

    }

    XYPieChart *pChart = [cell viewWithTag:970];
    pChart.hidden = TRUE;
    
    UILabel *pEnrolled = [cell viewWithTag:971];
    pEnrolled.hidden = TRUE;

    UILabel *pWaived = [cell viewWithTag:972];
    pWaived.hidden = TRUE;
    
    UILabel *pNotEnrolled = [cell viewWithTag:973];
    pNotEnrolled.hidden = TRUE;

    UILabel *pTerminated = [cell viewWithTag:974];
    pTerminated.hidden = TRUE;

    UILabel *pTotalEmployees = [cell viewWithTag:975];
    pTotalEmployees.hidden = TRUE;

    UILabel *pLabelCoverage = [cell viewWithTag:976];
    pLabelCoverage.hidden = TRUE;
    
    UILabel *pSeperator = [cell viewWithTag:977];
    pSeperator.hidden = TRUE;
    
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";

    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16];
    cell.textLabel.textColor = UIColorFromRGB(0x555555);
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16];
    cell.detailTextLabel.textColor = UIColorFromRGB(0x555555);

    UIActivityIndicatorView *spinner = [cell viewWithTag:3];
    spinner.hidden = TRUE;
    [spinner stopAnimating];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row > 0)
        {
            cell.textLabel.text = [renewalNames objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [renewalValues objectAtIndex:indexPath.row];
        }
        /*
        else
        {
            NSDateFormatter *f = [[NSDateFormatter alloc] init];
            [f setDateFormat:@"yyyy-MM-dd"];

            NSDate *endDate = [f dateFromString:[dictionary valueForKey:@"plan_year_begins"]]; //[f dateFromString:type.billing_report_date];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            [dateComponents setDay:364];
            NSDate *targetDate = [gregorian dateByAddingComponents:dateComponents toDate:endDate  options:0];
            
            [f setDateFormat:@"MMM dd, yyyy"];

            pSeperator.hidden = FALSE;

            pLabelCoverage.backgroundColor = [UIColor clearColor];
            pLabelCoverage.hidden = FALSE;
            NSString *lblCoverageYear = [NSString stringWithFormat:@"%@ - %@\n", [[f stringFromDate:endDate] uppercaseString], [[f stringFromDate:targetDate] uppercaseString]];
            
            NSDictionary *attrs = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x555555) };
            NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:lblCoverageYear attributes:attrs];
            
            NSString *temp_a = @"Coverage Year";
            NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:temp_a];
            [string1 beginEditing];
            [string1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Regular" size:16.0] range:NSMakeRange(0, string1.length)];
            [string1 endEditing];
          
            [attributedTitle appendAttributedString:string1];

            pLabelCoverage.attributedText = attributedTitle;
        }
         */
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
/*
            int emp_total = ([_dictionary valueForKey:@"employees_total"] == (NSString *)[NSNull null]) ? 0:[[_dictionary valueForKey:@"employees_total"] intValue];
            
            int emp_enr = ([_dictionary valueForKey:@"employees_enrolled"] == (NSString *)[NSNull null]) ? 0:[[_dictionary valueForKey:@"employees_enrolled"] intValue];
            
            int emp_waiv = ([_dictionary valueForKey:@"employees_waived"] == (NSString *)[NSNull null]) ? 0:[[_dictionary valueForKey:@"employees_waived"] intValue];
            
            int iNotEnrolled = emp_total - emp_waiv - emp_enr;
*/
            employerTabController *tabBar = (employerTabController *) self.tabBarController;

            pEnrolled.hidden = FALSE;
            pEnrolled.text = [NSString stringWithFormat:@"%@\nENROLLED", (tabBar.enrolled > -1) ? [NSString stringWithFormat:@"%d", tabBar.enrolled]:@"--"];
            
            pWaived.hidden = FALSE;
            pWaived.text = [NSString stringWithFormat:@"%@\nWAIVED", (tabBar.waived > -1) ? [NSString stringWithFormat:@"%d", tabBar.waived]:@"--"];

            pNotEnrolled.hidden = FALSE;
            pNotEnrolled.text = [NSString stringWithFormat:@"%@\nNOT ENROLLED", (tabBar.notenrolled > -1) ? [NSString stringWithFormat:@"%d", tabBar.notenrolled]:@"--"];

            pTerminated.hidden = FALSE;
            pTerminated.text = [NSString stringWithFormat:@"%@\nTERMINATED", (tabBar.terminated > -1) ? [NSString stringWithFormat:@"%d", tabBar.terminated]:@"--"];

            pTotalEmployees.hidden = FALSE;
            pTotalEmployees.text = [NSString stringWithFormat:@"%i\nTOTAL EMPLOYEES", tabBar.enrolled + tabBar.waived + tabBar.notenrolled];
            
            if (dataNotLoaded)
            {
//                UIActivityIndicatorView *spinner = [cell viewWithTag:3];
                spinner.hidden = FALSE;
                [spinner startAnimating];
            }
            else
            {
                spinner.hidden = TRUE;
                [spinner stopAnimating];
                pChart.hidden = FALSE;
                [pChart reloadData];
            }
        }
    }
    else
    {
        cell.textLabel.text = [monthlyCostNames objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [monthlyCostValues objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(void)userTappedOnEnrolledLink:(UIGestureRecognizer*)sender
{
    
    employerTabController *tabBar = (employerTabController *) self.tabBarController;

    tabBar.sortOrder = @"Enrolled";
    tabBar.iPath = nil;
    
    [self.tabBarController setSelectedIndex:1];
}

-(void)userTappedOnWaivedLink:(UIGestureRecognizer*)sender
{
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    tabBar.sortOrder = @"Waived";
    tabBar.iPath = nil;
    
    [self.tabBarController setSelectedIndex:1];
}

-(void)userTappedOnNotEnrolledLink:(UIGestureRecognizer*)sender
{
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    tabBar.sortOrder = @"Not Enrolled";
    tabBar.iPath = nil;
    
    [self.tabBarController setSelectedIndex:1];
}

-(void)userTappedOnTerminatedLink:(UIGestureRecognizer*)sender
{
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    tabBar.sortOrder = @"Terminated";
    tabBar.iPath = nil;
    
    [self.tabBarController setSelectedIndex:1];
}


-(void)userTappedOnTotalLink:(UIGestureRecognizer*)sender
{
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    tabBar.sortOrder = @"";
    tabBar.iPath = nil;
    
    [self.tabBarController setSelectedIndex:1];
}

-(void)changeCoverageYear:(NSInteger)index
{
    employerTabController *tabBar = (employerTabController *) self.tabBarController;


    tabBar.current_coverage_year_index = index;
//    iCurrentPlanIndex = index;
    [self processData];
    [detailTable reloadData];
}

-(NSInteger)getPlanIndex
{
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    return tabBar.current_coverage_year_index;
}
@end
