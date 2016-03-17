//
//  MyAccountViewController.m
//  HBXMobile
//
//  Created by David Boyd on 3/7/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "MyAccountViewController.h"

@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [myAccountTable setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = nil;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    myAccountTable.frame = CGRectMake(0,20,screenSize.width,600); //self.view.frame.size.width,500);
    
    tableData = [[NSMutableArray alloc] init];
    
    [tableData addObject:[NSArray arrayWithObjects:@"BlueChoice HMO HSA Bronze $6,550", @"carefirst.jpg", @"176.57", @"HMO", @"Bronze", @"DC-Metro", @"6,550", @"http://www.yahoo.com", nil] ];
    [tableData addObject:[NSArray arrayWithObjects:@"BlueChoice HMO HSA Bronze $6,000", @"carefirst.jpg", @"183.52", @"HMO", @"Bronze", @"DC-Metro", @"6,000", @"http://www.yahoo.com", nil] ];
    [tableData addObject:[NSArray arrayWithObjects:@"KP DC Bronze 6000/20%/HSA/Dental/Ped Dental", @"kaiser.jpg", @"251.83", @"HMO", @"Bronze", @"DC-Metro", @"6,000", @"http://www.yahoo.com", nil] ];
    [tableData addObject:[NSArray arrayWithObjects:@"KP DC Bronze 5000/50/HSA/Dental/Ped Dental", @"kaiser.jpg", @"255.66", @"HMO", @"Bronze", @"DC-Metro", @"5,000", @"http://www.yahoo.com", nil] ];
    
//    myAccountTable.rowHeight = 104;
    myAccountTable.separatorStyle = UITableViewCellSelectionStyleNone;

}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setTitle:@"My DC Health Link"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (section == 0)
//        return 2;
    if (section == 1)
        return 6;
    
    return 1;
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 1)
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
        
//        cell = [self getCellContentViewNames:simpleTableIdentifier myCell:cell];
    }
    
//    cell.backgroundColor = [UIColor clearColor];

    if ([indexPath section] == 1)
    {

        if ([indexPath row] == 0)
        {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;

            cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            
            cell.textLabel.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
            cell.textLabel.text = @"BlueChoice HMO HSA Bronze $6,550";

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      //      cell.detailTextLabel.text = @"BRONZE";
        }

        if ([indexPath row] == 1)
        {
            cell.textLabel.text = @"HMO";
            cell.detailTextLabel.text = @"BRONZE";
        }
        
        if ([indexPath row] == 2)
        {
            cell.textLabel.text = @"Effective Date";
            cell.detailTextLabel.text = @"04/01/2016";
        }
        if ([indexPath row] == 3)
        {
            cell.textLabel.text = @"DC Health Link ID";
            cell.detailTextLabel.text = @"297338";
        }
        if ([indexPath row] == 4)
        {
            cell.textLabel.text = @"Covered";
            cell.detailTextLabel.text = @"John";
        }
        if ([indexPath row] == 5)
        {
            cell.textLabel.text = @"Premium";
            cell.detailTextLabel.text = @"$306.67/month";
        }
    
        if ([indexPath row] == 6)
        {
            cell.textLabel.text = @"Plan Selected";
            cell.detailTextLabel.text = @"03/08/2016 (4:38PM)";
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
    if ([indexPath section] == 0)
    {
//        UILabel *plabel = [[UILabel alloc] initWithFrame:CGRectMake(15,32, 200, 30)];
//        plabel.text = @"John Doe";
//        [cell.contentView addSubview:plabel];
        cell.textLabel.text = @"John Doe";
    }
    
    if ([indexPath section] == 2)
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

    if ([indexPath section] == 1 && [indexPath row] == 0)
        [self performSegueWithIdentifier:@"Show Plan Details" sender:nil];

    if ([indexPath section] == 2)
        [self performSegueWithIdentifier:@"Show Notifications" sender:nil];
}

@end
