//
//  MyAccountViewController.m
//  HBXMobile
//
//  Created by David Boyd on 3/7/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyPlanCoverageTableViewController.h"
#import "showPlanDetailViewController.h"

@interface MyAccountViewController ()

@end

@implementation MyAccountViewController
/*
- (NSDictionary *) indexKeyedDictionaryFromArray:(NSArray *)array
{
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [array enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop){
         NSNumber *index = [NSNumber numberWithInteger:idx];
         [mutableDictionary setObject:obj forKey:index];
     }];
    NSDictionary *result = [NSDictionary.alloc initWithDictionary:mutableDictionary];
    return result;
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[myTabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"BotonMapas", @"comment")];
//    UITabBarItem *tabItem = [[[tabBarController tabBar] items] objectAtIndex:INDEX];
//    [[myTabBar.items objectAtIndex:0] setTitle:@"TEST"];
//    UITabBarItem *item = [myTabBar.items objectAtIndex:0];
//    [item setTitle:@"fgfdgd"];
//    UITabBarItem *tabBarItem1 = [self.tabBarController.tabBar.items objectAtIndex:0];
        UITabBarItem *tabBarItem1 = [myTabBar.items objectAtIndex:0];
    //    [tabBarItem1.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    tabBarItem1.image = [UIImage imageNamed:@"piggy48.png"];
    //    tabBarItem1.selectedImage = [UIImage imageNamed:@"piggy48.png" ];
    tabBarItem1.image = [UIImage imageNamed:@"cloud_download-arrow-32.png"];
    tabBarItem1.selectedImage = [UIImage imageNamed:@"cloud_download-arrow-32.png" ];
    
    UITabBarItem *tabBarItem2 = [myTabBar.items objectAtIndex:1];
    tabBarItem2.image = [UIImage imageNamed:@"phone.png"];
    tabBarItem2.selectedImage = [UIImage imageNamed:@"phone.png" ];
    
    UITabBarItem *tabBarItem3 = [myTabBar.items objectAtIndex:2];
    tabBarItem3.image = [UIImage imageNamed:@"email.png"];
    tabBarItem3.selectedImage = [UIImage imageNamed:@"email.png" ];
    
 //   self.tabBarController.tabBar.delegate = self;
    myTabBar.delegate = self;
    
    
    [myAccountTable setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = nil;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    myAccountTable.frame = CGRectMake(0,20,screenSize.width,screenSize.height-80); //self.view.frame.size.width,500);
    
    NSString* filepath = [[NSBundle mainBundle] pathForResource:@"sampleMyPlanJSON" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];//[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSError *error = nil;
//    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    subscriberPlans = [dictionary valueForKeyPath:@"subscriber_plans"];
    
    
    
    
//    NSArray *values = [dictionary allKeys]; //objectAtIndex:0];
    coverageKeys = [[dictionary valueForKeyPath:@"subscriber_plans"][0] allKeys]; //]objectForKey:@"PlanName"];
    
    NSDictionary *dict=[dictionary valueForKeyPath:@"subscriber_plans.plan"][0];
//    planKeys = [[coverageKeys valueForKeyPath:@"plan"] allKeys]; //]objectForKey:@"PlanName"];

    NSString *pt = [dict valueForKey:@"name"];
        NSString *pt1 = [subscriberPlans valueForKey:@"date_coverage_effective"][0];
//               NSDictionary *pDict = [subscriberPlans objectAtIndex:2];
    
    
    NSArray *pa= [subscriberPlans valueForKey:@"members_covered"][0];
    NSString *greeting = [pa componentsJoinedByString:@","];
//    NSString *pt = [coverageKeys objectAtIndex:0];
    
//    NSString *categoryString=[[dictionary valueForKeyPath:@"MyPlan"][0] objectForKey:@"PlanName"];
//    NSString *idString=[[results valueForKeyPath:@"data.abcd"][0] objectForKey:@"id"];
//    NSString *titleString=[[results valueForKeyPath:@"data.abcd"][0] objectForKey:@"title"];

//    NSArray *val = [[dictionary valueForKeyPath:@"MyPlan"][0] allValues];
/*
    NSArray *values = [[dictionary12 allKeys]objectAtIndex:0];
    id val = nil;
//    NSArray *values = [dictionary12 allValues];
    
    if ([values count] != 0)
        val = [values objectAtIndex:0];
    
//        NSString *test = [NSString stringWithFormat:@"%@", [dictionary12 objectForKey:@"PlanName"]];
//    NSString *test = [NSString stringWithFormat:@"%@", [dictionaryA objectForKey:@"PlanName"]];

    
//    NSArray *array = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
 //   NSDictionary *dictionary = [self indexKeyedDictionaryFromArray:[array objectAtIndex:0]]; //[array indexKeyedDictionary];
 //   NSDictionary *dictionary = [array objectAtIndex:0];
//    NSString *test = [dictionary objectForKey:@"ID"];
//    NSLog(@"Test is %@",test);
   */
    
    tableData = [[NSMutableArray alloc] init];
    
    [tableData addObject:[NSArray arrayWithObjects:@"BlueChoice HMO HSA Bronze $6,550", @"carefirst.jpg", @"176.57", @"HMO", @"Bronze", @"DC-Metro", @"6,550", @"http://www.yahoo.com", nil] ];
    [tableData addObject:[NSArray arrayWithObjects:@"BlueChoice HMO HSA Bronze $6,000", @"carefirst.jpg", @"183.52", @"HMO", @"Bronze", @"DC-Metro", @"6,000", @"http://www.yahoo.com", nil] ];
    [tableData addObject:[NSArray arrayWithObjects:@"KP DC Bronze 6000/20%/HSA/Dental/Ped Dental", @"kaiser.jpg", @"251.83", @"HMO", @"Bronze", @"DC-Metro", @"6,000", @"http://www.yahoo.com", nil] ];
    [tableData addObject:[NSArray arrayWithObjects:@"KP DC Bronze 5000/50/HSA/Dental/Ped Dental", @"kaiser.jpg", @"255.66", @"HMO", @"Bronze", @"DC-Metro", @"5,000", @"http://www.yahoo.com", nil] ];
    
//    myAccountTable.rowHeight = 104;
    myAccountTable.separatorStyle = UITableViewCellSelectionStyleNone;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myAccountTable.frame.size.width, 54)];
    
    UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(5,5,self.view.frame.size.width - 10,44)];
    whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
    whiteRoundedCornerView.layer.masksToBounds = NO;
    whiteRoundedCornerView.layer.cornerRadius = 3.0;
    whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
    whiteRoundedCornerView.layer.shadowOpacity = 0.5;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    imageView.image = [UIImage imageNamed:@"images.jpeg"];
    [whiteRoundedCornerView addSubview:imageView];
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(70, whiteRoundedCornerView.frame.size.height/2 - 10, whiteRoundedCornerView.frame.size.width - 70, 0)];
    labelView.text = @"Company ABC";
    [labelView sizeToFit];
 //   [labelView setCenter:headerView.center];
    [whiteRoundedCornerView addSubview:labelView];

    [headerView addSubview:whiteRoundedCornerView];
    [headerView sendSubviewToBack:whiteRoundedCornerView];

    myAccountTable.tableHeaderView = headerView;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setTitle:@"My DC Health Link"];
    
    type = 0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:@"Back"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    if (item.tag == 0)
    {
        [self performSegueWithIdentifier:@"Show Notifications" sender:nil];
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
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController*)viewController
{
 
     // prepare your transition
//     CATransition *transition;
//     transition = [CATransition animation];
//     transition.type = kCATransitionFromRight;
//     transition.duration = 0.5;
     
     // prepare your view switching
     //    [[[ViewController view]layer]addAnimation:transition forKey:nil];
     [[self.view layer] addAnimation:transition forKey:nil];
    
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionMoveIn]; //@"rippleEffect"]; //kCATransitionFade];
    [animation setDuration:0.25];
    //    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:
    //                                  kCAMediaTimingFunctionEaseIn]];
    [self.view.window.layer addAnimation:animation forKey:@"fadeTransition"];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [subscriberPlans count]; //[[dictionary valueForKeyPath:@"MyPlan"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (section == 0)
//        return 2;

    return  9;  //[[subscriberPlans objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 10;
    
    return 2.0;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        UIView *shadowView  =  [[UIView alloc] initWithFrame: CGRectMake(0,0,320,40)];
        shadowView.backgroundColor = [UIColor whiteColor];
        
        // Doing the Decoration Part
        shadowView.layer.shadowColor = [[UIColor blackColor] CGColor];
        shadowView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        shadowView.layer.shadowRadius = 3.0f;
        shadowView.layer.shadowOpacity = 1.0f;
        
        return shadowView;
    }
    return nil;
}
*/

/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    
    if (section == 0)
    {
        UILabel *lbl = [[UILabel alloc] init];
        //       lbl.frame = CGRectMake(0,0,320,70);
        //       lbl.text = @"What Type of Account Do You Need?";
        //        [v addSubview:lbl];
    }
    return v;
}
*/


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([indexPath section] > 0 && [indexPath section] < [[dictionary valueForKeyPath:@"MyPlan"] count] + 1)
        return 44; //204;
    
    return 80; // [indexPath row] * 20;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     if (cell.IsMonth)
     {
     UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
     av.backgroundColor = [UIColor clearColor];
     av.opaque = NO;
     av.image = [UIImage imageNamed:@"month-bar-bkgd.png"];
     UILabel *monthTextLabel = [[UILabel alloc] init];
     CGFloat font = 11.0f;
     monthTextLabel.font = [BVFont HelveticaNeue:&font];
     
     cell.backgroundView = av;
     cell.textLabel.font = [BVFont HelveticaNeue:&font];
     cell.textLabel.textColor = [BVFont WebGrey];
     }
     */
    int iHt;
    
    if ([indexPath section] == 1)
        iHt = 200;
    else
    {
        iHt = 80;

    }
/*
    {
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(10,10,self.view.frame.size.width - 20,iHt)];
        whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
        whiteRoundedCornerView.layer.masksToBounds = NO;
        whiteRoundedCornerView.layer.cornerRadius = 3.0;
        whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
        whiteRoundedCornerView.layer.shadowOpacity = 0.5;
        [cell.contentView addSubview:whiteRoundedCornerView];
        [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
        
    }
 */
}

- (UITableViewCell *) getCellContentViewNames:(NSString *)cellIdentifier myCell:(UITableViewCell *)cell
{
    //    CGRect CellFrame = CGRectMake(0, 0, 255, 40);
    //    CGRect Label1Frame = CGRectMake(5, 3, 120, 30);
    //    CGRect Label2Frame = CGRectMake(185, 3, 100, 30);
    //    CGRect Label3Frame = CGRectMake(365, 3, 100, 30);
    
    UILabel *lblTemp;
    
    //    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier];
    
    UIImageView *pImage = [[UIImageView alloc] initWithFrame:CGRectMake(172, 15, 75, 15)];
    pImage.tag = 13;
    [cell.contentView addSubview:pImage];
    
    
    
    //Initialize Label with tag 10.                         //Plan Name
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(50, 35, 300, 60)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.63 alpha:1.0];
    lblTemp.tag = 10;
    lblTemp.numberOfLines = 0;
    //   lblTemp.lineBreakMode = NSLineBreakByWordWrapping;
    //    [lblTemp sizeToFit];
    lblTemp.hidden = FALSE;
    lblTemp.font = [UIFont boldSystemFontOfSize:16];
    [cell.contentView addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(280, 75, 50, 15)]; //cell.contentView.frame.origin.x + cell.contentView.frame.size.width, 11, 50, 10)];  //Price per Month
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor blackColor]; //[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 11;
    lblTemp.hidden = FALSE;
    lblTemp.numberOfLines = 0;
    lblTemp.textAlignment = NSTextAlignmentRight;
    lblTemp.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:lblTemp];
    
    
    
    
    
    /////////////////////////////////
    //
    // HMO LABEL
    /////////////////////////////////
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 50, 10)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 14;
    lblTemp.hidden = FALSE;
    lblTemp.textAlignment     = NSTextAlignmentLeft;
    lblTemp.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lblTemp];
    
    
    /////////////////////////////////
    //
    // EFFECTIVE DATE LABEL
    /////////////////////////////////
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 120, 10)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 15;
    lblTemp.hidden = FALSE;
    lblTemp.textAlignment     = NSTextAlignmentLeft;
    lblTemp.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lblTemp];
   
    /////////////////////////////////
    //
    // DC HEALTH LINK ID LABEL
    /////////////////////////////////
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, 120, 10)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 16;
    lblTemp.hidden = FALSE;
    lblTemp.textAlignment     = NSTextAlignmentLeft;
    lblTemp.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lblTemp];
    
    
    /////////////////////////////////
    //
    // COVERED LABEL
    /////////////////////////////////
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 155, 120, 10)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 17;
    lblTemp.hidden = FALSE;
    lblTemp.textAlignment     = NSTextAlignmentLeft;
    lblTemp.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lblTemp];

    
    /////////////////////////////////
    //
    // HOW MANY COVERED ROUND BUTTON
    /////////////////////////////////
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag=30;
    [button setFrame:CGRectMake(150, 2, 30, 30)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor grayColor]];
    button.layer.cornerRadius = 15; // this value vary as per your desire
    button.clipsToBounds = YES;
    
    button.font = [UIFont boldSystemFontOfSize:12];
    [cell.contentView addSubview:button];
    
    /////////////////////////////////
    //
    // PREMIUM LABEL
    /////////////////////////////////
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(180, 65, 120, 10)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 18;
    lblTemp.hidden = FALSE;
    lblTemp.textAlignment     = NSTextAlignmentLeft;
    lblTemp.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lblTemp];
    
    /////////////////////////////////
    //
    // PLAN SELECTED LABEL
    /////////////////////////////////
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(180, 95, 120, 10)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 19;
    lblTemp.hidden = FALSE;
    lblTemp.textAlignment     = NSTextAlignmentLeft;
    lblTemp.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lblTemp];
    
/*
    
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 50, 10)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 14;
    lblTemp.hidden = FALSE;
//    lblTemp.text = @"TYPE";
    lblTemp.textAlignment     = NSTextAlignmentRight;
    lblTemp.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:lblTemp];

    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 50, 10)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor blackColor]; //[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 15;
    lblTemp.hidden = FALSE;
    lblTemp.textAlignment     = NSTextAlignmentRight;
    lblTemp.font = [UIFont boldSystemFontOfSize:12];
    [cell.contentView addSubview:lblTemp];
    
 
    
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, 50, 10)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 16;
    lblTemp.hidden = FALSE;
//    lblTemp.text = @"LEVEL";
    lblTemp.textAlignment     = NSTextAlignmentLeft;
    lblTemp.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:lblTemp];

 
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag=17;
    [button setFrame:CGRectMake(100, 75, 60, 15)];
    //    [button setImage:[UIImage imageNamed:@"img"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    //    [button setTitle:@"Abc" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    button.font = [UIFont boldSystemFontOfSize:12];
    [cell.contentView addSubview:button];
    
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(190, 65, 60, 10)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 18;
    lblTemp.hidden = FALSE;
//    lblTemp.text = @"NETWORK";
    lblTemp.textAlignment     = NSTextAlignmentLeft;
    lblTemp.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(190, 75, 50, 10)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor blackColor]; //[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 19;
    lblTemp.hidden = FALSE;
    lblTemp.textAlignment     = NSTextAlignmentLeft;
    lblTemp.font = [UIFont boldSystemFontOfSize:12];
    [cell.contentView addSubview:lblTemp];
    
    
    
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(280, 65, 70, 10)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 20;
    lblTemp.hidden = FALSE;
//    lblTemp.text = @"DEDUCTIBLE";
    lblTemp.textAlignment     = NSTextAlignmentLeft;
    lblTemp.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(280, 75, 50, 10)];
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.textColor = [UIColor blackColor]; //[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
    lblTemp.tag = 21;
    lblTemp.hidden = FALSE;
    lblTemp.textAlignment     = NSTextAlignmentLeft;
    lblTemp.font = [UIFont boldSystemFontOfSize:12];
    [cell.contentView addSubview:lblTemp];
*/
    
    //PDF Summary of benefits
    UIButton *btnSummary = [[UIButton alloc] initWithFrame:CGRectMake(20, 150, 250, 15)];
    [btnSummary.titleLabel setFont:[UIFont systemFontOfSize:14]];
    btnSummary.tag = 22;
    //    [btnSummary setBackgroundColor:[UIColor clearColor]];
    [btnSummary setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btnSummary setTitle:@"Summary of Benefits and Coverage" forState:UIControlStateNormal];
    [cell.contentView addSubview:btnSummary];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        if ([indexPath section] == 1 && ([indexPath row] == 0 || [indexPath row] == 4))
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
        
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=30;
        [button setFrame:CGRectMake(screenSize.width - 70, 5, 37, 37)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:self.view.backgroundColor];//[UIColor grayColor]];
        button.layer.cornerRadius = 18; // this value vary as per your desire
        button.clipsToBounds = YES;
        button.hidden = TRUE;
        button.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:button];

//        cell = [self getCellContentViewNames:simpleTableIdentifier myCell:cell];
    }
    
//    cell.backgroundColor = [UIColor clearColor];
    UIButton *button = (UIButton *)[cell viewWithTag:30];
    button.hidden = TRUE;
    
//    if ([indexPath section] > 0 && [indexPath section] < [[dictionary valueForKeyPath:@"MyPlan"] count] + 1)
    {
        NSDictionary *planValues = [dictionary valueForKeyPath:@"subscriber_plans.plan"][indexPath.section];
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:16];
        
        if ([indexPath row] == 0)
        {
            cell.textLabel.textAlignment = NSTextAlignmentLeft;

            cell.textLabel.font = [UIFont boldSystemFontOfSize:18]; //[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            
            cell.textLabel.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
 //           cell.textLabel.text = [keyNames objectAtIndex:0]; //[[dictionary valueForKeyPath:@"MyPlan"][indexPath.section] objectForKey:]; //@"BlueChoice HMO HSA Bronze $6,550";
 //           NSDictionary *pDict = [subscriberPlans objectAtIndex:indexPath.row];
            
//            cell.textLabel.text = [[subscriberPlans objectAtIndex:[indexPath section] objectAtIndex:1];
            cell.textLabel.text = [planValues valueForKey:@"name"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      //      cell.detailTextLabel.text = @"BRONZE";
        }

        if ([indexPath row] == 1)
        {
            cell.textLabel.text = [planValues valueForKey:@"type"];
            //cell.detailTextLabel.text = [[dictionary valueForKeyPath:@"MyPlan"][indexPath.section-1] objectForKey:@"HMO"];;
            cell.detailTextLabel.text = [planValues valueForKey:@"level"];
        }
        
        if ([indexPath row] == 2)
        {
            cell.textLabel.text = @"Effective Date";
           // cell.detailTextLabel.text = [[dictionary valueForKeyPath:@"MyPlan"][indexPath.section-1] objectForKey:@"Effective Date"];;
            NSString *dateStr = [subscriberPlans valueForKey:@"date_coverage_effective"][indexPath.section]; //@"2011-07-06 00:00:00";
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            //          NSDate *date = [formatter dateFromString:@"2011-01-12T14:17:55.043Z"];
            NSDate *date = [formatter dateFromString:dateStr];
            //         NSLog(@"Date: %@", date);
            //         NSLog(@"1970: %f", [date timeIntervalSince1970]);
            //         NSLog(@"sDate: %@", [formatter stringFromDate:date]);
                        [formatter setDateFormat:@"MM/dd/yyyy"];
            cell.detailTextLabel.text = [formatter stringFromDate:date]; //[subscriberPlans valueForKey:@"date_coverage_effective"][indexPath.section];
        }
        if ([indexPath row] == 3)
        {
            cell.textLabel.text = @"DC Health Link ID";
            cell.detailTextLabel.text = [subscriberPlans valueForKey:@"dc_health_link_id"][indexPath.section];
        }
        if ([indexPath row] == 4)
        {
            
            button.hidden = FALSE;
            cell.textLabel.text = @"# of Covered Members"; //@"Covered";
            //NSString *greeting = [[subscriberPlans valueForKey:@"members_covered"][indexPath.section] componentsJoinedByString:@", "];
            //cell.detailTextLabel.text = [[subscriberPlans valueForKey:@"members_covered"][indexPath.section] componentsJoinedByString:@", "];

            NSString *p = [NSString stringWithFormat:@"%ld", [[subscriberPlans valueForKey:@"members_covered"][indexPath.section] count]];
            // [button setTitle:@"2" forState:UIControlStateNormal];
            [button setTitle:p forState:UIControlStateNormal];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if ([indexPath row] == 5)
        {
            cell.textLabel.text = @"Premium";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.02f", [[subscriberPlans valueForKey:@"raw_monthly_premium"][indexPath.section] floatValue]];
        }
    
        if ([indexPath row] == 6)
        {
            cell.textLabel.text = @"Plan Selected";
            
            NSString *dateStr = [subscriberPlans valueForKey:@"date_selected"][indexPath.section]; //@"2011-07-06 00:00:00";
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
  //          NSDate *date = [formatter dateFromString:@"2011-01-12T14:17:55.043Z"];
            NSDate *date = [formatter dateFromString:dateStr];
   //         NSLog(@"Date: %@", date);
   //         NSLog(@"1970: %f", [date timeIntervalSince1970]);
   //         NSLog(@"sDate: %@", [formatter stringFromDate:date]);
            NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
            [dtF setDateFormat:@"MM/dd/yyyy"];
          //Removed to not include time
            //[dtF setDateFormat:@"MM-dd-yyyy (hh:mm a)"];
            NSLog(@"sDate: %@", [dtF stringFromDate:date]);
            
            cell.detailTextLabel.text = [dtF stringFromDate:date]; //[subscriberPlans valueForKey:@"date_selected"][indexPath.section];
        }

        if ([indexPath row] == 7)
        {
            cell.textLabel.text = @"Coverage Selected";
            cell.detailTextLabel.text = [subscriberPlans valueForKey:@"coverage_status"][indexPath.section];
        }

        if ([indexPath row] == 8)
        {
            cell.textLabel.text = @"Carrier Contact Info";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        /*
        UIImageView *pImage = (UIImageView *)[cell viewWithTag:13];
        UILabel *lblPlan = (UILabel *)[cell viewWithTag:10];
        UILabel *lblPrice = (UILabel *)[cell viewWithTag:11];
    
        [(UILabel *)[cell viewWithTag:14] setText:@"HMO"];
//        UILabel *lblType = (UILabel *)[cell viewWithTag:15];
        
        [(UILabel *)[cell viewWithTag:15] setText:@"EFFECTIVE DATE:"];
//        UILabel *lblLevel = (UILabel *)[cell viewWithTag:17];
        
        [(UILabel *)[cell viewWithTag:16] setText:@"NETWORK"];
//        UILabel *lblNetwork = (UILabel *)[cell viewWithTag:19];
        
        [(UILabel *)[cell viewWithTag:17] setText:@"DEDUCTIBLE"];
//        UILabel *lblDed = (UILabel *)[cell viewWithTag:21];
        [(UILabel *)[cell viewWithTag:18] setText:@"DEDUCTIBLE"];
                [(UILabel *)[cell viewWithTag:19] setText:@"DEDUCTIBLE"];
                [(UILabel *)[cell viewWithTag:20] setText:@"DEDUCTIBLE"];
         */
 /*
        [(UIButton *)[cell viewWithTag:22] setTitle:@"Summary of Benefits and Coverage" forState:UIControlStateNormal];
        UIButton *button = (UIButton *)[cell viewWithTag:17];
        [button setImage:[UIImage imageNamed:@"bronze-circle.png"] forState:UIControlStateNormal];
        [button setTitle:[[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*8+4]forState:UIControlStateNormal];
 */
    /*
     NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
     attachment.image = [UIImage imageNamed:@"bronze-circle.png"];
     
     NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
     
     NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*8+4]];
     [myString appendAttributedString:attachmentString];
     
     lblLevel.attributedText = myString;
     */
        
        /*
        lblType.text = [[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*8+3];
    //   lblLevel.text = [[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*8+4];
        lblNetwork.text = [[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*8+5];
        lblDed.text = [[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*8+6];
    
        UIImage *pimg = [UIImage imageNamed:[[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*8+1]];
        pImage.image = [MyAccountViewController imageWithImage:pimg scaledToSize:CGSizeMake(50,10)];
    
        lblPlan.text = [[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*8];
        lblPrice.text = [[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*8+2];
        [lblPlan sizeToFit];
    //    [lblPrice sizeToFit];
         
         */
    /*
     cell.textLabel.font = [UIFont systemFontOfSize:16];
     cell.textLabel.text = [[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*2];
     UIImage *pimg = [UIImage imageNamed:[[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*2+1]];
     //    cell.imageView.image = [ChoosePlanViewController imageWithImage:pimg scaledToWidth:50]; //[UIImage imageNamed:[[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*2+1]];
     cell.imageView.image = [ChoosePlanViewController imageWithImage:pimg scaledToSize:CGSizeMake(50,10)]; //[UIImage imageNamed:[[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row*2+1]];
     */
    }
    if ([indexPath section] == 22)
    {
//        UILabel *plabel = [[UILabel alloc] initWithFrame:CGRectMake(15,32, 200, 30)];
//        plabel.text = @"John Doe";
//        [cell.contentView addSubview:plabel];
        cell.textLabel.text = @"John Doe";
    }
    
    if ([indexPath section] == 22)
    {
        cell.textLabel.text = @"Notifications";
//        UILabel *plabel = [[UILabel alloc] initWithFrame:CGRectMake(15,0, 200, 80)];
//        plabel.text = @"Notifications";
//        [cell.contentView addSubview:plabel];
        
        UIButton *uiButtonItemCount = [UIButton buttonWithType:UIButtonTypeCustom];
        [uiButtonItemCount setTitle:@"1" forState:UIControlStateNormal];
        uiButtonItemCount.backgroundColor = [UIColor grayColor];
        CALayer *layer = uiButtonItemCount.layer;
        layer.cornerRadius = 12.0f;
        layer.masksToBounds = YES;
        layer.borderWidth = 1.0f;
        layer.borderColor = [UIColor colorWithWhite:1.5f alpha:0.2f].CGColor;
        
        [uiButtonItemCount setFrame: CGRectMake(275, 40 - 15, 40, 30)];
        [uiButtonItemCount setTag:3];
        uiButtonItemCount.hidden = FALSE;
        [uiButtonItemCount addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [uiButtonItemCount setTitle:[NSString stringWithFormat:@"%i", 2] forState:UIControlStateNormal];
        [cell.contentView addSubview:uiButtonItemCount];

        
//        [cell.contentView addSubview:uiButtonItemCount];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        /*
//        cell.backgroundColor = [UIColor greenColor];
        UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
        CGRect rc = cell.textLabel.frame;
        cell.textLabel.frame = CGRectMake(rc.origin.x, rc.origin.y + 120, rc.size.height, rc.size.width);
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.backgroundColor = [UIColor greenColor];
        cell.textLabel.text = @"Notifications";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         */
    }
    return cell;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView1 deselectRowAtIndexPath:[tableView1 indexPathForSelectedRow] animated:YES];

//    if ([indexPath section] == 0 && [indexPath row] == 0)
    if ([indexPath row] == 0)
    {
 //       [self performSegueWithIdentifier:@"Show Shop Plan Details" sender:nil];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        showPlanDetailViewController *selectPlanController = [mainStoryboard instantiateViewControllerWithIdentifier:@"Plan Detail View"];
  //      selectPlanController.level = 1;
        [self.navigationController pushViewController:selectPlanController animated:YES];

    }

    if ([indexPath row] == 4)
    {
        type = 0;
        [self performSegueWithIdentifier:@"Show Plan Details" sender:[[subscriberPlans valueForKey:@"members_covered"][indexPath.section] componentsJoinedByString:@", "]];
    }
    
    if ([indexPath row] == 8)
    {
        NSDictionary *carrierInfo = [dictionary valueForKeyPath:@"subscriber_plans.plan.carrier_contact_info"][indexPath.section];
        NSString *ci = [NSString stringWithFormat:@"%@,%@,%@", [carrierInfo valueForKey:@"phone"], [carrierInfo valueForKey:@"email"], @"https://individual.carefirst.com/individuals-families/home.page"];
        type = 1;
        [self performSegueWithIdentifier:@"Show Plan Details" sender:ci];
    }

    if ([indexPath section] == 2)
        [self performSegueWithIdentifier:@"Show Notifications" sender:[[subscriberPlans valueForKey:@"members_covered"][indexPath.section] componentsJoinedByString:@", "]];
}


 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([[segue identifier] isEqualToString:@"Show Plan Details"])
     { 
         // Get destination view
         MyPlanCoverageTableViewController *vc = [segue destinationViewController];
         vc.covered = (NSString *)sender;
         vc.type = type;
         
 // Get button tag number (or do whatever you need to do here, based on your object
 //       NSInteger tagIndex = [(UIButton *)sender tag];
 
 // Pass the information to your destination view
 //        [vc setSelectedButton:tagIndex];
     }
 }


@end
