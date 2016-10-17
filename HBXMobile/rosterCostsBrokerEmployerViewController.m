//
//  rosterCostsBrokerEmployerViewController.m
//  HBXMobile
//
//  Created by John Boyd on 9/15/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "rosterCostsBrokerEmployerViewController.h"
#import "EmployeeProfileViewController.h"

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
    
    employerTabController *tabBar = (employerTabController *) self.tabBarController;

    employerData = tabBar.employerData;
    
    navImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 0, 200, 40)];
    
    navImage.backgroundColor = [UIColor clearColor];
    navImage.image = [UIImage imageNamed:@"navHeader"];
    navImage.contentMode = UIViewContentModeCenter;
    
    self.navigationController.topViewController.navigationItem.titleView = navImage;
    
    vHeader.frame = CGRectMake(0,0,self.view.frame.size.width,145);
    [vHeader layoutHeaderView:employerData];
    
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
    
    pRosterTable.sectionIndexColor = [UIColor darkGrayColor];
    pRosterTable.sectionIndexBackgroundColor = [UIColor clearColor];
    
    [self loadDictionary];
/*
    NSMutableArray *persons = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        if (i < 10)
            [persons addObject:@"First Lastname"];
        else
            [persons addObject:@"Something else"];
    }
    pArray = [NSArray arrayWithArray:persons];
*/
    NSMutableSet *firstCharacters = [NSMutableSet setWithCapacity:0];
    
    for( NSString *string in pArray)
        [firstCharacters addObject:[NSString stringWithString:[string substringToIndex:1]]];
    
    sectionIndex = [[firstCharacters allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];


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

-(void)viewWillAppear:(BOOL)animated
{
    pRosterTable.frame = CGRectMake(0, vHeader.frame.origin.y + vHeader.frame.size.height, self.view.frame.size.width, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height);
    
 //   self.view.transform = CGAffineTransformMakeScale(22, 22);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDictionary
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
    
    rosterList = [dictionary valueForKey:@"roster"];//[0];// valueForKey:@"roster"][0];
    
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
        
        
        UILabel* detailLabel_2 = [[UILabel alloc] init];
        detailLabel_2.frame = CGRectMake(tableView.frame.size.width - iLabelWidth - iLabelWidth, 12, iLabelWidth, 20);
        detailLabel_2.font = [UIFont fontWithName:@"Roboto-Bold" size:(iOSDeviceScreenSize.width > 320) ? 16:14];
        detailLabel_2.tag = 34;
        detailLabel_2.hidden = FALSE;
        detailLabel_2.textAlignment = NSTextAlignmentCenter;
        detailLabel_2.textColor = UIColorFromRGB(0x555555);
        [cell.contentView addSubview:detailLabel_2];
         
        
        
        UILabel* detailLabel_3 = [[UILabel alloc] init];
        detailLabel_3.frame = CGRectMake(tableView.frame.size.width - iLabelWidth, 12, iLabelWidth, 20);
        detailLabel_3.font = [UIFont fontWithName:@"Roboto-Bold" size:(iOSDeviceScreenSize.width > 320) ? 16:14];
        detailLabel_3.tag = 35;
        detailLabel_3.hidden = FALSE;
        detailLabel_3.textAlignment = NSTextAlignmentCenter;
        detailLabel_3.textColor = UIColorFromRGB(0x555555);
        [cell.contentView addSubview:detailLabel_3];
         
    }
    
    UILabel *dt2 = [cell viewWithTag:34];
    UILabel *dt3 = [cell viewWithTag:35];
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:(iOSDeviceScreenSize.width > 320) ? 16:14];
    cell.textLabel.textColor = UIColorFromRGB(0x555555);
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[rosterList objectAtIndex:indexPath.row] valueForKey:@"first_name"],[[rosterList objectAtIndex:indexPath.row] valueForKey:@"last_name"]];
    
    NSString *oo = [[[[[[rosterList objectAtIndex:indexPath.row] valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"employer_contribution"] stringValue];
    NSString *ll =  [[[[[[rosterList objectAtIndex:indexPath.row] valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"employee_cost"] stringValue];
    
    if ([oo isEqualToString:@"0"] || !oo)
    {
        dt2.text = [[[[[rosterList objectAtIndex:indexPath.row] valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"status"];;
        dt3.text =  [[[[[rosterList objectAtIndex:indexPath.row] valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"status"];
        
        if ([dt2.text isEqualToString:@"Waived"])
        {
            dt2.textColor = UIColorFromRGB(0x625ba8);
            dt3.textColor = UIColorFromRGB(0x625ba8);
        }
        
        if ([dt2.text isEqualToString:@"Not Enrolled"])
        {
            dt2.textColor = [UIColor redColor];
            dt3.textColor = [UIColor redColor];
        }

    }
    else
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [numberFormatter setMaximumFractionDigits:2];
        
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
    return sectionIndex;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSIndexSet *indexes = [pArray indexesOfObjectsPassingTest:^BOOL(NSString *string, NSUInteger idx, BOOL *stop) {
        return [string hasPrefix:title];
    }];
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[indexes firstIndex] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return 1;
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
    NSArray *po = [rosterList objectAtIndex:indexPath.row] ;
    [self performSegueWithIdentifier:@"ShowEmployeeProfile" sender:po];
}

@end
