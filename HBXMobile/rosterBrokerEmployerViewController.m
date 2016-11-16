//
//  rosterBrokerEmployerViewController.m
//  HBXMobile
//
//  Created by John Boyd on 9/14/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "rosterBrokerEmployerViewController.h"
#import "EmployeeProfileViewController.h"
#import "Constants.h"

@interface rosterBrokerEmployerViewController ()

@end

@implementation rosterBrokerEmployerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveRosterNotification:)
                                                 name:@"rosterLoaded"
                                               object:nil];
    
    UIActivityIndicatorView *activityIndicator= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
    activityIndicator.layer.cornerRadius = 05;
    activityIndicator.opaque = NO;
    activityIndicator.tag = 44;
    activityIndicator.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    activityIndicator.center = self.view.center;
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;// UIActivityIndicatorViewStyleGray;
    [activityIndicator setColor:[UIColor colorWithRed:0.6 green:0.8 blue:1.0 alpha:1.0]];
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];

    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    employerData = tabBar.employerData;
    _enrollHost = tabBar.enrollHost;
    _customCookie_a = tabBar.customCookie_a;
    
    navImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 0, 200, 40)];
    
    navImage.backgroundColor = [UIColor clearColor];
    navImage.image = [UIImage imageNamed:@"navHeader"];
    navImage.contentMode = UIViewContentModeCenter;
    
    self.navigationController.topViewController.navigationItem.titleView = navImage;
    
    //self.navigationController.topViewController.title = @"info";
    vHeader.frame = CGRectMake(0,0,self.view.frame.size.width,185);
//    [vHeader layoutHeaderView:employerData];
    vHeader.delegate = self;
    //[vHeader layoutHeaderView:employerData];
    [vHeader layoutHeaderView:employerData showcoverage:YES showplanyear:NO];
/*
    pCompany.font = [UIFont fontWithName:@"Roboto-Bold" size:24];
    pCompany.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, 65);
    
    pCompany.textAlignment = NSTextAlignmentCenter;
    pCompany.text = employerData.companyName;
    
    pCompanyFooter.frame = CGRectMake(10, pCompany.frame.origin.y + pCompany.frame.size.height, self.view.frame.size.width - 20, pCompanyFooter.frame.size.height);
    pCompanyFooter.textAlignment = NSTextAlignmentCenter;
    //    pCompanyFooter.backgroundColor = [UIColor greenColor];
    
    if (employerData.status == (enrollmentState)NEEDS_ATTENTION)
    {
        pCompanyFooter.text = NSLocalizedString(@"TITLE_NOTE", @"OPEN ENROLLMENT IN PROGRESS - MINIMUM NOT MET");
        pCompanyFooter.textColor = [UIColor redColor];
        
    }
    else if (employerData.status == (enrollmentState)OPEN_ENROLLMENT_MET)
    {
        pCompanyFooter.text = @"OPEN ENROLLMENT IN PROGRESS";
        pCompanyFooter.textColor = [UIColor colorWithRed:218.0f/255.0f green:165.0f/255.0f blue:32.0f/255.0f alpha:1.0f]; //[UIColor yellowColor];
        
    }
    else if (employerData.status == (enrollmentState)RENEWAL_IN_PROGRESS)
    {
        pCompanyFooter.text = @"RENEWAL PENDING"; //@"RENEWAL IN PROGRESS";
        pCompanyFooter.textColor = [UIColor colorWithRed:218.0f/255.0f green:165.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
    }
    else if (employerData.status == (enrollmentState)NO_ACTION_REQUIRED)
    {
        pCompanyFooter.text = @"IN COVERAGE";
        pCompanyFooter.textColor = [UIColor colorWithRed:0.0f/255.0f green:139.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    }
 */
    slideView = [[UISlideView alloc] init];//]WithFrame:CGRectMake(self.view.frame.size.width, pRosterTable.frame.origin.y + 44, 200, 200)];
    slideView.backgroundColor = [UIColor clearColor];
    slideView.delegate = self;
    
    [self.view addSubview:slideView];
    
    pRosterTable.sectionIndexColor = [UIColor darkGrayColor];
    pRosterTable.sectionIndexBackgroundColor = [UIColor clearColor];
    
//    if (tabBar.rosterList == nil)
//        [self loadDictionary];
//    else
//    {
        displayArray = tabBar.rosterList;
        [self setDataSectionIndex];
//    }
    
    bFilterOpen = FALSE;
/*
    NSMutableSet *firstCharacters = [NSMutableSet setWithCapacity:0];
    
    for( NSString *string in [rosterList valueForKey:@"first_name"])
        [firstCharacters addObject:[NSString stringWithString:[string substringToIndex:1]]];
    
    sectionIndex = [[firstCharacters allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
 */
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
    
}

-(void)viewWillAppear:(BOOL)animated
{
    employerTabController *tabBar = (employerTabController *) self.tabBarController;

    pRosterTable.frame = CGRectMake(0, vHeader.frame.origin.y + vHeader.frame.size.height + 5, self.view.frame.size.width, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height);
    slideView.frame = CGRectMake(self.view.frame.size.width, pRosterTable.frame.origin.y + 34, 200, pRosterTable.frame.size.height - 34);
    
    if ([tabBar.sortOrder isEqualToString:@"show all"] || [tabBar.sortOrder length] == 0)
    {
        displayArray =  tabBar.rosterList;
        [pRosterTable reloadData];
        return;
    }
    if (tabBar.iPath == nil)
    {
        NSIndexPath *myIP;
        
        if ([tabBar.sortOrder isEqualToString:@"Enrolled"])
            myIP = [NSIndexPath indexPathForRow:0 inSection:0];
        
        if ([tabBar.sortOrder isEqualToString:@"Waived"])
            myIP = [NSIndexPath indexPathForRow:1 inSection:0];

        if ([tabBar.sortOrder isEqualToString:@"Not Enrolled"])
            myIP = [NSIndexPath indexPathForRow:2 inSection:0];

        if ([tabBar.sortOrder isEqualToString:@"Terminated"])
            myIP = [NSIndexPath indexPathForRow:3 inSection:0];
            
        [self sortByStatus:myIP];
    }
    else
        [self sortByStatus:tabBar.iPath];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDataSectionIndex
{
    NSMutableSet *firstCharacters = [NSMutableSet setWithCapacity:0];
//    double employer_contribution = 0;
//    double employee_cost = 0;
    
//    for( NSString *string in [displayArray valueForKey:@"last_name"])
    for (id myArrayElement in displayArray)
    {
        NSString *string = [myArrayElement valueForKey:@"last_name"];
        [firstCharacters addObject:[NSString stringWithString:[string substringToIndex:1]]];
/*
        NSString *oo = [[[[[myArrayElement valueForKey:@"enrollments"] valueForKey:@"renewal"] valueForKey:@"health"] valueForKey:@"employer_contribution"] stringValue];
        NSString *ll =  [[[[[myArrayElement valueForKey:@"enrollments"] valueForKey:@"renewal"] valueForKey:@"health"] valueForKey:@"employee_cost"] stringValue];

        employer_contribution += [oo doubleValue];
        employee_cost += [ll doubleValue];
 */
    }
    
    sectionIndex = [[firstCharacters allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    bDataLoading = FALSE;
    
    [pRosterTable reloadData];
    UIActivityIndicatorView *activityIndicator = [self.view viewWithTag:44];
    [activityIndicator stopAnimating];
    
    [activityIndicator removeFromSuperview];
    
}

-(void)receiveRosterNotification:(NSNotification *) notification
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"last_name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    // rosterList = [[dictionary valueForKey:@"roster"] sortedArrayUsingDescriptors:sortDescriptors];
//    tabBar.rosterList = [[dictionary valueForKey:@"roster"] sortedArrayUsingDescriptors:sortDescriptors];
    
    displayArray = tabBar.rosterList;//rosterList;
    
    [self setDataSectionIndex];
}

-(void)loadDictionary
{
    NSString *pUrl;
    NSString *e_url = employerData.roster_url;

    bDataLoading = TRUE;
    
    if (! [e_url hasPrefix:@"https://"] && ![e_url hasPrefix:@"http://"])
        pUrl = [NSString stringWithFormat:@"%@%@", _enrollHost, employerData.roster_url];
    else
        pUrl = employerData.roster_url;

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
            // check status code and possibly MIME type (which shall start with "application/json"):
  //          NSRange range = [response.MIMEType rangeOfString:@"application/json"];
            
            if (httpResponse.statusCode == 200) { // /* OK */ && range.length != 0) {
                NSError* error;
                id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (jsonObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // self.model = jsonObject;
                        NSLog(@"jsonObject: %@", jsonObject);
                        dictionary = jsonObject;
                        
                        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"last_name" ascending:YES];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
                        
                        employerTabController *tabBar = (employerTabController *) self.tabBarController;
                        
                        // rosterList = [[dictionary valueForKey:@"roster"] sortedArrayUsingDescriptors:sortDescriptors];
                        tabBar.rosterList = [[dictionary valueForKey:@"roster"] sortedArrayUsingDescriptors:sortDescriptors];
                        
                        displayArray = tabBar.rosterList;//rosterList;

                        [self setDataSectionIndex];
                        
                        /*
                        dictionary = jsonObject;
                        
                        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"last_name" ascending:YES];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
                        
                        employerTabController *tabBar = (employerTabController *) self.tabBarController;

                       // rosterList = [[dictionary valueForKey:@"roster"] sortedArrayUsingDescriptors:sortDescriptors];
                        tabBar.rosterList = [[dictionary valueForKey:@"roster"] sortedArrayUsingDescriptors:sortDescriptors];
                        
                        displayArray = tabBar.rosterList;//rosterList;

                        NSMutableSet *firstCharacters = [NSMutableSet setWithCapacity:0];
                        
                        for( NSString *string in [displayArray valueForKey:@"last_name"])
                            [firstCharacters addObject:[NSString stringWithString:[string substringToIndex:1]]];
                        
                        sectionIndex = [[firstCharacters allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

                        [pRosterTable reloadData];
                        UIActivityIndicatorView *activityIndicator = [self.view viewWithTag:44];
                        [activityIndicator stopAnimating];
                        
                        [activityIndicator removeFromSuperview];
                         */

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

-(void)loadDictionary1
{
    NSString *pUrl;// = [NSString stringWithFormat:@"%@%@", _enrollHost, employerData.detail_url];
    NSString *e_url = employerData.detail_url;
    //if (![e_url hasPrefix:@"http://"] || ![e_url hasPrefix:@"https://"])
    BOOL pp = [e_url hasPrefix:@"https://"];
    BOOL ll = [e_url hasPrefix:@"http://"];
    if (!pp && !ll)
        pUrl = [NSString stringWithFormat:@"%@%@", _enrollHost, employerData.roster_url];
    else
        pUrl = employerData.roster_url;
    
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
//    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/dchealthlink/HBX-mobile-app-APIs/master/enroll/broker/employers_list/response/example.json"];
//    data = [NSData dataWithContentsOfURL:url];
    
    if (error == nil)
    {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    
//    rosterList = [dictionary valueForKey:@"roster"];//[0];// valueForKey:@"roster"][0];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"last_name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
    
    rosterList = [[dictionary valueForKey:@"roster"] sortedArrayUsingDescriptors:sortDescriptors];

    displayArray = rosterList;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (bDataLoading)
        return 0;
    
    NSInteger actualNumberOfRows = [displayArray count];
    return (actualNumberOfRows == 0) ? 1:actualNumberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 34.0f;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pRosterTable.frame.size.width, headerHeight)];

    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;// | UIViewAutoresizingFlexibleHeight;
    headerView.backgroundColor = UIColorFromRGB(0xebebeb);//UIColorFromRGB(0xD9D9D9);
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, pRosterTable.frame.size.width/2, headerHeight)];
    label.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];//[UIColor clearColor];
    label.font = [UIFont fontWithName:@"Roboto-BOLD" size:15];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = UIColorFromRGB(0x555555);//[UIColor colorWithRed:79.0f/255.0f green:148.0f/255.0f blue:205.0f/255.0f alpha:1.0f];//[UIColor darkGrayColor];
if ([displayArray count] == 0)
    label.text = @"NAME";
else
    label.text = [NSString stringWithFormat:@"NAME (%ld employees)", [displayArray count]]; //@"NAME";

    [headerView addSubview:label];
/*
    UILabel *lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(pRosterTable.frame.size.width/2, 0, pRosterTable.frame.size.width/2 - 10, headerHeight)];
    lblStatus.backgroundColor = [UIColor clearColor];
    lblStatus.font = [UIFont fontWithName:@"Roboto-BOLD" size:15];
    lblStatus.lineBreakMode = NSLineBreakByWordWrapping;
    lblStatus.numberOfLines = 1;
    lblStatus.textAlignment = NSTextAlignmentRight;
    lblStatus.textColor = UIColorFromRGB(0x555555);
    lblStatus.text = @"STATUS";
    lblStatus.userInteractionEnabled = YES;
 */

    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(pRosterTable.frame.size.width/2, 0, pRosterTable.frame.size.width/2 - 10, headerHeight)];
//    button.layer.cornerRadius = 16;
//    button.layer.borderWidth = 2;
//    button.layer.borderColor = [UIColor whiteColor].CGColor;
//    button.clipsToBounds = YES;
    [button setBackgroundColor:[UIColor clearColor]];
    button.tag = 77;//section;
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    button.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:15.0];
    [button addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"STATUS" forState:UIControlStateNormal];
//    [Button addTarget:self action:@selector(doSomething:) forControlEvents:UIControlEventTouchUpInside];
//    [button addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
    UIImage *pImage = [UIImage imageNamed:@"OpenCaret.png"];
    [button setImage:pImage forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0., button.frame.size.width - (pImage.size.width + 15.), 0., 0.);
    button.titleEdgeInsets = UIEdgeInsetsMake(0., 0., 0., pImage.size.width);
    
    [headerView addSubview:button];
    
//    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
 //   [lblStatus addGestureRecognizer:recognizer];

    return headerView;
}

- (void)setBgColorForButton:(UIButton *)sender {
        [sender setBackgroundColor:[UIColor blackColor]];
}

- (void)handleTap:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor clearColor]];
    UIImage *pImage;
    
    if ((bFilterOpen = [slideView handleLeftSwipe]))
        pImage = [UIImage imageNamed:@"CloseCaret.png"];
    else
        pImage = [UIImage imageNamed:@"OpenCaret.png"];
    
    [sender setImage:pImage forState:UIControlStateNormal];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *indexes = [tableView indexPathsForVisibleRows];
    if ([indexes count] >= [sectionIndex count])
        return nil;
    return sectionIndex;//[[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", nil];
}
/*
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //sectionIndex was pArray
    NSIndexSet *indexes = [sectionIndex indexesOfObjectsPassingTest:^BOOL(NSString *string, NSUInteger idx, BOOL *stop) {
     //   *stop = TRUE;
        return [string hasPrefix:title];
    }];
    
    int uu = [indexes firstIndex];
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[indexes firstIndex] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return 1;
}
*/
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    NSInteger newRow = [self indexForFirstChar:title inArray:displayArray];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
    [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    return index;
}

// Return the index for the location of the first item in an array that begins with a certain character
- (NSInteger)indexForFirstChar:(NSString *)character inArray:(NSArray *)array
{
    NSUInteger count = 0;
    for (NSString *str in array) {
        if ([[str valueForKey:@"last_name"] hasPrefix:character]) {
            return count;
        }
        count++;
    }
    return 0;
}
/*
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    // Find the correct index of cell should scroll to.
    int foundIndex = 0;
    for (Object *obj in dataArray) {
        if ([[[obj.YOURNAME substringToIndex:1] uppercaseString] compare:title] == NSOrderedSame || [[[obj.YOURNAME substringToIndex:1] uppercaseString] compare: title] == NSOrderedDescending)
            break;
        foundIndex++;
    }
    if(foundIndex >= [dataArray count])
        foundIndex = [dataArray count]-1;
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:foundIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return 1;
}
*/

-(NSString*)getRenewalEnrollment:(NSInteger)row
{
    NSArray *pk = [[displayArray objectAtIndex:row] valueForKey:@"enrollments"];
    
    for (int ii=0;ii<[pk count];ii++)
    {
        NSDictionary *pp = [[displayArray objectAtIndex:row] valueForKey:@"enrollments"][ii]; //[pk value:ii];
        
        NSString *a;
        NSString *b;
        NSString *c;
        
        a = [pp valueForKey:@"coverage_kind"];
        b = [pp valueForKey:@"period_type"];
        c = [pp valueForKey:@"status"];
        
        if ([b isEqualToString:@"renewal"])
            if ([a isEqualToString:@"health"])
                return c;

        NSLog(@"%@    ---   %@   -----   %@", a,b,c);
        
    }
    return nil;
}

-(NSString*)getActiveEnrollment:(NSInteger)row
{
    NSArray *pk = [[displayArray objectAtIndex:row] valueForKey:@"enrollments"];
    
    for (int ii=0;ii<[pk count];ii++)
    {
//        NSDictionary *pp = [[rosterList objectAtIndex:row] valueForKey:@"enrollments"][ii]; //[pk value:ii];
        NSDictionary *pp = [[[[[displayArray objectAtIndex:row] valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"status"];//[ii]; //[pk value:ii];
        
        NSString *a;
        NSString *b;
        NSString *c;
        
        a = [pp valueForKey:@"coverage_kind"];
        b = [pp valueForKey:@"period_type"];
        c = [pp valueForKey:@"status"];
    
        if ([b isEqualToString:@"active"])
            if ([a isEqualToString:@"health"])
                return c;
        
        NSLog(@"%@    ---   %@   -----   %@", a,b,c);
        
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
/*
        UILabel* detailLabel_1 = [[UILabel alloc] init];
        detailLabel_1.frame = CGRectMake(10, 17, tableView.frame.size.width, 10);
        detailLabel_1.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
        detailLabel_1.tag = 33;
        detailLabel_1.hidden = FALSE;
        [cell.contentView addSubview:detailLabel_1];
*/
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16];

    cell.textLabel.textColor = UIColorFromRGB(0x555555);
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[rosterList objectAtIndex:indexPath.row] valueForKey:@"first_name"],[[rosterList objectAtIndex:indexPath.row] valueForKey:@"last_name"]];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    if ([displayArray count] == 0)
    {
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
        cell.textLabel.text = @"No data for selected filter";
        cell.detailTextLabel.text = @"";
        cell.detailTextLabel.attributedText = nil;
        return cell;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[displayArray objectAtIndex:indexPath.row] valueForKey:@"first_name"],[[displayArray objectAtIndex:indexPath.row] valueForKey:@"last_name"]];
    

    NSDictionary *attrs;// = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x00a99e)};//UIColorFromRGB(0x00a3e2) };
    NSString *sActive = [[[[[displayArray objectAtIndex:indexPath.row] valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"status"];//[ii]; //[pk value:ii];

 //   [self getActiveEnrollment:indexPath.row];
    if ([sActive isEqualToString:@"Enrolled"])
        attrs = @{ NSForegroundColorAttributeName : EMPLOYER_DETAIL_PARTICIPATION_ENROLLED};
    else if ([sActive isEqualToString:@"Not Enrolled"])
        attrs = @{ NSForegroundColorAttributeName : EMPLOYER_DETAIL_PARTICIPATION_NOT_ENROLLED};
    else if ([sActive isEqualToString:@"Terminated"])
        attrs = @{ NSForegroundColorAttributeName : EMPLOYER_DETAIL_PARTICIPATION_TERMINATED};
    else
        attrs = @{ NSForegroundColorAttributeName : EMPLOYER_DETAIL_PARTICIPATION_WAIVED};

    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:sActive attributes:attrs];
                             
    NSString *sRenewal = [[[[[displayArray objectAtIndex:indexPath.row] valueForKey:@"enrollments"] valueForKey:@"renewal"] valueForKey:@"health"] valueForKey:@"status"];//[ii]; //[pk value:ii];
//[self getRenewalEnrollment:indexPath.row];
    if (sRenewal != nil)
    {
        NSDictionary *attrsRenew;
        if ([sRenewal isEqualToString:@"Enrolled"])
            attrsRenew = @{ NSForegroundColorAttributeName : EMPLOYER_DETAIL_PARTICIPATION_ENROLLED};
        else if ([sRenewal isEqualToString:@"Not Enrolled"])
            attrsRenew = @{ NSForegroundColorAttributeName : EMPLOYER_DETAIL_PARTICIPATION_NOT_ENROLLED};
        else if ([sRenewal isEqualToString:@"Terminated"])
            attrsRenew = @{ NSForegroundColorAttributeName : EMPLOYER_DETAIL_PARTICIPATION_TERMINATED};
        else
            attrsRenew = @{ NSForegroundColorAttributeName : EMPLOYER_DETAIL_PARTICIPATION_WAIVED};
        
        NSMutableAttributedString *attributedTitle1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@ %@",sRenewal, @"for next year"] attributes:attrsRenew];
        
        [attributedTitle1 beginEditing];
        [attributedTitle1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:12] range:NSMakeRange(0, attributedTitle1.length)];
        [attributedTitle1 endEditing];
        
        [attributedTitle appendAttributedString:attributedTitle1];

        cell.detailTextLabel.numberOfLines = 2;
    }
    cell.detailTextLabel.attributedText = attributedTitle;

//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@ for next year", [self getActiveEnrollment:indexPath.row], [self getRenewalEnrollment:indexPath.row]];
    
//    cell.detailTextLabel.text = [self getActiveEnrollment:indexPath.row];
//    cell.detailTextLabel.textColor = UIColorFromRGB(0x00a99e);

 /*
    if (indexPath.row > 10)
    {
        cell.detailTextLabel.text = @"Enrolled";
        cell.detailTextLabel.textColor = UIColorFromRGB(0x00a99e);
    }
    else
    {
        cell.detailTextLabel.text = @"Waived";
        cell.detailTextLabel.textColor = UIColorFromRGB(0x00a99e);
    }
  */
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowEmployeeProfile"])
    {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Get destination view
        EmployeeProfileViewController *vc = [segue destinationViewController];
        vc.employeeData = (NSArray*)sender;
        vc.employerData = employerData;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (bFilterOpen)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
  //      (bFilterOpen = [slideView handleLeftSwipe]);
        UIImage *pImage;
        
        if ((bFilterOpen = [slideView handleLeftSwipe]))
            pImage = [UIImage imageNamed:@"CloseCaret.png"];
        else
            pImage = [UIImage imageNamed:@"OpenCaret.png"];
        
        UIButton *pbut = [self.view viewWithTag:77];
        [pbut setImage:pImage forState:UIControlStateNormal];

        return;
    }
    
    NSArray *po = [displayArray objectAtIndex:indexPath.row] ;
    [self performSegueWithIdentifier:@"ShowEmployeeProfile" sender:po];
}

-(void)sortByStatus:(NSIndexPath*)idx
{
    NSPredicate *predicate;
    NSString *substring = @"Enrolled";
    NSString *type = @"active";
    employerTabController *tabBar = (employerTabController *) self.tabBarController;

    bFilterOpen = FALSE;
    
    if (idx.section == 2)
        displayArray =  tabBar.rosterList;
    else
    {
        if (idx.section == 0)
            type = @"active";
        else
            type = @"renewal";
        
        switch (idx.row) {
            case 0:
                substring = @"Enrolled";
                break;
            case 1:
                substring = @"Waived";
                break;
            case 2:
                substring = @"Not Enrolled";
                break;
            case 3:
                substring = @"Terminated";
                break;
           default:
                break;
        }
//        predicate = [NSPredicate predicateWithFormat:@"enrollments.active.health.status contains[c] %@", substring];
        predicate = [NSPredicate predicateWithFormat:@"enrollments.%@.health.status == %@", type, substring];
        
        NSArray *filteredKeys = [tabBar.rosterList filteredArrayUsingPredicate:predicate];
        
        displayArray = filteredKeys;
    }
    
    NSMutableSet *firstCharacters = [NSMutableSet setWithCapacity:0];
    
    for( NSString *string in [displayArray valueForKey:@"first_name"])
        [firstCharacters addObject:[NSString stringWithString:[string substringToIndex:1]]];
    
    sectionIndex = [[firstCharacters allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    [pRosterTable reloadData];
    
    ((employerTabController *) self.tabBarController).sortOrder = substring;
    ((employerTabController *) self.tabBarController).iPath = idx;
}
@end
