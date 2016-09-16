//
//  rosterBrokerEmployerViewController.m
//  HBXMobile
//
//  Created by John Boyd on 9/14/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "rosterBrokerEmployerViewController.h"

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
    [self.tabBarItem setImage:[[UIImage imageNamed:@"rosternormal32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBarItem setSelectedImage:[[UIImage imageNamed:@"rosteractive32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"home_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"home.png"]];
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabBG.png"]]; //[UIImage imageNamed:@"tabbar_selected.png"]];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       UIColorFromRGB(0x007BC4), NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
    [UITabBarItem.appearance setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];

    
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    //if Custom class with Navigation Controller
    //    TabBarController *tabBar = (TabBarController *) self.navigationController.tabBarController;
    
    
    employerData = tabBar.employerData;
//    _enrollHost = tabBar.enrollHost;
//    _customCookie_a = tabBar.customCookie_a;

    navImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 0, 200, 40)];
    
    navImage.backgroundColor = [UIColor clearColor];
    navImage.image = [UIImage imageNamed:@"navHeader"];
    navImage.contentMode = UIViewContentModeCenter;
    
    self.navigationController.topViewController.navigationItem.titleView = navImage;
    
    //self.navigationController.topViewController.title = @"info";
    vHeader.frame = CGRectMake(0,0,self.view.frame.size.width,115);
    pCompany.font = [UIFont fontWithName:@"Roboto-Bold" size:24];
    pCompany.frame = CGRectMake(0, 0, self.view.frame.size.width, 65);
    
    pCompany.textAlignment = NSTextAlignmentCenter;
    pCompany.text = employerData.companyName;
    
    pCompanyFooter.frame = CGRectMake(0, pCompany.frame.origin.y + pCompany.frame.size.height, self.view.frame.size.width, pCompanyFooter.frame.size.height);
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
    
}

-(void)viewWillAppear:(BOOL)animated
{
    pRosterTable.frame = CGRectMake(0, vHeader.frame.origin.y + vHeader.frame.size.height, self.view.frame.size.width, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height);
    slideView.frame = CGRectMake(self.view.frame.size.width, pRosterTable.frame.origin.y + 34, 200, pRosterTable.frame.size.height - 34);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
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
    headerView.backgroundColor = UIColorFromRGB(0xD9D9D9);
    
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
    
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    button.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:15.0];
    [button addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"STATUS" forState:UIControlStateNormal];
//    [Button addTarget:self action:@selector(doSomething:) forControlEvents:UIControlEventTouchUpInside];
//    [button addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];

    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    [headerView addSubview:button];

//    [headerView addSubview:button];
    
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
    
//    [pRosterTable setUserInteractionEnabled:FALSE];
    
//    [self.view bringSubviewToFront:slideView];
    
    [slideView handleLeftSwipe:3];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16];

        cell.textLabel.textColor = UIColorFromRGB(0x555555);
        cell.detailTextLabel.textColor = UIColorFromRGB(0x00a99e);
    
    cell.textLabel.text = @"First Lastname";
    cell.detailTextLabel.text = @"Enrolled";

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end
