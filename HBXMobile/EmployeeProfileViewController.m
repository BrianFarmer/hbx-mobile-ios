//
//  EmployeeProfileViewController.m
//  HBXMobile
//
//  Created by David Boyd on 10/5/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "EmployeeProfileViewController.h"
#import "constants.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface EmployeeProfileViewController ()

@end

@implementation EmployeeProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    //Add reminder code when ready
    //
/*
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0,0,24,24)];
    [button1 setBackgroundImage:[UIImage imageNamed: @"bell.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(addReminder:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
*/
    navImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 0, 200, 40)];
    
    navImage.backgroundColor = [UIColor clearColor];
    navImage.image = [UIImage imageNamed:@"navHeader"];
    navImage.contentMode = UIViewContentModeCenter;
    
    self.navigationController.topViewController.navigationItem.titleView = navImage;

    vHeader.frame = CGRectMake(0,0,self.view.frame.size.width,185);

    vHeader.iCurrentPlanIndex = _currentCoverageYearIndex;
    
    vHeader.delegate = self;
//    [vHeader layoutHeaderView:_employerData];

    pName.font = [UIFont fontWithName:@"Roboto-Bold" size:24];
    
    pName.textAlignment = NSTextAlignmentCenter;
    NSString *sOwner =  ([[_employeeData valueForKey:@"is_business_owner"] boolValue] == TRUE) ? @"(Owner)" : @"";  //(clients_needing_immediate_attention > 1) ? @"have" : @"has"
    
    NSString *sMiddle = [_employeeData valueForKey:@"middle_name"];
    if (sMiddle == (NSString*)[NSNull null])
        sMiddle = @"";
    
    pName.text = [NSString stringWithFormat:@"%@ %@ %@ %@", [_employeeData valueForKey:@"first_name"], sMiddle, [_employeeData valueForKey:@"last_name"], sOwner];
    [pName sizeToFit];
    pName.frame = CGRectMake(self.view.frame.size.width/2 - pName.frame.size.width/2, 0, pName.frame.size.width, pName.frame.size.height);

    int posY = [vHeader layoutEmployeeProfile:_employerData nameY:pName.frame.origin.y + pName.frame.size.height];
    
    
//    int enrollmentIndex = 0;
    int iCnt = 0;
//    NSArray *pp1 = [[_employerData objectAtIndex:0] valueForKey:@"enrollments"];
    
    
//    NSArray *pp1 = [[_employeeData objectAtIndex:indexPath.row] valueForKey:@"enrollment"];
    NSString *sStatus = @"Not Enrolled";
    
//    if ([pp1 count] > 0)
//    {
        NSArray *pp = [[_employeeData valueForKey:@"enrollment"] valueForKey:@"health"]; //objectAtIndex:enrollmentIndex]  valueForKey:@"health"];
        
        sStatus = [pp valueForKey:@"status"];
//    }

    
    
    
    
 //   NSArray *pp = [[[_employeeData valueForKey:@"enrollments"] objectAtIndex:_currentCoverageYearIndex]  valueForKey:@"health"];

    
//    NSString *sStatus = [pp valueForKey:@"status"];
    

    pStatus_a.text = sStatus; //[[[[_employeeData valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"status"];
    if ([pStatus_a.text isEqualToString:@"Enrolled"])
        pStatus_a.textColor = EMPLOYER_DETAIL_PARTICIPATION_ENROLLED;
    if ([pStatus_a.text isEqualToString:@"Waived"])
        pStatus_a.textColor = EMPLOYER_DETAIL_PARTICIPATION_WAIVED;
    if ([pStatus_a.text isEqualToString:@"Not Enrolled"])
        pStatus_a.textColor = EMPLOYER_DETAIL_PARTICIPATION_NOT_ENROLLED;
    if ([pStatus_a.text isEqualToString:@"Terminated"])
        pStatus_a.textColor = EMPLOYER_DETAIL_PARTICIPATION_TERMINATED;
    
    pStatus_a.frame = CGRectMake(10, posY + 5, self.view.frame.size.width - 20, pStatus_a.frame.size.height); //pName.frame.origin.y + pName.frame.size.height
    pStatus_a.textAlignment = NSTextAlignmentCenter;
    
    /*
    NSString *sNextYearRenewal =  [[[[_employeeData valueForKey:@"enrollments"] valueForKey:@"renewal"] valueForKey:@"health"] valueForKey:@"status"];

    if (sNextYearRenewal != nil)
    {
        pStatus_b.text = [NSString stringWithFormat:@"%@ for next year", sNextYearRenewal];
        
        if ([sNextYearRenewal isEqualToString:@"Enrolled"])
            pStatus_b.textColor = UIColorFromRGB(0x00a99e);
        if ([sNextYearRenewal isEqualToString:@"Waived"])
            pStatus_b.textColor = UIColorFromRGB(0x625ba8);
        if ([sNextYearRenewal isEqualToString:@"Not Enrolled"])
            pStatus_b.textColor = [UIColor redColor];
    }
    
    pStatus_b.frame = CGRectMake(10, pStatus_a.frame.origin.y + pStatus_a.frame.size.height, self.view.frame.size.width - 20, pStatus_b.frame.size.height);
    pStatus_b.textAlignment = NSTextAlignmentCenter;
    
*/
    
    
    sections = [[NSArray alloc] initWithObjects: @"DETAILS", @"HEALTH PLAN", @"DEPENDENTS", nil];
    
    if (!expandedSections)
        expandedSections = [[NSMutableIndexSet alloc] init];

    [self processData];
    
    profileTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)processData
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dob = [f dateFromString:[_employeeData valueForKey:@"date_of_birth"]];
    NSDate *hired_on = [f dateFromString:[_employeeData valueForKey:@"hired_on"]];
    
    NSArray *lo = [_employeeData valueForKey:@"enrollment"]; //[[_employeeData valueForKey:@"enrollments"] objectAtIndex:_currentCoverageYearIndex];//[[[_employeeData valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"];
    
    NSDate *plan_start_on = [f dateFromString:[lo valueForKey:@"start_on"]];
    //    NSDate *plan_start_on = [f dateFromString:[pp valueForKey:@"plan_start_on"]];
    [f setDateFormat:@"MM/dd/yyyy"];
    
    detailValues = [[NSArray alloc] initWithObjects: [NSString stringWithFormat:@"DOB: %@", [f stringFromDate:dob]], [NSString stringWithFormat:@"SSN: %@", [_employeeData valueForKey:@"ssn_masked"]], [NSString stringWithFormat:@"Hired on: %@", [f stringFromDate:hired_on]], nil];
    /*
     dependentValues = [[NSArray alloc] initWithObjects: [NSString stringWithFormat:@"Benefit Group: %@", [lo valueForKey:@"benefit_group_name"]], [NSString stringWithFormat:@"Plan Name: %@", [lo valueForKey:@"plan_name"]], [NSString stringWithFormat:@"Plan Start: %@", [f stringFromDate:plan_start_on]], [[lo valueForKey:@"employer_contribution"] stringValue], [[lo valueForKey:@"employee_cost"] stringValue], [[lo valueForKey:@"total_premium"] stringValue], [lo valueForKey:@"metal_level"], nil];
     */
    if ([pStatus_a.text isEqualToString:@"Terminated"])
    {
        [f setDateFormat:@"yyyy-MM-dd"];
        NSDate *term_on = [f dateFromString:[[lo valueForKey:@"health"] valueForKey:@"terminated_on"]];
        [f setDateFormat:@"MM/dd/yyyy"];
        
        dependentValues = [[NSArray alloc] initWithObjects: [NSString stringWithFormat:@"Benefit Group: %@", [[lo valueForKey:@"health"] valueForKey:@"benefit_group_name"]], [NSString stringWithFormat:@"Plan Name: %@", [[lo valueForKey:@"health"] valueForKey:@"plan_name"]], [NSString stringWithFormat:@"Plan Terminated On: %@", [f stringFromDate:term_on]], [NSString stringWithFormat:@"Terminated Reason: %@", [[lo valueForKey:@"health"] valueForKey:@"terminate_reason"]], [NSString stringWithFormat:@"Metal Level: %@", [[lo valueForKey:@"health"] valueForKey:@"metal_level"]], @"", nil];
    }
    else if ([pStatus_a.text isEqualToString:@"Not Enrolled"])
    {
        dependentValues = [[NSArray alloc] initWithObjects: @"Not Enrolled in any plan for this year", @"", nil];
    }
    else
    {
        [f setDateFormat:@"yyyy-MM-dd"];
        //       NSDate *plan_start_on = [f dateFromString:_employerData.planYear];
        NSDate *plan_start_on = [f dateFromString:[lo valueForKey:@"start_on"]];
        
        [f setDateFormat:@"MM/dd/yyyy"];
        
        NSString *planName = [[lo valueForKey:@"health"] valueForKey:@"plan_name"];
        if (planName == (NSString*)[NSNull null])
            planName = [NSString stringWithFormat:@"%@(%@)", @"N/A", pStatus_a.text];
        
        NSString *metalLevel = [[lo valueForKey:@"health"] valueForKey:@"metal_level"];
        if (metalLevel == (NSString*)[NSNull null])
            metalLevel = @"N/A";
        
        dependentValues = [[NSArray alloc] initWithObjects: [NSString stringWithFormat:@"Benefit Group: %@", [[lo valueForKey:@"health"] valueForKey:@"benefit_group_name"]], [NSString stringWithFormat:@"Plan Name: %@", planName], [NSString stringWithFormat:@"Plan Start: %@", [f stringFromDate:plan_start_on]], [NSString stringWithFormat:@"Metal Level: %@", metalLevel], @"", nil];
    }

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
    
//    [vHeader drawCoverageYear:_currentCoverageYearIndex];
    
    int navbarHeight = self.navigationController.navigationBar.frame.size.height + 25; //Extra 25 must be accounted for. It is the status bar height (clock, batttery indicator)
    
    profileTable.frame = CGRectMake(0, vHeader.frame.origin.y + vHeader.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - navbarHeight - vHeader.frame.size.height);
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([expandedSections containsIndex:section])
    {
        if (section == 0)
            return [detailValues count];
        
        if (section == 1)
            return [dependentValues count];
        
        if (section == 2)
            return [[_employeeData valueForKey:@"dependents"] count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 24;
    if (indexPath.section == 1)
    {
        if (indexPath.row < [dependentValues count] - 1)
        {
            NSString *cellText = [dependentValues objectAtIndex:indexPath.row];
            UIFont *cellFont = [UIFont fontWithName:@"Roboto-Regular" size:14];
            
            if ([cellText length] > 0)
            {
                NSAttributedString *attributedText =
                [[NSAttributedString alloc] initWithString:cellText
                                                attributes:@{NSFontAttributeName: cellFont}];
                CGRect rect = [attributedText boundingRectWithSize:(CGSize){tableView.frame.size.width, CGFLOAT_MAX}
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:nil];
                CGSize size = rect.size;

//                CGSize size = [cellText sizeWithAttributes:
  //                             @{NSFontAttributeName: cellFont}];
                
                // Values are fractional -- you should take the ceilf to get equivalent values
                CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
                
                if (adjustedSize.height < 20)
                    return 25;
                
                return adjustedSize.height;
            }
            
            return 24;
        }
        else
            return 85;
    }
    return 44;
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
            headerView.backgroundColor = [UIColor lightGrayColor]; //UIColorFromRGB(0x00a99e);//[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
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
    
    if ([expandedSections containsIndex:section])
    {
        /*
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-50, 9, 32, 32)];
        button.layer.cornerRadius = 16;
        button.layer.borderWidth = 2;
        button.layer.borderColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1].CGColor;
        button.clipsToBounds = YES;
        button.tag = section;
        [button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:12.0];
        [button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
//        if (section == 2)
//            [button setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)[[_employeeData valueForKey:@"dependents"] count]] forState:UIControlStateNormal];
//        else
//        {
            button.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
     //       [button setTitle:[NSString stringWithFormat:@"%@", @"^"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"chevronblue.png"] forState:UIControlStateNormal];
//        }
        
        [headerView addSubview:button];

      */
        
        

        UIImageView *imgVew = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width-51, 8, 34, 34)];
        imgVew.backgroundColor = [UIColor clearColor];
        imgVew.image = [self imageWithImage:[UIImage imageNamed:@"upArrowBlue3.png"]  scaledToSize:CGSizeMake(34, 34)];//[UIImage imageNamed:@"close_arrow32x32.png"];
//        imgVew.contentMode = UIViewContentModeScaleAspectFit;
        // Add the image to the header view
        [headerView addSubview:imgVew];
 
    }
    else
    {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width-50, 9, 32, 32)];
        button.layer.cornerRadius = 16;
        button.layer.borderWidth = 2;
        button.layer.borderColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1].CGColor;
        button.clipsToBounds = YES;
        button.tag = section;
        [button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:12.0];
        [button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        if (section == 2)
            [button setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)[[_employeeData valueForKey:@"dependents"] count]] forState:UIControlStateNormal];
        else
        {
            button.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:24.0];
            [button setTitle:[NSString stringWithFormat:@"%@", @"+"] forState:UIControlStateNormal];
        }
        
        [headerView addSubview:button];
    }
    
    headerView.backgroundColor = UIColorFromRGB(0xebebeb); //[UIColor colorWithRed:216.0f/255.0f green:216.0f/255.0f blue:216.0f/255.0f alpha:1.0f];
    headerLabel.frame = CGRectMake(8, 0, tableView.frame.size.width - 5, 48);
    headerLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];;//UIColorFromRGB(0x007bc4);
    headerLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16.0];
    headerLabel.text = [sections objectAtIndex:section];///  @"This is the custom header view";
    headerLabel.textAlignment = NSTextAlignmentLeft;
    // Add the label to the header view
    [headerView addSubview:headerLabel];
    
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [headerView addGestureRecognizer:recognizer];
    
    return headerView;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    UIView *pHeaderView = (UIView*)sender.view;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];

    [profileTable beginUpdates];
    [profileTable reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
    [self tableView:profileTable didSelectHeader:indexPath];
    
    [profileTable endUpdates];
    
    if ([expandedSections containsIndex:pHeaderView.tag])
    {
        if ([profileTable numberOfRowsInSection:pHeaderView.tag] > 0)
            [profileTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)handleButtonTap:(id)sender {
    UIView *pHeaderView = (UIView*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
    
    [profileTable beginUpdates];
    [profileTable reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
    [self tableView:profileTable didSelectHeader:indexPath];
    
    [profileTable endUpdates];
    
    if ([expandedSections containsIndex:pHeaderView.tag])
        [profileTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
            if ((rows = [self tableView:tableView numberOfRowsInSection:section]) == 0)
                [expandedSections removeIndex:section];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        UIView *contributionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, profileTable.frame.size.width, 85)];
        contributionView.tag = 120;
        contributionView.hidden = YES;

        UILabel *lblContributionEmployee = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        lblContributionEmployee.tag = 121;
        lblContributionEmployee.numberOfLines = 2;
        lblContributionEmployee.textAlignment = NSTextAlignmentCenter;
        [lblContributionEmployee sizeToFit];
        [contributionView addSubview:lblContributionEmployee];
        
        
        UILabel *lblContributionSpouse = [[UILabel alloc] initWithFrame:CGRectMake(100,10,100, 20)];
        lblContributionSpouse.tag = 122;
        lblContributionSpouse.numberOfLines = 3;
        lblContributionSpouse.textAlignment = NSTextAlignmentCenter;
        [lblContributionSpouse sizeToFit];
        [contributionView addSubview:lblContributionSpouse];
        
        
        UILabel *lblContributionPartner = [[UILabel alloc] initWithFrame:CGRectMake(200,10,100, 20)];
        lblContributionPartner.tag = 123;
        lblContributionPartner.numberOfLines = 3;
        lblContributionPartner.textAlignment = NSTextAlignmentCenter;
        [lblContributionPartner sizeToFit];
        [contributionView addSubview:lblContributionPartner];

        [cell.contentView addSubview:contributionView];
    }
    
    UIView *lblContributionView = (UIView *)[cell viewWithTag:120];
    lblContributionView.hidden = YES;

    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:12];
    
    cell.textLabel.textColor = UIColorFromRGB(0x555555);
    cell.detailTextLabel.textColor = UIColorFromRGB(0x555555);

    if (indexPath.section == 0)
    {
        cell.textLabel.text = [detailValues objectAtIndex:indexPath.row];
    }

    if (indexPath.section == 1)
    {
        if (indexPath.row < [dependentValues count] - 1)
            cell.textLabel.text = [dependentValues objectAtIndex:indexPath.row];
        else
        {
   //         NSArray *lo = [[[_employeeData valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"];
            NSArray *lo = [_employeeData valueForKey:@"enrollment"];// objectAtIndex:_currentCoverageYearIndex];//[[[_employeeData valueForKey:@"enrollments"]
            
            lblContributionView.hidden = NO;
            UILabel *lblContributionTotal = (UILabel *)[cell viewWithTag:121];
            UILabel *lblContributionEmployer = (UILabel *)[cell viewWithTag:122];
            UILabel *lblContributionEmployee = (UILabel *)[cell viewWithTag:123];

            lblContributionTotal.frame = CGRectMake(20,10,100, 20);
            lblContributionEmployer.frame = CGRectMake(100,10,100, 20);
            lblContributionEmployee.frame = CGRectMake(200,10,100, 20);
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
            [numberFormatter setMaximumFractionDigits:2];
            
            ;
   /*
            topSectionNames = [[NSArray alloc] initWithObjects: @"Employee Contribution", @"Employer Contribution", @"TOTAL", nil];
            topSectionValues = [[NSArray alloc] initWithObjects: [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[dictionary valueForKeyPath:@"employee_contribution"] floatValue]]], [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[dictionary valueForKeyPath:@"employer_contribution"] floatValue]]], [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [[dictionary valueForKeyPath:@"total_premium"] floatValue]]], nil];
*/
            
            if (![[[lo valueForKey:@"health"] valueForKey:@"status"] isEqualToString:@"Not Enrolled"])
            {
                NSString *totalCont = [NSString stringWithFormat:@"%@",  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[[lo valueForKey:@"health"] valueForKey:@"total_premium"] floatValue]]]];
                
                
                lblContributionTotal.attributedText = [self setAttributedLabel:totalCont text2:@"\nPREMIUM" color:UIColorFromRGB(0x00a3e2)];
                [lblContributionTotal sizeToFit];
                
                NSString *employerCont = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[[lo valueForKey:@"health"] valueForKey:@"employer_contribution"] floatValue]]]];
                lblContributionEmployer.attributedText = [self setAttributedLabel:employerCont text2:@"\nEMPLOYER\nCONTRIBUTION" color:UIColorFromRGB(0x00a99e)];
                
                [lblContributionEmployer sizeToFit];
                
                NSString *employeeCont = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[[lo valueForKey:@"health"] valueForKey:@"employee_cost"] floatValue]]]];
                lblContributionEmployee.attributedText = [self setAttributedLabel:employeeCont text2:@"\nEMPLOYEE\nPAYS" color:UIColorFromRGB(0x625ba8)];
                [lblContributionEmployee sizeToFit];
                
                [self evenlySpaceTheseButtonsInThisView:@[lblContributionTotal, lblContributionEmployer, lblContributionEmployee] :lblContributionView];
            }
        }
    }

    if (indexPath.section == 2)
    {
        cell.detailTextLabel.textColor = UIColorFromRGB(0x555555); //[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12];

        NSArray *po = [_employeeData valueForKey:@"dependents"][indexPath.row];
        
        NSString *sMiddle = [po valueForKey:@"middle_name"];
        if (sMiddle == (NSString*)[NSNull null])
            sMiddle = @"";
        NSString *sSuffix = [po valueForKey:@"name_suffix"];
        if (sSuffix == (NSString*)[NSNull null])
            sSuffix = @"";
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", [po valueForKey:@"first_name"], sMiddle, [po valueForKey:@"last_name"], sSuffix];
        
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *dob = [f dateFromString:[po valueForKey:@"date_of_birth"]];
        
        [f setDateFormat:@"MM/dd/yyyy"];

        cell.detailTextLabel.text = [NSString stringWithFormat:@"dob: %@ \t \tgender: %@", [f stringFromDate:dob], [po valueForKey:@"gender"]];
    }
    return cell;
}

-(NSAttributedString*)setAttributedLabel:(NSString*)labelText1 text2:(NSString*)labelText2 color:(UIColor*)color
{
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : color };
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:labelText1 attributes:attrs];
    
    [attributedTitle beginEditing];
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:20] range:NSMakeRange(0, attributedTitle.length)];
    [attributedTitle endEditing];
/*
    NSMutableAttributedString *attributedTitle1 = [[NSMutableAttributedString alloc] initWithString:@"%\n" attributes:attrs];
    
    [attributedTitle1 beginEditing];
    [attributedTitle1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:18] range:NSMakeRange(0, attributedTitle1.length)];
    [attributedTitle1 endEditing];
*/
    NSMutableAttributedString *attributedTitle2 = [[NSMutableAttributedString alloc] initWithString:labelText2 attributes:attrs];
    
    [attributedTitle2 beginEditing];
    [attributedTitle2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:12] range:NSMakeRange(0, attributedTitle2.length)];
    [attributedTitle2 endEditing];
    
//    [attributedTitle appendAttributedString:attributedTitle1];
    [attributedTitle appendAttributedString:attributedTitle2];
    
    return attributedTitle;
}

-(void)addReminder:(id)sender
{
    
}

-(BOOL)changeCoverageYear:(NSInteger)index
{
//    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    if (![_delegate isEmployeeProfileDataAvailable:index empId:[_employeeData valueForKey:@"id"]])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No data available"
                                                                                 message:@"The employee does not have any data available for the coverage year you selected."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return FALSE;
    }
    
    _currentCoverageYearIndex = index;
    vHeader.iCurrentPlanIndex = index;
//    tabBar.current_coverage_year_index = index;
    
//    int iCnt = 0;
//    NSArray *pp1 = [_employeeData valueForKey:@"enrollment"];
//    NSArray *lo = [[_employeeData valueForKey:@"enrollments"] objectAtIndex:_enrollmentIndex];//[[[_employeeData valueForKey:@"enrollments"]
//    NSArray *employerData1 = [[_employerData valueForKey:@"plan_years"] objectAtIndex:_currentCoverageYearIndex];
    /*
    for (id py in pp1)
    {
        NSString *sPlanYear = [[[_employerData valueForKey:@"plan_years"] objectAtIndex:index] valueForKey:@"plan_year_begins"];
        if ([[py valueForKey:@"start_on"] isEqualToString:sPlanYear])
        {
            _currentCoverageYearIndex = iCnt;
            NSString *sStatus = [[py valueForKey:@"health"] valueForKey:@"status"];
            
            pStatus_a.text = sStatus;
            if ([pStatus_a.text isEqualToString:@"Enrolled"])
                pStatus_a.textColor = EMPLOYER_DETAIL_PARTICIPATION_ENROLLED;
            if ([pStatus_a.text isEqualToString:@"Waived"])
                pStatus_a.textColor = EMPLOYER_DETAIL_PARTICIPATION_WAIVED;
            if ([pStatus_a.text isEqualToString:@"Not Enrolled"])
                pStatus_a.textColor = EMPLOYER_DETAIL_PARTICIPATION_NOT_ENROLLED;
            if ([pStatus_a.text isEqualToString:@"Terminated"])
                pStatus_a.textColor = EMPLOYER_DETAIL_PARTICIPATION_TERMINATED;
        }
        iCnt++;
    }
    */
//    NSString *sPlanYear = [[[tabBar.detailDictionary valueForKey:@"plan_years"] objectAtIndex:_currentCoverageYearIndex] valueForKey:@"plan_year_begins"];
//    displayArray = [tabBar.rosterDictionary valueForKey:sPlanYear];

    [_delegate setCoverageYearIndex:index];
    _employeeData = [_delegate getEmployeeData:[_employeeData valueForKey:@"id"]];
    
    NSString *sStatus = @"Not Enrolled";
    
    //    if ([pp1 count] > 0)
    //    {
    NSArray *pp = [[_employeeData valueForKey:@"enrollment"] valueForKey:@"health"]; //objectAtIndex:enrollmentIndex]  valueForKey:@"health"];
    
    sStatus = [pp valueForKey:@"status"];
    pStatus_a.text = sStatus;
    if ([pStatus_a.text isEqualToString:@"Enrolled"])
        pStatus_a.textColor = EMPLOYER_DETAIL_PARTICIPATION_ENROLLED;
    if ([pStatus_a.text isEqualToString:@"Waived"])
        pStatus_a.textColor = EMPLOYER_DETAIL_PARTICIPATION_WAIVED;
    if ([pStatus_a.text isEqualToString:@"Not Enrolled"])
        pStatus_a.textColor = EMPLOYER_DETAIL_PARTICIPATION_NOT_ENROLLED;
    if ([pStatus_a.text isEqualToString:@"Terminated"])
        pStatus_a.textColor = EMPLOYER_DETAIL_PARTICIPATION_TERMINATED;


    
    [self processData];
    
    [profileTable reloadData];
    
    return TRUE;
}

-(NSInteger)getPlanIndex
{
//    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    return _currentCoverageYearIndex;//tabBar.current_coverage_year_index;
}

@end
