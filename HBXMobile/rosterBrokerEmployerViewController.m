//
//  rosterBrokerEmployerViewController.m
//  HBXMobile
//
//  Created by John Boyd on 9/14/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "rosterBrokerEmployerViewController.h"
#import "EmployeeProfileViewController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface rosterBrokerEmployerViewController ()

@end

@implementation rosterBrokerEmployerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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
    slideView = [[UISlideView alloc] init];//]WithFrame:CGRectMake(self.view.frame.size.width, pRosterTable.frame.origin.y + 44, 200, 200)];
    slideView.backgroundColor = [UIColor clearColor];
    slideView.delegate = self;
    
    [self.view addSubview:slideView];
    
    pRosterTable.sectionIndexColor = [UIColor darkGrayColor];
    pRosterTable.sectionIndexBackgroundColor = [UIColor clearColor];
    
    
     [self loadDictionary];
   /*
    NSString *substring = @"Enrolled";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"enrollments.active.health.status contains[c] %@",substring];

    NSArray *filteredKeys = [rosterList filteredArrayUsingPredicate:predicate];
    
    displayArray = filteredKeys;
    */
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
    
    for( NSString *string in [rosterList valueForKey:@"first_name"])
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
    employerTabController *tabBar = (employerTabController *) self.tabBarController;

    pRosterTable.frame = CGRectMake(0, vHeader.frame.origin.y + vHeader.frame.size.height, self.view.frame.size.width, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height);
    slideView.frame = CGRectMake(self.view.frame.size.width, pRosterTable.frame.origin.y + 34, 200, pRosterTable.frame.size.height - 34);
    
    if ([tabBar.sortOrder isEqualToString:@"show all"] || [tabBar.sortOrder length] == 0)
        return;
    
    NSIndexPath *myIP;
    
    if ([tabBar.sortOrder isEqualToString:@"Enrolled"])
        myIP = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if ([tabBar.sortOrder isEqualToString:@"Waived"])
        myIP = [NSIndexPath indexPathForRow:1 inSection:0];

    if ([tabBar.sortOrder isEqualToString:@"Not Enrolled"])
        myIP = [NSIndexPath indexPathForRow:2 inSection:0];

    
    [self sortByStatus:myIP];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDictionary
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
    
    if (error == nil)
    {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    
    rosterList = [dictionary valueForKey:@"roster"];//[0];// valueForKey:@"roster"][0];
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
    return [displayArray count];
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
    label.text = @"NAME";

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
    button.tag = section;
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
//    UILabel *lblStatus = (UILabel*)sender.view;
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
//        lblStatus.backgroundColor = [UIColor lightGrayColor];
//    [self.tableView beginUpdates];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
//    [self tableView:self.tableView didSelectHeader:indexPath];
    
//    [self.tableView endUpdates];
    //    [self.tableView reloadData];
    [sender setBackgroundColor:[UIColor clearColor]];
    
    UIImage *pImage = [UIImage imageNamed:@"CloseCaret.png"];
    [sender setImage:pImage forState:UIControlStateNormal];

//    [pRosterTable setUserInteractionEnabled:FALSE];
    
//    [self.view bringSubviewToFront:slideView];
    
    [slideView handleLeftSwipe];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sectionIndex;//[[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", nil];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //sectionIndex was pArray
    NSIndexSet *indexes = [sectionIndex indexesOfObjectsPassingTest:^BOOL(NSString *string, NSUInteger idx, BOOL *stop) {
     //   *stop = TRUE;
        return [string hasPrefix:title];
    }];
    
//    int uu = [indexes firstIndex];
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[indexes firstIndex] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return 1;
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[rosterList objectAtIndex:indexPath.row] valueForKey:@"first_name"],[[rosterList objectAtIndex:indexPath.row] valueForKey:@"last_name"]];
    

    NSDictionary *attrs;// = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x00a99e)};//UIColorFromRGB(0x00a3e2) };
    NSString *sActive = [[[[[displayArray objectAtIndex:indexPath.row] valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"status"];//[ii]; //[pk value:ii];

 //   [self getActiveEnrollment:indexPath.row];
    if ([sActive isEqualToString:@"Enrolled"])
        attrs = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x00a99e)};
    else if ([sActive isEqualToString:@"Not Enrolled"])
        attrs = @{ NSForegroundColorAttributeName : [UIColor redColor]};
    else
        attrs = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x625ba8)};

    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:sActive attributes:attrs];
                             
    NSString *sRenewal = [[[[[displayArray objectAtIndex:indexPath.row] valueForKey:@"enrollments"] valueForKey:@"renewal"] valueForKey:@"health"] valueForKey:@"status"];//[ii]; //[pk value:ii];
//[self getRenewalEnrollment:indexPath.row];
    
    NSDictionary *attrsRenew;
    if ([sRenewal isEqualToString:@"Enrolled"])
        attrsRenew = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x00a99e)};
    else if ([sRenewal isEqualToString:@"Not Enrolled"])
        attrsRenew = @{ NSForegroundColorAttributeName : [UIColor redColor]};
    else
        attrsRenew = @{ NSForegroundColorAttributeName : UIColorFromRGB(0x625ba8)};
    
    NSMutableAttributedString *attributedTitle1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@ %@",sRenewal, @"for next year"] attributes:attrsRenew];
    
    [attributedTitle1 beginEditing];
    [attributedTitle1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:12] range:NSMakeRange(0, attributedTitle1.length)];
    [attributedTitle1 endEditing];
    
    [attributedTitle appendAttributedString:attributedTitle1];

    cell.detailTextLabel.numberOfLines = 2;
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
    NSArray *po = [rosterList objectAtIndex:indexPath.row] ;
    [self performSegueWithIdentifier:@"ShowEmployeeProfile" sender:po];
}

-(void)sortByStatus:(NSIndexPath*)idx
{
    NSPredicate *predicate;
    NSString *substring = @"Enrolled";
    NSString *type = @"active";
    
    if (idx.section == 2)
        displayArray = rosterList;
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
            default:
                break;
        }
//        predicate = [NSPredicate predicateWithFormat:@"enrollments.active.health.status contains[c] %@", substring];
        predicate = [NSPredicate predicateWithFormat:@"enrollments.%@.health.status == %@", type, substring];
        
        NSArray *filteredKeys = [rosterList filteredArrayUsingPredicate:predicate];
        
        displayArray = filteredKeys;
    }
    
    NSMutableSet *firstCharacters = [NSMutableSet setWithCapacity:0];
    
    for( NSString *string in [displayArray valueForKey:@"first_name"])
        [firstCharacters addObject:[NSString stringWithString:[string substringToIndex:1]]];
    
    sectionIndex = [[firstCharacters allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    [pRosterTable reloadData];
    
    ((employerTabController *) self.tabBarController).sortOrder = substring;

}
@end
