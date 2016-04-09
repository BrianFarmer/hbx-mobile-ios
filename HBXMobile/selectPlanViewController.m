//
//  selectPlanViewController.m
//  HBXMobile
//
//  Created by David Boyd on 3/24/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "selectPlanViewController.h"
#import "MyPlanWebViewController.h"

//https://enroll-preprod.dchbx.org/insured/plan_shoppings/56fbc9c01a9f4268d5000016?coverage_kind=health&enrollment_kind=sep&market_kind=individual

@interface selectPlanViewController ()

@end

@implementation selectPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [plansTable setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = nil;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    plansTable.frame = CGRectMake(0,20,screenSize.width,600); //self.view.frame.size.width,500);
    plansTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    if (self.level == 33)
    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *post = [NSString stringWithFormat:@"company_id=1234"]; //],@"test@yopmail.com",@"password",@"bob"];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
        
        [request setURL:[NSURL URLWithString:@"http://ec2-54-165-241-146.compute-1.amazonaws.com:3000/plans"]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if(conn) {
            NSLog(@"Connection Successful");
        } else {
            NSLog(@"Connection could not be made");
        }

    }
    
    NSString* filepath = [[NSBundle mainBundle] pathForResource:@"samplePlanJSON" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    
    NSError *error = nil;

    dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    subscriberPlans = [dictionary valueForKeyPath:@"plans"];
    coverageKeys = [[dictionary valueForKeyPath:@"plans"][0] allKeys];
/*
    NSDictionary *dict=[dictionary valueForKeyPath:@"subscriber_plans.plan"][0];
    
    NSString *pt = [dict valueForKey:@"name"];
    NSString *pt1 = [subscriberPlans valueForKey:@"date_coverage_effective"][0];
    
    NSArray *pa= [subscriberPlans valueForKey:@"members_covered"][0];
    NSString *greeting = [pa componentsJoinedByString:@","];
    //    NSString *pt = [coverageKeys objectAtIndex:0];
*/
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.level == 0)
    {
        [self.navigationItem setHidesBackButton:YES];
        [self.navigationItem setTitle:@"My DC Health Link"];
    }
    else
        [self.navigationItem setTitle:@"Select a Plan"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:@"Back"];
}
// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s", __FUNCTION__);
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.level == 0 )
        return 1;
    
    if (self.level == 2)
        return 2;
    
    return [subscriberPlans count]; //[[dictionary valueForKeyPath:@"MyPlan"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    if (section == 0)
    //        return 2;
    
    return  1;  //[[subscriberPlans objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if ([indexPath section] > 0 && [indexPath section] < [[dictionary valueForKeyPath:@"MyPlan"] count] + 1)
    if ([indexPath section] == 1 && self.level == 2)
        return 44;
    
    return 160; //204;
    
    return 80; // [indexPath row] * 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    
    if (section == 0)
    {
 //       UILabel *lbl = [[UILabel alloc] init];
 //       lbl.frame = CGRectMake(0,0,320,70);
        //       lbl.text = @"What Type of Account Do You Need?";
        //        [v addSubview:lbl];
    }
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    return view;
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
    
        if ([indexPath section] == 1 && self.level == 2)
            return;
    
    
     {
     cell.contentView.backgroundColor = [UIColor clearColor];
     UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(10,10,self.view.frame.size.width - 20, 160)];
     whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
     whiteRoundedCornerView.layer.masksToBounds = NO;
     whiteRoundedCornerView.layer.cornerRadius = 3.0;
     whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
     whiteRoundedCornerView.layer.shadowOpacity = 0.5;

         
     [cell.contentView addSubview:whiteRoundedCornerView];
     [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
     }
    
}

- (UITableViewCell *) getCellContentViewNames:(NSString *)cellIdentifier
{
//UILabel *noPlanTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(100,100,200,20)];
//CGFloat font = 18.0f;
//noPlanTextLabel.textColor = [UIColor blackColor];
//noPlanTextLabel.text = @"No Plan Selected";
//[whiteRoundedCornerView addSubview:noPlanTextLabel];

    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
  UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,screenSize.width,50) reuseIdentifier:cellIdentifier];

UILabel *lblTemp;

//    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier];

UIImageView *pImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 50, 10)];
pImage.tag = 13;
[cell.contentView addSubview:pImage];

    int iFontSize = 12;
    

//Initialize Label with tag 10.                         //Plan Name
lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(20, 11, screenSize.width-100, 40)];
lblTemp.backgroundColor = [UIColor clearColor];
lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.63 alpha:1.0];
lblTemp.tag = 10;
lblTemp.numberOfLines = 0;
//   lblTemp.lineBreakMode = NSLineBreakByWordWrapping;
//    [lblTemp sizeToFit];
lblTemp.hidden = FALSE;
lblTemp.font = [UIFont boldSystemFontOfSize:16];
[cell.contentView addSubview:lblTemp];

lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width-110, 11, 90, 20)];   //Price per Month
lblTemp.backgroundColor = [UIColor clearColor];
lblTemp.textColor = [UIColor blackColor];
lblTemp.tag = 11;
lblTemp.hidden = FALSE;
lblTemp.numberOfLines = 0;
lblTemp.textAlignment = NSTextAlignmentRight;
lblTemp.font = [UIFont systemFontOfSize:16];
[cell.contentView addSubview:lblTemp];
    
/*
 lblTemp = [[UILabel alloc] initWithFrame:Label3Frame];  //Credit
 lblTemp.backgroundColor = [UIColor clearColor];
 lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
 lblTemp.tag = 12;
 lblTemp.hidden = FALSE;
 lblTemp.textAlignment     = NSTextAlignmentRight;
 lblTemp.font = [UIFont systemFontOfSize:14];
 [cell.contentView addSubview:lblTemp];
 */

lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, 50, 10)];
lblTemp.backgroundColor = [UIColor clearColor];
lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
lblTemp.tag = 14;
lblTemp.hidden = FALSE;
lblTemp.text = @"TYPE";
lblTemp.textAlignment     = NSTextAlignmentLeft;
lblTemp.font = [UIFont systemFontOfSize:iFontSize];
    [lblTemp sizeToFit];
[cell.contentView addSubview:lblTemp];

lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(20, 85, 50, 10)];
lblTemp.backgroundColor = [UIColor clearColor];
lblTemp.textColor = [UIColor blackColor]; //[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
lblTemp.tag = 15;
lblTemp.hidden = FALSE;
lblTemp.textAlignment     = NSTextAlignmentLeft;
lblTemp.font = [UIFont boldSystemFontOfSize:iFontSize];
[cell.contentView addSubview:lblTemp];



lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(100, 65, 50, 10)];
lblTemp.backgroundColor = [UIColor clearColor];
lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
lblTemp.tag = 16;
lblTemp.hidden = FALSE;
lblTemp.text = @"LEVEL";
lblTemp.textAlignment     = NSTextAlignmentLeft;
lblTemp.font = [UIFont systemFontOfSize:iFontSize];
        [lblTemp sizeToFit];
[cell.contentView addSubview:lblTemp];

UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
button.tag=17;
[button setFrame:CGRectMake(85, 85, 70, 15)];
//    [button setImage:[UIImage imageNamed:@"img"] forState:UIControlStateNormal];
[button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
//    [button setTitle:@"Abc" forState:UIControlStateNormal];
[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
[button setBackgroundColor:[UIColor clearColor]];
button.font = [UIFont boldSystemFontOfSize:iFontSize];

[cell.contentView addSubview:button];
/*
 lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(100, 55, 50, 10)];
 lblTemp.backgroundColor = [UIColor clearColor];
 lblTemp.textColor = [UIColor blackColor]; //[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
 lblTemp.tag = 17;
 lblTemp.hidden = FALSE;
 lblTemp.textAlignment     = NSTextAlignmentLeft;
 lblTemp.font = [UIFont boldSystemFontOfSize:9];
 [cell.contentView addSubview:lblTemp];
 */


lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(190, 65, 50, 10)];
lblTemp.backgroundColor = [UIColor clearColor];
lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
lblTemp.tag = 18;
lblTemp.hidden = FALSE;
lblTemp.text = @"NETWORK";
lblTemp.textAlignment     = NSTextAlignmentLeft;
lblTemp.font = [UIFont systemFontOfSize:iFontSize];
        [lblTemp sizeToFit];
[cell.contentView addSubview:lblTemp];

lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(190, 85, 50, 10)];
lblTemp.backgroundColor = [UIColor clearColor];
lblTemp.textColor = [UIColor blackColor]; //[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
lblTemp.tag = 19;
lblTemp.hidden = FALSE;
lblTemp.textAlignment     = NSTextAlignmentLeft;
lblTemp.font = [UIFont boldSystemFontOfSize:iFontSize];
[cell.contentView addSubview:lblTemp];



lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(280, 65, 60, 10)];
lblTemp.backgroundColor = [UIColor clearColor];
lblTemp.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
lblTemp.tag = 20;
lblTemp.hidden = FALSE;
lblTemp.text = @"DEDUCTIBLE";
lblTemp.textAlignment     = NSTextAlignmentLeft;
lblTemp.font = [UIFont systemFontOfSize:iFontSize];
        [lblTemp sizeToFit];
[cell.contentView addSubview:lblTemp];

lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(280, 85, 50, 10)];
lblTemp.backgroundColor = [UIColor clearColor];
lblTemp.textColor = [UIColor blackColor]; //[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
lblTemp.tag = 21;
lblTemp.hidden = FALSE;
lblTemp.textAlignment     = NSTextAlignmentLeft;
lblTemp.font = [UIFont boldSystemFontOfSize:iFontSize];
[cell.contentView addSubview:lblTemp];


//PDF Summary of benefits
UIButton *btnSummary = [[UIButton alloc] initWithFrame:CGRectMake(20, 110, 210, 15)];
[btnSummary.titleLabel setFont:[UIFont systemFontOfSize:10]];
[btnSummary setBackgroundColor:[UIColor greenColor]];
    btnSummary.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//[btnSummary setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
[btnSummary setTitleColor:[UIColor colorWithRed:0.22 green:0.33 blue:0.63 alpha:1.0] forState:UIControlStateNormal];
[btnSummary setTitle:@"Summary of Benefits and Coverage" forState:UIControlStateNormal];
[btnSummary addTarget:self action:@selector(showPDF:) forControlEvents:UIControlEventTouchUpInside];
[btnSummary addTarget:self action:@selector(highlightButton:) forControlEvents:UIControlStateHighlighted];
    
// [cell.contentView addSubview:btnSummary];

    UIButton *btnDetails = [[UIButton alloc] initWithFrame:CGRectMake(screenSize.width-190, 130, 65, 30)];
    [btnDetails.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [btnDetails setBackgroundColor:[UIColor whiteColor]];
    //[btnSummary setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btnDetails setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnDetails setTitle:@"Details" forState:UIControlStateNormal];
    btnDetails.layer.cornerRadius = 5; // this value vary as per your desire
    btnDetails.layer.borderWidth=1.0f;
    btnDetails.layer.borderColor=[[UIColor blueColor] CGColor];
    btnDetails.clipsToBounds = YES;
    [btnDetails addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    //    [btnSelect addTarget:self action:@selector(highlightButton:) forControlEvents:UIControlStateHighlighted];
    
    [cell.contentView addSubview:btnDetails];

    
    UIButton *btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(screenSize.width-115, 130, 100, 30)];
    [btnSelect.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [btnSelect setBackgroundColor:[UIColor redColor]];
    //[btnSummary setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btnSelect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSelect setTitle:@"Select Plan" forState:UIControlStateNormal];
    btnSelect.layer.cornerRadius = 5; // this value vary as per your desire
    btnSelect.clipsToBounds = YES;
//    [btnSelect addTarget:self action:@selector(showPDF:) forControlEvents:UIControlEventTouchUpInside];
//    [btnSelect addTarget:self action:@selector(highlightButton:) forControlEvents:UIControlStateHighlighted];
    
    [cell.contentView addSubview:btnSelect];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Show Plan PDF a"]) {
        
        // Get destination view
        MyPlanWebViewController *vc = [segue destinationViewController];
        vc.url = (NSString *)sender;
    }
}

- (void)highlightButton:(UIButton*)sender{
    [sender.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
}

- (void)showDetails:(UIButton*)sender{
    [sender.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [self performSegueWithIdentifier:@"Show Shop Plan Details" sender:nil];
}

- (void)showPDF:(UIButton*)sender{
    [sender.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [self performSegueWithIdentifier:@"Show Plan PDF a" sender:@"https://dc.checkbookhealth.org/hie/dc/2016/assets/pdfs/86052DC0400005-01.pdf"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        /*
        if ([indexPath section] == 1 && [indexPath row] == 0)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
         */
        if (self.level == 0 || (self.level == 2 && [indexPath section] == 1))
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        else
            cell = [self getCellContentViewNames:simpleTableIdentifier]; //] myCell:cell];

    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.level == 0)
    {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        
        UILabel *noPlanTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width/2-100,100,200,20)];
        noPlanTextLabel.text = @"No Plan Selected";
        [noPlanTextLabel sizeToFit];
  //      CGRect fr = noPlanTextLabel.frame;
        noPlanTextLabel.frame = CGRectMake(screenSize.width/2-noPlanTextLabel.frame.size.width/2, 75, noPlanTextLabel.frame.size.width, noPlanTextLabel.frame.size.height);
        //CGFloat font = 18.0f;
        noPlanTextLabel.textColor = [UIColor blackColor];

        [cell.contentView addSubview:noPlanTextLabel];
        return cell;
    }
    
    NSInteger selectedValue;
    if (self.level == 2)
    {
        selectedValue = self.selectedPlan;
        if (indexPath.section == 1)
        {
            cell.backgroundColor = [UIColor redColor];
            cell.textLabel.text = @"Submit";
            cell.textLabel.textColor = [UIColor whiteColor];
            return cell;
        }
    }
    else
    {
        selectedValue = indexPath.section;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    UILabel *lblPlan = (UILabel *)[cell viewWithTag:10];
    UILabel *lblPrice = (UILabel *)[cell viewWithTag:11];
    UILabel *lblType = (UILabel *)[cell viewWithTag:15];
    UILabel *lblNetwork = (UILabel *)[cell viewWithTag:19];
    UILabel *lblDed = (UILabel *)[cell viewWithTag:21];
    
    lblPlan.text = [subscriberPlans valueForKey:@"name"][selectedValue];
    [lblPlan sizeToFit];
    lblType.text = @"HMO"; //[subscriberPlans valueForKey:@"name"][indexPath.section];
    [lblType sizeToFit];
    
    NSArray *pa = [subscriberPlans valueForKey:@"premium_tables"][selectedValue][1];
    
    NSNumber *pNum = [pa valueForKey:@"cost"];
    
//    NSLog(@"%@", pp);
    lblPrice.text = [NSString stringWithFormat:@"$%4.2f", [pNum doubleValue]];
    
    
    UIButton *button = (UIButton *)[cell viewWithTag:17];
    [button setTitle:[subscriberPlans valueForKey:@"metal_level"][selectedValue] forState:UIControlStateNormal];
    if ([[subscriberPlans valueForKey:@"metal_level"][selectedValue] isEqualToString:@"bronze"])
        [button setImage:[UIImage imageNamed:@"bronze-circle.png"] forState:UIControlStateNormal];
    else if ([[subscriberPlans valueForKey:@"metal_level"][selectedValue] isEqualToString:@"silver"])
        [button setImage:[UIImage imageNamed:@"silver-circle.png"] forState:UIControlStateNormal];
    else if ([[subscriberPlans valueForKey:@"metal_level"][selectedValue] isEqualToString:@"gold"])
        [button setImage:[UIImage imageNamed:@"gold-circle.png"] forState:UIControlStateNormal];
    else if ([[subscriberPlans valueForKey:@"metal_level"][selectedValue] isEqualToString:@"platinum"])
        [button setImage:[UIImage imageNamed:@"platinum-circle.png"] forState:UIControlStateNormal];
    
    lblNetwork.text = @"DC-Metro";
        [lblNetwork sizeToFit];
    lblDed.text = [subscriberPlans valueForKey:@"deductible"][selectedValue];
    [lblDed sizeToFit];
    
    return cell;
}
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Show Plan PDF"]) {
 
        // Get destination view
        MyPlanWebViewController *vc = [segue destinationViewController];
        vc.url = (NSString *)sender;
 
        // Get button tag number (or do whatever you need to do here, based on your object
        //       NSInteger tagIndex = [(UIButton *)sender tag];
        
        // Pass the information to your destination view
        //        [vc setSelectedButton:tagIndex];
    }
}
*/

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView1 deselectRowAtIndexPath:[tableView1 indexPathForSelectedRow] animated:YES];
    
//    selectPlanViewController *yourViewController = [[selectPlanViewController alloc] init];
//    yourViewController.level = 1;
//    [self.navigationController pushViewController:yourViewController animated:YES];
    if (self.level == 0)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        selectPlanViewController *selectPlanController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SHOP Employee"];
        selectPlanController.level = 1;
        [self.navigationController pushViewController:selectPlanController animated:YES];
    }
    /*
    if (self.level == 1)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        selectPlanViewController *selectPlanController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SHOP Employee"];
        selectPlanController.level = 2;
        selectPlanController.selectedPlan = indexPath.section;
        [self.navigationController pushViewController:selectPlanController animated:YES];
    }
    
    else if (self.level == 2 && [indexPath section] == 1)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        
        UIViewController *vc ;
        
        vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"My Account"];
        
        [self.navigationController pushViewController:vc animated:TRUE];
        
    }
*/
}
@end
