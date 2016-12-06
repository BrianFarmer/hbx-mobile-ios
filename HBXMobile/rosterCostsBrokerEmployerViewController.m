//
//  rosterCostsBrokerEmployerViewController.m
//  HBXMobile
//
//  Created by John Boyd on 9/15/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "rosterCostsBrokerEmployerViewController.h"
#import "EmployeeProfileViewController.h"
#import "constants.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface rosterCostsBrokerEmployerViewController ()

@end

@implementation rosterCostsBrokerEmployerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

//    employerData = tabBar.employerData;
    _enrollHost = tabBar.enrollHost;
    _customCookie_a = tabBar.customCookie_a;
    
    navImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 0, 200, 40)];
    
    navImage.backgroundColor = [UIColor clearColor];
    navImage.image = [UIImage imageNamed:@"navHeader"];
    navImage.contentMode = UIViewContentModeCenter;
    
    self.navigationController.topViewController.navigationItem.titleView = navImage;
    
    vHeader.frame = CGRectMake(0,0,self.view.frame.size.width,185);
//    [vHeader layoutHeaderView:employerData];
    vHeader.delegate = self;
    //[vHeader layoutHeaderView:employerData];
    [vHeader layoutHeaderView:tabBar.detailDictionary showcoverage:YES showplanyear:NO];
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
    pRosterTable.sectionIndexColor = [UIColor darkGrayColor];
    pRosterTable.sectionIndexBackgroundColor = [UIColor clearColor];
    
//    [self loadDictionary];
    if (tabBar.rosterList == nil)
        [self loadDictionary];
    else
    {
        rosterList = tabBar.rosterList;
        [self setDataSectionIndex];
    }

/*
    NSMutableSet *firstCharacters = [NSMutableSet setWithCapacity:0];
    
    for( NSString *string in pArray)
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
    pRosterTable.frame = CGRectMake(0, vHeader.frame.origin.y + vHeader.frame.size.height + 5, self.view.frame.size.width, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height);

    if ([rosterList count] > 0)
    {
        employerTabController *tabBar = (employerTabController *) self.tabBarController;
        
        int iCnt = 0;
        NSArray *pp1 = [[rosterList objectAtIndex:0] valueForKey:@"enrollments"];
        for (id py in pp1)
        {
            NSString *sPlanYear = [[employerData.plans objectAtIndex:tabBar.current_coverage_year_index] valueForKey:@"plan_year_begins"];
            if ([[py valueForKey:@"start_on"] isEqualToString:sPlanYear])
                enrollmentIndex = iCnt;
            iCnt++;
        }
        }
    
    [vHeader drawCoverageYear:[self getPlanIndex]];
    
    [pRosterTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDataSectionIndex
{
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    NSMutableSet *firstCharacters = [NSMutableSet setWithCapacity:0];
    
    for( NSString *string in [tabBar.rosterList valueForKey:@"last_name"])
        [firstCharacters addObject:[NSString stringWithString:[string substringToIndex:1]]];
    
    sectionIndex = [[firstCharacters allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    [pRosterTable reloadData];
    UIActivityIndicatorView *activityIndicator = [self.view viewWithTag:44];
    [activityIndicator stopAnimating];
    
    [activityIndicator removeFromSuperview];
    
}

-(void)loadDictionary
{
    NSString *pUrl;
    NSString *e_url = employerData.roster_url;
    
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
                         rosterList = [[dictionary valueForKey:@"roster"] sortedArrayUsingDescriptors:sortDescriptors];
                         tabBar.rosterList = rosterList;
                         
                        [self setDataSectionIndex];
   //                      displayArray = rosterList;
/*
                         NSMutableSet *firstCharacters = [NSMutableSet setWithCapacity:0];
                         
                         for( NSString *string in [rosterList valueForKey:@"last_name"])
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
    NSString *pUrl;
    NSString *e_url = employerData.detail_url;

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
    
    if (error == nil)
    {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    
//    rosterList = [dictionary valueForKey:@"roster"];//[0];// valueForKey:@"roster"][0];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"last_name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];

    rosterList = [[dictionary valueForKey:@"roster"] sortedArrayUsingDescriptors:sortDescriptors];
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
    return [rosterList count];
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
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat headerHeight = 34.0f;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pRosterTable.frame.size.width, headerHeight)];
    
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;// | UIViewAutoresizingFlexibleHeight;
    headerView.backgroundColor = UIColorFromRGB(0xebebeb);//UIColorFromRGB(0xD9D9D9);
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, headerHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Roboto-Bold" size:(iOSDeviceScreenSize.width > 320) ? 15:13];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = UIColorFromRGB(0x555555);
    label.text = @"NAME";
    
    [headerView addSubview:label];
    
    int iLabelWidth = (iOSDeviceScreenSize.width > 320) ? 110:100;

    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width - (iLabelWidth*2), 0, iLabelWidth, headerHeight)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont fontWithName:@"Roboto-Bold" size:(iOSDeviceScreenSize.width > 320) ? 15:13];
    label1.lineBreakMode = NSLineBreakByWordWrapping;
    label1.numberOfLines = 1;
    label1.textAlignment = NSTextAlignmentCenter;

    label1.textColor = UIColorFromRGB(0x555555);
    label1.text = @"EMPLOYER";
    label1.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label1];

    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - iLabelWidth, 0, iLabelWidth, headerHeight)];
    [button setBackgroundColor:[UIColor clearColor]];
    button.tag = section;
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (iOSDeviceScreenSize.width > 320) ? 20:10);
    button.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:(iOSDeviceScreenSize.width > 320) ? 15:13];
//    [button addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"EMPLOYEE" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    [headerView addSubview:button];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    int iLabelWidth = (iOSDeviceScreenSize.width > 320) ? 110:100;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        UILabel* detailLabel = [[UILabel alloc] init];
        detailLabel.frame = CGRectMake(5, 0, tableView.frame.size.width - (iLabelWidth * 2), 44);
        detailLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:(iOSDeviceScreenSize.width > 320) ? 16:14];
        detailLabel.tag = 33;
        detailLabel.hidden = FALSE;
        detailLabel.numberOfLines = 0;
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.textColor = UIColorFromRGB(0x555555);
     //   detailLabel.backgroundColor = [UIColor greenColor];
        [cell.contentView addSubview:detailLabel];
        
        UILabel* detailLabel_2 = [[UILabel alloc] init];
        detailLabel_2.frame = CGRectMake(tableView.frame.size.width - iLabelWidth - iLabelWidth, 12, iLabelWidth, 20);
        detailLabel_2.font = [UIFont fontWithName:@"Roboto-Bold" size:(iOSDeviceScreenSize.width > 320) ? 16:14];
        detailLabel_2.tag = 34;
        detailLabel_2.hidden = FALSE;
        detailLabel_2.textAlignment = NSTextAlignmentCenter;
        detailLabel_2.textColor = UIColorFromRGB(0x555555);
        [cell.contentView addSubview:detailLabel_2];
        
        UILabel* detailLabel_3 = [[UILabel alloc] init];
        detailLabel_3.frame = CGRectMake(tableView.frame.size.width - iLabelWidth - 3, 12, iLabelWidth, 20);
        detailLabel_3.font = [UIFont fontWithName:@"Roboto-Bold" size:(iOSDeviceScreenSize.width > 320) ? 16:14];
        detailLabel_3.tag = 35;
        detailLabel_3.hidden = FALSE;
        detailLabel_3.textAlignment = NSTextAlignmentCenter;
        detailLabel_3.textColor = UIColorFromRGB(0x555555);
        [cell.contentView addSubview:detailLabel_3];
         
    }
    
    UILabel *dt1 = [cell viewWithTag:33];
    UILabel *dt2 = [cell viewWithTag:34];
    UILabel *dt3 = [cell viewWithTag:35];

    dt1.textColor = UIColorFromRGB(0x555555);
    dt2.textColor = UIColorFromRGB(0x555555);
    dt3.textColor = UIColorFromRGB(0x555555);
/*
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:(iOSDeviceScreenSize.width > 320) ? 16:14];
    cell.textLabel.textColor = UIColorFromRGB(0x555555);
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[rosterList objectAtIndex:indexPath.row] valueForKey:@"first_name"],[[rosterList objectAtIndex:indexPath.row] valueForKey:@"last_name"]];
*/

    dt1.text = [NSString stringWithFormat:@"%@ %@", [[rosterList objectAtIndex:indexPath.row] valueForKey:@"first_name"],[[rosterList objectAtIndex:indexPath.row] valueForKey:@"last_name"]];

//    NSArray *pp1 = [[rosterList objectAtIndex:indexPath.row] valueForKey:@"enrollments"];
    
 //   NSArray *pp = [[[rosterList objectAtIndex:indexPath.row] valueForKey:@"enrollments"] valueForKey:@"health"];
    
    NSArray *pp1 = [[rosterList objectAtIndex:indexPath.row] valueForKey:@"enrollments"];
    NSString *sStatus = @"Not Enrolled";
    NSArray *pp;
    
    if ([pp1 count] > 0)
    {
        pp = [[[[rosterList objectAtIndex:indexPath.row] valueForKey:@"enrollments"] objectAtIndex:enrollmentIndex]  valueForKey:@"health"];
        
        sStatus = [pp valueForKey:@"status"];
    }
    
 //   NSArray *pp = [[[[rosterList objectAtIndex:indexPath.row] valueForKey:@"enrollments"] objectAtIndex:enrollmentIndex]  valueForKey:@"health"];
    
 //   NSString *sStatus = [pp valueForKey:@"status"];

/*
    NSString *oo = [[[[[[rosterList objectAtIndex:indexPath.row] valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"employer_contribution"] stringValue];
    NSString *ll =  [[[[[[rosterList objectAtIndex:indexPath.row] valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"employee_cost"] stringValue];
*/
    NSString *oo = [[pp valueForKey:@"employer_contribution"] stringValue];
    NSString *ll =  [[pp valueForKey:@"employee_cost"] stringValue];
    
    /*
    NSDictionary *dictEmployerContribution = [[pp valueForKey:@"employer_contribution"] objectAtIndex:0];
    NSDictionary *dictEmployeeCost = [[pp valueForKey:@"employee_cost"] objectAtIndex:0];

    NSString *sEmployerContribution = ([dictEmployerContribution isKindOfClass:[NSNull class]]) ? @"0" : [NSString stringWithFormat:@"%@", dictEmployerContribution];
    NSString *sEmployerCost = ([dictEmployeeCost isKindOfClass:[NSNull class]]) ? @"0" : [NSString stringWithFormat:@"%@", dictEmployeeCost];
*/
    if ([oo isEqualToString:@"0"] || !oo)
    {
     //   NSDictionary *courseDetail = [[pp valueForKey:@"status"] objectAtIndex:0];
        
      //  NSString *sStatus = [NSString stringWithFormat:@"%@", courseDetail];
        dt3.text = sStatus;
        
/*
        dt2.text = [[[[[rosterList objectAtIndex:indexPath.row] valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"status"];;
        dt3.text =  [[[[[rosterList objectAtIndex:indexPath.row] valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"status"];
 */
        if ([dt3.text isEqualToString:@"Waived"])
        {
            dt2.textColor = EMPLOYER_DETAIL_PARTICIPATION_WAIVED;//UIColorFromRGB(0x625ba8);
            dt3.textColor = EMPLOYER_DETAIL_PARTICIPATION_WAIVED;//UIColorFromRGB(0x625ba8);
        }
        
        if ([dt3.text isEqualToString:@"Not Enrolled"])
        {
            dt2.textColor = EMPLOYER_DETAIL_PARTICIPATION_NOT_ENROLLED;
            dt3.textColor = EMPLOYER_DETAIL_PARTICIPATION_NOT_ENROLLED;
        }

        if ([dt3.text isEqualToString:@"Terminated"])
        {
            dt2.textColor = EMPLOYER_DETAIL_PARTICIPATION_TERMINATED;
            dt3.textColor = EMPLOYER_DETAIL_PARTICIPATION_TERMINATED;
        }

    }
    else
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [numberFormatter setMaximumFractionDigits:2];
        
//        sEmployerContribution = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[sEmployerContribution floatValue]]];
//        sEmployerCost = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[sEmployerCost floatValue]]];
                oo = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[oo floatValue]]];
               ll = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[ll floatValue]]];
     
        //        pCompany.employee_contribution = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[ck valueForKeyPath:@"estimated_premium.employee_contribution"] floatValue]]];
        //        pCompany.employer_contribution = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[ck valueForKeyPath:@"estimated_premium.employer_contribution"] floatValue]]];

        dt2.text = oo;//[NSString stringWithFormat:@"$%@", oo];
        dt3.text = ll;//[NSString stringWithFormat:@"$%@", ll];
    }
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *indexes = [tableView indexPathsForVisibleRows];
    if ([indexes count] >= [sectionIndex count])
    return nil;

    return sectionIndex;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    NSInteger newRow = [self indexForFirstChar:title inArray:rosterList];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowEmployeeProfile"])
    {
        //        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Get destination view
        EmployeeProfileViewController *vc = [segue destinationViewController];
        vc.employeeData = (NSArray*)sender;
        vc.employerData = employerData;
        vc.enrollmentIndex = enrollmentIndex;
        vc.currentCoverageYearIndex = [self getPlanIndex];
        vc.delegate = self;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *po = [rosterList objectAtIndex:indexPath.row] ;
    [self performSegueWithIdentifier:@"ShowEmployeeProfile" sender:po];
}

-(void)changeCoverageYear:(NSInteger)index
{
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    vHeader.iCurrentPlanIndex = index;
    tabBar.current_coverage_year_index = index;
    
    int iCnt = 0;
    NSArray *pp1 = [[rosterList objectAtIndex:0] valueForKey:@"enrollments"];
    for (id py in pp1)
    {
        NSString *sPlanYear = [[employerData.plans objectAtIndex:tabBar.current_coverage_year_index] valueForKey:@"plan_year_begins"];
        if ([[py valueForKey:@"start_on"] isEqualToString:sPlanYear])
            enrollmentIndex = iCnt;
        iCnt++;
    }
    
    [pRosterTable reloadData];
}

-(NSInteger)getPlanIndex
{
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    return tabBar.current_coverage_year_index;
}

-(void)setCoverageYearIndex:(NSInteger)index
{
    //Used from Employee Profile
    
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    tabBar.current_coverage_year_index = index;
}
@end
