//
//  brokerPlanDetailViewController.m
//  HBXMobile
//
//  Created by David Boyd on 5/16/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "brokerPlanDetailViewController.h"
#import "brokerEmployersData.h"
#import "QuartzCore/QuartzCore.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

@interface brokerPlanDetailViewController ()

@end

@implementation brokerPlanDetailViewController

#define SECTION_HEIGHT  50

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@synthesize type, bucket;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 0, 200, 40)];
    //    UIImageView *pView1 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 160, 42)];
    pView1.backgroundColor = [UIColor clearColor];
    //    pView1.image = [UIImage imageNamed:@"BrokerMVP_AppHeader200x40WHT.png"];
    pView1.image = [UIImage imageNamed:@"navHeader"];//[UIImage imageNamed:@"BrokerMVP_AppHeader200x40_144ppi_WHT.png"];
    pView1.contentMode = UIViewContentModeCenter;// UIViewContentModeScaleAspectFill;
    
    self.navigationItem.titleView = pView1;

    // Send a synchronous request
//    NSString *pUrl = [NSString stringWithFormat:@"http://%@%@", _enrollHost, type.detail_url];
    NSString *pUrl = [NSString stringWithFormat:@"%@%@", _enrollHost, type.detail_url];
    
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
    
    // Do any additional setup after loading the view.
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    CGRect sSize = [[UIApplication sharedApplication] statusBarFrame];
    
    if (screenSize.height < 600)
        globalFontSize = 12;
    else
    {
        if ([UIScreen mainScreen].nativeScale > 2.8f)
            globalFontSize = 16;
        else
            globalFontSize = 16;
    }

    myTabBar.hidden = FALSE;
    myTabBar.frame = CGRectMake(0,screenSize.height - self.navigationController.navigationBar.frame.size.height - 49 - sSize.size.height, screenSize.width, 49);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 600 && [UIScreen mainScreen].nativeScale < 2.8f)
    {
        vHeader.frame = CGRectMake(0,0,screenSize.width,115);
        pCompany.font = [UIFont fontWithName:@"Roboto-Bold" size:24.0];
        pCompany.frame = CGRectMake(0, 0, screenSize.width, 65);//pCompany.frame.size.height);
    }
    else
    {
        vHeader.frame = CGRectMake(0,0,screenSize.width,115);
        pCompany.font = [UIFont fontWithName:@"Roboto-Bold" size:24];
        pCompany.frame = CGRectMake(0, 0, screenSize.width, 65);//pCompany.frame.size.height);
    }
    
    pCompany.textAlignment = NSTextAlignmentCenter;
    pCompany.text = type.companyName;
    

    long lNotCompleted = [[dictionary valueForKeyPath:@"employees_total"] integerValue] - ([[dictionary valueForKeyPath:@"employees_enrolled"] integerValue] + [[dictionary valueForKeyPath:@"employees_waived"] integerValue]);
    
    NSString *notCompleted = [NSString stringWithFormat:@"%ld", lNotCompleted];

    NSDate *today = [NSDate date];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *endDate = [f dateFromString:type.open_enrollment_ends];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:today
                                                          toDate:endDate
                                                         options:NSCalendarWrapComponents];
    
    /////////////////////////////////////////////////
    /////////////////////////////////////////////////
    ////
    ////        TOP SECTION
    ////
    /////////////////////////////////////////////////
    

    if (type.status == (enrollmentState)NEEDS_ATTENTION)
    {
        NSDate *startDate = [f dateFromString:type.open_enrollment_begins];
        [f setDateFormat:@"MMM dd, yyyy"];
        topSectionNames = [[NSArray alloc] initWithObjects: NSLocalizedString(@"OPEN_ENROLLMENT_BEGAN", @"Open Enrollment Began"), NSLocalizedString(@"OPEN_ENROLLMENT_CLOSES", @"Open Enrollment Closes"), NSLocalizedString(@"DAYS_LEFT",@"Days Left"), nil];
        topSectionValues = [[NSArray alloc] initWithObjects: [f stringFromDate:startDate], [f stringFromDate:endDate], [NSString stringWithFormat:@"%ld", (long)[components day]], nil];
    }
    else if (type.status == (enrollmentState)OPEN_ENROLLMENT_MET)
    {
        NSDate *startDate = [f dateFromString:type.open_enrollment_begins];
        [f setDateFormat:@"MMM dd, yyyy"];

        NSDate *today = [NSDate date];
        
        if ([startDate compare:today] == NSOrderedAscending)
            topSectionNames = [[NSArray alloc] initWithObjects: NSLocalizedString(@"OPEN_ENROLLMENT_BEGAN", @"Open Enrollment Began"), NSLocalizedString(@"OPEN_ENROLLMENT_CLOSES", @"Open Enrollment Closes"), NSLocalizedString(@"DAYS_LEFT",@"Days Left"), @"BINDER PAYMENT DUE", nil];
        else
            topSectionNames = [[NSArray alloc] initWithObjects: @"Open Enrollment Begins", @"Open Enrollment Closes", @"Days Left", @"BINDER PAYMENT DUE", nil];
        
        topSectionValues = [[NSArray alloc] initWithObjects: [f stringFromDate:startDate], [f stringFromDate:endDate], [NSString stringWithFormat:@"%ld", (long)[components day]], type.employeesTotal, nil];
    }
    else if (type.status == (enrollmentState)RENEWAL_IN_PROGRESS)
    {
        NSDate *employerApplicationDate = [f dateFromString:type.renewal_application_due];
        NSDate *planYearDate = [f dateFromString:type.planYear];
        NSDate *binderDate = [f dateFromString:type.binder_payment_due];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components1 = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:today
                                                              toDate:employerApplicationDate
                                                             options:NSCalendarWrapComponents];

        [f setDateFormat:@"MMM dd, yyyy"];
        
        if ([type.binder_payment_due length] > 0)
        {
            topSectionNames = [[NSArray alloc] initWithObjects: @"Employer Application Due", @"Open Enrollment Ends", @"Coverage Begins", @"Binder Payment Due", nil];
            topSectionValues = [[NSArray alloc] initWithObjects: [NSString stringWithFormat:@"%ld days left", (long)[components1 day]], [NSString stringWithFormat:@"%ld days left", (long)[components day]], [f stringFromDate:planYearDate], [f stringFromDate:binderDate], nil];
        }
        else
        {
            topSectionNames = [[NSArray alloc] initWithObjects: @"Employer Application Due", @"Open Enrollment Ends", @"Coverage Begins", nil];
            topSectionValues = [[NSArray alloc] initWithObjects: [NSString stringWithFormat:@"%ld days left", (long)[components1 day]], [NSString stringWithFormat:@"%ld days left", (long)[components day]], [f stringFromDate:planYearDate], nil];
        }
        
    }
    else
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [numberFormatter setMaximumFractionDigits:2];

        ;
        
        topSectionNames = [[NSArray alloc] initWithObjects: @"Employee Contribution", @"Employer Contribution", @"TOTAL", nil];
        topSectionValues = [[NSArray alloc] initWithObjects: [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[dictionary valueForKeyPath:@"employee_contribution"] floatValue]]], [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[dictionary valueForKeyPath:@"employer_contribution"] floatValue]]], [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[dictionary valueForKeyPath:@"total_premium"] floatValue]]], nil];
        //        topSectionValues = [[NSArray alloc] initWithObjects: type.employee_contribution, type.employer_contribution, type.total_premium, nil];
        
    }

    /////////////////////////////////////////////////
    /////////////////////////////////////////////////
    ////
    ////        MIDDLE SECTION
    ////
    /////////////////////////////////////////////////
    
    if (type.status == (enrollmentState)NEEDS_ATTENTION)
    {
        midSectionNames = [[NSArray alloc] initWithObjects: @"Must Participate to Meet Minimum", @"Enrolled", @"Waived", @"Not Completed", @"TOTAL EMPLOYEES", nil];
        midSectionValues = [[NSArray alloc] initWithObjects: [[dictionary valueForKeyPath:@"minimum_participation_required"] stringValue], [[dictionary valueForKeyPath:@"employees_enrolled"] stringValue], [[dictionary valueForKeyPath:@"employees_waived"] stringValue], notCompleted, [[dictionary valueForKeyPath:@"employees_total"] stringValue], nil];
//        midSectionValues = [[NSArray alloc] initWithObjects: type.planMinimum, type.employeesEnrolled, type.employeesWaived, notCompleted, type.employeesTotal, nil];
    }
    else if (type.status == (enrollmentState)OPEN_ENROLLMENT_MET)    {
        midSectionNames = [[NSArray alloc] initWithObjects: @"Enrolled", @"Waived", @"Not Completed", @"TOTAL EMPLOYEES", nil];
        midSectionValues = [[NSArray alloc] initWithObjects: [[dictionary valueForKeyPath:@"employees_enrolled"] stringValue], [[dictionary valueForKeyPath:@"employees_waived"] stringValue], notCompleted, [[dictionary valueForKeyPath:@"employees_total"] stringValue], nil];
//        midSectionValues = [[NSArray alloc] initWithObjects: type.employeesEnrolled, type.employeesWaived, notCompleted, type.employeesTotal, nil];
    }
    else
    {
        midSectionNames = [[NSArray alloc] initWithObjects: @"Enrolled", @"Waived", @"Not Enrolled", @"TOTAL EMPLOYEES", nil];
        midSectionValues = [[NSArray alloc] initWithObjects: [[dictionary valueForKeyPath:@"employees_enrolled"] stringValue], [[dictionary valueForKeyPath:@"employees_waived"] stringValue], notCompleted, [[dictionary valueForKeyPath:@"employees_total"] stringValue], nil];
//        midSectionValues = [[NSArray alloc] initWithObjects: type.employeesEnrolled, type.employeesWaived, notCompleted, type.employeesTotal, nil];
    }

    /////////////////////////////////////////////////
    /////////////////////////////////////////////////
    
    pCompanyFooter.frame = CGRectMake(0, pCompany.frame.origin.y + pCompany.frame.size.height, screenSize.width, pCompanyFooter.frame.size.height);
    pCompanyFooter.textAlignment = NSTextAlignmentCenter;
//    pCompanyFooter.backgroundColor = [UIColor greenColor];
    
    if (type.status == (enrollmentState)NEEDS_ATTENTION)
    {
        pCompanyFooter.text = NSLocalizedString(@"TITLE_NOTE", @"OPEN ENROLLMENT IN PROGRESS - MINIMUM NOT MET");
        pCompanyFooter.textColor = [UIColor redColor];

    }
    else if (type.status == (enrollmentState)OPEN_ENROLLMENT_MET)
    {
        pCompanyFooter.text = @"OPEN ENROLLMENT IN PROGRESS";
        pCompanyFooter.textColor = [UIColor colorWithRed:218.0f/255.0f green:165.0f/255.0f blue:32.0f/255.0f alpha:1.0f]; //[UIColor yellowColor];
        
    }
    else if (type.status == (enrollmentState)RENEWAL_IN_PROGRESS)
    {
        pCompanyFooter.text = @"RENEWAL IN PROGRESS";
        pCompanyFooter.textColor = [UIColor colorWithRed:218.0f/255.0f green:165.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
    }   
    else if (type.status == (enrollmentState)NO_ACTION_REQUIRED)
    {
        pCompanyFooter.text = @"IN COVERAGE";
        pCompanyFooter.textColor = [UIColor colorWithRed:0.0f/255.0f green:139.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    }
    //This works to stop swipe back
    //Thought I may need this is I added a tab to slide out contact menu
    //
    //if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    //    [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [myTable addSubview:refreshControl];

    for (int btnCount=0;btnCount<4;btnCount++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=30+btnCount;
        [button setFrame:CGRectMake(10, pCompanyFooter.frame.origin.y + pCompanyFooter.frame.size.height + 10, 38, 38)];
        [button setBackgroundColor:[UIColor clearColor]];
        UIImage *btnImage;
        switch(btnCount)
        {
            case 0:
                btnImage = [UIImage imageNamed:@"phone.png"];
                [button addTarget:self action:@selector(phoneEmployer:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                btnImage = [UIImage imageNamed:@"message.png"];
                [button addTarget:self action:@selector(smsEmployer:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                btnImage = [UIImage imageNamed:@"location.png"];
                [button addTarget:self action:@selector(showDirections:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 3:
                btnImage = [UIImage imageNamed:@"email.png"];
                [button addTarget:self action:@selector(emailEmployer:) forControlEvents:UIControlEventTouchUpInside];
                break;
        }

        button.contentMode = UIViewContentModeScaleToFill;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [button setImage:btnImage forState:UIControlStateNormal];

        [vHeader addSubview:button];
    }
    
//    [self evenlySpaceTheseButtonsInThisView:@[button, button1, button2, button3] :self.view];
    [self evenlySpaceTheseButtonsInThisView:@[[self.view viewWithTag:30], [self.view viewWithTag:31], [self.view viewWithTag:32], [self.view viewWithTag:33]] :self.view];
    
    UIButton *button = (UIButton*) [self.view viewWithTag:30];
    
    vHeader.frame = CGRectMake(0,0,screenSize.width, button.frame.origin.y + button.frame.size.height + 10);
    
    int myTabBarY = myTabBar.frame.origin.y - 5;// - 65;
    int vHeaderHt = vHeader.frame.origin.y + vHeader.frame.size.height;

    myTable.frame = CGRectMake(10, button.frame.origin.y + button.frame.size.height + 10, screenSize.width-25, myTabBarY - vHeaderHt);
    
    
    myTable.backgroundColor = [UIColor clearColor];
    myTable.backgroundView = nil;
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

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    myTable.frame = CGRectMake(10, 165, self.view.frame.size.width-25, self.view.frame.size.height - 10); //myTabBarY - vHeaderHt);
    
    [self evenlySpaceTheseButtonsInThisView:@[[self.view viewWithTag:30], [self.view viewWithTag:31], [self.view viewWithTag:32], [self.view viewWithTag:33]] :self.view];

    [myTable reloadData];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)phoneEmployer:(id)sender
{
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sub.messageTitle = type.companyName;
    sub.messageArray = type.contact_info;
    sub.messageType = typePopupPhone;
    [self presentViewController:sub animated:YES completion: nil];
}

- (void)emailEmployer:(id)sender
{
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sub.messageTitle = type.companyName;
    sub.messageArray = type.contact_info;
    sub.messageType = typePopupEmail;
    
//    NSArray *pp =[type.emails objectAtIndex:0];
//    if ([pp isKindOfClass:[NSNull class]])
//        return;
    [self presentViewController:sub animated:YES completion: nil];
}

- (IBAction)smsEmployer:(id)sender {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sub.messageTitle = type.companyName;
    sub.messageArray = type.contact_info;
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
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sub.messageTitle = type.companyName;
    sub.messageArray = type.contact_info;
    sub.messageType = typePopupMAP;
    sub.delegate = self;
    
    [self presentViewController:sub animated:YES completion: nil];
}

-(void)MAPTheseDirections:(id)sender
{
    NSArray *ck = [sender objectAtIndex:0];
    NSDictionary *pk = [ck objectAtIndex:0];
    
    //(DB) NEW API CHANGE
    NSString *destinationAddress= [NSString stringWithFormat:@"%@, %@, %@, %@", [pk valueForKey:@"address_1"], [pk valueForKey:@"city"], [pk valueForKey:@"state"], [pk valueForKey:@"zip"]]; //@"130 M Street NE, Washington, DC, 20002";
    //(DB) NEW API CHANGE
//    NSString *destinationAddress; // = [NSString stringWithFormat:@"%@, %@, %@, %@", type.employer_address_1, type.employer_city, type.employer_state, type.employer_zip]; //@"130 M Street NE, Washington, DC, 20002";
    
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

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0)
    {
    }
    else if(item.tag == 1)
    {
    }
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
    if (type.active_general_agency != (NSString *)[NSNull null] && [type.active_general_agency length] > 0)
        return 4;
    
    int uu = 3;
    return uu;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [topSectionNames count];

    if (section == 1)
        return [midSectionNames count];

    if (section == 3)
        return 1;

    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (type.status == (enrollmentState)NO_ACTION_REQUIRED && section == 2)
        return SECTION_HEIGHT;

    if (section != 0 || (type.status == (enrollmentState)NO_ACTION_REQUIRED && section == 0))
       return SECTION_HEIGHT - 20;
        
    return SECTION_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:globalFontSize]; //14
        tableViewHeaderFooterView.textLabel.textColor = [UIColor darkGrayColor];
        tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
        tableViewHeaderFooterView.textLabel.backgroundColor = [UIColor greenColor];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (type.active_general_agency != (NSString *)[NSNull null])
    {
        if (section == 3)
            return nil;
    }
    else
    {
        if (section == 2)
            return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 8)];

    CGRect sepFrame = CGRectMake(0, 4, tableView.frame.size.width, 1);
    UIView *seperatorView =[[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [UIColor colorWithWhite:200.0/255.0 alpha:1.0];
    [view addSubview:seperatorView];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
//    [f setDateFormat:@"MM-dd-yyyy"];
    
    NSDate *endDate = [f dateFromString:[dictionary valueForKey:@"plan_year_begins"]]; //[f dateFromString:type.billing_report_date];

    switch (section)
    {
        case 0:
            if (type.status == (enrollmentState)NEEDS_ATTENTION || type.status == (enrollmentState)OPEN_ENROLLMENT_MET)
                sectionName = NSLocalizedString(@"OPEN_ENROLLMENT", @"OPEN ENROLLMENT");
            else if (type.status == (enrollmentState)RENEWAL_IN_PROGRESS)
                sectionName = @"RENEWAL DEADLINES";
            else
                sectionName = NSLocalizedString(@"MONTHLY_ESTIMATED_COST", @"MONTHLY ESTIMATED COST");
            break;
        case 1:
            sectionName = NSLocalizedString(@"PARTICIPATION", @"PARTICIPATION"); //NSLocalizedString(@"myOtherSectionName", @"PARTICIPATION");
            break;
        case 3:
            sectionName = @"GENERAL AGENCY"; //NSLocalizedString(@"myOtherSectionName", @"GENERAL AGENCY");
            break;
        default:
            if (bucket == 0 || bucket == 1)
            {
                [f setDateFormat:@"MMM yyyy"];
                
                sectionName = [NSString stringWithFormat:@"%@ - %@", NSLocalizedString(@"MONTHLY_ESTIMATED_COST", @"MONTHLY ESTIMATED COST"), [[f stringFromDate:endDate] uppercaseString]];
            }
            else
                sectionName = @"COVERAGE INFO";
            break;
    }
    
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;

    int headeFontSize = 12;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 600)
        headeFontSize = 14;
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEIGHT)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 15)];
    label.backgroundColor = [UIColor clearColor];

    label.font = [UIFont fontWithName:@"Roboto-Bold" size:headeFontSize+2];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorFromRGB(0x00a99e); //UIColorFromRGB(0x555555); //UIColorFromRGB(0x007bc4); //[UIColor colorWithRed:79.0f/255.0f green:148.0f/255.0f blue:205.0f/255.0f alpha:1.0f];//[UIColor darkGrayColor];  007bc4
    label.text = sectionName;
    [sectionView addSubview:label];

    if ((section == 0 && type.status != (enrollmentState)NO_ACTION_REQUIRED) || (type.status == (enrollmentState)NO_ACTION_REQUIRED && section == 2))
    {
        [f setDateFormat:@"MMM dd, yyyy"];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:364];
        NSDate *targetDate = [gregorian dateByAddingComponents:dateComponents toDate:endDate  options:0];

        UILabel * labelCoverage = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, tableView.frame.size.width, 12)];
        labelCoverage.backgroundColor = [UIColor clearColor];
        labelCoverage.font = [UIFont fontWithName:@"Roboto-Regular" size:headeFontSize];
        labelCoverage.textAlignment = NSTextAlignmentCenter;
        labelCoverage.textColor = [UIColor darkGrayColor];
        labelCoverage.text = [NSString stringWithFormat:@"COVERAGE YEAR  %@ - %@", [[f stringFromDate:endDate] uppercaseString], [[f stringFromDate:targetDate] uppercaseString]];
        [sectionView addSubview:labelCoverage];
    }
    
    if (section == 1 && type.status == (enrollmentState)OPEN_ENROLLMENT_MET)
    {
        [f setDateFormat:@"MMM dd, yyyy"];
        
        UILabel * labelCoverage = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, tableView.frame.size.width, 10)];
        labelCoverage.backgroundColor = [UIColor clearColor];
        labelCoverage.font = [UIFont fontWithName:@"Roboto-Regular" size:headeFontSize];
        labelCoverage.textAlignment = NSTextAlignmentCenter;
        labelCoverage.textColor = [UIColor darkGrayColor];
        labelCoverage.text = [NSString stringWithFormat:@"MINIMUM MET √"];
        
        NSMutableAttributedString *text =
        [[NSMutableAttributedString alloc]
         initWithString: labelCoverage.text];
        
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorWithRed:0.0f/255.0f green:139.0f/255.0f blue:0.0f/255.0f alpha:1.0f]
                     range:NSMakeRange(11, 2)];
        
        labelCoverage.attributedText = text;
        [sectionView addSubview:labelCoverage];
    }

    return sectionView;
}

-(void)showCellCosts:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    //        pCompany.employee_contribution = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[ck valueForKeyPath:@"estimated_premium.employee_contribution"] floatValue]]];
    //        pCompany.employer_contribution = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[ck valueForKeyPath:@"estimated_premium.employer_contribution"] floatValue]]];
    
    // Removed this becuase we now include total in json
    //        float total_premium = [[ck valueForKeyPath:@"estimated_premium.employee_contribution"] floatValue] + [[ck valueForKeyPath:@"estimated_premium.employer_contribution"] floatValue];
    //        float total_premium = [[ck valueForKeyPath:@"estimated_premium.total_premium"] floatValue];
    
    //        pCompany.total_premium = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: total_premium]];

    cell.detailTextLabel.textColor = UIColorFromRGB(0x555555);//[UIColor colorWithRed:84.0f/255.0f green:84.0f/255.0f blue:84.0f/255.0f alpha:1.0f];
    if (indexPath.row == 0)
    {
        cell.textLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:globalFontSize];
        cell.textLabel.text = @"Employer Contribution";
        cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:globalFontSize];
        cell.detailTextLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[dictionary valueForKeyPath:@"employer_contribution"] floatValue]]];
 //       [[dictionary valueForKey:@"employer_contribution"] stringValue];//type.employer_contribution;
    }
    if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Employee Contribution";
        cell.detailTextLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[dictionary valueForKeyPath:@"employee_contribution"] floatValue]]];

        
//        [[dictionary valueForKey:@"employee_contribution"] stringValue]; //type.employee_contribution;
    }
    if (indexPath.row == 2)
    {
        cell.textLabel.text = @"TOTAL";
        cell.detailTextLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[dictionary valueForKeyPath:@"total_premium"] floatValue]]];//[[dictionary valueForKey:@"total_premium"] stringValue];//type.total_premium;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    if (screenSize.height < 600)
        return 22;
    
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:globalFontSize];
    cell.textLabel.textColor = [UIColor darkGrayColor];

    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:globalFontSize];
    cell.detailTextLabel.textColor = UIColorFromRGB(0x555555);//[UIColor colorWithRed:84.0f/255.0f green:84.0f/255.0f blue:84.0f/255.0f alpha:1.0f];

    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [topSectionNames objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [topSectionValues objectAtIndex:indexPath.row];
        if (type.status == (enrollmentState)NEEDS_ATTENTION && (indexPath.row == [topSectionNames count] - 1))
        {
            cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:globalFontSize];
            cell.textLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
 
        if (type.status == (enrollmentState)OPEN_ENROLLMENT_MET && (indexPath.row == [topSectionNames count] - 2))
        {
            cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:globalFontSize];
            cell.textLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
            cell.detailTextLabel.textColor = [UIColor redColor];
        }

        if (type.status == (enrollmentState)OPEN_ENROLLMENT_MET && (indexPath.row == [topSectionNames count] - 1))
        {
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
            
            if ([type.binder_payment_due length] > 0)
            {
                UILabel *labelBinder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
                labelBinder.font = [UIFont fontWithName:@"Roboto-Bold" size:globalFontSize-2];
                labelBinder.textColor = [UIColor darkGrayColor];
                labelBinder.textAlignment = NSTextAlignmentCenter;
                labelBinder.layer.borderWidth = 1.0;
                labelBinder.layer.borderColor = [UIColor colorWithRed:193.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0f].CGColor;
                
                NSDateFormatter *f = [[NSDateFormatter alloc] init];
                [f setDateFormat:@"yyyy-MM-dd"];  //DATE FORMAT IN
                
                NSDate *binderDate = [f dateFromString:type.binder_payment_due];
                [f setDateFormat:@"MMM dd, yyyy"]; //DATE FORMAT OUT

                labelBinder.text = [NSString stringWithFormat:@"BINDER PAYMENT DUE %@", [[f stringFromDate:binderDate] uppercaseString]];//[topSectionNames objectAtIndex:indexPath.row];
                [labelBinder sizeToFit];
                labelBinder.frame = CGRectMake(tableView.frame.size.width/2-labelBinder.frame.size.width/2-5,3,labelBinder.frame.size.width+25,labelBinder.frame.size.height+5);
                
                [cell.contentView addSubview:labelBinder];
            }
        }
        
        if (type.status == (enrollmentState)NO_ACTION_REQUIRED && (indexPath.row == [topSectionNames count] - 1))
        {
            cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:globalFontSize];
            cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:globalFontSize];
            cell.textLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
            cell.detailTextLabel.textColor = [UIColor colorWithRed:84.0f/255.0f green:84.0f/255.0f blue:84.0f/255.0f alpha:1.0f];
        }
    }

    if (indexPath.section == 1)
    {
        cell.textLabel.text = [midSectionNames objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [midSectionValues objectAtIndex:indexPath.row];
        if (type.status == (enrollmentState)NEEDS_ATTENTION && indexPath.row == 0)
        {
            cell.textLabel.textColor = [UIColor redColor];
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
        
        if (indexPath.row == [midSectionNames count] - 1)
        {
            cell.textLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
            cell.detailTextLabel.textColor = [UIColor colorWithRed:84.0f/255.0f green:84.0f/255.0f blue:84.0f/255.0f alpha:1.0f];
            cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:globalFontSize];
            cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:globalFontSize];
        }
    }

    if (indexPath.section == 2)
    {
        if (type.status == (enrollmentState)NO_ACTION_REQUIRED)
        {
            NSDateFormatter *f = [[NSDateFormatter alloc] init];
            [f setDateFormat:@"yyyy-MM-dd"];
//            [f setDateFormat:@"MM-dd-yyyy"];
            
             if (indexPath.row == 0)
            {
                NSDate *endDate = [f dateFromString:type.renewal_application_available];
                
                [f setDateFormat:@"MMM dd, yyyy"];

                cell.textLabel.text = @"Renewal Available";
                cell.detailTextLabel.text = [f stringFromDate:endDate];//type.renewal_applicable_available;
            }
            if (indexPath.row == 1)
            {
                NSDate *endDate = [f dateFromString:type.planYear];
                [f setDateFormat:@"MMM dd, yyyy"];
                
                cell.textLabel.text = @"Next Coverage Year Begins";
                cell.detailTextLabel.text = [f stringFromDate:endDate];
            }
            if (indexPath.row == 2)
            {
                NSDate *endDate = [f dateFromString:type.open_enrollment_ends];
                [f setDateFormat:@"MMM dd, yyyy"];
                
               cell.textLabel.text = @"Next Open Enrollment Ends";
                cell.detailTextLabel.text = [f stringFromDate:endDate];
            }

        }
        else
            [self showCellCosts:cell indexPath:indexPath];
    }
    if (indexPath.section == 3)
    {
        cell.textLabel.text = @"General Agency";
        cell.detailTextLabel.text = type.active_general_agency;
    }
    
    return cell;
}


@end
