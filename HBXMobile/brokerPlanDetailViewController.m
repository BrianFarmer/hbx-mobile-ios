//
//  brokerPlanDetailViewController.m
//  HBXMobile
//
//  Created by David Boyd on 5/16/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "brokerPlanDetailViewController.h"
#import "BrokerAccountViewController.h"
#import  "QuartzCore/QuartzCore.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

@interface brokerPlanDetailViewController ()

@end

@implementation brokerPlanDetailViewController

@synthesize type, bucket;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    CGRect sSize = [[UIApplication sharedApplication] statusBarFrame];
    
    myTabBar.hidden = TRUE;
//    int xx = myTabBar.frame.size.height;
//    int yy = self.navigationController.navigationBar.frame.size.height;
    
    myTabBar.frame = CGRectMake(0,screenSize.height - self.navigationController.navigationBar.frame.size.height - 49 - sSize.size.height, screenSize.width, 49);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 600)
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
    
    
    pCompanyFooter.frame = CGRectMake(0, pCompany.frame.origin.y + pCompany.frame.size.height, screenSize.width, pCompanyFooter.frame.size.height);
    pCompanyFooter.textAlignment = NSTextAlignmentCenter;
//    pCompanyFooter.backgroundColor = [UIColor greenColor];
    
    if (bucket == 0)
    {
        pCompanyFooter.text = @"REQUIRES IMMEDIATE ATTENTION - TARGET NOT MET";
        pCompanyFooter.textColor = [UIColor redColor];

    }
    else if (bucket == 1)
    {
        pCompanyFooter.text = @"OPEN ENROLLMENT";
        pCompanyFooter.textColor = [UIColor darkGrayColor];
        
    }

    else if (bucket == 2)
    {
        pCompanyFooter.text = @"UPCOMING OPEN ENROLLMENT";
        pCompanyFooter.textColor = [UIColor darkGrayColor];
    }
   
    else if (bucket == 3)
    {
        pCompanyFooter.text = @"ALL OTHER CLIENTS";
        pCompanyFooter.textColor = [UIColor darkGrayColor];
    }
    //This works to stop swipe back
    //Thought I may need this is I added a tab to slide out contact menu
    //
    //if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    //    [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    
//    int yy = myTabBar.frame.origin.y;
    int myTabBarY = myTabBar.frame.origin.y - 5;// - 65;
    int vHeaderHt = vHeader.frame.origin.y + vHeader.frame.size.height;
    
    myTable.frame = CGRectMake(35, vHeader.frame.origin.y + vHeader.frame.size.height, screenSize.width-70, myTabBarY - vHeaderHt); //screenBound.origin.y + screenSize.height - 290); //  myTabBar.frame.origin.y-90);

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
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.recipients = [NSArray arrayWithObjects:@"12024686571", nil];
 //   picker.body = yourTextField.text;

    [self presentModalViewController:picker animated:YES];
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
//NSURL *URL = [NSURL URLWithString:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f"];
//        NSURL *URL = [NSURL URLWithString:@"http://maps.google.com/maps?saddr=125,96&daddr=126,97"];
//        [[UIApplication sharedApplication] openURL:URL];
        
        
//        CLLocationCoordinate2D coordinate =    CLLocationCoordinate2DMake(self.location.latitude,self.location.longitude);
        /*
        NSString *text = @"My mail text";
        NSURL *recipients = [NSURL URLWithString:@"mailto:foo@bar.com"];
        
        NSArray *activityItems = @[text, recipients];
        
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc]
         initWithActivityItems:activityItems
         applicationActivities:nil];
        
        [self presentViewController:activityController
                           animated:YES completion:nil];
         
         */
        /*
        NSString *textToShare = @"Look at this awesome website for aspiring iOS Developers!";
        NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];

         NSArray *objectsToShare = @[textToShare, myWebsite];
//        [self performSegueWithIdentifier:@"Show Notifications" sender:nil];
        NSArray *excludedActivities = @[UIActivityTypeMessage, UIActivityTypeMail];
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
        [self presentViewController:controller animated:YES completion:nil];
*/
    }
    else if(item.tag == 1)
    {
        NSString *actionSheetTitle = @"Contact"; //Action Sheet Title
        //       NSString *destructiveTitle = @"Destructive Button"; //Action Sheet Button Titles
        NSString *other1 = @"Medical";
        NSString *other2 = @"Dental";
        NSString *other3 = @"Broker";
        NSString *other4 = @"Case Worker";
        NSString *other5 = @"Generic";
        NSString *cancelTitle = @"Cancel";
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil //actionSheetTitle
                                      delegate:self
                                      cancelButtonTitle:cancelTitle
                                      destructiveButtonTitle:nil //destructiveTitle
                                      otherButtonTitles:other1, other2, other3, other4, other5, nil];
        
        [actionSheet showInView:self.view];
        ////        SettingsViewController *ViewController = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
        //       [self presentViewController:ViewController animated:NO completion:nil];
    }
    else if (item.tag == 2)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:"]];
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
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 3;
    
    if (section == 1 && bucket != 2)
        return 5;
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
 //   if (section == 0)
//        return 34.0;
    return 24.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
        tableViewHeaderFooterView.textLabel.textColor = [UIColor darkGrayColor];
        tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
        tableViewHeaderFooterView.textLabel.backgroundColor = [UIColor greenColor];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 5)];

    CGRect sepFrame = CGRectMake(0, 4, tableView.frame.size.width, 1);
    UIView *seperatorView =[[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [UIColor colorWithWhite:200.0/255.0 alpha:1.0];
    [view addSubview:seperatorView];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            if (bucket == 0 || bucket == 1)
                sectionName = @"OPEN ENROLLMENT"; //NSLocalizedString(@"mySectionName", @"mySectionName");
            else
                sectionName = @"MONTHLY ESTIMATED COST";
            break;
        case 1:
            sectionName = @"PARTICIPATION"; //NSLocalizedString(@"myOtherSectionName", @"myOtherSectionName");
            break;
        default:
            if (bucket == 0 || bucket == 1)
                sectionName = @"MONTHLY ESTIMATED COST";
            else
                sectionName = @"NEXT OPEN ENROLLMENT";
            break;
    }

    UILabel * label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.text = sectionName;
    return label;
}

-(void)showCellDates:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"Start";
        cell.detailTextLabel.text = type.planEnrollmentStartDate;
    }
    if (indexPath.row == 1)
    {
        cell.textLabel.text = @"End";
        cell.detailTextLabel.text = type.planEnrollmentEndDate;
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
        
        NSDate *endDate = [f dateFromString:type.planEnrollmentEndDate];
        
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

-(void)showCellCosts:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"Total Premium";
        cell.detailTextLabel.text = @"$12,237";
    }
    if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Employee Contribution";
        cell.detailTextLabel.text = @"$5,167";
    }
    if (indexPath.row == 2)
    {
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:13.0];
        cell.textLabel.text = @"Employer Contribution";
        cell.detailTextLabel.text = @"$7,070";
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    float fFontsize;
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

    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    float fFontsize;
    if (screenSize.height < 600)
        fFontsize = 12;
    else
        fFontsize = 13;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:fFontsize];
    cell.textLabel.textColor = [UIColor darkGrayColor];

    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:fFontsize];
    
    if (indexPath.section == 0)
    {
        if (bucket == 2)
            [self showCellCosts:cell indexPath:indexPath];
        else
            [self showCellDates:cell indexPath:indexPath];
    }

    if (indexPath.section == 1)
    {
        if (bucket == 2)
        {
            if (indexPath.row == 0)
            {
                cell.textLabel.text = @"Enrolled";
                cell.detailTextLabel.text = type.employeesEnrolled;
            }
            if (indexPath.row == 1)
            {
                cell.textLabel.text = @"Not Participating";
                cell.detailTextLabel.text = @"5"; //type.employeesWaived;
             }
            if (indexPath.row == 2)
            {
                cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:13.0];
                cell.textLabel.text = @"Total Employees";
                cell.detailTextLabel.text = type.employeesTotal;
            }
        }
        else
        {
            if (indexPath.row == 0)
            {
                if (bucket == 0)
                    cell.detailTextLabel.textColor = [UIColor redColor];
                cell.textLabel.text = @"Target Participation";
                cell.detailTextLabel.text = type.planMinimum;
            }

            if (indexPath.row == 1)
            {
                cell.textLabel.text = @"Enrolled";
                cell.detailTextLabel.text = type.employeesEnrolled;
            }
            if (indexPath.row == 2)
            {
                cell.textLabel.text = @"Waived";
                cell.detailTextLabel.text = @"5"; //type.employeesWaived;
            }
            if (indexPath.row == 3)
            {
                cell.textLabel.text = @"Haven't Participated";
                cell.detailTextLabel.text = @"26";
            }
            if (indexPath.row == 4)
            {
                cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:13.0];
                cell.textLabel.text = @"Total Employees";
                cell.detailTextLabel.text = type.employeesTotal;
            }

        }
    }

    if (indexPath.section == 2)
    {
        if (bucket == 2)
            [self showCellDates:cell indexPath:indexPath];
        else
            [self showCellCosts:cell indexPath:indexPath];
    }
    
    return cell;
}
@end
