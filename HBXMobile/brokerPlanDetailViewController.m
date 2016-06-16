//
//  brokerPlanDetailViewController.m
//  HBXMobile
//
//  Created by David Boyd on 5/16/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "brokerPlanDetailViewController.h"
#include "BrokerAccountViewController.h"
#import  "QuartzCore/QuartzCore.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

@interface brokerPlanDetailViewController ()

@end

@implementation brokerPlanDetailViewController

#define SECTION_HEIGHT  50

@synthesize type, bucket;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    CGRect sSize = [[UIApplication sharedApplication] statusBarFrame];
    
    if (screenSize.height < 600)
        globalFontSize = 12;
    else
    {
        if ([UIScreen mainScreen].nativeScale > 2.8f)
            globalFontSize = 14;
        else
            globalFontSize = 15;
    }

    myTabBar.hidden = TRUE;
//    int xx = myTabBar.frame.size.height;
//    int yy = self.navigationController.navigationBar.frame.size.height;
    
    myTabBar.frame = CGRectMake(0,screenSize.height - self.navigationController.navigationBar.frame.size.height - 49 - sSize.size.height, screenSize.width, 49);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 600 && [UIScreen mainScreen].nativeScale < 2.8f)
    {
        vHeader.frame = CGRectMake(0,0,screenSize.width,135);
        pCompany.font = [UIFont fontWithName:@"Roboto-Bold" size:23.0];
        pCompany.frame = CGRectMake(0, 0, screenSize.width, 65);//pCompany.frame.size.height);
    }
    else{
        vHeader.frame = CGRectMake(0,0,screenSize.width,115);
        pCompany.font =        [UIFont fontWithName:@"Roboto-Bold" size:19.0];
        pCompany.frame = CGRectMake(0, 0, screenSize.width, 45);//pCompany.frame.size.height);
    }
    pCompany.textAlignment = NSTextAlignmentCenter;
    pCompany.text = type.companyName;
    
//    pCompany.backgroundColor = [UIColor blueColor];
/*
    CGSize labelSize = [pCompany.text sizeWithFont:pCompany.font
                                constrainedToSize:pCompany.frame.size
                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat labelHeight = labelSize.height;
    
    
    int lines = [pCompany.text sizeWithFont:pCompany.font
                         constrainedToSize:pCompany.frame.size
                             lineBreakMode:NSLineBreakByWordWrapping].height/23;
    // '23' is font size
 */
    long lNotCompleted = [type.employeesTotal integerValue] - ([type.employeesEnrolled integerValue] + [type.employeesWaived integerValue]);
    NSString *notCompleted = [NSString stringWithFormat:@"%ld", lNotCompleted];

    NSDate *today = [NSDate date];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"MM-dd-yyyy"];
    
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
        topSectionNames = [[NSArray alloc] initWithObjects: @"Open Enrollment Began", @"Open Enrollment Closes", @"Days Left", nil];
        topSectionValues = [[NSArray alloc] initWithObjects: [f stringFromDate:startDate], [f stringFromDate:endDate], [NSString stringWithFormat:@"%ld", (long)[components day]], nil];
    }
    else if (type.status == (enrollmentState)OPEN_ENROLLMENT_MET)
    {
        NSDate *startDate = [f dateFromString:type.open_enrollment_begins];
        [f setDateFormat:@"MMM dd, yyyy"];

        NSDate *today = [NSDate date];
        
        if ([startDate compare:today] == NSOrderedAscending)
            topSectionNames = [[NSArray alloc] initWithObjects: @"Open Enrollment Began", @"Open Enrollment Closes", @"Days Left", @"BINDER PAYMENT DUE", nil];
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
        topSectionNames = [[NSArray alloc] initWithObjects: @"Total Premium", @"Employee Contribution", @"Employer Contribution", nil];
        topSectionValues = [[NSArray alloc] initWithObjects: type.total_premium, type.employee_contribution, type.employer_contribution, nil];
    }

    /////////////////////////////////////////////////
    /////////////////////////////////////////////////
    ////
    ////        MIDDLE SECTION
    ////
    /////////////////////////////////////////////////
    
    if (type.status == (enrollmentState)NEEDS_ATTENTION)
    {
        midSectionNames = [[NSArray alloc] initWithObjects: @"Must Participate to Meet Minimum", @"Enrolled", @"Waived", @"Not Completed", @"Total Employees", nil];
        midSectionValues = [[NSArray alloc] initWithObjects: type.planMinimum, type.employeesEnrolled, type.employeesWaived, notCompleted, type.employeesTotal, nil];
    }
    else if (type.status == (enrollmentState)OPEN_ENROLLMENT_MET)    {
        midSectionNames = [[NSArray alloc] initWithObjects: @"Enrolled", @"Waived", @"Not Completed", @"Total Employees", nil];
        midSectionValues = [[NSArray alloc] initWithObjects: type.employeesEnrolled, type.employeesWaived, notCompleted, type.employeesTotal, nil];
    }
    else
    {
        midSectionNames = [[NSArray alloc] initWithObjects: @"Enrolled", @"Waived", @"Not Enrolled", @"Total Employees", nil];
        midSectionValues = [[NSArray alloc] initWithObjects: type.employeesEnrolled, type.employeesWaived, notCompleted, type.employeesTotal, nil];        
    }

    /////////////////////////////////////////////////
    /////////////////////////////////////////////////
    
    pCompanyFooter.frame = CGRectMake(0, pCompany.frame.origin.y + pCompany.frame.size.height, screenSize.width, pCompanyFooter.frame.size.height);
    pCompanyFooter.textAlignment = NSTextAlignmentCenter;
//    pCompanyFooter.backgroundColor = [UIColor greenColor];
    
    if (type.status == (enrollmentState)NEEDS_ATTENTION)
    {
        pCompanyFooter.text = @"OPEN ENROLLMENT IN PROGRESS - MINIMUM NOT MET";
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
    
//    int yy = myTabBar.frame.origin.y;
    int myTabBarY = myTabBar.frame.origin.y - 5;// - 65;
    int vHeaderHt = vHeader.frame.origin.y + vHeader.frame.size.height;
    
    myTable.frame = CGRectMake(30, vHeader.frame.origin.y + vHeader.frame.size.height, screenSize.width-65, myTabBarY - vHeaderHt); //screenBound.origin.y + screenSize.height - 290); //  myTabBar.frame.origin.y-90);

    myTable.backgroundColor = [UIColor clearColor];
    myTable.backgroundView = nil;
    
//    myTable.layer.borderWidth = 2.0;
    
    int iBtn = myTable.frame.size.width / 4;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag=30;
    [button setFrame:CGRectMake(vHeader.frame.origin.x + 65, vHeader.frame.origin.y + vHeader.frame.size.height - 40, 32, 32)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    UIImage *btnImage = [UIImage imageNamed:@"phoneCirclelightBlue.png"];
    [button setImage:btnImage forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button addTarget:self
                action:@selector(phoneEmployer:)
      forControlEvents:UIControlEventTouchUpInside];
    [vHeader addSubview:button];
    
    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.tag=30;
    [button1 setFrame:CGRectMake(vHeader.frame.origin.x + 65 + iBtn, vHeader.frame.origin.y + vHeader.frame.size.height - 40, 32, 32)];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor clearColor]];
    UIImage *btnImage1 = [UIImage imageNamed:@"chatWithCircleLightBlue.png"];
    [button1 setImage:btnImage1 forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button1 addTarget:self
                action:@selector(smsEmployer:)
      forControlEvents:UIControlEventTouchUpInside];
    [vHeader addSubview:button1];

    UIButton* button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag=30;
    [button2 setFrame:CGRectMake(vHeader.frame.origin.x + 65 + (iBtn*2), vHeader.frame.origin.y + vHeader.frame.size.height - 40, 32, 32)];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor clearColor]];
    UIImage *btnImage2 = [UIImage imageNamed:@"markerWithCircleLightBlue.png"];
    [button2 setImage:btnImage2 forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button2 addTarget:self
               action:@selector(showDirections:)
     forControlEvents:UIControlEventTouchUpInside];
    [vHeader addSubview:button2];
    
    UIButton* button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.tag=30;
    [button3 setFrame:CGRectMake(vHeader.frame.origin.x + 65 + (iBtn*3), vHeader.frame.origin.y + vHeader.frame.size.height - 40, 32, 32)];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button3 setBackgroundColor:[UIColor clearColor]];
    UIImage *btnImage3 = [UIImage imageNamed:@"emailWithCirclelightBlue.png"];
    [button3 setImage:btnImage3 forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button3 addTarget:self
                action:@selector(emailEmployer:)
      forControlEvents:UIControlEventTouchUpInside];
    [vHeader addSubview:button3];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)phoneEmployer:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"12024686571"]]];
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
 //   picker.body = yourTextField.text;

    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)emailEmployer:(id)sender {
    
//    NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from HBX!";
    NSString *recipients = @"mailto:hbx@mobile.com?subject=Hello from HBX!";
   
    NSString *body = @"&body=Enroll! Enroll! Enroll!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    
    /*
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"<h1>Message Body</h1>"; // Change the message body to HTML
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"healthcare@gmail.com"];
    
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
        [destination setName:@"Union Station"];
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
    
    return 3;
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
    [f setDateFormat:@"MM-dd-yyyy"];
    
    NSDate *endDate = [f dateFromString:type.planYear];

    switch (section)
    {
        case 0:
            if (type.status == (enrollmentState)NEEDS_ATTENTION || type.status == (enrollmentState)OPEN_ENROLLMENT_MET)
                sectionName = @"OPEN ENROLLMENT"; //NSLocalizedString(@"mySectionName", @"OPEN ENROLLMENT");
            else if (type.status == (enrollmentState)RENEWAL_IN_PROGRESS)
                sectionName = @"RENEWAL DEADLINES";
            else
                sectionName = @"MONTHLY ESTIMATED COST";
            break;
        case 1:
            sectionName = @"PARTICIPATION"; //NSLocalizedString(@"myOtherSectionName", @"PARTICIPATION");
            break;
        case 3:
            sectionName = @"GENERAL AGENCY"; //NSLocalizedString(@"myOtherSectionName", @"GENERAL AGENCY");
            break;
        default:
            if (bucket == 0 || bucket == 1)
            {
                [f setDateFormat:@"MMM yyyy"];
                
                sectionName = [NSString stringWithFormat:@"%@ - %@", @"MONTHLY ESTIMATED COST", [[f stringFromDate:endDate] uppercaseString]];
            }
            else
                sectionName = @"COVERAGE INFO";
            break;
    }
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;

    int headeFontSize = 10;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 600)
        headeFontSize = 12;
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEIGHT)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 15)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Roboto-BOLD" size:headeFontSize+2];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:79.0f/255.0f green:148.0f/255.0f blue:205.0f/255.0f alpha:1.0f];//[UIColor darkGrayColor];
    label.text = sectionName;
    [sectionView addSubview:label];

    if ((section == 0 && type.status != (enrollmentState)NO_ACTION_REQUIRED) || (type.status == (enrollmentState)NO_ACTION_REQUIRED && section == 2))
    {
        [f setDateFormat:@"MMM dd, yyyy"];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:364];
        NSDate *targetDate = [gregorian dateByAddingComponents:dateComponents toDate:endDate  options:0];

        UILabel * labelCoverage = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, tableView.frame.size.width, 10)];
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
/*
-(void)showCellDates:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"Open Enrollment Begins";
        cell.detailTextLabel.text = type.open_enrollment_begins;
    }
    if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Open Enrollment Closes";
        cell.detailTextLabel.text = type.open_enrollment_ends;
    }
    if (indexPath.row == 2)
    {
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:13.0];
        if (bucket == 2)
            cell.textLabel.text = @"Days Until";
        else
            cell.textLabel.text = @"Days Left";
        
        NSDate *today = [NSDate date];
        
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"MM-dd-yyyy"];
        
        NSDate *endDate = [f dateFromString:type.open_enrollment_ends];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:today
                                                              toDate:endDate
                                                             options:NSCalendarWrapComponents];
        
        if (bucket == 0)
            cell.detailTextLabel.textColor = [UIColor redColor];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", [components day]];
    }
    
}
*/
-(void)showCellCosts:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"Total Premium";
        cell.detailTextLabel.text = type.total_premium;
    }
    if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Employee Contribution";
        cell.detailTextLabel.text = type.employee_contribution;
    }
    if (indexPath.row == 2)
    {
        cell.textLabel.textColor = [UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:globalFontSize];
        cell.textLabel.text = @"Employer Contribution";
        cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:globalFontSize];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:84.0f/255.0f green:84.0f/255.0f blue:84.0f/255.0f alpha:1.0f];
        cell.detailTextLabel.text = type.employer_contribution;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    if (screenSize.height < 600)
        return 22;
    
    return 24;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:globalFontSize];
    cell.textLabel.textColor = [UIColor darkGrayColor];

    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:globalFontSize];
    
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
                [f setDateFormat:@"MM-dd-yyyy"];  //DATE FORMAT IN
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
        
        /*
        if (type.status == (enrollmentState)NO_ACTION_REQUIRED)
            [self showCellCosts:cell indexPath:indexPath];
        else
            [self showCellDates:cell indexPath:indexPath];
         */
    }

    if (indexPath.section == 1)
    {
        cell.textLabel.text = [midSectionNames objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [midSectionValues objectAtIndex:indexPath.row];
        if (type.status == (enrollmentState)NEEDS_ATTENTION && indexPath.row == 0)
        {
            cell.detailTextLabel.textColor = [UIColor redColor];
            /*
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",[midSectionNames objectAtIndex:indexPath.row], @"Enrolled or Waived"];
            
            NSMutableAttributedString *text =
            [[NSMutableAttributedString alloc]
             initWithString: cell.textLabel.text];
            
            [text addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:0.0f/255.0f green:139.0f/255.0f blue:0.0f/255.0f alpha:1.0f]
                         range:NSMakeRange(11, 2)];
            
            cell.textLabel.attributedText = text;
             */

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
            [f setDateFormat:@"MM-dd-yyyy"];
            
             if (indexPath.row == 0)
            {
                NSDate *endDate = [f dateFromString:type.renewal_applicable_available];
                
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
