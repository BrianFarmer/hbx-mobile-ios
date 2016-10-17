//
//  plansBrokerEmployerViewController.m
//  HBXMobile
//
//  Created by David Boyd on 9/20/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "plansBrokerEmployerViewController.h"
#import "benefitGroupCardView.h"
#import <QuartzCore/QuartzCore.h>
#import "Settings.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define VERSION 2

@interface plansBrokerEmployerViewController ()

@end

@implementation plansBrokerEmployerViewController

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
    
    //self.navigationController.topViewController.title = @"info";
    vHeader.frame = CGRectMake(0,0,self.view.frame.size.width,175);
    [vHeader layoutHeaderView:employerData];
    
    pCompany.font = [UIFont fontWithName:@"Roboto-Bold" size:24];
    pCompany.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, 65);
    
    pCompany.textAlignment = NSTextAlignmentCenter;
    pCompany.text = employerData.companyName;
    
    pCompanyFooter.frame = CGRectMake(10, pCompany.frame.origin.y + pCompany.frame.size.height, self.view.frame.size.width - 20, pCompanyFooter.frame.size.height);
    pCompanyFooter.textAlignment = NSTextAlignmentCenter;
    pCompanyFooter.font = [UIFont fontWithName:@"Roboto-Bold" size:18];
    
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
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Roboto-Bold" size:12], NSFontAttributeName,
                                [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1], NSForegroundColorAttributeName, nil];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"ACTIVE YEAR", @"IN RENEWAL", nil];
    UISegmentedControl *planYearControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    planYearControl.frame = CGRectMake(self.view.frame.size.width/2 - 80, [self.view viewWithTag:30].frame.origin.y + [self.view viewWithTag:30].frame.size.height + 10, 160, 30);
    [planYearControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [planYearControl setTintColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]];
    
    [planYearControl addTarget:self action:@selector(HandleSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    planYearControl.selectedSegmentIndex = 0;
    
    [self.view addSubview:planYearControl];

    Settings *obj=[Settings getInstance];

    if (obj.iPlanVersion == 2)
    {

        CGSize size = [[UIScreen mainScreen] bounds].size;
        CGFloat frameX = size.width;
        CGFloat frameY = size.height-30; 

        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, vHeader.frame.origin.y + vHeader.frame.size.height, self.view.frame.size.width, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height)]; //155, frameX, 200)];
                                     
        scrollView.pagingEnabled = YES;
        
        scrollView.backgroundColor = UIColorFromRGB(0xebebeb);//UIColorFromRGB(0xd3d3d3); //d3d3d3
        scrollView.contentSize = CGSizeMake(frameX, frameY);
        scrollView.delegate = self;
        
        [self.view addSubview: scrollView];
      
    //    NSDictionary *aa = [[[_delegate getEmployer] valueForKey:@"plan_offerings"] valueForKey:@"active"];
        
        NSArray *po = [[[self getEmployer] valueForKey:@"plan_offerings"] valueForKey:@"active"];// valueForKey:@"active"];

        for(int i = 0; i < [po count]; i++)
        {
            benefitGroupCardView *cardView = [[benefitGroupCardView alloc] initWithFrame:CGRectMake(frameX * i + 10, 10.0, frameX - 20, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height - 30)];
            cardView.po = [po objectAtIndex:i];
            cardView.delegate = self;
            cardView.tag = 300+i;
            [cardView layoutView:i+1 totalPages:[po count]];
            cardView.layer.cornerRadius = 3;
    /*
            cardView.layer.masksToBounds = NO;
            cardView.layer.shadowOffset = CGSizeMake(-2, 5);
            cardView.layer.shadowRadius = 5;
            cardView.layer.shadowOpacity = 0.5;
            cardView.layer.shadowPath = [UIBezierPath bezierPathWithRect:cardView.bounds].CGPath;
    */        
            [scrollView addSubview:cardView];
        }
        
        scrollView.contentSize = CGSizeMake(frameX*[po count], self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height - 40);//200);

        
        // Init Page Control
        pageControl = [[UIPageControl alloc] init];
    //    pageControl.frame = CGRectMake(10, scrollView.frame.origin.y - 20, scrollView.frame.size.width, 20);
        //369+165
        pageControl.frame = CGRectMake(10,self.tabBarController.tabBar.frame.origin.y - 20,scrollView.frame.size.width-20, 20);
        pageControl.numberOfPages = [po count];
        pageControl.currentPage = 0;
        pageControl.backgroundColor = [UIColor clearColor];
        
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self.view addSubview:pageControl];
    }
    else
    {
        plans = [[tabBar.detailDictionary valueForKey:@"plan_offerings"] valueForKey:@"active"];// valueForKey:@"active"];

        planTable = [[UITableView alloc] initWithFrame:CGRectMake(0, vHeader.frame.origin.y + vHeader.frame.size.height + 5, self.view.frame.size.width, self.view.frame.size.height - 65) style:UITableViewStyleGrouped];
        planTable.dataSource = self;
        planTable.delegate = self;
        planTable.rowHeight = 44.0f;
        planTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        planTable.separatorColor = [UIColor whiteColor];
        
        [planTable setBackgroundView:nil];
        [planTable setBackgroundColor:[UIColor whiteColor]];  //[UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:1.0]];
        [self.view addSubview:planTable];
        
        if (!expandedSections)
            expandedSections = [[NSMutableIndexSet alloc] init];
/*
        _planDetails = [[NSMutableArray alloc] init];
        _planDentalDetails = [[NSMutableArray alloc] init];
        for (int ii = 0;ii<[plans count];ii++)
        {

            [_planDetails addObject:[NSArray arrayWithObjects:@"PLANS OFFERED", [plans[ii] valueForKey:@"eligibility_rule"], nil]];
            [_planDetails addObject:[NSArray arrayWithObjects:@"ELIGIBILITY", [plans[ii] valueForKey:@"eligibility_rule"], nil]];
            [_planDetails addObject:[NSArray arrayWithObjects:@"CONTRIBUTION LEVELS", @"0", nil]];
            [_planDetails addObject:[NSArray arrayWithObjects:@"REFERENCE PLAN", [[plans[ii] valueForKey:@"health"] valueForKey:@"reference_plan_name"], nil]];
            
        //    _planDentalDetails = [[NSMutableArray alloc] init];
            
            if ([plans valueForKey:@"dental"] != [NSNull null])
            {
                [_planDentalDetails addObject:[NSArray arrayWithObjects:@"ELIGIBILITY", [plans valueForKey:@"eligibility_rule"], nil]];
                [_planDentalDetails addObject:[NSArray arrayWithObjects:@"CONTRIBUTION LEVELS", @"0", nil]];
                [_planDentalDetails addObject:[NSArray arrayWithObjects:@"ELECTED DENTAL PLANS", [NSString stringWithFormat:@"\t\u2022 %@", @"BlueDental Preferred"], nil]];
                [_planDentalDetails addObject:[NSArray arrayWithObjects:@"EPLIST", [NSString stringWithFormat:@"\t\u2022 %@", @"BlueDental Traditional"], nil]];
                [_planDentalDetails addObject:[NSArray arrayWithObjects:@"EPLIST", [NSString stringWithFormat:@"\t\u2022 %@", @"Delta Dental PPO Basic Plan for Families for Small Businesses"], nil]];
                [_planDentalDetails addObject:[NSArray arrayWithObjects:@"REFERENCE PLAN", [[plans valueForKey:@"dental"] valueForKey:@"reference_plan_name"], nil]];
            }
        }
*/
    }
  
}

-(void)viewWillAppear:(BOOL)animated
{
    int navbarHeight = self.navigationController.navigationBar.frame.size.height + 25; //Extra 25 must be accounted for. It is the status bar height (clock, batttery indicator)
    
    planTable.frame = CGRectMake(0, vHeader.frame.origin.y + vHeader.frame.size.height + 5, self.view.frame.size.width, self.view.frame.size.height - navbarHeight - vHeader.frame.size.height);
}

-(void)scrolltoNextPage:(int)page
{
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width*page, 0.0f) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)sView
{
    int width = sView.frame.size.width;
    float xPos = sView.contentOffset.x+10;
    
    //Calculate the page we are on based on x coordinate position and width of scroll view
    pageControl.currentPage = (int)xPos/width;
}

- (void)HandleSegmentControlAction:(UISegmentedControl *)segment
{
    Settings *obj=[Settings getInstance];
    
    if (obj.iPlanVersion == 1)
    {
        employerTabController *tabBar = (employerTabController *) self.tabBarController;
        if(segment.selectedSegmentIndex == 0)
            plans = [[tabBar.detailDictionary valueForKey:@"plan_offerings"] valueForKey:@"active"];// valueForKey:@"active"];
        else
            plans = [[tabBar.detailDictionary valueForKey:@"plan_offerings"] valueForKey:@"renewal"];// valueForKey:@"active"];
        
        [planTable reloadData];
    }
    else
    {
        if(segment.selectedSegmentIndex == 0)
        {
            for(UIView *subview in [scrollView subviews]) {
                [subview removeFromSuperview];
            }
            
            CGSize size = [[UIScreen mainScreen] bounds].size;
            CGFloat frameX = size.width;
            
            NSArray *pRenewal = [[[self getEmployer] valueForKey:@"plan_offerings"] valueForKey:@"active"];
            
            for(int i = 0; i < [pRenewal count]; i++)
            {
                benefitGroupCardView *cardView = [[benefitGroupCardView alloc] initWithFrame:CGRectMake(frameX * i + 10, 10.0, frameX - 20, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height - 30)];
                cardView.po = [pRenewal objectAtIndex:i];
                cardView.delegate = self;
                cardView.tag = 300+i;
                [cardView layoutView:i+1 totalPages:[pRenewal count]];
                cardView.layer.cornerRadius = 3;
                
                [scrollView addSubview:cardView];
            }
            
            pageControl.numberOfPages = [pRenewal count];
        }
        
        if(segment.selectedSegmentIndex == 1)
        {
            /*
             NSArray *po = [[[self getEmployer] valueForKey:@"plan_offerings"] valueForKey:@"active"];
             
             for(int i = 0; i < [po count]; i++)
             {
                 benefitGroupCardView *cardView = [self.view viewWithTag:300+i];
                 [cardView removeFromSuperview];
             }
            */
            for(UIView *subview in [scrollView subviews]) {
                [subview removeFromSuperview];
            }

            CGSize size = [[UIScreen mainScreen] bounds].size;
            CGFloat frameX = size.width;

            NSArray *pRenewal = [[[self getEmployer] valueForKey:@"plan_offerings"] valueForKey:@"renewal"];
            
            for(int i = 0; i < [pRenewal count]; i++)
            {
                benefitGroupCardView *cardView = [[benefitGroupCardView alloc] initWithFrame:CGRectMake(frameX * i + 10, 10.0, frameX - 20, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height - 30)];
                cardView.po = [pRenewal objectAtIndex:i];
                cardView.delegate = self;
                cardView.tag = 300+i;
                [cardView layoutView:i+1 totalPages:[pRenewal count]];
                cardView.layer.cornerRadius = 3;
     
                [scrollView addSubview:cardView];
            }
            
            pageControl.numberOfPages = [pRenewal count];
        }
    }

}

-(NSDictionary*)getEmployer
{
    return ((employerTabController *) self.tabBarController).detailDictionary;
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
-(void)phoneEmployer:(id)sender
{
    //    -(void)showAddressBook{
    ABPeoplePickerNavigationController *_addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [_addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:_addressBookController animated:YES completion:nil];
    //    }

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if ([_planDentalDetails count] > 0)
//        return 2;
    
    return [plans count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([expandedSections containsIndex:section])
    {
//        if (section == 1)
//            return 6;
        if ([plans[section] valueForKey:@"dental"] != [NSNull null])
            return 5 + 9;
        else
            return 5;
    }
    
    return 0;//[plans count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3 || indexPath.row == 8) // && (indexPath.section == 0 || indexPath.section == 1))
        return 118;
    
    if (indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12)
        return 35;
    
//    if (indexPath.section == 1 && indexPath.row == 5 )
//        return 55;
    
    CGSize labelSize = CGSizeMake(200.0, 20.0);
    NSString *cellText;
    if (indexPath.section == 0)
        cellText = [plans[indexPath.section] valueForKey:@"eligibility_rule"];//[[_planDetails objectAtIndex:indexPath.row] objectAtIndex:1];
    else
        cellText = [plans[indexPath.section] valueForKey:@"eligibility_rule"];//[[_planDentalDetails objectAtIndex:indexPath.row] objectAtIndex:1];
    
    UIFont *cellFont = [UIFont fontWithName:@"Roboto-Regular" size:14];
    
    if ([cellText length] > 0)
        labelSize = [cellText sizeWithFont: cellFont constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
    
    if (labelSize.height + 10 < 44)
        return 44;
    
    return (labelSize.height + 20);
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
    
    CGRect CellFrame = CGRectMake(0, 0, self.view.frame.size.width, 105);
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    UIView *conrtibutionView = [[UIView alloc] initWithFrame:CellFrame];
    conrtibutionView.tag = 120;
    conrtibutionView.hidden = YES;
 
    UILabel *lblContribution = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    lblContribution.text = @"CONTRIBUTION LEVELS";
    lblContribution.font = [UIFont fontWithName:@"Roboto-Bold" size:14.0f];
    lblContribution.textColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];//UIColorFromRGB(0x555555);
    lblContribution.textAlignment = NSTextAlignmentLeft;
    [lblContribution sizeToFit];
    [conrtibutionView addSubview:lblContribution];
    
    UILabel *lblContributionEmployee = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 100, 20)];
    lblContributionEmployee.tag = 121;
    lblContributionEmployee.numberOfLines = 2;
    lblContributionEmployee.textAlignment = NSTextAlignmentCenter;
    [lblContributionEmployee sizeToFit];
    [conrtibutionView addSubview:lblContributionEmployee];
    
    
    UILabel *lblContributionSpouse = [[UILabel alloc] initWithFrame:CGRectMake(100,30,100, 20)];
    lblContributionSpouse.tag = 122;
    lblContributionSpouse.numberOfLines = 2;
    lblContributionSpouse.textAlignment = NSTextAlignmentCenter;
    [lblContributionSpouse sizeToFit];
    [conrtibutionView addSubview:lblContributionSpouse];
    
    
    UILabel *lblContributionPartner = [[UILabel alloc] initWithFrame:CGRectMake(200,30,100, 20)];
    lblContributionPartner.tag = 123;
    lblContributionPartner.numberOfLines = 3;
    lblContributionPartner.textAlignment = NSTextAlignmentCenter;
    [lblContributionPartner sizeToFit];
    [conrtibutionView addSubview:lblContributionPartner];
    
    
    UILabel *lblContributionChild = [[UILabel alloc] initWithFrame:CGRectMake(300, 30, 100, 20)];
    lblContributionChild.tag = 124;
    lblContributionChild.numberOfLines = 2;
    lblContributionChild.textAlignment = NSTextAlignmentCenter;
    [lblContributionChild sizeToFit];
    [conrtibutionView addSubview:lblContributionChild];
    
    //    [self evenlySpaceTheseButtonsInThisView:@[lblContributionEmployee, lblContributionSpouse, lblContributionPartner, lblContributionChild] :conrtibutionView];
    
    [cell.contentView addSubview:conrtibutionView];
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // The view for the header
    //    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.size.width/2 - 75, 0, 150, 34)];
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    
    // Set a custom background color and a border
    headerView.backgroundColor = UIColorFromRGB(0xebebeb);//[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
    headerView.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;//[UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    headerView.tag = section;
    
    // Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 0, tableView.frame.size.width - 5, 48);
    //    headerLabel.frame = CGRectMake(tableView.frame.size.width/2-75, 0, 150, 34);
    headerLabel.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    headerLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    headerLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16.0];

    headerLabel.text = [[[plans objectAtIndex:section] valueForKey:@"benefit_group_name"] uppercaseString];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // Add the label to the header view
    [headerView addSubview:headerLabel];
    
    if ([expandedSections containsIndex:section])
    {
        UIImageView *imgVew = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width-50, 9, 32, 32)];
        imgVew.backgroundColor = [UIColor clearColor];
        imgVew.image = [UIImage imageNamed:@"close_arrow32x32.png"];
        imgVew.contentMode = UIViewContentModeScaleAspectFit;
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
  //      [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1] forState:UIControlStateNormal];

        button.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:24.0];
        [button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
//        UIImage *btnImage = [UIImage imageNamed:@"open_plus32x32.png"];
//        [button setImage:btnImage forState:UIControlStateNormal];

        [button setTitle:[NSString stringWithFormat:@"%@", @"+"] forState:UIControlStateNormal];
        
        [headerView addSubview:button];
    }
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [headerView addGestureRecognizer:recognizer];
    
    return headerView;
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    UIView *pHeaderView = (UIView*)sender.view;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
    
    [planTable beginUpdates];
    [planTable reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
    [self tableView:planTable didSelectHeader:indexPath];
    
    [planTable endUpdates];
    
    if ([expandedSections containsIndex:pHeaderView.tag])
        [planTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)handleButtonTap:(id)sender {
    UIView *pHeaderView = (UIView*)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
    
    [planTable beginUpdates];
    [planTable reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
    [self tableView:planTable didSelectHeader:indexPath];
    
    [planTable endUpdates];
    
    if ([expandedSections containsIndex:pHeaderView.tag])
        [planTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
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
        
        cell = [self getCellContentView:CellIdentifier];
        
        CGRect sepFrame = CGRectMake(10, 45, tableView.frame.size.width - 90, 1);
        UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
        seperatorView.hidden = TRUE;
        seperatorView.tag = 976;
        seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
        [cell.contentView addSubview:seperatorView];

    }
    
//    cell.backgroundColor = UIColorFromRGB(0xebebeb);
    cell.textLabel.textColor = UIColorFromRGB(0x555555);
    cell.detailTextLabel.textColor = UIColorFromRGB(0x555555);
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    
//    cell.textLabel.text = [[[plans objectAtIndex:indexPath.row] valueForKey:@"benefit_group_name"] uppercaseString];
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]; //[UIColor redColor];
    //    cell.detailTextLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    

    UIView *lblContributionView = (UIView *)[cell viewWithTag:120];
    lblContributionView.hidden = YES;
    
    UILabel *pSeperator = [cell viewWithTag:976];
    pSeperator.hidden = TRUE;

//    if (indexPath.section == 0)
    {
        //        NSString *txt = [[_planDetails objectAtIndex:indexPath.row] objectAtIndex:1];
        NSString *sKey;
        //if (indexPath.section == 0 && indexPath.row == 2)
        if (indexPath.row == 3 || indexPath.row == 8)
        {
            lblContributionView.hidden = NO;
            UILabel *lblContributionEmployee = (UILabel *)[cell viewWithTag:121];
            UILabel *lblContributionSpouse = (UILabel *)[cell viewWithTag:122];
            UILabel *lblContributionPartner = (UILabel *)[cell viewWithTag:123];
            UILabel *lblContributionChild = (UILabel *)[cell viewWithTag:124];

            if (indexPath.row == 3)
                sKey = @"health";
            else
                sKey = @"dental";
            
            NSString *empCont =  [[[[plans[indexPath.section] valueForKey:sKey] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"employee"] stringValue];
            lblContributionEmployee.attributedText = [self setAttributedLabel:empCont text2:@"EMPLOYEE" color:UIColorFromRGB(0x00a3e2)];
            
            [lblContributionEmployee sizeToFit];
            
            NSString *spouseCont =  [[[[plans[indexPath.section] valueForKey:sKey] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"spouse"] stringValue];
            lblContributionSpouse.attributedText = [self setAttributedLabel:spouseCont text2:@"SPOUSE" color:UIColorFromRGB(0x00a99e)];
            
            [lblContributionSpouse sizeToFit];
            
            NSString *partnerCont =  [[[[plans[indexPath.section] valueForKey:sKey] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"domestic_partner"] stringValue];
            lblContributionPartner.attributedText = [self setAttributedLabel:partnerCont text2:@"DOMESTIC\nPARTNER" color:UIColorFromRGB(0x625ba8)];
            
            [lblContributionPartner sizeToFit];
            
            NSString *childCont =  [[[[plans[indexPath.section] valueForKey:sKey] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"child"] stringValue];
            lblContributionChild.attributedText = [self setAttributedLabel:childCont text2:@"CHILD <26" color:UIColorFromRGB(0xf06eaa)];
            
            [lblContributionChild sizeToFit];
            
            [self evenlySpaceTheseButtonsInThisView:@[lblContributionEmployee, lblContributionSpouse, lblContributionPartner, lblContributionChild] :lblContributionView];

        }
        else
        {
            //HEALTH
            if (indexPath.row == 0)
            {
                cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:18];

                cell.textLabel.textColor = UIColorFromRGB(0x555555);
                cell.textLabel.text = @"HEALTH PLAN";
                //   cell.detailTextLabel.text = [[plans[indexPath.section] valueForKey:@"dental"] valueForKey:@"plans_by_summary_text"];
 
                pSeperator.hidden = FALSE;

            }
            if (indexPath.row == 1)
            {
                cell.textLabel.text = @"PLANS OFFERED";
                cell.detailTextLabel.text = [[plans[indexPath.section] valueForKey:@"health"] valueForKey:@"plans_by_summary_text"];
            }
            if (indexPath.row == 2)
            {
                cell.textLabel.text = @"ELIGIBILITY";
                cell.detailTextLabel.text = [plans[indexPath.section] valueForKey:@"eligibility_rule"];
            }
            if (indexPath.row == 4)
            {
                cell.textLabel.text = @"REFERENCE PLAN";
                cell.detailTextLabel.text = [[plans[indexPath.section] valueForKey:@"health"] valueForKey:@"reference_plan_name"];
            }
            
            //DENTAL
            if (indexPath.row == 5)
            {
                cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:18];

                cell.textLabel.textColor = UIColorFromRGB(0x555555);
                cell.textLabel.text = @"DENTAL PLAN";
             //   cell.detailTextLabel.text = [[plans[indexPath.section] valueForKey:@"dental"] valueForKey:@"plans_by_summary_text"];
                pSeperator.hidden = FALSE;
            }
            
            if (indexPath.row == 6)
            {
                cell.textLabel.text = @"PLANS OFFERED";
                cell.detailTextLabel.text = [[plans[indexPath.section] valueForKey:@"dental"] valueForKey:@"plans_by_summary_text"];
            }
            if (indexPath.row == 7)
            {
                cell.textLabel.text = @"ELIGIBILITY";
                cell.detailTextLabel.text = [plans[indexPath.section] valueForKey:@"eligibility_rule"];
            }
            
            if (indexPath.row == 9)
            {
                cell.textLabel.text = @"ELECTED DENTAL PLANS";
                //cell.detailTextLabel.text = [plans[indexPath.section] valueForKey:@"eligibility_rule"];
            }

            if (indexPath.row == 10)
            {
                cell.textLabel.textColor = UIColorFromRGB(0x555555);
                cell.textLabel.text = [NSString stringWithFormat:@"\t\u2022 %@", @"BlueDental Preferred"];
               // cell.detailTextLabel.text = //[plans[indexPath.section] valueForKey:@"eligibility_rule"];
            }

            if (indexPath.row == 11)
            {
                cell.textLabel.textColor = UIColorFromRGB(0x555555);
                cell.textLabel.text = [NSString stringWithFormat:@"\t\u2022 %@", @"BlueDental Traditional"];
              //  cell.detailTextLabel.text = [plans[indexPath.section] valueForKey:@"eligibility_rule"];
            }

            if (indexPath.row == 12)
            {
                cell.textLabel.textColor = UIColorFromRGB(0x555555);
                cell.textLabel.text = [NSString stringWithFormat:@"\t\u2022 %@", @"Delta Dental PPO Basic Plan for Families for Small Businesses"];
                //  cell.detailTextLabel.text = [plans[indexPath.section] valueForKey:@"eligibility_rule"];
            }
            
            if (indexPath.row == 13)
            {
                cell.textLabel.text = @"REFERENCE PLAN";
                cell.detailTextLabel.text = [[plans[indexPath.section] valueForKey:@"dental"] valueForKey:@"reference_plan_name"];
            }
            
        }
    }
    /*
    else
    {
        if (indexPath.section == 1 && indexPath.row == 1)
        {
            lblContributionView.hidden = NO;
            UILabel *lblContributionEmployee = (UILabel *)[cell viewWithTag:121];
            UILabel *lblContributionSpouse = (UILabel *)[cell viewWithTag:122];
            UILabel *lblContributionPartner = (UILabel *)[cell viewWithTag:123];
            UILabel *lblContributionChild = (UILabel *)[cell viewWithTag:124];

            NSString *empCont =  [[[[plans[indexPath.section] valueForKey:@"dental"] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"employee"] stringValue];
            lblContributionEmployee.attributedText = [self setAttributedLabel:empCont text2:@"EMPLOYEE" color:UIColorFromRGB(0x00a3e2)];
            
            [lblContributionEmployee sizeToFit];
            
            NSString *spouseCont =  [[[[plans[indexPath.section] valueForKey:@"dental"] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"spouse"] stringValue];
            lblContributionSpouse.attributedText = [self setAttributedLabel:spouseCont text2:@"SPOUSE" color:UIColorFromRGB(0x00a99e)];
            
            [lblContributionSpouse sizeToFit];
            
            NSString *partnerCont =  [[[[plans[indexPath.section] valueForKey:@"dental"] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"domestic_partner"] stringValue];
            lblContributionPartner.attributedText = [self setAttributedLabel:partnerCont text2:@"DOMESTIC\nPARTNER" color:UIColorFromRGB(0x625ba8)];
            
            [lblContributionPartner sizeToFit];
            
            NSString *childCont =  [[[[plans[indexPath.section] valueForKey:@"dental"] valueForKey:@"employer_contribution_by_relationship"] valueForKey:@"child"] stringValue];
            lblContributionChild.attributedText = [self setAttributedLabel:childCont text2:@"CHILD <26" color:UIColorFromRGB(0xf06eaa)];
            
            [lblContributionChild sizeToFit];
            
            [self evenlySpaceTheseButtonsInThisView:@[lblContributionEmployee, lblContributionSpouse, lblContributionPartner, lblContributionChild] :lblContributionView];

        }
        else
        {
            if (![[[_planDentalDetails objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:@"EPLIST"])
                cell.textLabel.text = [[_planDentalDetails objectAtIndex:indexPath.row] objectAtIndex:0];
            
            if (indexPath.row == 0)
                cell.detailTextLabel.text = [plans[indexPath.section] valueForKey:@"eligibility_rule"];
            
            if (indexPath.row == 5)
                cell.detailTextLabel.text = [[plans[indexPath.section] valueForKey:@"dental"] valueForKey:@"reference_plan_name"];

    //        cell.detailTextLabel.text = [[_planDentalDetails objectAtIndex:indexPath.row] objectAtIndex:1];
        }
     
    }
     */
    return cell;
}

- (void) evenlySpaceTheseButtonsInThisView : (NSArray *) buttonArray : (UIView *) thisView {
    int widthOfAllButtons = 0;
    for (int i = 0; i < buttonArray.count; i++) {
        UILabel *thisButton = [buttonArray objectAtIndex:i];
        //    [thisButton setCenter:CGPointMake(0, thisView.frame.size.height / 2.0)];
        widthOfAllButtons = widthOfAllButtons + thisButton.frame.size.width;
    }
    
    int spaceBetweenButtons = (thisView.frame.size.width - widthOfAllButtons) / (buttonArray.count + 1);
    
    UILabel *lastButton = nil;
    for (int i = 0; i < buttonArray.count; i++) {
        UILabel *thisButton = [buttonArray objectAtIndex:i];
        if (lastButton == nil) {
            [thisButton setFrame:CGRectMake(spaceBetweenButtons, thisButton.frame.origin.y, thisButton.frame.size.width, thisButton.frame.size.height)];
        } else {
            [thisButton setFrame:CGRectMake(spaceBetweenButtons + lastButton.frame.origin.x + lastButton.frame.size.width, thisButton.frame.origin.y, thisButton.frame.size.width, thisButton.frame.size.height)];
        }
        
        lastButton = thisButton;
    }
    
}

-(NSAttributedString*)setAttributedLabel:(NSString*)labelText1 text2:(NSString*)labelText2 color:(UIColor*)color
{
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : color };
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:labelText1 attributes:attrs];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    [attributedTitle beginEditing];
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:(screenSize.width <= 320) ? 24.0 : 32.0] range:NSMakeRange(0, attributedTitle.length)];
    [attributedTitle endEditing];
    
    NSMutableAttributedString *attributedTitle1 = [[NSMutableAttributedString alloc] initWithString:@"%\n" attributes:attrs];
    
    [attributedTitle1 beginEditing];
    [attributedTitle1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:(screenSize.width <= 320) ? 16.0 : 18.0] range:NSMakeRange(0, attributedTitle1.length)];
    [attributedTitle1 endEditing];
    
    NSMutableAttributedString *attributedTitle2 = [[NSMutableAttributedString alloc] initWithString:labelText2 attributes:attrs];
    
    [attributedTitle2 beginEditing];
    [attributedTitle2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Bold" size:(screenSize.width <= 320) ? 14.0 : 16.0] range:NSMakeRange(0, attributedTitle2.length)];
    [attributedTitle2 endEditing];
    
    [attributedTitle appendAttributedString:attributedTitle1];
    [attributedTitle appendAttributedString:attributedTitle2];
    
    return attributedTitle;
}

@end
