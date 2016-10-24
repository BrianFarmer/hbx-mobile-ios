//
//  brokerSearchResultTableViewController.m
//  HBXMobile
//
//  Created by David Boyd on 7/8/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "brokerSearchResultTableViewController.h"
#import "brokerPlanDetailViewController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface brokerSearchResultTableViewController ()

@end

@implementation brokerSearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    sections = [[NSArray alloc] initWithObjects: NSLocalizedString(@"table-section-open-enrollment", @"OPEN ENROLLMENT IN PROGRESS"), NSLocalizedString(@"table-section-renewals-in-progress", @"RENEWALS IN PROGRESS"), NSLocalizedString(@"table-section-all-others", @"ALL OTHER CLIENTS"), nil];

    if (!expandedSections)
        expandedSections = [[NSMutableIndexSet alloc] init];

    [expandedSections addIndex:0];
    [expandedSections addIndex:1];
    [expandedSections addIndex:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.filteredProducts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([expandedSections containsIndex:section])
        return [[self.filteredProducts objectAtIndex:section] count];
    
    return 0; // only top row showing
}

-(void) swipeTableCellWillBeginSwiping:(MGSwipeTableCell *) cell;
{
    UIButton *button = [cell.contentView viewWithTag:55];
    button.hidden = TRUE;
}

-(void) swipeTableCellWillEndSwiping:(MGSwipeTableCell *) cell;
{
    UIButton *button = [cell.contentView viewWithTag:55];
    button.hidden = FALSE;
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings;
{
    expansionSettings.buttonIndex = 1;
    expansionSettings.fillOnTrigger = NO;
    return [self createLeftButtons:4];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([expandedSections containsIndex:section])
        return 80.0;
    
    return 60;
    
//    return 34.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    brokerEmployersData *ttype = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (ttype.type == 1)
        return 20;
    
    return 88;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [expandedSections containsIndex:section] ? 60:80)];
    
    // Set a custom background color and a border
    //    headerView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
    //    headerView.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;//[UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    //    headerView.layer.borderWidth = 1.0;
    
    headerView.tag = section;
    
    // Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    int mySection = [[[self.filteredProducts objectAtIndex:section] objectAtIndex:0] status];
    if (mySection > 1)
        mySection -= 1;
    
    switch (mySection) {
        case 0:
            headerView.backgroundColor = UIColorFromRGB(0x00a99e);//[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
            //            headerLabel.backgroundColor = UIColorFromRGB(0x00a99e);
            break;
        case 1:
            headerView.backgroundColor = UIColorFromRGB(0x00a3e2);//[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
            //           headerLabel.backgroundColor = UIColorFromRGB(0x00a3e2);
            break;
        case 2:
            headerView.backgroundColor = UIColorFromRGB(0x625ba8);//[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
            //         headerLabel.backgroundColor = UIColorFromRGB(0x625ba8);
            break;
            
        default:
            break;
    }
    
    headerLabel.frame = CGRectMake(8, 0, tableView.frame.size.width - 5, 60);
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16.0];
    headerLabel.text = [sections objectAtIndex:mySection];///  @"This is the custom header view";
    headerLabel.textAlignment = NSTextAlignmentLeft;
    // Add the label to the header view
    [headerView addSubview:headerLabel];
    
    
    if ([expandedSections containsIndex:section])
    {
        UIImageView *imgVew = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width-50, 14, 32, 32)];
        imgVew.backgroundColor = [UIColor clearColor];
        imgVew.image = [UIImage imageNamed:@"uparrowWHT.png"];
        imgVew.contentMode = UIViewContentModeScaleAspectFit;
        // Add the image to the header view
        [headerView addSubview:imgVew];
        
        UIView* subHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, tableView.frame.size.width, 20)];
        subHeaderView.backgroundColor = UIColorFromRGB(0xD9D9D9);
        
        UILabel* headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 100, 20)];
        headerTitle.text = @"CLIENT";
        headerTitle.textColor = [UIColor darkGrayColor];
        headerTitle.font = [UIFont fontWithName:@"Roboto-Bold" size:10.0];
        // Add the header title to the header view
        [subHeaderView addSubview:headerTitle];
        
        UILabel* headerTitle1 = [[UILabel alloc] init];
        if (mySection == 0)
        {
            [headerTitle1 setFrame:CGRectMake(tableView.frame.size.width - 195, 0, 135, 20)];
            headerTitle1.text = @"EMPLOYEES NEEDED";
        }
        else
        {
            [headerTitle1 setFrame:CGRectMake(tableView.frame.size.width - 180, 0, 135, 20)];
            headerTitle1.text = @"PLAN YEAR";
        }
        
        headerTitle1.textAlignment = NSTextAlignmentCenter;
        headerTitle1.textColor = [UIColor darkGrayColor];
        headerTitle1.font = [UIFont fontWithName:@"Roboto-Bold" size:10.0];
        // Add the header title to the header view
        [subHeaderView addSubview:headerTitle1];
        
        if (mySection < 2)
        {
            UILabel* headerTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 70, 0, 135, 20)];
            headerTitle2.text = @"DAYS LEFT";
            headerTitle2.textColor = [UIColor darkGrayColor];
            headerTitle2.font = [UIFont fontWithName:@"Roboto-Bold" size:10.0];
            // Add the header title to the header view
            [subHeaderView addSubview:headerTitle2];
        }
        
        [headerView addSubview:subHeaderView];
    }
    else
    {
        if (mySection == 0)// && clients_needing_immediate_attention > 0)
        {
            UIView *_leftColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, headerView.frame.size.height)];
            _leftColor.backgroundColor = [UIColor redColor];
            [headerView addSubview:_leftColor];
        }
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-50, 14, 32, 32)];
        button.layer.cornerRadius = 16;
        button.layer.borderWidth = 2;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.clipsToBounds = YES;
        button.tag = section;
        button.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:12.0];
        [button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)[[self.filteredProducts objectAtIndex:section] count]] forState:UIControlStateNormal];
        [headerView addSubview:button];
    }
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [headerView addGestureRecognizer:recognizer];
    
    return headerView;
}

-(NSArray *) createLeftButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    UIColor * colors[4] = {[UIColor clearColor],
        [UIColor clearColor],
        [UIColor clearColor],[UIColor clearColor]};
    UIImage * icons[4] = {[UIImage imageNamed:@"email.png"],  [UIImage imageNamed:@"location.png"], [UIImage imageNamed:@"message.png"], [UIImage imageNamed:@"phone.png"]};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:@"" icon:icons[i] backgroundColor:colors[i] padding:10 callback:^BOOL(MGSwipeTableCell * sender){
            if (i == 3)
            {
                //                [self phoneEmployer:sender];
                NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
                brokerEmployersData *pTab = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                
                popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
                sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                sub.messageTitle = pTab.companyName;
                sub.messageArray = pTab.contact_info;
                sub.messageType = typePopupPhone;
                [self presentViewController:sub animated:YES completion: nil];
            }
            
            if (i == 2)
                [self smsEmployer:sender];
            
            if (i == 1)
                [self showDirections:sender];
            
            if (i == 0)
                [self emailEmployer:sender];
            
            return YES;
        }];
        [result addObject:button];
    }
    return result;
}

-(void)showDirections:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    brokerEmployersData *pTab = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sub.messageTitle = pTab.companyName;
    sub.messageArray = pTab.contact_info;
    sub.messageType = typePopupMAP;
    sub.delegate = self;
    
    [self presentViewController:sub animated:YES completion: nil];
}

- (void)handleButtonTap:(id)sender {
    UIView *pHeaderView = (UIView*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
    [self tableView:self.tableView didSelectHeader:indexPath];
    [self.tableView endUpdates];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    UIView *pHeaderView = (UIView*)sender.view;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
    [self tableView:self.tableView didSelectHeader:indexPath];
    [self.tableView endUpdates];
}

- (void)emailEmployer:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    brokerEmployersData *pTab = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sub.messageTitle = pTab.companyName;
    sub.messageArray = pTab.contact_info;
    sub.messageType = typePopupEmail;
    [self presentViewController:sub animated:YES completion: nil];
}

- (IBAction)smsEmployer:(id)sender {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    brokerEmployersData *pTab = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    popupMessageBox *sub = [[popupMessageBox alloc] initWithNibName:@"popupMessageBox" bundle:nil];
    sub.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sub.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    sub.messageTitle = pTab.companyName;
    sub.messageArray = pTab.contact_info;
    sub.messageType = typePopupSMS;
    sub.delegate = self;
    
    [self presentViewController:sub animated:YES completion: nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier2 = @"prototypeCell";
    
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    
    brokerEmployersData *ttype = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if ( cell == nil )
    {
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        
        UIImage *image = [UIImage imageNamed:@"chevron_right.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGRect frame = CGRectMake(tableView.frame.size.width - 20.0, 88/2-8, 16, 16);
        button.frame = frame;   // match the button's size with the image size
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.tag = 55;
        button.hidden = FALSE;
        
        [cell.contentView addSubview:button];

    }

    cell.frame = CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height);
    
    cell.leftColor.frame = CGRectMake(0,0, 4, 88);
    
    cell.delegate = self;
    cell.leftSwipeSettings.transition = MGSwipeTransition3D;
    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    
    cell.allowsMultipleSwipe = NO;
    cell.delegate = self;
    cell.daysleftLabel.textColor = [UIColor darkGrayColor];
    cell.lblDaysLeftText.text = @"DAYS LEFT";
    
    cell.employerLabel.text = ttype.companyName;
    cell.employeesLabel.text = ttype.employeesEnrolled;
//    cell.alertButton.hidden = TRUE;
    
    NSDate *today = [NSDate date];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    
    cell.leftColor.hidden = TRUE;

    int iOffset = 0;
    
    if (ttype.status == NEEDS_ATTENTION)
    {
        cell.lblEmployeesNeeded.text = @"EMPLOYEES NEEDED";
        cell.daysleftLabel.textColor = [UIColor redColor];
//        cell.alertButton.hidden = FALSE;
        cell.leftColor.hidden = FALSE;
    }
    
    if (ttype.status == OPEN_ENROLLMENT_MET)
        cell.lblEmployeesNeeded.text = [NSString stringWithFormat:@"OF %@ ENROLLED", ttype.employeesTotal];
    
    if (ttype.status == RENEWAL_IN_PROGRESS || ttype.status == NO_ACTION_REQUIRED)
    {
        cell.lblEmployeesNeeded.text = @"PLAN\nYEAR";
        
        NSDate *dateFromString = [f dateFromString:ttype.planYear];
        [f setDateFormat:@"MMM dd"];
        NSString *stringFromDate = [f stringFromDate:dateFromString];
        cell.employeesLabel.text = stringFromDate;
        
        int width = ceil([cell.employeesLabel.text sizeWithAttributes:@{NSFontAttributeName: cell.employeesLabel.font}].width);
        
        cell.employeesLabel.frame = CGRectMake(cell.employeesLabel.frame.origin.x, cell.employeesLabel.frame.origin.y, width, 20);
        cell.lblEmployeesNeeded.frame = CGRectMake(cell.employeesLabel.frame.origin.x + width + 2, cell.lblEmployeesNeeded.frame.origin.y, cell.lblEmployeesNeeded.frame.size.width, cell.lblEmployeesNeeded.frame.size.height);
        
        cell.lblEmployeesNeeded.text = @"PLAN\nYEAR";
        
        iOffset = 15;
    }
    
    if (ttype.status == NO_ACTION_REQUIRED)
    {
        cell.lblDaysLeftText.text = @"";
        cell.daysleftLabel.text = @"";
    }
    else
    {
        [f setDateFormat:@"yyyy-MM-dd"];
        NSDate *endDate = [f dateFromString:ttype.open_enrollment_ends];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:today
                                                              toDate:endDate
                                                             options:NSCalendarWrapComponents];
        cell.daysleftLabel.text = [NSString stringWithFormat:@"%ld", (long)[components day]];
    }

    [cell.employeesLabel sizeToFit];
    [cell.daysleftLabel sizeToFit];
    
    cell.daysleftLabel.frame = CGRectMake(tableView.frame.size.width - 82/2 - cell.daysleftLabel.frame.size.width/2, 0, cell.daysleftLabel.frame.size.width, 88);//cell.daysleftLabel.frame.size.height);
    cell.employeesLabel.frame = CGRectMake(cell.daysleftLabel.frame.origin.x - 80 - iOffset, 0, cell.employeesLabel.frame.size.width, 88);//cell.employeesLabel.frame.size.height);
    cell.employerLabel.frame = CGRectMake(cell.employerLabel.frame.origin.x, 1, cell.employeesLabel.frame.origin.x - 25, 88);//cell.employerLabel.frame.size.height);

    return cell;
    
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
            [tableView deleteRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationTop];
            
            //              cell.accessoryView = [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeDown];
        }
        else
        {
            [tableView insertRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationTop];
            //            cell.accessoryView =  [DTCustomColoredAccessory accessoryWithColor:[UIColor grayColor] type:DTCustomColoredAccessoryTypeUp];
        }
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate didSelectSearchItem:[[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return;
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

-(void)MAPTheseDirections:(id)sender
{
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//    brokerEmployersData *pTab = [[self.filteredProducts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    NSArray *ck = [sender objectAtIndex:0];
    NSDictionary *pk = [ck objectAtIndex:0];
    
    //(DB) NEW API CHANGE
    NSString *destinationAddress= [NSString stringWithFormat:@"%@, %@, %@, %@", [pk valueForKey:@"address_1"], [pk valueForKey:@"city"], [pk valueForKey:@"state"], [pk valueForKey:@"zip"]]; //@"130 M Street NE, Washington, DC, 20002";
    
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

@end
