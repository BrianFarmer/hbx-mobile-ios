//
//  rosterCostsBrokerEmployerViewController.m
//  HBXMobile
//
//  Created by John Boyd on 9/15/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "rosterCostsBrokerEmployerViewController.h"

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
    vHeader.frame = CGRectMake(0,0,self.view.frame.size.width,145);
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
    [self evenlySpaceTheseButtonsInThisView:@[[self.view viewWithTag:30], [self.view viewWithTag:31], [self.view viewWithTag:32], [self.view viewWithTag:33]] :self.view];
    
    NSMutableArray *persons = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        if (i < 10)
            [persons addObject:@"First Lastname"];
        else
            [persons addObject:@"Something else"];
    }
    pArray = [NSArray arrayWithArray:persons];
    
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
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(pRosterTable.frame.size.width/2, 0, pRosterTable.frame.size.width/2 - 10, headerHeight)];
    [button setBackgroundColor:[UIColor clearColor]];
    button.tag = section;
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    button.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:15.0];
    [button addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"COSTS" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    [headerView addSubview:button];
    
    return headerView;
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
    cell.detailTextLabel.text = @"$1000.00";
    
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

@end
