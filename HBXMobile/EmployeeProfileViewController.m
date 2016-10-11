//
//  EmployeeProfileViewController.m
//  HBXMobile
//
//  Created by David Boyd on 10/5/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "EmployeeProfileViewController.h"

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
    
    navImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 0, 200, 40)];
    
    navImage.backgroundColor = [UIColor clearColor];
    navImage.image = [UIImage imageNamed:@"navHeader"];
    navImage.contentMode = UIViewContentModeCenter;
    
    self.navigationController.topViewController.navigationItem.titleView = navImage;
    
    vHeader = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,145)];
    [self.view addSubview:vHeader];
    
    sections = [[NSArray alloc] initWithObjects: @"DETAILS", @"HEALTH PLAN", @"DEPENDENTS", nil];
    
    if (!expandedSections)
        expandedSections = [[NSMutableIndexSet alloc] init];

    
    for (int btnCount=0;btnCount<4;btnCount++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=30+btnCount;
        [button setFrame:CGRectMake(10, 95, 38, 38)];
//        [button setFrame:CGRectMake(10, pCompanyFooter.frame.origin.y + pCompanyFooter.frame.size.height + 10, 38, 38)];
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
    int navbarHeight = self.navigationController.navigationBar.frame.size.height + 25; //Extra 25 must be accounted for. It is the status bar height (clock, batttery indicator)
    
    profileTable.frame = CGRectMake(0, vHeader.frame.origin.y + vHeader.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - navbarHeight - vHeader.frame.size.height);
                                    
                                    
                                    //self.tabBarController.tabBar.frame.origin.y - navbarHeight - vHeader.frame.size.height);
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
    return 0;//[displayArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        [button setTitleColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:12.0];
        [button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *btnImage = [UIImage imageNamed:@"open_plus32x32.png"];
        [button setImage:btnImage forState:UIControlStateNormal];
        
        [button setTitle:[NSString stringWithFormat:@"%@", @"+"] forState:UIControlStateNormal];
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

- (void)handleTap:(UITapGestureRecognizer *)sender {
    UIView *pHeaderView = (UIView*)sender.view;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag];
/*
    [detailTable beginUpdates];
    [detailTable reloadSections:[NSIndexSet indexSetWithIndex:pHeaderView.tag] withRowAnimation:NO];
    [self tableView:detailTable didSelectHeader:indexPath];
    
    [detailTable endUpdates];
    
    if ([expandedSections containsIndex:pHeaderView.tag])
        [detailTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:pHeaderView.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
 
 */
}

@end
